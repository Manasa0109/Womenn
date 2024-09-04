import 'package:flutter/material.dart';

void main() {
  runApp(MaterialApp(
    initialRoute: '/',
    routes: {
      '/': (context) => HomePage(),
      '/cameraMode': (context) => const CameraModePage(),
      '/nonCameraMode': (context) => const NonCameraModePage(),
      '/audioDetection': (context) => const AudioDetectionPage(),
      '/destinationTracking': (context) => const DestinationTrackingPage(),
    },
  ));
}

// HomePage with buttons to navigate to different modes
class HomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Select Mode'),
        centerTitle: true,
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            _buildModeButton(
              context: context,
              icon: Icons.camera_alt,
              color: Colors.blueAccent,
              onPressed: () {
                Navigator.pushNamed(context, '/cameraMode');
              },
            ),
            const SizedBox(height: 16),
            _buildModeButton(
              context: context,
              icon: Icons.mic,
              color: Colors.orangeAccent,
              onPressed: () {
                Navigator.pushNamed(context, '/nonCameraMode');
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildModeButton({
    required BuildContext context,
    required IconData icon,
    required Color color,
    required VoidCallback onPressed,
  }) {
    return GestureDetector(
      onTap: onPressed,
      child: Container(
        width: 48,  // Width same as height to make it square
        height: 48, // Square size
        decoration: BoxDecoration(
          color: Colors.white,
          border: Border.all(color: color, width: 2),
          borderRadius: BorderRadius.circular(8), // Slightly rounded corners
        ),
        child: Icon(
          icon,
          color: color,
          size: 24, // Icon size to fit within the square button
        ),
      ),
    );
  }
}

// NonCameraModePage with updated design
class NonCameraModePage extends StatelessWidget {
  const NonCameraModePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Non-Camera Mode"),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Column(
                  children: [
                    _buildSquareButton(
                      context: context,
                      icon: Icons.mic,
                      color: Colors.orangeAccent,
                      onPressed: () {
                        Navigator.pushNamed(context, '/audioDetection');
                      },
                    ),
                    const SizedBox(height: 8),
                    const Text("Audio Detection"),
                  ],
                ),
                Column(
                  children: [
                    _buildSquareButton(
                      context: context,
                      icon: Icons.map,
                      color: Colors.blueAccent,
                      onPressed: () {
                        Navigator.pushNamed(context, '/destinationTracking');
                      },
                    ),
                    const SizedBox(height: 8),
                    const Text("Destination Tracking"),
                  ],
                ),
              ],
            ),
            const SizedBox(height: 16),
            Expanded(
              child: Container(
                width: double.infinity,
                padding: const EdgeInsets.all(16.0),
                decoration: BoxDecoration(
                  color: Colors.grey[200],
                  border: Border.all(color: Colors.blueAccent),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: const Text(
                  "Alert Messages will appear here.",
                  style: TextStyle(fontSize: 16, color: Colors.black),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSquareButton({
    required BuildContext context,
    required IconData icon,
    required Color color,
    required VoidCallback onPressed,
  }) {
    return GestureDetector(
      onTap: onPressed,
      child: Container(
        width: 64,
        height: 64,
        decoration: BoxDecoration(
          color: Colors.white,
          border: Border.all(color: color, width: 2),
          borderRadius: BorderRadius.circular(8),
        ),
        child: Icon(
          icon,
          color: color,
          size: 32,
        ),
      ),
    );
  }
}

// Placeholder for the CameraModePage
class CameraModePage extends StatelessWidget {
  const CameraModePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Camera Mode"),
        centerTitle: true,
      ),
      body: const Center(
        child: Text(
          "Camera Mode Activated",
          style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
        ),
      ),
    );
  }
}

// Placeholder for the AudioDetectionPage
class AudioDetectionPage extends StatelessWidget {
  const AudioDetectionPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Audio Detection"),
        centerTitle: true,
      ),
      body: const Center(
        child: Text(
          "Audio Detection Page",
          style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
        ),
      ),
    );
  }
}

// Placeholder for the DestinationTrackingPage
class DestinationTrackingPage extends StatelessWidget {
  const DestinationTrackingPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Destination Tracking"),
        centerTitle: true,
      ),
      body: const Center(
        child: Text(
          "Destination Tracking Page",
          style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
        ),
      ),
    );
  }
}
