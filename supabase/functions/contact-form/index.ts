import { serve } from "https://deno.land/std@0.168.0/http/server.ts"

const corsHeaders = {
  'Access-Control-Allow-Origin': '*',
  'Access-Control-Allow-Headers': 'authorization, x-client-info, apikey, content-type',
}

serve(async (req) => {
  // Handle CORS preflight requests
  if (req.method === 'OPTIONS') {
    return new Response('ok', { headers: corsHeaders })
  }

  try {
    const { name, email, message } = await req.json()

    // Validar datos
    if (!name || !email || !message) {
      throw new Error('Faltan campos requeridos')
    }

    // Aquí puedes integrar con servicios como:
    // - Resend
    // - SendGrid
    // - Nodemailer con SMTP
    
    // Ejemplo con fetch a un servicio de email
    const emailData = {
      to: 'julio.cesar@rojascala.org',
      subject: 'Nueva consulta desde el sitio web - Rojas Cala',
      html: `
        <h2>Nueva consulta recibida</h2>
        <p><strong>Nombre:</strong> ${name}</p>
        <p><strong>Email:</strong> ${email}</p>
        <p><strong>Mensaje:</strong></p>
        <p>${message}</p>
      `
    }

    // Simular envío exitoso
    console.log('Email enviado:', emailData)

    return new Response(
      JSON.stringify({ success: true, message: 'Email enviado correctamente' }),
      {
        headers: { ...corsHeaders, 'Content-Type': 'application/json' },
        status: 200,
      },
    )
  } catch (error) {
    return new Response(
      JSON.stringify({ error: error.message }),
      {
        headers: { ...corsHeaders, 'Content-Type': 'application/json' },
        status: 400,
      },
    )
  }
})