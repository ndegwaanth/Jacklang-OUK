from flask import Flask, request, render_template, jsonify
from openai import OpenAI
from config import Config
import subprocess
import os
import json

app = Flask(__name__)
app.config.from_object(Config)

# Initialize OpenRouter API client
client = OpenAI(
    base_url=Config.BASE_URL,
    api_key=Config.OPENROUTER_API_KEY,
)

# JAC Backend Functions
def run_jac_file(filename, walker_name, context=None):
    """Run JAC file with specified walker and context"""
    try:
        jac_path = "BE"  # Changed to BE folder
        
        # Build command - using correct JAC syntax
        if context:
            # Convert context to JAC argument format
            ctx_args = " ".join([f"-{k} {json.dumps(v)}" for k, v in context.items()])
            cmd = f"jac run {filename} -walk {walker_name} {ctx_args}"
        else:
            cmd = f"jac run {filename} -walk {walker_name}"
        
        print(f"Executing JAC command: {cmd}")  # Debug
        
        # Execute JAC command
        result = subprocess.run(
            cmd,
            shell=True,
            capture_output=True,
            text=True,
            timeout=30,
            cwd=jac_path  # Run from BE folder
        )
        
        print(f"JAC return code: {result.returncode}")  # Debug
        print(f"JAC stdout: {result.stdout}")  # Debug
        print(f"JAC stderr: {result.stderr}")  # Debug
        
        if result.returncode == 0:
            output = result.stdout.strip()
            # Try to parse JSON output if possible
            try:
                return json.loads(output)
            except:
                return output
        else:
            return {"error": result.stderr}
            
    except subprocess.TimeoutExpired:
        return {"error": "JAC command timed out"}
    except Exception as e:
        return {"error": f"System error: {str(e)}"}

def clone_and_analyze_repo(repo_url):
    """Use JAC to clone and analyze repository"""
    context = {"repo_url": repo_url}
    result = run_jac_file("repo_analyzer.jac", "analyze_repository", context)
    return result

def generate_documentation(docs_data):
    """Use JAC to generate documentation"""
    if isinstance(docs_data, str):
        try:
            docs_data = json.loads(docs_data)
        except:
            docs_data = [{"type": "file", "name": "unknown", "docstring": docs_data}]
    
    context = {"docs": docs_data}
    result = run_jac_file("doc_generation.jac", "generate_documentation", context)
    return result

@app.route("/", methods=["GET", "POST"])
def index():
    if request.method == "POST":
        repo_url = request.form.get("repo_url")
        
        if not repo_url:
            return render_template("index.html", result="Error: Repository URL is required")
        
        try:
            # Step 1: Use JAC to clone and analyze repo
            print(f"Analyzing repository: {repo_url}")
            analysis_result = clone_and_analyze_repo(repo_url)
            
            if "error" in analysis_result:
                return render_template("index.html", result=f"JAC Analysis Error: {analysis_result['error']}")
            
            # Step 2: Use JAC to generate basic documentation
            print("Generating documentation...")
            basic_docs = generate_documentation(analysis_result)
            
            if "error" in basic_docs:
                return render_template("index.html", result=f"JAC Documentation Error: {basic_docs['error']}")
            
            # Step 3: Enhance with AI
            print("Enhancing with AI...")
            completion = client.chat.completions.create(
                extra_headers={
                    "HTTP-Referer": "https://yourwebsite.com",
                    "X-Title": "Flask Doc Generator"
                },
                model="deepseek/deepseek-chat",
                messages=[
                    {
                        "role": "system",
                        "content": """You are an advanced documentation generator that produces professional, detailed RMarkdown documentation
                        for GitHub repositories. Format your output in rich RMarkdown style."""
                    },
                    {
                        "role": "user",
                        "content": f"Repository Analysis Results:\n{basic_docs}\n\nGenerate comprehensive RMarkdown documentation for this repository: {repo_url}"
                    }
                ]
            )

            doc_output = completion.choices[0].message.content
            return render_template("index.html", result=doc_output)

        except Exception as e:
            return render_template("index.html", result=f"Error: {str(e)}")

    return render_template("index.html")

@app.route("/api/generate", methods=["POST"])
def api_generate():
    """API endpoint for documentation generation"""
    try:
        data = request.get_json()
        repo_url = data.get("repo_url")
        
        if not repo_url:
            return jsonify({"error": "Repository URL is required"}), 400
        
        # Step 1: Use JAC to clone and analyze repo
        analysis_result = clone_and_analyze_repo(repo_url)
        
        if "error" in analysis_result:
            return jsonify({"error": analysis_result["error"]}), 500
        
        # Step 2: Use JAC to generate basic documentation
        basic_docs = generate_documentation(analysis_result)
        
        if "error" in basic_docs:
            return jsonify({"error": basic_docs["error"]}), 500
        
        # Step 3: Enhance with AI
        completion = client.chat.completions.create(
            model="deepseek/deepseek-chat",
            messages=[
                {
                    "role": "system", 
                    "content": "You are a documentation generator that creates professional RMarkdown documentation for code repositories."
                },
                {
                    "role": "user",
                    "content": f"Repository Analysis:\n{basic_docs}\n\nFormat this into professional RMarkdown documentation for: {repo_url}"
                }
            ]
        )

        doc_output = completion.choices[0].message.content
        return jsonify({"documentation": doc_output})
        
    except Exception as e:
        return jsonify({"error": str(e)}), 500

@app.route("/health")
def health():
    """Health check endpoint"""
    # Check if BE folder and JAC files exist
    be_exists = os.path.exists("BE")
    repo_analyzer_exists = os.path.exists("BE/repo_analyzer.jac")
    doc_generation_exists = os.path.exists("BE/doc_generation.jac")
    
    return jsonify({
        "status": "healthy", 
        "BE_folder_exists": be_exists,
        "repo_analyzer_exists": repo_analyzer_exists,
        "doc_generation_exists": doc_generation_exists
    })

if __name__ == "__main__":
    app.run(debug=True)