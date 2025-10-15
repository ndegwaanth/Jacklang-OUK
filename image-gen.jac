import from openai { OpenAI }

glob OPENROUTER_API_KEY = "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";


def text_gen_with_llama(prompt: str) -> str {
    try {
        client = OpenAI(
            base_url = "https://openrouter.ai/api/v1",
            api_key = OPENROUTER_API_KEY,
            default_headers = {
                "HTTP-Referer": "https://github.com/ndegwaanth/jacklang-OUK",
                "X-Title": "Jac Image Generation"
            }
        );
        
        response = client.chat.completions.create(
            model = "meta-llama/llama-3.2-3b-instruct:free",
            messages = [
                {"role": "user", "content": prompt}
            ],
            max_tokens = 1000,
            temperature = 0.7
        );
        
        if response.choices and response.choices != [] {
            return response.choices[0].message.content;
        } else {
            return "Error: No response content";
        }
    }
    except Exception as e {
        print(f"Error generating text: {e}");
        return "Error: Exception occurred while generating text";
    }
}

with entry {
    while 1 {
        print("Enter a prompt for text generation (or type 'exit' to quit): ");
        user_input = input().strip();
        
        if user_input.lower() == "exit" {
            break;
        }
        
        result = text_gen_with_llama(user_input);
        print(f"{result}");
    }
}