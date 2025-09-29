import from byllm { Model }
import os;


glob llm = Model(
    model_name="gemini-1.5-flash",    # Gemini model name
    provider="google_ai_studio",      #  provider for API key usage
    api_key=std.env("GEMINI_API_KEY") # pulls from .env
);

enum Personality {
    INTROVERT,
    EXTROVERT,
    AMBIVERT
}

def get_personality(name: str) -> Personality by llm();

with entry {
    name = "Albert Einstein";
    result = get_personality(name);
    print(f"{result} detected for {name}");
}