**Chatbot Application**

Overview
This project demonstrates a simple chatbot application that uses Flutter for the frontend and Flask for the backend. The chatbot leverages the DeepSeek API to process user messages and generate responses. The app runs locally using Ollama for running the model and communicates between Flutter (frontend) and Flask (backend).

Features:
* Flutter Frontend: A mobile interface to interact with the chatbot. The app allows users to input messages and displays the chatbot’s response.
* Flask Backend: A Flask API that processes user messages, interacts with the DeepSeek model, and returns the chatbot's response.

Dependencies:
Frontend (Flutter):
Ensure you have the following Flutter dependencies in your pubspec.yaml:
* http
* flutter_dotenv

 If not add them and Run flutter pub get to install the dependencies.

Backend (Flask):
Ensure you have the following Python dependencies:
* Flask
* requests
* python-dotenv
You can simply add them by navigating to backend directory and running the following command: pip install -r requirements.txt

Setup Instruction:
Backend (Flask):
1. Clone the repository and navigate to the backend directory.
2. Create a .env file in the lib folder with the following variables:
    * DEEPSEEK_API_URL=<your_deepseek_api_url> 
    * FLASK_RUN_HOST=<your_flask_host> 
    * FLASK_RUN_PORT=<port_on_which_flask_is_running> 
    * DEBUG=True	

3. Run the Flask backend: python app.py
4. Your backend will be available at http://FLASK_RUN_HOST:FLASK_RUN_PORT/chat.

Frontend (Flutter):
1. Clone the repository and navigate to the Flutter project directory.
2. Add a new variable in .env file:
    * BACKEND_URL=http://localhost:5001/chat
3. Run the flutter app: flutter run 
4. The frontend will interact with the Flask backend and show the chatbot responses.

How it Works:
* The Flutter frontend sends a message to the Flask backend.
* The Flask API processes the message, interacts with the DeepSeek model, and returns the response.
* The frontend displays the chatbot's response and allows the user to continue the conversation.

Running Locally with Ollama:
This project runs locally using Ollama for model processing. Ensure that Ollama is set up properly on your local machine to run the DeepSeek model.

Author: 
Harris Hussain 
harrishussain2408@gmail.com

License:
This project is open-source and available under the MIT License.
