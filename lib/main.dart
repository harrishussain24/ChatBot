import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'dart:async';

Future<void> main() async {
  await dotenv.load(fileName: "lib/.env");
  WidgetsFlutterBinding.ensureInitialized();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Chatbot',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: ChatScreen(),
    );
  }
}

class ChatScreen extends StatefulWidget {
  @override
  _ChatScreenState createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  TextEditingController _controller = TextEditingController();
  List<String> _messages = [];
  bool _isLoading = false;
  String _typingDots = '';

  // Timer for typing dots effect
  Timer? _typingTimer;

  // Function to send messages and handle responses
  Future<void> _sendMessage(String message) async {
    if (message.isEmpty) return;

    setState(() {
      _isLoading = true;
      _typingDots = ''; // Clear typing dots when starting the request
    });

    final String? backendUrl = dotenv.env['BACKEND_URL'];

    // Simulate typing dots effect
    _simulateTypingDots();

    final response = await http.post(
      Uri.parse(backendUrl!), // Backend URL
      headers: {'Content-Type': 'application/json'},
      body: json.encode({'message': message}),
    );

    setState(() {
      _isLoading = false;
    });

    // Stop the typing dots after receiving a response
    _stopTypingDots();

    if (response.statusCode == 200) {
      final responseData = json.decode(response.body);
      setState(() {
        _messages.add('You: $message');
        _messages.add('Bot: ${responseData['response']}');
      });
    } else {
      setState(() {
        _messages.add('Error: Unable to get response from the bot.');
      });
    }
  }

  // Simulate typing dots effect by updating _typingDots
  void _simulateTypingDots() {
    int count = 0;
    _typingTimer = Timer.periodic(Duration(milliseconds: 500), (timer) {
      setState(() {
        if (count == 3) {
          _typingDots = '';
          count = 0;
        } else {
          _typingDots += '.';
          count++;
        }
      });
    });
  }

  // Stop typing dots effect
  void _stopTypingDots() {
    if (_typingTimer != null && _typingTimer!.isActive) {
      _typingTimer!.cancel();
      setState(() {
        _typingDots = '';
      });
    }
  }

  // Build the UI of the chat screen
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Chatbot Using DeepSeek')),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 10.0, vertical: 20.0),
        child: Column(
          children: [
            Expanded(
              child: ListView.builder(
                itemCount: _messages.length,
                itemBuilder: (context, index) {
                  return ListTile(
                    title: Text(_messages[index]),
                  );
                },
              ),
            ),
            if (_isLoading)
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text(
                  'Bot is generating$_typingDots', // Display typing dots
                  style: TextStyle(fontStyle: FontStyle.italic),
                ),
              ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Row(
                children: [
                  Expanded(
                    child: TextField(
                      controller: _controller,
                      decoration: InputDecoration(
                          hintText: 'Type a message',
                          suffixIcon: IconButton(
                            icon: Icon(Icons.send),
                            onPressed: () {
                              String message = _controller.text;
                              if (message.isNotEmpty) {
                                _sendMessage(message);
                                _controller.clear();
                              }
                            },
                          ),
                          border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10))),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
