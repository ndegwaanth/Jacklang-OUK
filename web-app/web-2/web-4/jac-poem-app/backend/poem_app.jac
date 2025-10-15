import from openai { OpenAI }

glob OPENROUTER_API_KEY = "sk-or-v1-2d24c2bbfbe8b173bfcda1c684b746";
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
    has input topic = "nature";
    has output poem;
    has output status = "success";
    
    with entry {
        if topic.strip() == "" {
            topic = "nature";
        }
        
        poem = gpt_gen(topic);
        
        # Check if there was an error in generation
        if poem.startswith("Error:") {
            status = "error";
        }
        
        report {
            "topic": topic,
            "poem": poem,
            "status": status
        };
    }
}

# Walker to get server status
walker api_status {
    with entry {
        report {
            "status": "ready",
            "message": "Jac AI Poem Generator Server is running",
            "timestamp": std.time_now()
        };
    }
}

# Walker to save poem history
node saved_poem {
    has topic;
    has poem;
    has created_at;
}

graph poem_history {
    has anchor poems;
}

walker save_poem {
    has input topic, poem;
    
    root {
        spawn here ++> node::saved_poem(
            topic=topic,
            poem=poem,
            created_at=std.time_now()
        );
        report {"saved": true};
    }
}

walker get_poem_history {
    has output history = [];
    
    saved_poem {
        history += [{
            "topic": here.topic,
            "poem": here.poem,
            "created_at": here.created_at
        }];
        take -->;
    }
    
    with exit {
        report history;
    }
}

with entry {
    print("Jac AI Poem Generator Server ready...");
    print("Run using: jsserv -m");
    print("API Endpoints:");
    print("  - POST /js/walker_run (name: api_generate_poem)");
    print("  - POST /js/walker_run (name: api_status)");
}