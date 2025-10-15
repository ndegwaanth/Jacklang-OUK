class JacPoemApp {
    constructor() {
        this.baseUrl = 'http://localhost:8000';
        this.token = 'poem_master_key_123';
        this.init();
    }

    init() {
        this.checkServerStatus();
        this.setupEventListeners();
    }

    setupEventListeners() {
        const topicInput = document.getElementById('topicInput');
        topicInput.addEventListener('keypress', (e) => {
            if (e.key === 'Enter') {
                this.generatePoem();
            }
        });
    }

    async callWalker(walker, data = {}) {
        try {
            const response = await fetch(`${this.baseUrl}/js/walker_run`, {
                method: 'POST',
                headers: {
                    'Content-Type': 'application/json',
                    'Authorization': `token ${this.token}`
                },
                body: JSON.stringify({
                    name: walker,
                    ctx: data
                })
            });

            if (!response.ok) {
                throw new Error(`HTTP error! status: ${response.status}`);
            }

            const result = await response.json();
            return result;
        } catch (error) {
            console.error('API call failed:', error);
            throw error;
        }
    }

    async generatePoem() {
        const topicInput = document.getElementById('topicInput');
        const generateBtn = document.getElementById('generateBtn');
        const btnText = document.getElementById('btnText');
        const loadingSpinner = document.getElementById('loadingSpinner');
        const topic = topicInput.value.trim();

        if (!topic) {
            this.showError('Please enter a topic for your poem');
            return;
        }

        // Show loading state
        generateBtn.disabled = true;
        btnText.textContent = 'Generating...';
        loadingSpinner.classList.remove('hidden');
        this.hideResult();
        this.hideError();

        try {
            const result = await this.callWalker('api_generate_poem', { topic });
            
            if (result && result.report && result.report[0]) {
                const poemData = result.report[0];
                
                if (poemData.status === 'error') {
                    this.showError(poemData.poem);
                } else {
                    this.showResult(poemData.topic, poemData.poem);
                }
            } else {
                this.showError('Invalid response from server');
            }
        } catch (error) {
            this.showError(`Failed to generate poem: ${error.message}`);
        } finally {
            // Reset loading state
            generateBtn.disabled = false;
            btnText.textContent = 'Generate Poem';
            loadingSpinner.classList.add('hidden');
        }
    }

    async checkServerStatus() {
        const statusDot = document.getElementById('statusDot');
        const statusText = document.getElementById('statusText');

        try {
            const result = await this.callWalker('api_status');
            statusDot.className = 'status-dot connected';
            statusText.textContent = 'Server connected and ready';
        } catch (error) {
            statusDot.className = 'status-dot error';
            statusText.textContent = 'Server disconnected - please start the Jac server';
        }
    }

    showResult(topic, poem) {
        const resultSection = document.getElementById('resultSection');
        const poemTopic = document.getElementById('poemTopic');
        const poemContent = document.getElementById('poemContent');

        poemTopic.textContent = topic;
        poemContent.textContent = poem;
        resultSection.classList.remove('hidden');

        // Scroll to result
        resultSection.scrollIntoView({ behavior: 'smooth', block: 'nearest' });
    }

    showError(message) {
        const errorSection = document.getElementById('errorSection');
        const errorMessage = document.getElementById('errorMessage');

        errorMessage.textContent = message;
        errorSection.classList.remove('hidden');
        errorSection.scrollIntoView({ behavior: 'smooth', block: 'nearest' });
    }

    hideResult() {
        document.getElementById('resultSection').classList.add('hidden');
    }

    hideError() {
        document.getElementById('errorSection').classList.add('hidden');
    }

    async copyToClipboard() {
        const poemContent = document.getElementById('poemContent');
        const topic = document.getElementById('poemTopic').textContent;

        const textToCopy = `Poem about ${topic}:\n\n${poemContent.textContent}`;

        try {
            await navigator.clipboard.writeText(textToCopy);
            this.showTempMessage('📋 Poem copied to clipboard!');
        } catch (err) {
            console.error('Failed to copy: ', err);
        }
    }

    sharePoem() {
        const poemContent = document.getElementById('poemContent');
        const topic = document.getElementById('poemTopic').textContent;
        
        const textToShare = `Check out this AI-generated poem about ${topic}:\n\n${poemContent.textContent}\n\nCreated with Jac AI Poem Generator`;

        if (navigator.share) {
            navigator.share({
                title: `Poem about ${topic}`,
                text: textToShare
            });
        } else {
            // Fallback: copy to clipboard
            this.copyToClipboard();
        }
    }

    generateNew() {
        this.hideResult();
        document.getElementById('topicInput').value = '';
        document.getElementById('topicInput').focus();
    }

    setExample(topic) {
        document.getElementById('topicInput').value = topic;
        document.getElementById('topicInput').focus();
    }

    showTempMessage(message) {
        // Create temporary message element
        const msgElement = document.createElement('div');
        msgElement.textContent = message;
        msgElement.style.cssText = `
            position: fixed;
            top: 20px;
            right: 20px;
            background: #10b981;
            color: white;
            padding: 15px 20px;
            border-radius: 8px;
            z-index: 1000;
            box-shadow: 0 4px 12px rgba(0,0,0,0.15);
        `;

        document.body.appendChild(msgElement);

        // Remove after 3 seconds
        setTimeout(() => {
            document.body.removeChild(msgElement);
        }, 3000);
    }
}

// Global functions for HTML onclick handlers
function generatePoem() {
    app.generatePoem();
}

function copyToClipboard() {
    app.copyToClipboard();
}

function sharePoem() {
    app.sharePoem();
}

function generateNew() {
    app.generateNew();
}

function setExample(topic) {
    app.setExample(topic);
}

function hideError() {
    app.hideError();
}

// Initialize the app when page loads
let app;
document.addEventListener('DOMContentLoaded', () => {
    app = new JacPoemApp();
});