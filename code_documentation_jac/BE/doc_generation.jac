def generate_documentation(docs: list) -> str {
    has output: str = "---\ntitle: 'Project Documentation'\noutput: html_document\n---\n\n";
    has my: str = "```";

    for item in docs {
        output += f"## {item['type'].capitalize()}: {item['name']}\n\n";
        output += f"{my}python\n{item['docstring']}\n{my}\n\n"; 
    }
    return output;
}