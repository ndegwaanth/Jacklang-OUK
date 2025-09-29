import from byllm { Model };
import from byllm { ChatCompletionRequestMessageRoleEnum };
import from byllm { ChatCompletionRequestMessage };
import from byllm { ChatCompletionRequest };
import from byllm { ChatCompletionResponse };
import from byllm { ByLlmClient };
import from byllm { ByLlmClientConfig };
import from byllm { LogLevelEnum };
import from byllm { OpenAIAuth };
import from byllm { OpenAIAuthTypeEnum };
import from byllm { OpenAIClientConfig };
import from byllm { OpenAIClient };
import from byllm { AzureOpenAIClientConfig };
import from byllm { AzureOpenAIClient };
import from byllm { AzureOpenAIAuth };
import from byllm { AzureOpenAIAuthTypeEnum };
import from byllm { ChatCompletionStreamResponse };
import from byllm { ChatCompletionStreamRequest };
import from byllm { ChatCompletionStreamRequestMessage };
import from byllm { ChatCompletionStreamRequestMessageRoleEnum };
import from byllm { ChatCompletionStreamResponseChoice };
import from byllm { ChatCompletionStreamResponseChoiceDelta };
import from byllm { ChatCompletionStreamResponseChoiceDeltaContent };
import from byllm { ChatCompletionStreamResponseChoiceDeltaFunctionCall };
import from byllm { ChatCompletionStreamResponseChoiceDeltaFunctionCallName };
import from byllm { ChatCompletionStreamResponseChoiceDeltaFunctionCallArguments };
import from byllm { ChatCompletionStreamResponseChoiceFinishReasonEnum };
import from byllm { ChatCompletionStreamResponseUsage };
import from byllm { ChatCompletionStreamResponseUsagePromptTokens };
import from byllm { ChatCompletionStreamResponseUsageCompletionTokens };
import from byllm { ChatCompletionStreamResponseUsageTotalTokens };
import from byllm { ChatCompletionStreamResponseChoiceIndex };
import from byllm { ChatCompletionStreamResponseChoiceDeltaRole };
import from byllm { ChatCompletionStreamResponseChoiceDeltaRoleEnum };
import from byllm { ChatCompletionStreamResponseChoiceDeltaContentEnum };
import from byllm { ChatCompletionStreamResponseChoiceDeltaFunctionCallEnum };
import from byllm { ChatCompletionStreamResponseChoiceDeltaFunctionCallNameEnum };
import from byllm { ChatCompletionStreamResponseChoiceDeltaFunctionCallArgumentsEnum };
import from byllm { ChatCompletionStreamResponseChoiceFinishReasonEnum };

glob  llm = Model("gpt-4o",  // or "gpt-4o-mini", "gpt-4o-2024-08-06", etc.
    temperature=0.7,
    max_tokens=1000,
    top_p=1,
    frequency_penalty=0,
    presence_penalty=0,
    n=1,
    stop=null
);

# Function to get a response from the LLM
def get_llm_response(prompt: str) -> str {
    messages = [
        ChatCompletionRequestMessage(
            role=ChatCompletionRequestMessageRoleEnum.USER,
            content=prompt
        )
    ];
    
    request = ChatCompletionRequest(
        model=llm,
        messages=messages,
        temperature=0.7,
        max_tokens=1000,
        top_p=1,
        frequency_penalty=0,
        presence_penalty=0,
        n=1,
        stop=null
    );
    
    client_config = ByLlmClientConfig(
        log_level=LogLevelEnum.INFO
    );
    
    client = ByLlmClient(client_config);
    
    response: ChatCompletionResponse = client.create_chat_completion(request);
    
    return response.choices[0].message.content;
}

# Example usage
with entry {  
    prompt = "Write a simple Python function to add two numbers.";
    response = get_llm_response(prompt);
    print("LLM Response:\n", response);
}