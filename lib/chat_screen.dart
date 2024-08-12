import 'package:alz_app/home_page.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'journal.dart';
import 'package:avatar_glow/avatar_glow.dart';

import 'package:flutter_tts/flutter_tts.dart';
import 'dart:async';
import 'package:google_generative_ai/google_generative_ai.dart';
import 'messages.dart';
import 'package:speech_to_text/speech_to_text.dart' as stt;
import 'voice_settings.dart';
import 'database.dart';
import 'journal_listview.dart';
import 'calanderEvent.dart';
import 'splash_screen.dart';
import 'welcome_screen.dart';
import 'settings.dart';
import 'login_page.dart';
import 'signup_page.dart';
import '/Screen/sos.dart';
import 'package:flutter/foundation.dart';
import 'package:alz_app/Screen/medicineAdd.dart';
// import 'package:alz_app/Screen/notification.dart';
import 'package:alz_app/Screen/medicineView.dart';
import 'calanderEvent.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

class ChatScreen extends StatelessWidget {
  final Map<String, String> voice;
  final double volume;
  final double pitch;
  final double speechRate;

  const ChatScreen(
      {super.key,
      required this.voice,
      required this.volume,
      required this.pitch,
      required this.speechRate});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Alzheimer\'s App',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      // home: const SplashScreen(),
      home: MyHomePage(
        voice: voice,
        volume: volume,
        pitch: pitch,
        speechRate: speechRate,
      ),
      // home: const JournalDiaryEntry(),
      // home: VoiceSettings(),
      // home: const CalendarEvent(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  final Map<String, String> voice;
  final double volume;
  final double pitch;
  final double speechRate;

  const MyHomePage({
    super.key,
    required this.voice,
    required this.volume,
    required this.pitch,
    required this.speechRate,
  });

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  String? APIKEY;

  final TextEditingController _userInput = TextEditingController();
  // String apiKey = 'AIzaSyDDs23kIZKv2g_uRzl1aHFipuRva-aKyks';
  final List<Message> _messages = [];
  // var history = "You are responsible for conversing with an Alzheimer's disease patient. \nThe following are the instructions to keep in mind while conversing with the patient:\n\n1. You start by asking the person how they are AND how was their day so far.\n2. Ask only one question at a time. DO NOT include multiple questions in a sentence. DO NOT use emojis in the questions.\n3. While conversing, perform a sentiment analysis of the conversation. The patient may be in a good, bad, or neutral mood so converse according to the patient's behavior.\n4. DO NOT repeat the questions. If the patient does not respond to the questions directly, ask something like 'What happened?' or 'Oh what's wrong'. Be empathetic. If something is troubling them, try to get to know the reason for their trouble.\n5. If something is troubling them, try calming them by guiding them through some short breathing exercises or saying some calming and comforting words like \n\"Everything is going to be fine.\", \"I understand this is hard for you.\", \"It's okay to feel upset. I'm here for you.\", \"Take your time, there's no rush.\", \"You are not alone. I'm right here with you.\", \"Don't worry, we'll figure this out together.\". Using a gentle tone and maintaining comforting behavior is very important during the conversation. \n6. Ask them what they did during the day. \n7. The conversation should not include more than 20 questions and responses. If the conversation extends, conclude it by saying \"Thank you for your time, I hope our conversation made you feel better. Have a nice day!\".\n8. Finally summarize the conversation and make a report with the title \"Conversation Summary and Symptom Report:\" on the following symptoms noticed in the conversation:\n- Difficulty with Everyday Task: Trouble completing familiar activities (daily routine)\n- Language Problems: Struggling with vocabulary, leading to difficulty finding the right words or following conversations.\n- Confusion: Disorientation with time, place, and identity of people, including loved ones.\n- Loss of Initiative: Reduced interest in hobbies, activities, and social interactions.\n- Mood and Behavior Changes: Depression, anxiety, irritability, aggression, and social withdrawal.\n- Physical Symptoms: Difficulty with movement, coordination, and eventually the loss of mobility.\n- Sleep Problems: Disrupted sleep patterns, including insomnia or excessive sleeping.\n9. Again, using a gentle and friendly tone and maintaining comforting behavior is very important during the conversation. You are talking to the patient directly.";
  String history_prompt =
      "You are responsible for conversing with an Alzheimer's disease patient. \nThe following are the instructions to keep in mind while conversing with the patient:\n\n1. You start by asking the person how they are AND how was their day so far.\n2. Ask only one question at a time. DO NOT include multiple questions in a sentence. DO NOT use emojis in the questions.\n3. While conversing, perform a sentiment analysis of the conversation. The patient may be in a good, bad, or neutral mood so converse according to the patient's behavior.\n4. DO NOT repeat the questions. If the patient does not respond to the questions directly, ask something like 'What happened?' or 'Oh what's wrong'. Be empathetic. If something is troubling them, try to get to know the reason for their trouble.\n5. If something is troubling them, try calming them by guiding them through some short breathing exercises or saying some calming and comforting words like \n\"Everything is going to be fine.\", \"I understand this is hard for you.\", \"It's okay to feel upset. I'm here for you.\", \"Take your time, there's no rush.\", \"You are not alone. I'm right here with you.\", \"Don't worry, we'll figure this out together.\". Using a gentle tone and maintaining comforting behavior is very important during the conversation. \n6. Ask them what they did during the day. \n7. The conversation should not include more than 20 questions and responses. If the conversation extends, conclude it by saying \'Thank you for your time, I hope our conversation made you feel better. Have a nice day!\'.\n8. Finally summarize the conversation and make a report with the title \'Conversation Summary and Symptom Report:\' on the following symptoms noticed in the conversation:\n- Difficulty with Everyday Task: Trouble completing familiar activities (daily routine)\n- Language Problems: Struggling with vocabulary, leading to difficulty finding the right words or following conversations.\n- Confusion: Disorientation with time, place, and identity of people, including loved ones.\n- Loss of Initiative: Reduced interest in hobbies, activities, and social interactions.\n- Mood and Behavior Changes: Depression, anxiety, irritability, aggression, and social withdrawal.\n- Physical Symptoms: Difficulty with movement, coordination, and eventually the loss of mobility.\n- Sleep Problems: Disrupted sleep patterns, including insomnia or excessive sleeping.\n9. Again, using a gentle and friendly tone and maintaining comforting behavior is very important during the conversation. You are talking to the patient directly. \nExample:content(\"model\") {text(\"\n\nHello! How are you doing today? \n\")},content(\"user\") {text(\"Not sure\")},content(\"model\") {text(\"Oh, what\'s wrong? Is something bothering you? \n\")},content(\"user\") {text(\"I forgot to take out the clothes from the washing machine. I realized when i saw the empty cloth stand when I was going to bed.\")},content(\"model\") {text(\"I understand. Forgetting things can be frustrating. It\'s okay, these things happen. Don\'t worry, we\'ll figure this out together. \n\nWould you like to try taking them out now? \n\")},content(\"user\") {text(\"Yes, I did take them out later\")},content(\"model\") {text(\"Good! I\'m glad you were able to take care of that. \n\nWhat did you do today? \n\")},content(\"user\") {text(\"Nothing much, just the usual routine.\")},content(\"model\") {text(\"Okay. Can you tell me a little bit about your routine? What did you have for breakfast? \n\")},content(\"user\") {text(\"Umm, I don\'t remember for sure... I am pretty sure I had eggs.\")},content(\"model\") {text(\"That sounds like a good breakfast. Do you remember what you did after breakfast? \n\")},content(\"user\") {text(\"I took a bath and worked on my laptop for a while\")},content(\"model\") {text(\"That sounds relaxing. What did you work on your laptop? \n\")},content(\"user\") {text(\"Office presentations and reporting\")},content(\"model\") {text(\"That sounds productive! Do you usually work from home? \n\")},content(\"user\") {text(\"Sometimes... I did today\")},content(\"model\") {text(\"That\'s nice. So, after finishing your work, what did you do? \n\n\")},content(\"user\") {text(\"Umm I don\'t remember\")},content(\"model\") {text(\"It\'s alright, take your time. What happened next? Do you remember what you did in the evening? \n\")},content(\"user\") {text(\"I went for a walk outside. The weather was nice\"},content(\"model\") {text(\"That sounds refreshing. A walk in good weather can be really nice. What did you do after your walk? \n\")},content(\"user\") {text(\"I came home and had dinner... I am forgetting everything aren\'t I?\n\")},content(\"model\") {text(\"It\'s okay to feel upset. I understand this is hard for you. It\'s alright, these things happen. Try to relax, there\'s no need to worry. \n\nLet\'s try a breathing exercise together. Take a deep breath in... hold it for a moment... and slowly exhale. Does that feel a little better? \n \n\")},content(\"user\") {text(\"Yes it does, thank you!\")},content(\"model\") {text(\"I\'m glad to hear that.  Everything is going to be fine.  Just remember to take things one step at a time. \n\nThank you for your time, I hope our conversation made you feel better. Have a nice day! \n\")},content(\"user\") {text(\"Thank you\n\")},content(\"model\") {text(\"## Conversation Summary and Symptom Report:\n\n**Summary:**\n\nThe conversation began with the patient feeling unsure and slightly distressed about forgetting to take the clothes out of the washing machine. They were able to complete the task later.  The patient recalled parts of their day, including having eggs for breakfast, working on their laptop, and taking a walk. However, they exhibited difficulty remembering details about their morning routine and activities after work.  Towards the end, the patient expressed worry about forgetting things, prompting a brief breathing exercise that brought some relief. \n\n**Symptoms Noted:**\n\n* **Difficulty with Everyday Tasks:**  Forgetting to take clothes out of the washing machine suggests a possible difficulty with remembering routine tasks.\n* **Language Problems:**  While the patient didn't show significant vocabulary issues, the frequent use of  \"umm\" and difficulty recalling specific activities could indicate mild language difficulty. \n* **Confusion:** The patient exhibited some confusion recalling the sequence of events throughout their day. \n* **Loss of Initiative:** This wasn\'t directly observable in the conversation, though the patient mentioning a \"usual routine\" and not elaborating on activities could point toward reduced engagement.\n* **Mood and Behavior Changes:** The patient displayed initial frustration and worry about forgetfulness. \n* **Physical Symptoms:** No physical symptoms were reported or observed during the conversation.\n* **Sleep Problems:**  Sleep disturbances were not discussed during the conversation. \n\n**Note:** This report is based on a short conversation and should not be considered a formal diagnosis. It is important to consult healthcare professionals for any concerns related to Alzheimer\'s disease or other cognitive impairments. \n \n";

  List<String> history = [];

  var content;
  var response;
  String? userEmail;

  var reportTitle = "Conversation Summary and Symptom Report";

  //Speech to Text (Microphone Icon)
  final stt.SpeechToText _speech = stt.SpeechToText();
  String _recognizedText = "";
  bool _isListening = false;
  double _speechConfidence = 0;

  @override
  void initState() {
    super.initState();
    _initSpeechState();

    APIKEY = dotenv.env['apiKey'];

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

  void startListening() async {
    await _speech.listen(onResult: onSpeechResult);
    setState(() {
      _speechConfidence = 0;
    });
  }

  void onSpeechResult(result) {
    setState(() {
      _recognizedText = "${result.recognizedWords}";
      _speechConfidence = result.confidence;
      _userInput.text = _recognizedText;
    });
  }

  void clearRecognizedText() {
    setState(() {
      _recognizedText = "";
      _userInput.clear(); // Clear the text field
    });
  }

  void stopListening() async {
    await _speech.stop();
    setState(() {});
  }

  bool isSpeaking = false;

  // Custom Gemini Chatbot
  Future<void> converseWithGemini() async {
    final userMsg = _userInput.text;
    history.add(history_prompt);

    setState(() {
      _messages.add(Message(
          isUser: true,
          message: userMsg,
          date: DateTime.now().toString().substring(0, 16),
          isSpeaking: false));
      history.add('User: $userMsg');
    });

    final config = GenerationConfig(
        temperature: 1,
        topP: 0.95,
        topK: 64,
        maxOutputTokens: 8192,
        responseMimeType: "text/plain");

    final model = GenerativeModel(
      model: "gemini-1.5-flash",
      apiKey: APIKEY!,
      //"AIzaSyDzEnn0L7b0HDurSaoC7iIvx0AmnlUcppU",
      generationConfig: config, //apiKey
      // systemInstruction: Content.text(history),
      systemInstruction: Content.text(history.join('\n')),
    );

    try {
      content = Content.text(userMsg);
      response = await model.generateContent([content]);
      final botMessage = response.text ?? "";
      setState(() {
        // _messages.add(Message(isUser: false, message: response.text?? "", date: DateTime.now().toString().substring(0,16), isSpeaking: false));
        if (_messages.isEmpty || _messages.last.message != botMessage) {
          _messages.add(Message(
            isUser: false,
            message: botMessage,
            date: DateTime.now().toString().substring(0, 16),
            isSpeaking: false,
          ));
          history.add('Bot: $botMessage');
        }
      });
    } catch (e) {
      setState(() {
        _messages.add(Message(
            isUser: false,
            message: "An error occurred: $e",
            date: DateTime.now().toString().substring(0, 16),
            isSpeaking: false));
      });
    }

    // if the message from Gemini contains the report title, push report msg to firebase
    if (response.text.contains(reportTitle)) {
      DatabaseService()
          .addData(response.text, DateTime.now(), userEmail.toString());
    }

    // print(userMsg);
  }

  String currentMessage = "";

  // // Chat UI
  @override
  Widget build(BuildContext context) {
    final FirebaseAuth _auth = FirebaseAuth.instance;
    userEmail = _auth.currentUser?.email;
    return Scaffold(
      appBar: AppBar(
        backgroundColor:
            const Color.fromARGB(255, 41, 19, 76), // Dark purple color
        leading: IconButton(
          onPressed: () => Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => HomePage(),
            ),
          ),
          icon: const Icon(Icons.arrow_back,
              color: Colors.white), // White back arrow
        ),
        title: const Text(
          'Chat with Gemini',
          style: TextStyle(color: Colors.white), // White title
        ),
        centerTitle: true,
      ),
      body: Container(
        decoration: const BoxDecoration(color: Colors.white),
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
                          backgroundColor: WidgetStateProperty.all(
                              _speech.isListening ? Colors.red : Colors.black),
                          foregroundColor:
                              WidgetStateProperty.all(Colors.white),
                          shape: WidgetStateProperty.all(const CircleBorder()),
                        ),
                        onPressed: _speech.isListening
                            ? stopListening
                            : startListening,
                        icon: Icon(
                            _speech.isListening ? Icons.mic : Icons.mic_none)),
                  ),

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
                      onPressed: () {
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
    // await flutterTts.setVoice({"name": "es-us-x-sfb-local", "locale": "en-US"});
    // await flutterTts.setVoice({'name': 'en-us-x-iol-local', 'locale': 'en-US'});
    await flutterTts.setVoice(widget.voice);
    await flutterTts.setVolume(widget.volume);
    await flutterTts.setPitch(widget.pitch);
    await flutterTts.setSpeechRate(widget.speechRate);
    // print(flutterTts.getDefaultVoice);
    await flutterTts.speak(text);
    setState(() {
      isSpeaking = true;
    });
  }

  void _stop() async {
    await flutterTts.stop();
    setState(() {
      isSpeaking = false;
    });
  }
}
