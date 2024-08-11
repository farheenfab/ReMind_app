import 'package:flutter/material.dart';
import 'package:flutter_tts/flutter_tts.dart';
import 'settings.dart'; // Import the settings page

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

  void _navigateToNextPage(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => SettingsPage(), // Navigate to settings page
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Voice Over Setting',
          style: TextStyle(color: Colors.white), // Title color to white
        ),
        centerTitle: false, // Title aligned to the left
        backgroundColor: const Color.fromARGB(
            255, 41, 19, 76), // Dark purple color for AppBar
        leading: IconButton(
          icon: const Icon(Icons.arrow_back,
              color: Colors.white), // Back arrow color to white
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
      body: Container(
        color: Colors.white, // White background for the main content
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment:
                CrossAxisAlignment.center, // Align content to the center
            children: [
              const SizedBox(height: 20), // Add space at the top
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text(
                    "Default Text: Hi There!",
                    style: TextStyle(fontSize: 21),
                  ),
                  const SizedBox(width: 30), // Increased width for spacing
                  ElevatedButton(
                    onPressed: _speak,
                    child: const Text("Test voice"),
                  ),
                ],
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
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
                    },
                  ),
                  Text(
                    "${volume.toStringAsFixed(1)}",
                    style: TextStyle(fontSize: 17),
                  ),
                ],
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
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
                    },
                  ),
                  Text(
                    "${pitch.toStringAsFixed(1)}",
                    style: TextStyle(fontSize: 17),
                  ),
                ],
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
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
                    },
                  ),
                  Text(
                    "${speechRate.toStringAsFixed(1)}",
                    style: TextStyle(fontSize: 17),
                  ),
                ],
              ),
              const SizedBox(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  ElevatedButton(
                    onPressed: () => _selectButton(1),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: isFemale
                          ? Color.fromARGB(255, 255, 235, 254)
                          : Color.fromARGB(255, 244, 244, 244),
                      padding: const EdgeInsets.symmetric(
                          horizontal: 50,
                          vertical: 15), // Increased button size
                    ),
                    child: const Text(
                      'Female',
                      style:
                          TextStyle(color: Colors.black), // Text color to black
                    ),
                  ),
                  const SizedBox(width: 20),
                  ElevatedButton(
                    onPressed: () => _selectButton(2),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: isMale
                          ? const Color.fromARGB(255, 214, 221, 255)
                          : Color.fromARGB(255, 244, 244, 244),
                      padding: const EdgeInsets.symmetric(
                        horizontal: 50,
                        vertical: 15, // Increased button size
                      ),
                    ),
                    child: const Text(
                      'Male',
                      style:
                          TextStyle(color: Colors.black), // Text color to black
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 40),
              ElevatedButton(
                onPressed: () => _navigateToNextPage(context),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Color.fromARGB(255, 231, 255, 225),
                  padding: const EdgeInsets.symmetric(
                      horizontal: 50, vertical: 15), // Increased button size
                ),
                child: const Text(
                  'Save Voice Settings',
                  style: TextStyle(color: Colors.black), // Text color to black
                ),
              ),
            ],
          ),
        ),
      ),
    );
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
