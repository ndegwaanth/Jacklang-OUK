#!/usr/bin/env python3
"""
Load the Jac code and test the API integration
"""
import requests
import json
import time
import sys

def load_jac_app():
    """Load the Jac application with API support"""
    
    base_url = "http://localhost:8000"
    master_key = "poem_master_key_123"
    
    headers = {
        "Content-Type": "application/json",
        "Authorization": f"token {master_key}"
    }
    
    # Read the Jac file
    try:
        with open("poem_app.jac", "r") as f:
            jac_code = f.read()
        print("✅ Loaded poem_app.jac")
    except FileNotFoundError:
        print("❌ poem_app.jac file not found!")
        return False
    
    max_retries = 10
    for i in range(max_retries):
        try:
            print(f"🔍 Connecting to server (attempt {i+1}/{max_retries})...")
            
            # Test server connection
            response = requests.get(f"{base_url}/", headers=headers, timeout=5)
            
            if response.status_code == 200:
                print("✅ Server is running!")
                break
        except requests.exceptions.ConnectionError:
            if i == max_retries - 1:
                print("❌ Cannot connect to Jaseci server after multiple attempts")
                print("💡 Make sure to run: python run_api_server.py first")
                return False
            time.sleep(2)
    else:
        print("❌ Server connection failed")
        return False
    
    try:
        # Load the Jac code
        print("📝 Loading Jac code into Jaseci...")
        payload = {
            "code": jac_code,
            "name": "poem_app",
            "auto_run": ""
        }
        
        response = requests.post(
            f"{base_url}/js/sentinel_register", 
            headers=headers,
            json=payload,
            timeout=10
        )
        
        if response.status_code == 200:
            print("✅ Jac code loaded successfully!")
            
            # Test the poem generation API
            print("🧪 Testing poem generation API...")
            test_payload = {
                "name": "api_generate_poem",
                "ctx": {"topic": "nature"}
            }
            
            response = requests.post(
                f"{base_url}/js/walker_run",
                headers=headers,
                json=test_payload,
                timeout=30
            )
            
            if response.status_code == 200:
                result = response.json()
                if 'report' in result and result['report']:
                    poem_data = result['report'][0]
                    if poem_data.get('status') == 'success':
                        print("✅ API test successful! Poem generated:")
                        print(f"📖 Topic: {poem_data['topic']}")
                        print(f"📝 Poem: {poem_data['poem'][:100]}...")
                    else:
                        print(f"⚠️  API test completed with status: {poem_data.get('status')}")
                        print(f"💡 Message: {poem_data.get('poem', 'No message')}")
                else:
                    print("⚠️  API response format unexpected")
            else:
                print(f"⚠️  API test request failed: {response.status_code}")
            
            print("\n🎉 Backend is ready!")
            print("\n📋 Next steps:")
            print("1. Keep the server running in this terminal")
            print("2. Open a NEW terminal and go to frontend directory")
            print("3. Run: cd frontend && python -m http.server 8080")
            print("4. Open: http://localhost:8080 in your browser")
            print("5. Start generating poems with the AI!")
            
            return True
        else:
            print(f"❌ Failed to load Jac code: {response.status_code}")
            print(f"💡 Response: {response.text}")
            return False
            
    except requests.exceptions.Timeout:
        print("❌ Request timeout - API might be slow to respond")
        return False
    except Exception as e:
        print(f"❌ Error: {e}")
        return False

if __name__ == "__main__":
    print("📥 Loading Jac Poem App with API Integration...")
    print("=" * 60)
    success = load_jac_app()
    sys.exit(0 if success else 1)