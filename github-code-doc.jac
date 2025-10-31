import os;
import ast;
import tempfile;
import git;
import  from byllm.lib { Model }
import from dotenv { load_dotenv }


glob llm = Model(model_name="deepseek/deepseek-chat", api_key=os.getenv("OPENROUTER_API_KEY"));

node repo_analyser {
    def clone_repo(repo_url:str) -> str {
        temp_dir = tempfile.mkdtemp();
        Repo.clone_from(repo_url, temp_dir);
        return temp_dir;

    } 

    def extract_code_docs(repo_path:str) -> dict {
        with open(repo_path, 'r', encoding='utf-8') as file {
            try {
                tree = ast.parse(file.read());
                docstrings = {};
                for node in ast.walk(tree) {
                    if isinstance(node, (ast.FunctionDef, ast.ClassDef, ast.Module)) {
                        docstring = ast.get_docstring(node);
                        if docstring {
                            docstrings[node.name] = docstring;
                        }
                    }
                }
                return docstrings;
            } except Exception as e {
                return {};
            }
        }

    }

    def analyze_rep(repo_dir:str) -> dict {
        code_docs = {};
        for walk_item in os.walk(repo_dir) {
            root = walk_item[0];
            dirs = walk_item[1];
            files = walk_item[2];
            for file in files {
                if file.endswith('.py') {
                    file_path = os.path.join(root, file);
                    docs = self.extract_code_docs(file_path);
                    if docs {
                        code_docs[file_path] = docs;
                    }
                }
            }
        }
        return code_docs;
    }

    def process_repo(repo_url:str) -> dict {
        repo_path = self.clone_repo(repo_url);
        docs = self.analyze_rep(repo_path);
        return docs;
    }

    can execute with repanlz entry {
        response = self.process_repo(visitor.repo_url);
        report {
            "docs": response,
            "repo_url": visitor.repo_url
        };
    }
}


node doc_generator {
    def generate_rmarkdown(docs:dict) -> str {
        markdown = "# Code Documentation\n\n";
        for (file_path, docstrings in docs.items()){ 
                markdown += f"## File: {file_path}\n\n";
                for name, docstring in docstrings.items():
                    markdown += f"### {name}\n\n";
                    markdown += f"{docstring}\n\n";
                }
    }
        return markdown;
    }

    def process_docs(docs:dict) -> str {
        rmarkdown = self.generate_rmarkdown(docs);
        return rmarkdown;
    }
    can execute with repanlz entry {
        rmd_content = self.process_docs(visitor.docs);
        report {
            rmarkdown = rmd_content;
        }
    }
}


node Deep_seeker {
    """ Write a poem about topic with error handling """
    def gpt_gen(topic: str) -> str {
        try {
            completion = client.chat.completions.create(
                        extra_headers={
                            "HTTP-Referer": "https://yourwebsite.com",
                            "X-Title": "Flask Doc Generator"
                        },
                        model="deepseek/deepseek-chat",
                        messages = [
                            {
                                "role": "system",
                                "content": """You are an advanced documentation generator that produces professional, detailed RMarkdown documentation
                        for GitHub repositories. Format your output in rich RMarkdown style, including:

                        - YAML header for metadata
                        - Collapsible sections using HTML <details> and <summary> tags
                        - Tables for summarizing components
                        - Syntax-highlighted code blocks
                        - Markdown badges or highlights for emphasis
                        - 'Callout' sections for notes, warnings, or important info
                        - Include a comprehensive 'Technologies Used' section listing all programming languages, frameworks, and libraries found in the repository

                        Example structure:
                        ---
                        title: "Comprehensive Documentation for <Project Name>"
                        author: "AI Documentation Generator"
                        date: "`r Sys.Date()`"
                        output:
                        html_document:
                            toc: true
                            toc_depth: 3
                            toc_float: true
                        ---

                        # Overview
                        <High-level explanation>

                        # Architecture
                        <Flowchart or component table>

                        # Key Modules
                        <detailed sections with code snippets>

                        # How It Works
                        <step-by-step explanation>

                        # Technologies Used
                        <List all programming languages, frameworks, libraries, and tools utilized in the repository>

                        # Importance and Use Cases
                        <business and technical significance>

                        # Conclusion
                        <final thoughts or references>

                        Use elegant formatting, clear structure, and ensure all technologies are mentioned."""
                            },
                            {
                                "role": "user",
                                "content": f"Generate comprehensive RMarkdown documentation for this repository: {repo_url}"
                            }
                        ]

                    );

            
            # print("Raw completion:", completion);
            
            # Extract the content safely
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

    def process_repo(repo_url:str) -> str {
        rmarkdown = self.gpt_gen(repo_url);
        return rmarkdown;
    }

    can execute with repanlz entry {
        rmd_content = self.process_repo(visitor.repo_url);
        report {
            rmarkdown = rmd_content;
        }
    }
}

enum Routingnode{
    Deep_seeker
}

walker repo_walker {
    has repo_url: str;

    def process_docs(visitor: Routingnode) -> str {
        if visitor == Routingnode.Deep_seeker {
            node_instance = Deep_seeker();
            rmd = node_instance.process_repo(self.repo_url);
            return rmd;
        } else {
            return "Error: Unknown routing node";
        }
    }
}