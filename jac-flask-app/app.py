from flask import Flask, render_template, request, jsonify
from datetime import datetime

app = Flask(__name__)

# In-memory storage (simulating Jac graph)
users = []

@app.route('/')
def index():
    return render_template('index.html')

@app.route('/api/users', methods=['GET'])
def get_users():
    """Get all users - simulates Jac walker"""
    return jsonify({
        "success": True,
        "users": users,
        "count": len(users)
    })

@app.route('/api/users', methods=['POST'])
def create_user():
    """Create a new user - simulates Jac walker"""
    user_data = request.json
    
    new_user = {
        "name": user_data.get('name'),
        "email": user_data.get('email'),
        "age": user_data.get('age'),
        "created_at": datetime.now().isoformat()
    }
    
    users.append(new_user)
    
    return jsonify({
        "success": True,
        "user": new_user
    })

@app.route('/api/analyze', methods=['POST'])
def analyze_users():
    """Analyze user data - simulates Jac AI processing"""
    if not users:
        return jsonify({
            "success": True,
            "analysis": {
                "total_users": 0,
                "average_age": 0,
                "email_domains": {}
            }
        })
    
    total_age = sum(user['age'] for user in users)
    avg_age = total_age / len(users)
    
    # Analyze email domains (simulating Jac processing)
    domains = {}
    for user in users:
        if '@' in user['email']:
            domain = user['email'].split('@')[1]
            domains[domain] = domains.get(domain, 0) + 1
        else:
            domains['unknown'] = domains.get('unknown', 0) + 1
    
    return jsonify({
        "success": True,
        "analysis": {
            "total_users": len(users),
            "average_age": round(avg_age, 1),
            "email_domains": domains
        }
    })

if __name__ == '__main__':
    print("Starting Flask app on http://localhost:5000")
    print("Note: Running in mock mode (Jaseci not installed)")
    app.run(debug=True, port=5000)