import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class Message {
  final bool isUser;
  final String message;
  final String date;
  // final VoidCallback onPressed;
  final bool isSpeaking;

  Message(
      {required this.isUser,
      required this.message,
      required this.date,
      this.isSpeaking = false});
}

class Messages extends StatelessWidget {
  final bool isUser;
  final String message;
  final String date;
  final VoidCallback onPressed;
  final bool isSpeaking;

  const Messages({
    super.key,
    required this.isUser,
    required this.message,
    required this.date,
    required this.onPressed,
    required this.isSpeaking,
  });
  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(15),
      margin: EdgeInsets.symmetric(vertical: 15)
          .copyWith(left: isUser ? 100 : 10, right: isUser ? 10 : 100),
      decoration: BoxDecoration(
          color: isUser ? Colors.blueAccent : Colors.grey,
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(10),
            bottomLeft: isUser ? Radius.circular(10) : Radius.zero,
            topRight: Radius.circular(10),
            bottomRight: isUser ? Radius.zero : Radius.circular(10),
          )),
      child: Stack(
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(message,
                  style: TextStyle(fontSize: 16, color: Colors.white)),
              const Text(""),
              Text(date, style: TextStyle(fontSize: 10, color: Colors.white)),
            ],
          ),
          Positioned(
            bottom: 0,
            right: 0,
            child: IconButton(
                padding: EdgeInsets.all(1),
                iconSize: 20,
                style: ButtonStyle(
                  backgroundColor: isSpeaking
                      ? WidgetStateProperty.all(Colors.black)
                      : WidgetStateProperty.all(Colors.green),
                  foregroundColor: WidgetStateProperty.all(Colors.white),
                  shape: WidgetStateProperty.all(CircleBorder()),
                ),
                onPressed: onPressed,
                icon: isSpeaking ? Icon(Icons.pause) : Icon(Icons.play_arrow)),
          ),
        ],
      ),
    );
  }
}
