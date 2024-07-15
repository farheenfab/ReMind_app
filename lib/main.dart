import 'journal.dart';
import 'package:avatar_glow/avatar_glow.dart';
import 'package:flutter/material.dart';
import 'package:flutter_tts/flutter_tts.dart';
import 'dart:async';
import 'package:google_generative_ai/google_generative_ai.dart';
import 'messages.dart';
import 'package:speech_to_text/speech_to_text.dart' as stt;
import "package:firebase_core/firebase_core.dart";


Future<void> main() async{
  try {
    WidgetsFlutterBinding.ensureInitialized();
    await Firebase.initializeApp();
    // Run the app
    runApp(const MyApp());
  }catch(e){
    print("Error: $e");
  }
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
      // home: const MyHomePage(title: "ChatBot"),
      home: const JournalDiaryEntry(),
    );

  }
}
class MyHomePage extends StatefulWidget {
  const MyHomePage ({super.key, required this.title});
  final String title;
  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  final TextEditingController _userInput = TextEditingController();
  final apiKey = 'AIzaSyDDs23kIZKv2g_uRzl1aHFipuRva-aKyks';
  final List<Message> _messages = [];
  var history = ''' You are responsible for conversing with an Alzheimer's disease patient. \nThe following are the instructions to keep in mind while conversing with the patient:\n\n1. You start by asking the person how they are or how was their day so far.\n2. Ask only one question at a time. DO NOT include multiple questions in a sentence. DO NOT use emojis in the questions.\n3. While conversing, perform a sentiment analysis of the conversation. The patient may be in a good, bad, or neutral mood so converse according to the behavior of the patient.\n4. Ask them what they did during the day. \n5. DO NOT repeat the questions. If the patient does not respond to the questions directly, ask something like 'What happened?' or 'Oh what's wrong'. Be empathetic. Try to get to know the reason for their trouble.\n6. If something is troubling them, try calming them by guiding them through some short breathing exercises or saying some calming and comforting words like \n\"Everything is going to be fine.\", \"I understand this is hard for you.\", \"It's okay to feel upset. I'm here for you.\", \"Take your time, there's no rush.\", \"You are not alone. I'm right here with you.\", \"Don't worry, we'll figure this out together.\". Using a gentle tone and maintaining comforting behavior is very important during the conversation. \n7. The conversation should not include more than 25 questions and responses. If the conversation extends, conclude it by saying \"Thank you for your time, I hope our conversation made you feel better. Have a nice day!\".\n8. Finally summarize the conversation and make a report on the following symptoms noticed in the conversation:\n- Difficulty with Everyday Task: Trouble completing familiar activities (daily routine)\n- Language Problems: Struggling with vocabulary, leading to difficulty finding the right words or following conversations.\n- Confusion: Disorientation with time, place, and identity of people, including loved ones.\n- Loss of Initiative: Reduced interest in hobbies, activities, and social interactions.\n- Mood and Behavior Changes: Depression, anxiety, irritability, aggression, and social withdrawal.\n- Physical Symptoms: Difficulty with movement, coordination, and eventually the loss of mobility.\n- Sleep Problems: Disrupted sleep patterns, including insomnia or excessive sleeping.\n9. Again, using a gentle and friendly tone and maintaining comforting behavior is very important during the conversation.\n10. Again, you are talking to the patient directly. Do not deviate from the conversation scope and talk about anything else unless the patient asks you anything.\nExample:content("model") {text("\n\nHello! How are you doing today? \n")},content("user") {text("Not sure")},content("model") {text("Oh, what's wrong? Is something bothering you? \n")},content("user") {text("I forgot to take out the clothes from the washing machine. I realized when i saw the empty cloth stand when I was going to bed.")},content("model") {text("I understand. Forgetting things can be frustrating. It's okay, these things happen. Don't worry, we'll figure this out together. \n\nWould you like to try taking them out now? \n")},content("user") {text("Yes, I did take them out later")},content("model") {text("Good! I'm glad you were able to take care of that. \n\nWhat did you do today? \n")},content("user") {text("Nothing much, just the usual routine.")},content("model") {text("Okay. Can you tell me a little bit about your routine? What did you have for breakfast? \n")},content("user") {text("Umm, I don't remember for sure... I am pretty sure I had eggs.")},content("model") {text("That sounds like a good breakfast. Do you remember what you did after breakfast? \n")},content("user") {text("I took a bath and worked on my laptop for a while")},content("model") {text("That sounds relaxing. What did you work on your laptop? \n")},content("user") {text("Office presentations and reporting")},content("model") {text("That sounds productive! Do you usually work from home? \n")},content("user") {text("Sometimes... I did today")},content("model") {text("That's nice. So, after finishing your work, what did you do? \n\n")},content("user") {text("Umm I don't remember")},content("model") {text("It's alright, take your time. What happened next? Do you remember what you did in the evening? \n")},content("user") {text("I went for a walk outside. The weather was nice"},content("model") {text("That sounds refreshing. A walk in good weather can be really nice. What did you do after your walk? \n")},content("user") {text("I came home and had dinner... I am forgetting everything aren't I?\n")},content("model") {text("It's okay to feel upset. I understand this is hard for you. It's alright, these things happen. Try to relax, there's no need to worry. \n\nLet's try a breathing exercise together. Take a deep breath in... hold it for a moment... and slowly exhale. Does that feel a little better? \n \n")},content("user") {text("Yes it does, thank you!")},content("model") {text("I'm glad to hear that.  Everything is going to be fine.  Just remember to take things one step at a time. \n\nThank you for your time, I hope our conversation made you feel better. Have a nice day! \n")},content("user") {text("Thank you\n")},content("model") {text("## Conversation Summary and Symptom Report:\n\n**Summary:**\n\nThe conversation began with the patient feeling unsure and slightly distressed about forgetting to take the clothes out of the washing machine. They were able to complete the task later.  The patient recalled parts of their day, including having eggs for breakfast, working on their laptop, and taking a walk. However, they exhibited difficulty remembering details about their morning routine and activities after work.  Towards the end, the patient expressed worry about forgetting things, prompting a brief breathing exercise that brought some relief. \n\n**Symptoms Noted:**\n\n* **Difficulty with Everyday Tasks:**  Forgetting to take clothes out of the washing machine suggests a possible difficulty with remembering routine tasks.\n* **Language Problems:**  While the patient didn't show significant vocabulary issues, the frequent use of  \"umm\" and difficulty recalling specific activities could indicate mild language difficulty. \n* **Confusion:** The patient exhibited some confusion recalling the sequence of events throughout their day. \n* **Loss of Initiative:** This wasn't directly observable in the conversation, though the patient mentioning a \"usual routine\" and not elaborating on activities could point toward reduced engagement.\n* **Mood and Behavior Changes:** The patient displayed initial frustration and worry about forgetfulness. \n* **Physical Symptoms:** No physical symptoms were reported or observed during the conversation.\n* **Sleep Problems:**  Sleep disturbances were not discussed during the conversation. \n\n**Note:** This report is based on a short conversation and should not be considered a formal diagnosis. It is important to consult healthcare professionals for any concerns related to Alzheimer's disease or other cognitive impairments. \n \n")}''';

  //Speech to Text (Microphone Icon)
  final stt.SpeechToText _speech  = stt.SpeechToText();
  String _recognizedText = "";
  bool _isListening = false;
  double _speechConfidence = 0;

  @override
  void initState() {
    super.initState();
    _initSpeechState();

    flutterTts.setCompletionHandler(() {
      setState(() {
        isSpeaking = false;
      });
    });
    flutterTts.setCancelHandler(() {
      setState(() {
        isSpeaking = false;
      });
    });
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

  // Text to Speech
  double volume = 1.0;
  double pitch = 1.0;
  double speechRate = 0.5;
  List<String> ? languages;
  String langCode = "en-US";
  // late final response;

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

    var model = GenerativeModel(
      model: "gemini-1.5-pro",
      apiKey: apiKey,
      generationConfig: config,
      systemInstruction: Content.text(history),
      // safetySettings: Adjust safety settings
      // See https://ai.google.dev/gemini-api/docs/safety-settings
    );
    try{
      final content = Content.text(userMsg);
      final response = await model.generateContent([content]);
      // List<Content> conversationHistory = _messages.map((msg) => Content.text(userMsg)).toList();
      // final response = await model.generateContent(conversationHistory);

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

  // Chat UI
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading:
        IconButton(onPressed: () => Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => JournalDiaryEntry()),
        ), icon: Icon(Icons.add_circle))
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
                      // keyboardType: TextInputType.phone,
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

  FlutterTts flutterTts = FlutterTts();
  void _speak(String text) async {
    await flutterTts.speak(text);
    setState(() {
      isSpeaking = true;
    });
  }

  void _stop() async{
    await flutterTts.stop();
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
