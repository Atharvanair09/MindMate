exports.chatCompletions = async (req, res) => {
    try {
        if (!process.env.OPENROUTER_API_KEY) {
            return res.status(500).json({ error: "OPENROUTER_API_KEY is not configured." });
        }

        const { messages } = req.body;

        if (!messages || !Array.isArray(messages)) {
            return res.status(400).json({ error: "Messages array is required." });
        }

        const response = await fetch("https://openrouter.ai/api/v1/chat/completions", {
            method: "POST",
            headers: {
                "Authorization": `Bearer ${process.env.OPENROUTER_API_KEY}`,
                "Content-Type": "application/json",
                "HTTP-Referer": "https://mindmate.app",
                "X-Title": "MindMate",
            },
            body: JSON.stringify({
                "model": "openai/gpt-4.1-mini",
                "messages": messages,
                "temperature": 0.7
            }),
        });

        if (!response.ok) {
            const errorText = await response.text();
            console.error("OpenRouter API Error:", errorText);
            return res.status(response.status).json({ error: "Failed to fetch response from OpenRouter." });
        }

        const data = await response.json();
        res.json(data);
    } catch (error) {
        console.error("OpenRouter proxy error:", error);
        res.status(500).json({ error: "Internal Server Error" });
    }
};
