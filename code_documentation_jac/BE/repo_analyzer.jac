walker init {
    has repo_url: str;

    with entry {
        # Ask user for GitHub repo URL
        std.out("Enter the GitHub repository URL to analyze:");
        repo_url = std.in();

        if std.trim(repo_url) == "" {
            std.out("❌ No URL provided. Exiting...");
            stop;
        }

        std.out("Repository URL received: " + repo_url);
        spawn here analyze_repository(repo_url=repo_url);
        std.out("✅ Analysis started...");
    }
}

node python_file {
    has name: str;
    has file_path: str;
    has functions: list[str] = [];
    has classes: list[str] = [];
}

walker analyze_repository {
    has repo_url: str;
    has temp_dir: str = null;
    has python_files: list[str] = [];
    has analysis_results: list[dict] = [];
    has file_path: str;
    has file_name: str;
    has file_content: str;
    has functions: list[str];
    has classes: list[str];
    has lines: list[str];
    has line: str;
    has trimmed: str;
    has func_name: str;
    has class_name: str;

    with entry {
        std.out("🔍 Starting repository analysis for: " + repo_url);
        
        # Clone repository
        std.exec("git clone " + repo_url + " temp_repo", true);
        std.out("📁 Repository cloned to temp_repo");

        # Find Python files
        python_files = [];
        for entry in std.walk("temp_repo") {
            root = entry[0];
            dirs = entry[1];
            files = entry[2];
            for file in files {
                if std.ends_with(file, ".py") {
                    file_path = std.join_path(root, file);
                    python_files.append(file_path);
                }
            }
        }
        std.out("🐍 Found " + std.str(python_files.length) + " Python files");
        
        # Analyze each Python file
        analysis_results = [];
        for file_path in python_files {
            file_name = std.base_name(file_path);
            file_content = std.read_file(file_path);
            functions = [];
            classes = [];
            
            # Pattern matching for Python definitions
            lines = std.split(file_content, "\n");
            for line in lines {
                trimmed = std.trim(line);
                if std.starts_with(trimmed, "def ") {
                    func_name = std.replace(trimmed, "def ", "");
                    func_name = std.split(func_name, "(")[0];
                    functions.append(std.trim(func_name));
                } elif std.starts_with(trimmed, "class ") {
                    class_name = std.replace(trimmed, "class ", "");
                    class_name = std.split(class_name, "(")[0];
                    class_name = std.split(class_name, ":")[0];
                    classes.append(std.trim(class_name));
                }
            }
            
            analysis_results.append({
                "file_path": file_path,
                "file_name": file_name,
                "functions": functions,
                "classes": classes,
                "content_preview": std.slice(file_content, 0, 200) + "..."
            });
        }

        # Cleanup cloned repo
        std.exec("rm -rf temp_repo", true);
        
        report std.to_json(analysis_results);
    }
}