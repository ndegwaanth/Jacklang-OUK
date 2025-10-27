import os;
import ast;
import re;
import json;
import tempfile;
import shutil;
import git;
import from typing { List, Dict, Any }



# Clone a git repository to a temporary directory
def clone_repo(repo_url: str) -> str {
    temp_dir = tempfile.mkdtemp()
    git.Repo.clone_from(repo_url, temp_dir)
    return temp_dir
}


# extract Python files from a directory
def extract_python_files(dir_path: str) -> List[str] {
    python_files = []
    for root, dirs, files in os.walk(dir_path) {
        for file in files {
            if file.endswith(".py") {
                python_files.append(os.path.join(root, file))
            }
        }
    }
    return python_files
}

# Analyze a Python file to extract function and class definitions
def analyze_python_file(file_path: str) -> Dict[str, Any] {
    with open(file_path, "r", encoding="utf-8") as file {
        file_content = file.read()
    }
    tree = ast.parse(file_content)
    functions = []
    classes = []

    for node in ast.walk(tree) {
        if isinstance(node, ast.FunctionDef) {
            functions.append(node.name)
        } elif isinstance(node, ast.ClassDef) {
            classes.append(node.name)
        }
    }

    return {
        "file_path": file_path,
        "functions": functions,
        "classes": classes
    }
}