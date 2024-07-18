import 'package:firebase_core/firebase_core.dart';
// import 'package:flutter/foundation.dart';

import 'journal.dart';
import 'package:avatar_glow/avatar_glow.dart';
import 'package:flutter/material.dart';
// import 'package:flutter_tts/flutter_tts.dart';
import 'dart:async';
import 'package:google_generative_ai/google_generative_ai.dart';
import 'messages.dart';
import 'package:speech_to_text/speech_to_text.dart' as stt;


Future<void> main() async{
    WidgetsFlutterBinding.ensureInitialized();
    await Firebase.initializeApp();
    // Run the app
    runApp(const MyApp());
  
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Alzheimer\'s App',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      // home: const SplashScreen(),
      home: const MyHomePage(),
      // home: const JournalDiaryEntry(),
    );

  }
}
class MyHomePage extends StatefulWidget {
  const MyHomePage ({super.key});
  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  final TextEditingController _userInput = TextEditingController();
  final apiKey = 'AIzaSyDDs23kIZKv2g_uRzl1aHFipuRva-aKyks';
  final List<Message> _messages = [];
  var history = "You are responsible for conversing with an Alzheimer's disease patient. \nThe following are the instructions to keep in mind while conversing with the patient:\n\n1. You start by asking the person how they are AND how was their day so far.\n2. Ask only one question at a time. DO NOT include multiple questions in a sentence. DO NOT use emojis in the questions.\n3. While conversing, perform a sentiment analysis of the conversation. The patient may be in a good, bad, or neutral mood so converse according to the patient's behavior.\n4. DO NOT repeat the questions. If the patient does not respond to the questions directly, ask something like 'What happened?' or 'Oh what's wrong'. Be empathetic. If something is troubling them, try to get to know the reason for their trouble.\n5. If something is troubling them, try calming them by guiding them through some short breathing exercises or saying some calming and comforting words like \n\"Everything is going to be fine.\", \"I understand this is hard for you.\", \"It's okay to feel upset. I'm here for you.\", \"Take your time, there's no rush.\", \"You are not alone. I'm right here with you.\", \"Don't worry, we'll figure this out together.\". Using a gentle tone and maintaining comforting behavior is very important during the conversation. \n6. Ask them what they did during the day. \n7. The conversation should not include more than 20 questions and responses. If the conversation extends, conclude it by saying \"Thank you for your time, I hope our conversation made you feel better. Have a nice day!\".\n8. Finally summarize the conversation and make a report with the title \"Conversation Summary and Symptom Report:\" on the following symptoms noticed in the conversation:\n- Difficulty with Everyday Task: Trouble completing familiar activities (daily routine)\n- Language Problems: Struggling with vocabulary, leading to difficulty finding the right words or following conversations.\n- Confusion: Disorientation with time, place, and identity of people, including loved ones.\n- Loss of Initiative: Reduced interest in hobbies, activities, and social interactions.\n- Mood and Behavior Changes: Depression, anxiety, irritability, aggression, and social withdrawal.\n- Physical Symptoms: Difficulty with movement, coordination, and eventually the loss of mobility.\n- Sleep Problems: Disrupted sleep patterns, including insomnia or excessive sleeping.\n9. Again, using a gentle and friendly tone and maintaining comforting behavior is very important during the conversation. You are talking to the patient directly.";
  
  //Speech to Text (Microphone Icon)
  final stt.SpeechToText _speech  = stt.SpeechToText();
  String _recognizedText = "";
  bool _isListening = false;
  double _speechConfidence = 0;

  @override
  void initState() {
    super.initState();
    _initSpeechState();

    // flutterTts.setCompletionHandler(() {
    //   setState(() {
    //     isSpeaking = false;
    //   });
    // });
    // flutterTts.setCancelHandler(() {
    //   setState(() {
    //     isSpeaking = false;
    //   });
    // });
  }

  void _initSpeechState() async {
    _isListening = await _speech.initialize();
    setState(() {});
  }

  void startListening() async{
    await _speech.listen(onResult: onSpeechResult);
    setState(() {
      _speechConfidence = 0;
    });
  }

  void onSpeechResult(result){
    setState(() {
      _recognizedText = "${result.recognizedWords}";
      _speechConfidence = result.confidence;
      _userInput.text = _recognizedText;

    });
  }

  void clearRecognizedText() {
    setState(() {
      _recognizedText = "";
      // _speechConfidence = 0.0; // Assuming you want to reset confidence as well
      _userInput.clear(); // Clear the text field
    });
  }

  void stopListening() async{
    await _speech.stop();
    setState(() {});
  }

  // // Text to Speech
  // double volume = 1.0;
  // double pitch = 1.0;
  // double speechRate = 0.5;
  // List<String> ? languages;
  // String langCode = "en-US";
  // // late final response;

  bool isSpeaking = false;


  // Custom Gemini Chatbot
  Future<void> converseWithGemini() async{
    final userMsg = _userInput.text;

    setState(() {
      _messages.add(Message(isUser: true, message: userMsg, date: DateTime.now().toString().substring(0,16), isSpeaking: false));
    });


    final config = GenerationConfig(
        temperature: 1,
        topP: 0.95,
        topK: 64,
        maxOutputTokens: 8192,
        responseMimeType: "text/plain"
    );

    final model = GenerativeModel(
      model: "gemini-1.5-flash",
      apiKey: "AIzaSyDzEnn0L7b0HDurSaoC7iIvx0AmnlUcppU", 
      generationConfig : config //apiKey
    );
    
    try{
      final content = [Content.text(history)];
      final response = await model.generateContent(content);

      setState(() {
        _messages.add(Message(isUser: false, message: response.text?? "", date: DateTime.now().toString().substring(0,16), isSpeaking: false));
      });
    }catch (e){
      setState(() {
        _messages.add(Message(isUser: false, message: "An error occurred: $e", date: DateTime.now().toString().substring(0, 16), isSpeaking: false));
      });
    }

    // print(userMsg);
  }
  String currentMessage = "";

  // // Chat UI
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading:
        IconButton(onPressed: () => Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => const JournalDiaryEntry()),
        ), icon: const Icon(Icons.add_circle))
        ,
        title: const Text('Chat with Gemini'),
        centerTitle: true,

      ),

      body: Container(
        decoration: const BoxDecoration(
            color: Colors.white
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            Expanded(
              child: ListView.builder(
                itemCount: _messages.length,
                itemBuilder: (context, index) {
                  final message = _messages[index];
                  return Messages(
                    isUser: message.isUser,
                    message: message.message,
                    date: message.date,
                    onPressed: () {
                      setState(() {
                        if (isSpeaking && currentMessage == message.message) {
                          _stop();
                        } else {
                          _speak(message.message);
                          currentMessage = message.message;
                        }
                        isSpeaking = !isSpeaking;
                      });
                    },
                    isSpeaking: isSpeaking && currentMessage == message.message,
                  );
                },
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Row(
                children: [
                  //MICROPHONE ICON
                  AvatarGlow(
                    animate: _speech.isListening,
                    glowColor: Colors.red,
                    glowRadiusFactor: 0.4,
                    duration: const Duration(milliseconds: 2000),
                    repeat: true,
                    child: IconButton(
                        padding: const EdgeInsets.all(12),
                        iconSize: 30,
                        style: ButtonStyle(
                          backgroundColor: WidgetStateProperty.all(_speech.isListening ? Colors.red : Colors.black),
                          foregroundColor: WidgetStateProperty.all(Colors.white),
                          shape: WidgetStateProperty.all(const CircleBorder()),
                        ),
                        onPressed: _speech.isListening ? stopListening: startListening,
                        icon: Icon( _speech.isListening ? Icons.mic: Icons.mic_none)),
                  ),
                  // IconButton(
                  //     padding: EdgeInsets.all(7),
                  //     iconSize: 35,
                  //     style: ButtonStyle(
                  //       backgroundColor: isSpeaking ? WidgetStateProperty.all(Colors.black) : WidgetStateProperty.all(Colors.green) ,
                  //       foregroundColor: WidgetStateProperty.all(Colors.white),
                  //       shape: WidgetStateProperty.all(CircleBorder()),
                  //     ),
                  //     onPressed: (){
                  //       if (isSpeaking) {
                  //         _stop();
                  //       } else {
                  //         _speak();
                  //       }
                  //       // _speak();
                  //
                  //     },
                  //     icon: isSpeaking  ? Icon(Icons.pause) : Icon(Icons.play_arrow)),
                  const Spacer(),
                  // TEXT FIELD
                  Expanded(
                    flex: 15,
                    child: TextField(
                      style: const TextStyle(color: Colors.black),
                      controller: _userInput,
                      keyboardType: TextInputType.phone,
                      decoration: InputDecoration(
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(15),
                        ),
                        hintText: 'Enter your message here',
                      ),
                    ),
                  ),
                  const Spacer(),
                  // SEND BUTTON
                  IconButton(
                      padding: const EdgeInsets.all(12),
                      iconSize: 30,
                      style: ButtonStyle(
                        backgroundColor: WidgetStateProperty.all(Colors.black),
                        foregroundColor: WidgetStateProperty.all(Colors.white),
                        shape: WidgetStateProperty.all(const CircleBorder()),
                      ),
                      onPressed: (){

                        converseWithGemini();
                        clearRecognizedText();

                      },
                      icon: const Icon(Icons.send))
                ],
              ),
            )

          ],
        ),
      ),
    );
  }

  // FlutterTts flutterTts = FlutterTts();
  void _speak(String text) async {
    // await flutterTts.speak(text);
    setState(() {
      isSpeaking = true;
    });
  }

  void _stop() async{
    // await flutterTts.stop();
    setState(() {
      isSpeaking = false;
    });
  }

}

//----------------------------[Previous Code]----------------------------------------

// void main() async {
//   WidgetsFlutterBinding.ensureInitialized();
//   await Firebase.initializeApp();
//   runApp(const MyApp());
// }
//
// class MyApp extends StatelessWidget {
//   const MyApp({super.key});
//
//
//   @override
//   Widget build(BuildContext context) {
//     return MaterialApp(
//       title: 'Flutter Demo',
//       theme: ThemeData(
//         colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
//         useMaterial3: true,
//       ),
//       home: const MyHomePage(title: 'Flutter Demo Home Page'),
//     );
//   }
// }
//
// class MyHomePage extends StatefulWidget {
//   const MyHomePage({super.key, required this.title});
//   final String title;
//
//   @override
//   State<MyHomePage> createState() => _MyHomePageState();
// }
//
// class _MyHomePageState extends State<MyHomePage> {
//   int _counter = 0;
//
//   void _incrementCounter() {
//     setState(() {
//       _counter++;
//     });
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         backgroundColor: Theme.of(context).colorScheme.inversePrimary,
//         title: Text(widget.title),
//       ),
//       body: Center(
//         child: Column(
//           mainAxisAlignment: MainAxisAlignment.center,
//           children: <Widget>[
//             const Text(
//               'You have pushed the button this many times:',
//             ),
//             Text(
//               '$_counter',
//               style: Theme.of(context).textTheme.headlineMedium,
//             ),
//           ],
//         ),
//       ),
//       floatingActionButton: FloatingActionButton(
//         onPressed: _incrementCounter,
//         tooltip: 'Increment',
//         child: const Icon(Icons.add),
//       ),
//     );
//   }
// }
