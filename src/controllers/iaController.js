const { OpenAI } = require('openai');
require('dotenv').config();

const openai = new OpenAI({
    apiKey: process.env.OPENAI_API_KEY,
});

// Prompt del sistema: Las reglas que debe seguir el bot
const instruccionesSistema = `
Eres AVIKO, el asistente virtual inteligente de Fumigaciones K.O.
Tu objetivo es atender clientes, responder dudas sobre plagas y preparar cotizaciones.
Tono: Profesional, amable y resolutivo.
Regla 1: Si preguntan por precios, diles que dependemos del tipo de inmueble y plaga.
Regla 2: Pide los datos de contacto (nombre, ubicación) amablemente.
Regla 3: Tus respuestas deben ser cortas, ideales para leer en WhatsApp.
`;

async function procesarMensajeIA(mensajeUsuario) {
    try {
        const respuesta = await openai.chat.completions.create({
            model: "gpt-3.5-turbo", // O el modelo que prefieras
            messages: [
                { role: "system", content: instruccionesSistema },
                { role: "user", content: mensajeUsuario }
            ],
            max_tokens: 150,
        });
        
        return respuesta.choices[0].message.content;
    } catch (error) {
        console.error("Error en la IA:", error);
        return "Disculpa, en este momento tengo un problema técnico. ¿Podrías intentar en unos minutos?";
    }
}

module.exports = { procesarMensajeIA };