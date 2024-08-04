import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class MicrophoneSettingsPage extends StatefulWidget {
  @override
  _MicrophoneSettingsPageState createState() => _MicrophoneSettingsPageState();
}

class _MicrophoneSettingsPageState extends State<MicrophoneSettingsPage> {
  String _voiceType = 'male';
  double _speechRate = 1.0;

  @override
  void initState() {
    super.initState();
    _loadSettings();
  }

  Future<void> _loadSettings() async {
    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      String? savedVoiceType = prefs.getString('voiceType');
      double? savedSpeechRate = prefs.getDouble('speechRate');

      setState(() {
        _voiceType = savedVoiceType ?? 'male';
        _speechRate = savedSpeechRate ?? 1.0;
      });

      // Debugging: Print loaded settings
      print('Loaded settings: voiceType=$_voiceType, speechRate=$_speechRate');
    } catch (e) {
      print('Error loading settings: $e');
    }
  }

  Future<void> _saveSettings() async {
    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();

      bool voiceTypeSaved = await prefs.setString('voiceType', _voiceType);
      bool speechRateSaved = await prefs.setDouble('speechRate', _speechRate);

      // Debugging: Print save status
      print('VoiceType saved: $voiceTypeSaved');
      print('SpeechRate saved: $speechRateSaved');
    } catch (e) {
      print('Error saving settings: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Microphone Voice Settings',
            style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold)),
        backgroundColor: Colors.white,
        iconTheme: IconThemeData(color: Color(0xFF382973)), // Dark purple icons
      ),
      body: Container(
        color: Colors.white,
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Text('Voice Type',
                style: TextStyle(
                    fontSize: 18,
                    color: Colors.black,
                    fontWeight: FontWeight.bold)),
            Row(
              children: [
                Expanded(
                  child: RadioListTile<String>(
                    title: const Text('Male',
                        style: TextStyle(color: Colors.black)),
                    value: 'male',
                    groupValue: _voiceType,
                    activeColor: Color(0xFF382973), // Dark purple
                    onChanged: (String? value) {
                      if (value != null) {
                        setState(() {
                          _voiceType = value;
                        });
                        _saveSettings(); // Save the selected voice type
                      }
                    },
                  ),
                ),
                Expanded(
                  child: RadioListTile<String>(
                    title: const Text('Female',
                        style: TextStyle(color: Colors.black)),
                    value: 'female',
                    groupValue: _voiceType,
                    activeColor: Color(0xFF382973), // Dark purple
                    onChanged: (String? value) {
                      if (value != null) {
                        setState(() {
                          _voiceType = value;
                        });
                        _saveSettings(); // Save the selected voice type
                      }
                    },
                  ),
                ),
              ],
            ),
            SizedBox(height: 20),
            Text('Speech Rate',
                style: TextStyle(
                    fontSize: 18,
                    color: Colors.black,
                    fontWeight: FontWeight.bold)),
            Slider(
              value: _speechRate,
              min: 0.5,
              max: 2.0,
              divisions: 6,
              label: _speechRate.toStringAsFixed(1),
              activeColor: Color(0xFF382973), // Dark purple
              inactiveColor:
                  Color(0xFF382973).withOpacity(0.3), // Lighter purple
              onChanged: (double value) {
                setState(() {
                  _speechRate = value;
                });
                _saveSettings(); // Save the updated speech rate
              },
            ),
          ],
        ),
      ),
    );
  }
}
