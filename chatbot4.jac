# mt_poem.jac - Simple AI integration
import from byllm { Model }

glob OPENROUTER_API_KEY = "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";
glob llm = Model(
    model_name="deepseek/deepseek-chat-v3.1:free",
    base_url="https://openrouter.ai/api/v1",
    api_key=OPENROUTER_API_KEY
);

""" Write a poem about topic """
def write_poetry(topic: str) -> str by llm();

with entry {
    poem = write_poetry("A serene landscape with mountains.");
    print(poem);
}