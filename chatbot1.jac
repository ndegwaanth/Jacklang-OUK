import from openai { OpenAI }

glob client = OpenAI(
  base_url="https://openrouter.ai/api/v1",
  api_key="<OPENAI_API_KEY>",
);


def text_gen(topic: str) -> str {
	response = client.responses.create(
		# model = "openai/gpt-4o",
		input = f"write the context of: {topic}."
	);
	return response.output_text;
}


with entry {
	context = text_gen("Artificial Intelligence and Machine Learning Engineering");
	print(context);

}
