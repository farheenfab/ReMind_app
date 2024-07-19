import 'package:flutter/material.dart';

class ChatPage extends StatefulWidget {
  @override
  _ChatPageState createState() => _ChatPageState();
}

class _ChatPageState extends State<ChatPage> {
  final TextEditingController _controller = TextEditingController();
  final List<Map<String, String>> _messages = [
    {"sender": "bot", "text": "Hello! How can I assist you today?"}
  ];

  void _sendMessage(String text) {
    if (text.isNotEmpty) {
      setState(() {
        _messages.add({"sender": "user", "text": text});
        _controller.clear();
      });

      // Get a response from the bot
      String response = _generateResponse(text);
      Future.delayed(Duration(seconds: 1), () {
        setState(() {
          _messages.add({"sender": "bot", "text": response});
        });
      });
    }
  }

  String _generateResponse(String userInput) {
    final lowerCaseInput = userInput.toLowerCase();

    if (lowerCaseInput.contains('hello') || lowerCaseInput.contains('hi')) {
      return "Hi there! How can I help you?";
    } else if (lowerCaseInput.contains('how are you')) {
      return "I'm just a bot, but I'm doing well. How can I assist you?";
    } else if (lowerCaseInput.contains('help')) {
      return "Sure, I’m here to help. What do you need assistance with?";
    } else if (lowerCaseInput.contains('what is your name')) {
      return "I'm a simple chatbot created to assist you.";
    } else if (lowerCaseInput.contains('bye') ||
        lowerCaseInput.contains('goodbye')) {
      return "Goodbye! Have a great day!";
    } else {
      return "Sorry, I didn't understand that. Can you ask something else?";
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Chat'),
      ),
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
              itemCount: _messages.length,
              itemBuilder: (context, index) {
                final message = _messages[index];
                final isUserMessage = message['sender'] == 'user';
                return Container(
                  alignment: isUserMessage
                      ? Alignment.centerRight
                      : Alignment.centerLeft,
                  padding: EdgeInsets.symmetric(vertical: 10, horizontal: 20),
                  child: Container(
                    padding: EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      color: isUserMessage ? Colors.blue : Colors.grey[300],
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Text(
                      message['text']!,
                      style: TextStyle(
                        color: isUserMessage ? Colors.white : Colors.black,
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
          Padding(
            padding: EdgeInsets.all(8.0),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _controller,
                    decoration: InputDecoration(
                      hintText: 'Type your message...',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                  ),
                ),
                IconButton(
                  icon: Icon(Icons.send),
                  onPressed: () {
                    _sendMessage(_controller.text);
                  },
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
