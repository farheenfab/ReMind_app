import 'package:flutter/material.dart';

class SOSPage extends StatefulWidget {
  @override
  _SOSPageState createState() => _SOSPageState();
}

class _SOSPageState extends State<SOSPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('SOS'),
        bottom: PreferredSize(
          preferredSize: Size.fromHeight(1.0),
          child: Divider(
            height: 3.0,
            color: Colors.black,
          ),
        ),
      ),
      body: Container(
        color: Colors.white,
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            SOSContainer(
              icon: Icons.phone,
              text: 'Send alert to emergency contacts',
            ),
            SizedBox(height: 20),
            SOSContainer(
              icon: Icons.location_on,
              text: 'Lost!!! click here to find your way back home.',
            ),
            SizedBox(height: 20),
            SOSContainer(
              icon: Icons.local_hospital,
              text: 'Medical emergency? Click here to send alert to nearby clinic.',
            ),
          ],
        ),
      ),
    );
  }
}

class SOSContainer extends StatelessWidget {
  final IconData icon;
  final String text;

  const SOSContainer({
    Key? key,
    required this.icon,
    required this.text,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16.0),
      decoration: BoxDecoration(
        color: const Color(0xFF382973),
        borderRadius: BorderRadius.circular(10),
      ),
      child: Row(
        children: [
          Icon(
            icon,
            color: Colors.white,
            size: 50,
          ),
          SizedBox(width: 15),
          Expanded(
            child: Text(
              text,
              style: TextStyle(
                color: Colors.white,
                fontSize: 20,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
