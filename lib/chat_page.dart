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
        backgroundColor: Color.fromARGB(255, 41, 19, 76), // Dark Purple background color for AppBar
        title: Text(
          'Chat',
          style: TextStyle(color: Colors.white), // White color for the title
        ),
        iconTheme: IconThemeData(
          color: Colors.white, // White color for the back arrow
        ),
        bottom: PreferredSize(
          preferredSize: Size.fromHeight(1.0),
          child: Divider(
            height: 1.0,
            color: Colors.black,
          ),
        ),
      ),
      body: Container(
        color: Colors.white, // Grey background color for the whole page
        child: Column(
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
                        color: isUserMessage
                            ? const Color.fromARGB(255, 41, 19, 76)
                            : Color.fromARGB(255, 199, 197, 197),
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
            Divider(
              height: 1.0,
              color: const Color.fromARGB(255, 31, 31, 31),
            ),
            Container(
              decoration: BoxDecoration(
                border: Border.all(
                  color: Color.fromARGB(255, 45, 44, 44),
                ),
                // width: 1.0), // Black border
              ),
              padding: EdgeInsets.all(8.0),
              child: Row(
                children: [
                  Expanded(
                    child: TextField(
                      controller: _controller,
                      decoration: InputDecoration(
                        hintText: 'Type your message...',
                        hintStyle:
                            TextStyle(color: Colors.grey), // Hint text color
                        border: InputBorder.none, // Removes the default border
                      ),
                      style: TextStyle(color: Colors.black), // Text input color
                    ),
                  ),
                  IconButton(
                    icon: Icon(Icons.send),
                    color: const Color.fromARGB(255, 41, 19, 76), // Send button color
                    onPressed: () {
                      _sendMessage(_controller.text);
                    },
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
