import from openai { OpenAI }

glob OPENROUTER_API_KEY = "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";

def test_models(prompt: str) {
    models = [
        "google/gemini-2.0-flash-exp",
        "google/gemini-flash-1.5",
        "google/gemini-pro-1.5",
        "meta-llama/llama-3.2-3b-instruct:free",
        "microsoft/phi-3-mini-128k-instruct:free"
    ];
    
    for model in models {
        print(f"Testing model: {model}");
        try {
            client = OpenAI(
                base_url = "https://openrouter.ai/api/v1",
                api_key = OPENROUTER_API_KEY,
                default_headers = {
                    "HTTP-Referer": "https://github.com/ndegwaanth/jacklang-OUK",
                    "X-Title": "Jac Model Testing"
                }
            );
            
            response = client.chat.completions.create(
                model = model,
                messages = [
                    {"role": "user", "content": prompt}
                ],
                max_tokens = 100,
                temperature = 0.7
            );
            
            if response.choices and response.choices != [] {
                print(f"✓ SUCCESS with {model}");
                print(f"Response: {response.choices[0].message.content[:100]}...");
                return model;
            }
        }
        except Exception as e {
            print(f"✗ FAILED with {model}: {e}");
        }
        print("---");
    }
    return None;
}

with entry {
    prompt = "Hello, please respond with a brief greeting.";
    working_model = test_models(prompt);
    if working_model {
        print(f"Use this model: {working_model}");
    } else {
        print("No working models found");
    }
}