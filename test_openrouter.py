from openai import OpenAI

client = OpenAI(
  base_url="https://openrouter.ai/api/v1",
  api_key="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",
)

completion = client.chat.completions.create(
  extra_headers={
    "HTTP-Referer": "http://localhost", # Optional. Site URL for rankings on openrouter.ai.
    "X-Title": "Test App", # Optional. Site title for rankings on openrouter.ai.
  },
  extra_body={},
  model="deepseek/deepseek-chat-v3.1:free",
  messages=[
    {
      "role": "user",
      "content": "What is the meaning of life?"
    }
  ]
)
print(completion.choices[0].message.content)