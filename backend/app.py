import os
from flask import Flask, request, jsonify
import requests
from dotenv import load_dotenv

# Load environment variables from the lib folder
env_path = load_dotenv(os.path.join(os.path.dirname(__file__), '..', 'lib', '.env'))
print(f"Loading .env from: {env_path}")
load_dotenv(env_path)

app = Flask(__name__)

# Fetch API URL from environment variables
DEEPSEEK_API_URL = os.getenv('DEEPSEEK_API_URL')
flask_run_port = os.getenv('FLASK_RUN_PORT', 5000)  # Default to 5000 if not found
flask_run_host = os.getenv('FLASK_RUN_HOST', '127.0.0.1')  # Default to '127.0.0.1' if not found

# Checking that environment variables are loaded correctly
print(f"FLASK_RUN_HOST: {flask_run_host}")
print(f"FLASK_RUN_PORT: {flask_run_port}")
print(f"DEEPSEEK_API_URL: {DEEPSEEK_API_URL}")


@app.route('/chat', methods=['POST'])
def chat():
    try:
        user_message = request.json.get('message')
        if not user_message:
            return jsonify({"error": "Message is required"}), 400

        payload = {
            "model": "deepseek-r1:1.5b",
            "messages": [{"role": "user", "content": user_message}],
            "stream": False
        }

        # Log the request payload
        print(f"Payload: {payload}")

        response = requests.post(DEEPSEEK_API_URL, json=payload)

        # Log the response details
        print(f"API Response Status: {response.status_code}")
        print(f"API Response Body: {response.text}")

        response.raise_for_status()  # Raise an error for bad HTTP responses

        data = response.json()
        chatbot_reply = data.get('message', {}).get('content', 'Error: Invalid response from API.')

        return jsonify({"response": chatbot_reply}), 200

    except requests.exceptions.RequestException as req_error:
        print(f"Request error: {req_error}")
        return jsonify({"error": f"Request failed: {str(req_error)}"}), 500
    except Exception as e:
        print(f"General error: {e}")
        return jsonify({"error": str(e)}), 500


if __name__ == '__main__':
    app.run(debug=os.getenv('DEBUG') == 'True', host=flask_run_host, port=int(flask_run_port))
