import from openai { OpenAI }

glob OPENROUTER_API_KEY = "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";
glob m: int = 10;

glob client = OpenAI(
    base_url = "https://openrouter.ai/api/v1",
    api_key = OPENROUTER_API_KEY
);

""" Write a poem about topic with error handling """
def gpt_gen(topic: str) -> str {
    try {
        completion = client.chat.completions.create(
            extra_headers = {
                "HTTP-Referer": "https://myapp.com",
                "X-Title": "My Jac App"
            },
            model = "deepseek/deepseek-chat",
            messages = [
                {
                    "role": "user", 
                    "content": f"Write a beautiful short poem about: {topic}."
                }
            ],
            max_tokens = 2000
        );
        
        # Extract safely
        if completion.choices and completion.choices != [] {
            if completion.choices[0].message and completion.choices[0].message.content {
                return completion.choices[0].message.content;
            } else {
                return "Error: No message content in response";
            }
        } else {    
            return "Error: No choices in response";
        }
    }
    except Exception as e {
        print(f"Error generating poem: {e}");
        return "Error: Exception occurred while generating poem";
    }
}

# ✅ Walker for web API call
walker api_generate_poem {
    can run {
        input = ctx.request.json;
        topic = input.get("topic", "nature");
        poem = gpt_gen(topic);
        return {"topic": topic, "poem": poem};
    }
}

with entry {
    print("Jac AI Server ready... Run using: jsserv -m");
}

