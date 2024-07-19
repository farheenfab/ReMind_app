import 'package:flutter/material.dart';
import 'package:flutter_tts/flutter_tts.dart';

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
  String langCode = "en-US";
  String defaultText = "Hi There";

  FlutterTts text_to_speech = FlutterTts();
  List<Map> _voices = [];
  Map? _currentVoice;

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
        
        setState(() {
           _voices = _voices.where((_voice) => _voice["name"].contains("en")).toList();
           _currentVoice = _voices[0];
           setVoice(_currentVoice!);
        });
       
      }catch(e){
        print(e);
      }
    });
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

            ElevatedButton(onPressed: (){}, child: const Text("Save voice settings")),
            //on pressed, add the settings to Firebase

            const Row(
              children: [
                Text("Languages: ", style: TextStyle(fontSize: 17),),
                SizedBox(width: 10,),
                // DropdownButton(
                //   value: _currentVoice,
                //   items: _voices.map((_voice) => DropdownMenuItem(
                //     value: _voice,
                //     child: Text(_voice["name"]))).toList(), 
                //   onChanged: (value){})
              ],
            )
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
