import 'package:flutter/material.dart';
import 'package:flutter_sms/flutter_sms.dart';
import 'package:geolocator/geolocator.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:womenn/features/user_auth/presentation/pages/trusted_contacts_page.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  void initState() {
    super.initState();
  }

  Future<void> _sendAlert() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    List<String> contacts = prefs.getStringList('trustedContacts') ?? [];

    if (contacts.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('No trusted contacts available!')),
      );
      return;
    }

    var smsPermission = await Permission.sms.status;
    if (!smsPermission.isGranted) {
      smsPermission = await Permission.sms.request();
      if (!smsPermission.isGranted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('SMS permission is required!')),
        );
        return;
      }
    }

    try {
      Position position = await _getUserLocation();
      String message =
          'ALERT! Help is needed. Location: https://maps.google.com/?q=${position.latitude},${position.longitude}';

      for (String contact in contacts) {
        await _sendSMS(message, [contact]);
      }

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Alert sent!')),
      );
    } catch (e) {
      print("Error in sending alert: $e");
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to send alert: $e')),
      );
    }
  }

  Future<Position> _getUserLocation() async {
    bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      return Future.error('Location services are disabled.');
    }

    LocationPermission permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        return Future.error('Location permissions are denied.');
      }
    }

    if (permission == LocationPermission.deniedForever) {
      return Future.error('Location permissions are permanently denied, we cannot request permissions.');
    }

    return await Geolocator.getCurrentPosition();
  }

  Future<void> _sendSMS(String message, List<String> recipients) async {
    try {
      await sendSMS(
        message: message,
        recipients: recipients,
      );
    } catch (e) {
      print("Failed to send SMS: $e");
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to send SMS: $e')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Home"),
        backgroundColor: Color(0xFF4A90E2),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                CircleAvatar(
                  radius: 40,
                  backgroundColor: Colors.grey,
                  child: Icon(Icons.person, size: 40, color: Colors.white),
                ),
                SizedBox(width: 15),
                Text(
                  "Welcome, User!",
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF2C3E50),
                  ),
                ),
              ],
            ),
            SizedBox(height: 30),

            Text(
              "Your safety is our priority. Please use the options below to choose your preferred mode.",
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w600,
                color: Color(0xFF2C3E50),
              ),
            ),
            SizedBox(height: 30),

            Text(
              "Select Mode:",
              style: TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
                color: Color(0xFF2C3E50),
              ),
            ),
            SizedBox(height: 20),

            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                _buildModeButton(
                  context,
                  label: 'Camera Mode',
                  onPressed: () => Navigator.pushNamed(context, '/cameraMode'),
                ),
                _buildModeButton(
                  context,
                  label: 'Non-Camera Mode',
                  onPressed: () => Navigator.pushNamed(context, '/nonCameraMode'),
                ),
              ],
            ),
            SizedBox(height: 30),

            _buildListTile(
              context,
              icon: Icons.contacts,
              title: "Trusted Contacts",
              subtitle: "Manage your trusted contacts",
              onTap: () => Navigator.pushNamed(context, '/trustedContacts'),
            ),
            SizedBox(height: 30),

            Text(
              "Safety Tips:",
              style: TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
                color: Color(0xFF2C3E50),
              ),
            ),
            SizedBox(height: 10),
            Expanded(
              child: ListView(
                children: [
                  _buildTipTile("Stay aware of your surroundings."),
                  _buildTipTile("Keep your trusted contacts updated."),
                ],
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _sendAlert,
        child: Icon(Icons.phone),
        backgroundColor: Color(0xFFF5A623),
        tooltip: "Emergency Contact",
      ),
    );
  }

  ElevatedButton _buildModeButton(BuildContext context, {required String label, required VoidCallback onPressed}) {
    return ElevatedButton(
      onPressed: onPressed,
      child: Text(label),
      style: ElevatedButton.styleFrom(
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
        side: BorderSide(color: Color(0xFF4A90E2)),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
        ),
        padding: EdgeInsets.symmetric(horizontal: 25, vertical: 15),
      ),
    );
  }

  ListTile _buildListTile(BuildContext context, {required IconData icon, required String title, required String subtitle, required VoidCallback onTap}) {
    return ListTile(
      leading: Icon(icon, color: Color(0xFF4A90E2)),
      title: Text(title),
      subtitle: Text(subtitle),
      onTap: onTap,
      tileColor: Color(0xFFF5F5F5),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10),
        side: BorderSide(color: Color(0xFF4A90E2)),
      ),
    );
  }

   ListTile _buildTipTile(String tip) {
    return ListTile(
      leading: Icon(Icons.info_outline, color: Color(0xFF4A90E2)),
      title: Text(
        tip,
        style: TextStyle(
          fontSize: 16,
          color: Color(0xFF2C3E50),
        ),
      ),
      tileColor: Color(0xFFF5F5F5),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10),
        side: BorderSide(color: Color(0xFF4A90E2)),
      ),
      contentPadding: EdgeInsets.symmetric(horizontal: 15, vertical: 10),
    );
  }
}
