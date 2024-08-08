import 'package:flutter/material.dart';
import 'package:flutter_tts/flutter_tts.dart';
import 'dart:developer';
import 'main.dart';
import 'chat_screen.dart';
import 'home_page.dart';

class VoiceSettings extends StatefulWidget {
  @override
  State<VoiceSettings> createState() => VoiceSettingsState();
}

class VoiceSettingsState extends State<VoiceSettings> {
  double volume = 1;
  double pitch = 1.0;
  double speechRate = 1;

  String defaultText = "Hi There";

  bool isFemale = true;
  bool isMale = false;

  Map<String, String> voice = {"name": "en-us-x-tpf-local", "locale": "en-US"};

  FlutterTts text_to_speech = FlutterTts();

  @override
  void initState() {
    super.initState();
  }

  void _selectButton(int buttonNumber) {
    setState(() {
      if (buttonNumber == 1) {
        isFemale = true;
        isMale = false;
        voice = {"name": "en-us-x-tpf-local", "locale": "en-US"};
      } else if (buttonNumber == 2) {
        isFemale = false;
        isMale = true;
        voice = {'name': 'en-us-x-iol-local', 'locale': 'en-US'};
      }
    });
  }

  // Method to navigate to another page
  void _navigateToNextPage(BuildContext context) {
    // Pass the selected option to the next page
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => MyHomePage(
            voice: isFemale
                ? {"name": "en-us-x-tpf-local", "locale": "en-US"}
                : {'name': 'en-us-x-iol-local', 'locale': 'en-US'},
            // voice: voice,
            volume: volume,
            pitch: pitch,
            speechRate: speechRate),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text('Voice Over Setting'),
          centerTitle: true,
        ),
        body: Center(
            child: Column(
          children: [
            Row(
              children: [
                const Text(
                  "Default Text: Hi There!",
                  style: TextStyle(fontSize: 21),
                ),
                const SizedBox(
                  width: 10,
                ),
                ElevatedButton(
                    onPressed: _speak, child: const Text("Test voice"))
              ],
            ),
            Row(
              children: [
                const Text(
                  "Volume",
                  style: TextStyle(fontSize: 17),
                ),
                Slider(
                    min: 0.0,
                    max: 1.0,
                    value: volume,
                    onChanged: (value) {
                      setState(() {
                        volume = value;
                      });
                    }),
                Text(
                  "${volume.toStringAsFixed(1)}",
                  style: TextStyle(fontSize: 17),
                ),
              ],
            ),
            Row(
              children: [
                const Text(
                  "Pitch",
                  style: TextStyle(fontSize: 17),
                ),
                Slider(
                    min: 0.5,
                    max: 2.0,
                    value: pitch,
                    onChanged: (value) {
                      setState(() {
                        pitch = value;
                      });
                    }),
                Text(
                  "${pitch.toStringAsFixed(1)}",
                  style: TextStyle(fontSize: 17),
                ),
              ],
            ),
            Row(
              children: [
                const Text(
                  "Speech Rate",
                  style: TextStyle(fontSize: 17),
                ),
                Slider(
                    min: 0.0,
                    max: 1.0,
                    value: speechRate,
                    onChanged: (value) {
                      setState(() {
                        speechRate = value;
                      });
                    }),
                Text(
                  "${speechRate.toStringAsFixed(1)}",
                  style: TextStyle(fontSize: 17),
                ),
              ],
            ),
            ElevatedButton(
              onPressed: () => _selectButton(1),
              style: ElevatedButton.styleFrom(
                backgroundColor: isFemale ? Colors.blue : Colors.grey,
              ),
              child: const Text('Female'),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () => _selectButton(2),
              style: ElevatedButton.styleFrom(
                backgroundColor: isMale ? Colors.blue : Colors.grey,
              ),
              child: const Text('Male'),
            ),
            const SizedBox(height: 40),
            ElevatedButton(
              onPressed: () => _navigateToNextPage(context),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.green,
              ),
              child: const Text('Save Voice Settings'),
            ),
          ],
        )));
  }

  @override
  void initSetting() {
    text_to_speech.setVolume(volume);
    text_to_speech.setPitch(pitch);
    text_to_speech.setSpeechRate(speechRate);
    text_to_speech.setVoice(voice);
  }

  void _speak() async {
    initSetting();
    text_to_speech.speak(defaultText);
  }
}
