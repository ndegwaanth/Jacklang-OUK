walker generate_documentation {
    has docs: str;
    has docs_data: any;
    has output: str;
    has item: dict;
    has code_block: str = "```";
    
    with entry {
        # Parse the docs JSON
        docs_data = std.from_json(docs);
        
        output = "---\ntitle: 'Project Documentation'\noutput: html_document\n---\n\n";
        output += "# Project Analysis Report\n\n";
        
        if std.type(docs_data) == "list" {
            for item: dict in docs_data {
                output += "## File: " + item["file_name"] + "\n\n";
                output += "**Path:** " + item["file_path"] + "\n\n";
                
                if item["functions"].length > 0 {
                    output += "**Functions:** " + std.join(item["functions"], ", ") + "\n\n";
                }
                
                if item["classes"].length > 0 {
                    output += "**Classes:** " + std.join(item["classes"], ", ") + "\n\n";
                }
                
                output += "**Preview:**\n" + code_block + "python\n" + item["content_preview"] + "\n" + code_block + "\n\n";
                output += "---\n\n";
            }
        } else {
            output += "Analysis data: " + docs + "\n";
        }
        
        report output;
    }
}

walker format_documentation {
    has raw_docs: list[dict];
    has formatted_output: str;
    has section: dict;
    
    with entry {
        formatted_output = "# Generated Documentation\n\n";
        
        for section: dict in raw_docs {
            formatted_output += "## " + section["type"] + ": " + section["name"] + "\n\n";
            formatted_output += code_block + "python\n" + section["docstring"] + "\n" + code_block + "\n\n";
        }
        
        report formatted_output;
    }
}

walker init {
    has sample_docs: list[dict] = [
        {
            "type": "function",
            "name": "calculate_total",
            "docstring": "def calculate_total(price: float, quantity: int) -> float:\n    return price * quantity"
        },
        {
            "type": "class", 
            "name": "User",
            "docstring": "class User:\n    def __init__(self, name: str):\n        self.name = name"
        }
    ];
    
    result = spawn here walker::generate_documentation(docs=std.to_json(sample_docs));
    std.out("Documentation generated:\n" + result.context);
}