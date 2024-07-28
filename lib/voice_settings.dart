import 'package:flutter/material.dart';
import 'package:flutter_tts/flutter_tts.dart';
import 'dart:developer';

class VoiceSettings extends StatefulWidget{
  @override
  State<VoiceSettings> createState() => VoiceSettingsState();
  
}

class VoiceSettingsState extends State<VoiceSettings>{

  double volume = 1;
  double pitch = 1.0;
  double speechRate = 1;
  // Map<String,String> languages = {"English": "en-US"};
  List<String>? languages;
  Map<String, String> langCode = {"name": "en-us-x-sfg#male_1-local", "locale": "en-US"};
  String defaultText = "Hi There";

  FlutterTts text_to_speech = FlutterTts();
  List<Map> _voices = [];
  Map? _currentVoice;
  bool isMale = true;

    @override
  void initState(){
    super.initState();
    init();
  }

  void init() async{
    // languages = List<String>.from(await text_to_speech.getLanguages);
    text_to_speech.getVoices.then((data){
      try{
        _voices = List<Map>.from(data);
        log("${_voices}");
        setState(() {
          _updateVoiceList();
          //  _voices = _voices.where((_voice) => _voice["name"].contains("en")).toList();
           _currentVoice = _voices[0];
           setVoice(_currentVoice!);
        });
       
      }catch(e){
        print(e);
      }
    });
  }

  void _updateVoiceList() {
    _voices = _voices.where((voice) {
      return voice['locale'] == langCode && voice['gender'] == (isMale ? 'male' : 'female');
    }).toList();
  }

  void setVoice(Map voice){
    text_to_speech.setVoice({"name":voice["name"], "locale":voice["locale"]});
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
                const Text("Default Text: Hi There!", style: TextStyle(fontSize: 21),),
                const SizedBox(width: 10,),
                ElevatedButton(onPressed: _speak, child: const Text("Test voice"))
              ],
            ),
            
            Row(
              children: [
                const Text("Volume", style: TextStyle(fontSize: 17),),
                Slider(min: 0.0, max: 1.0, value: volume, onChanged: (value) {
                  setState(() {
                    volume = value;
                  });
                }),
                Text("${volume.toStringAsFixed(1)}", style: TextStyle(fontSize: 17),),
              ],
            ),

            Row(
              children: [
                const Text("Pitch", style: TextStyle(fontSize: 17),),
                Slider(min: 0.5, max: 2.0, value: pitch, onChanged: (value) {
                  setState(() {
                    pitch = value;
                  });
                }),
                Text("${pitch.toStringAsFixed(1)}", style: TextStyle(fontSize: 17),),
              ],
            ),

            Row(
              children: [
                const Text("Speech Rate", style: TextStyle(fontSize: 17),),
                Slider(min: 0.0, max: 1.0, value: speechRate, onChanged: (value) {
                  setState(() {
                    speechRate = value;
                  });
                }),
                Text("${speechRate.toStringAsFixed(1)}", style: TextStyle(fontSize: 17),),
              ],
            ),

            ElevatedButton(onPressed: (){
                text_to_speech.getVoices.then((data){
              _voices = List<Map>.from(data);
              print(_voices);});
            }, child: const Text("Save voice settings")),

            Row(
            children: [
              const Text(
                "Languages: ",
                style: TextStyle(fontSize: 17),
              ),
              const SizedBox(width: 10),
              DropdownButton(
                value: langCode,
                items: const [
                  DropdownMenuItem(value: {"name": "es-us-x-sfb-local", "locale": "es-US"}, child: Text("US")),
                  DropdownMenuItem(value: {"name": "cy-gb-x-cyf-network", "locale": "cy-GB"}, child: Text("UK")),
                  DropdownMenuItem(value: {"name": "en-in-x-end-network", "locale": "en-IN"}, child: Text("India")),
                ],
                onChanged: (value) {
                  setState(() {
                    langCode = value!;
                    _updateVoiceList();
                    if (_voices.isNotEmpty) {
                      _currentVoice = _voices[0];
                      setVoice(_currentVoice!);
                    }
                  });
                },
              ),
            ],
          ),

          Row(
              children: [
                ElevatedButton(
                  onPressed: () {
                    setState(() {
                      isMale = true;
                      _updateVoiceList();
                      if (_voices.isNotEmpty) {
                        _currentVoice = _voices[0];
                        setVoice(_currentVoice!);
                      }
                    });
                  },
                  child: const Text("Male Voice"),
                ),
                const SizedBox(width: 10),
                ElevatedButton(
                  onPressed: () {
                    setState(() {
                      isMale = false;
                      _updateVoiceList();
                      if (_voices.isNotEmpty) {
                        _currentVoice = _voices[0];
                        setVoice(_currentVoice!);
                      }
                    });
                  },
                  child: const Text("Female Voice"),
                ),
              ],
            ),
          ],
        )
      )
    );
  }

  @override
  void initSetting() async {
    await text_to_speech.setVolume(volume);
    await text_to_speech.setPitch(pitch);
    await text_to_speech.setSpeechRate(speechRate);
    await text_to_speech.setVoice(langCode);
  }

  void _speak() async{
    initSetting();
    await text_to_speech.speak(defaultText);
  }

  // Widget speakerSelector(){
  //   return DropdownButton(
  //     value: _currentVoice,
  //     items: _voices.map((_voice) => DropdownMenuItem(
  //       value: _voice,
  //       child: Text(_voice["name"]))).toList(), 
  //     onChanged: (value){});
  // }


}
