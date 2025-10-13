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
                    "content": f"Tailor the response based on this topic: {topic}."
                }
            ],
            max_tokens = 2000
        );
        
        # print("Raw completion:", completion);
        
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
    print("Testing deepseek model...");
    while 1 {   
        user_input = input("What can I help you with today? ");
        poem = gpt_gen(user_input);
        print("=" * 40);
        print(poem);
        print("=" * 40);
    }
}