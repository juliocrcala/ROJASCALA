import { createClient } from 'npm:@supabase/supabase-js@2.39.8';

const corsHeaders = {
  'Access-Control-Allow-Origin': '*',
  'Access-Control-Allow-Methods': 'GET, POST, OPTIONS',
  'Access-Control-Allow-Headers': 'Content-Type, Authorization, X-Client-Info, Apikey',
};

Deno.serve(async (req: Request) => {
  if (req.method === 'OPTIONS') {
    return new Response(null, { status: 200, headers: corsHeaders });
  }

  try {
    const oldSupabase = createClient(
      'https://kyekcfjulzgvziqpyfod.supabase.co',
      'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6Imt5ZWtjZmp1bHpndnppcXB5Zm9kIiwicm9sZSI6ImFub24iLCJpYXQiOjE3NTA1NjkzNjQsImV4cCI6MjA2NjE0NTM2NH0.UVCqAK9eodnYaVxZyrrD6n7aU5x3cNC92ypaVgM0krQ'
    );

    const [articlesRes, categoriesRes, contactsRes, consultationsRes] = await Promise.all([
      oldSupabase.from('articles').select('*'),
      oldSupabase.from('categories_config').select('*'),
      oldSupabase.from('contacts').select('*'),
      oldSupabase.from('consultations').select('*')
    ]);

    const data = {
      articles: articlesRes.data || [],
      categories: categoriesRes.data || [],
      contacts: contactsRes.data || [],
      consultations: consultationsRes.data || [],
      errors: {
        articles: articlesRes.error,
        categories: categoriesRes.error,
        contacts: contactsRes.error,
        consultations: consultationsRes.error
      }
    };

    return new Response(JSON.stringify(data), {
      headers: { ...corsHeaders, 'Content-Type': 'application/json' },
    });
  } catch (error) {
    return new Response(
      JSON.stringify({ error: error.message }),
      { status: 500, headers: { ...corsHeaders, 'Content-Type': 'application/json' } }
    );
  }
});