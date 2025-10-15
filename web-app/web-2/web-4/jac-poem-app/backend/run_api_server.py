#!/usr/bin/env python3
"""
Run the Jac API Server with OpenAI/OpenRouter integration - Windows Compatible
"""
import os
import sys
import subprocess
import time

def check_dependencies():
    """Check and install required packages"""
    print("📦 Checking dependencies...")
    
    # Skip the problematic jaseci import check and just install
    try:
        import jaseci
        print("✅ jaseci is installed")
    except ImportError:
        print("❌ jaseci not found. Please install manually:")
        print("   pip install jaseci")
        return False
    
    try:
        import openai
        print("✅ openai is installed")
    except ImportError:
        print("📦 Installing openai...")
        subprocess.run([sys.executable, "-m", "pip", "install", "openai"])
    
    try:
        import requests
        print("✅ requests is installed")
    except ImportError:
        print("📦 Installing requests...")
        subprocess.run([sys.executable, "-m", "pip", "install", "requests"])
    
    return True

def start_jaseci_server():
    """Start Jaseci server with Windows compatibility"""
    print("🚀 Starting Jaseci Server...")
    print("📡 API Server: http://localhost:8000")
    print("🔑 Using OpenRouter API Key")
    print("🤖 AI Model: deepseek/deepseek-chat")
    print("⏹️  Press Ctrl+C to stop the server")
    
    # Set environment variables
    os.environ['JASECI_CONFIG'] = '{"master_key": "poem_master_key_123"}'
    
    try:
        # Start Jaseci server directly without the problematic signal module
        print("🔧 Starting server (Windows compatible mode)...")
        subprocess.run([
            sys.executable, "-m", "jaseci", "serv", "-m",
            "--host", "0.0.0.0",
            "--port", "8000"
        ])
    except KeyboardInterrupt:
        print("\n🛑 Server stopped")
    except Exception as e:
        print(f"❌ Error: {e}")
        print("💡 Try running: python -m jaseci serv -m")

if __name__ == "__main__":
    print("🎭 Jac AI Poem Generator - API Version (Windows)")
    print("=" * 50)
    
    if check_dependencies():
        start_jaseci_server()
    else:
        print("❌ Please install missing dependencies and try again")