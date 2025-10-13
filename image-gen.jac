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
    prompt = input("Enter your prompt for LLaMA 3.2 (free): ");
    response = text_gen_with_llama(prompt);
    print(f"LLaMA Response: {response}");
}