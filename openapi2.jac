import from openai { OpenAI }

# API key directly in the file
glob OPENROUTER_API_KEY="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";

# Site info also in the file
glob SITE_URL = "https://myapp.com";
glob SITE_NAME = "My Jac App";

glob client = OpenAI(
    base_url = "https://openrouter.ai/api/v1",
    api_key = OPENROUTER_API_KEY
);

""" Write a poem about topic """
def write_poetry(topic: str) -> str {
    response = client.responses.create(
        extra_headers = {
            "HTTP-Referer": SITE_URL,
            "X-Title": SITE_NAME
        },
        model = "deepseek/deepseek-chat",
        input = f"Write a beautiful poem about {topic}."
    );

    # Debug: print the response type to understand the structure
    print("Response type:", type(response));
    print("Full response:", response);

    # Try different ways to access the content
    return response;  # If it's already a string, just return it
}

with entry {
    poem = write_poetry("A serene landscape with mountains.");
    print("Final poem:");
    print(poem);
}