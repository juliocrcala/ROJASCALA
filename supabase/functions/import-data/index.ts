import { createClient } from 'npm:@supabase/supabase-js@2.39.8';

const corsHeaders = {
  'Access-Control-Allow-Origin': '*',
  'Access-Control-Allow-Methods': 'POST, OPTIONS',
  'Access-Control-Allow-Headers': 'Content-Type, Authorization, X-Client-Info, Apikey',
};

Deno.serve(async (req: Request) => {
  if (req.method === 'OPTIONS') {
    return new Response(null, { status: 200, headers: corsHeaders });
  }

  try {
    const data = await req.json();
    
    const supabase = createClient(
      Deno.env.get('SUPABASE_URL')!,
      Deno.env.get('SUPABASE_SERVICE_ROLE_KEY')!
    );

    const results = {
      categories: { success: 0, errors: [] as any[] },
      contacts: { success: 0, errors: [] as any[] },
      articles: { success: 0, errors: [] as any[] },
    };

    if (data.categories && data.categories.length > 0) {
      const { error } = await supabase
        .from('categories_config')
        .upsert(data.categories, { onConflict: 'id' });
      
      if (error) {
        results.categories.errors.push(error);
      } else {
        results.categories.success = data.categories.length;
      }
    }

    if (data.contacts && data.contacts.length > 0) {
      const { error } = await supabase
        .from('contacts')
        .upsert(data.contacts, { onConflict: 'id' });
      
      if (error) {
        results.contacts.errors.push(error);
      } else {
        results.contacts.success = data.contacts.length;
      }
    }

    if (data.articles && data.articles.length > 0) {
      const { error } = await supabase
        .from('articles')
        .upsert(data.articles, { onConflict: 'id' });
      
      if (error) {
        results.articles.errors.push(error);
      } else {
        results.articles.success = data.articles.length;
      }
    }

    return new Response(JSON.stringify(results), {
      headers: { ...corsHeaders, 'Content-Type': 'application/json' },
    });
  } catch (error) {
    return new Response(
      JSON.stringify({ error: error.message }),
      { status: 500, headers: { ...corsHeaders, 'Content-Type': 'application/json' } }
    );
  }
});