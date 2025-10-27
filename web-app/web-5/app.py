from flask import Flask, render_template
import subprocess
import os

app = Flask(__name__)

class JACBackend:
    def __init__(self):
        self.jac_path = "jac_backend"
    
    def get_hello_message(self):
        """Get hello message from JAC"""
        try:
            # First, let's check if the JAC file exists
            jac_file = os.path.join(self.jac_path, "hello_world.jac")
            if not os.path.exists(jac_file):
                return "JAC file not found. Please create hello_world.jac in jac_backend folder"
            
            # Run JAC command with full path
            cmd = f"cd {self.jac_path} && jac run hello_world.jac"
            result = subprocess.run(
                cmd,
                shell=True,
                capture_output=True,
                text=True,
                timeout=10  # Add timeout to prevent hanging
            )
            
            # Debug output
            print(f"Return code: {result.returncode}")
            print(f"STDOUT: {result.stdout}")
            print(f"STDERR: {result.stderr}")
            
            if result.returncode == 0:
                message = result.stdout.strip()
                return message if message else "JAC executed but no output"
            else:
                return f"JAC Error: {result.stderr}"
                
        except subprocess.TimeoutExpired:
            return "JAC command timed out"
        except Exception as e:
            return f"System Error: {str(e)}"

jac_backend = JACBackend()

@app.route('/')
def hello():
    message = jac_backend.get_hello_message()
    return render_template('index.html', message=message)

@app.route('/test-jac')
def test_jac():
    """Test JAC directly"""
    message = jac_backend.get_hello_message()
    return f"<h1>JAC Test Result:</h1><pre>{message}</pre>"

if __name__ == '__main__':
    app.run(debug=True, port=5000)