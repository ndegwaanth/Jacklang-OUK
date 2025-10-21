// Load users when page loads
document.addEventListener('DOMContentLoaded', function() {
    loadUsers();
});

// Handle form submission
document.getElementById('userForm').addEventListener('submit', function(e) {
    e.preventDefault();
    
    const userData = {
        name: document.getElementById('name').value,
        email: document.getElementById('email').value,
        age: parseInt(document.getElementById('age').value)
    };

    fetch('/api/users', {
        method: 'POST',
        headers: {
            'Content-Type': 'application/json',
        },
        body: JSON.stringify(userData)
    })
    .then(response => response.json())
    .then(data => {
        if (data.success) {
            alert('User created successfully!');
            document.getElementById('userForm').reset();
            loadUsers();
        }
    })
    .catch(error => console.error('Error:', error));
});

// Load all users
function loadUsers() {
    fetch('/api/users')
        .then(response => response.json())
        .then(data => {
            const usersList = document.getElementById('usersList');
            if (data.success && data.users.length > 0) {
                usersList.innerHTML = data.users.map(user => `
                    <div class="user-item">
                        <strong>${user.name}</strong> (${user.age})<br>
                        ${user.email}<br>
                        <small>Created: ${new Date(user.created_at).toLocaleString()}</small>
                    </div>
                `).join('');
            } else {
                usersList.innerHTML = '<p>No users found</p>';
            }
        });
}

// Analyze users
function analyzeUsers() {
    fetch('/api/analyze', {
        method: 'POST',
        headers: {
            'Content-Type': 'application/json',
        }
    })
    .then(response => response.json())
    .then(data => {
        if (data.success) {
            const analysis = data.analysis;
            document.getElementById('analysisResult').innerHTML = `
                <h3>User Analysis</h3>
                <p><strong>Total Users:</strong> ${analysis.total_users}</p>
                <p><strong>Average Age:</strong> ${analysis.average_age.toFixed(1)}</p>
                <p><strong>Email Domains:</strong> ${JSON.stringify(analysis.email_domains)}</p>
            `;
        }
    });
}