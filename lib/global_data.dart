// lib/global_data.dart
class GlobalData {
  static final GlobalData _instance = GlobalData._internal();
 
  factory GlobalData() {
    return _instance;
  }
 
  GlobalData._internal();
 
  String? patientName;
}