// Use global fetch (available in Node 18+)

exports.getSessionToken = async (req, res) => {
    try {
        if (!process.env.OPENAI_API_KEY) {
            return res.status(500).json({ error: "OPENAI_API_KEY is not configured." });
        }

        const response = await fetch("https://api.openai.com/v1/realtime/sessions", {
            method: "POST",
            headers: {
                "Authorization": `Bearer ${process.env.OPENAI_API_KEY}`,
                "Content-Type": "application/json",
            },
            body: JSON.stringify({
                model: "gpt-4o-realtime-preview-2024-12-17",
                voice: "shimmer", // A warm, compassionate voice
                instructions: "You are a compassionate mental health support companion. Speak naturally, warmly, and conversationally. Keep responses concise and human-like. Ask thoughtful follow-up questions. Do not claim to be a licensed therapist. Encourage professional help when appropriate.",
            }),
        });

        if (!response.ok) {
            const errorText = await response.text();
            console.error("OpenAI Realtime API Error:", errorText);
            return res.status(response.status).json({ error: "Failed to generate ephemeral token." });
        }

        const data = await response.json();
        
        // Ensure CORS allows the Flutter app if needed, though server.js usually handles this
        res.json(data);
    } catch (error) {
        console.error("Session token error:", error);
        res.status(500).json({ error: "Internal Server Error" });
    }
};
