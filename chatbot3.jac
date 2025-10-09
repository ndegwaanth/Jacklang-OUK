import from openai { OpenAI }

glob OPENROUTER_API_KEY = "";

glob client = OpenAI(
    base_url = "https://openrouter.ai/api/v1",
    api_key = OPENROUTER_API_KEY
);

""" Write a poem about topic with error handling """
def write_poetry(topic: str) -> str {
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
                    "content": f"Write a beautiful 20-line poem about {topic}."
                }
            ],
            max_tokens = 2000
        );
        
        print("Raw completion:", completion);
        
        # Extract the content safely
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

with entry {
    print("Testing poetry generation...");
    poem = write_poetry("a serene landscape with mountains at sunset");
    print("\nGenerated Poem:");
    print("=" * 40);
    print(poem);
    print("=" * 40);
}