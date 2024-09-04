import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class CameraModePage extends StatefulWidget {
  const CameraModePage({super.key});

  @override
  _CameraModePageState createState() => _CameraModePageState();
}

class _CameraModePageState extends State<CameraModePage> {
  late VideoPlayerController _controller;
  final Uri _streamUrl = Uri.parse('http://commondatastorage.googleapis.com/gtv-videos-bucket/sample/BigBuckBunny.mp4');
  final FirebaseAuth _auth = FirebaseAuth.instance;
  String _userRole = 'user'; // Default to 'user'
  bool _isRoleFetched = false;

  @override
  void initState() {
    super.initState();
    _fetchUserRole();
    _controller = VideoPlayerController.networkUrl(_streamUrl)
      ..initialize().then((_) {
        setState(() {});
      });
  }

  Future<void> _fetchUserRole() async {
    User? user = _auth.currentUser;
    if (user != null) {
      // Fetch user role from Firestore
      DocumentSnapshot userDoc = await FirebaseFirestore.instance.collection('users').doc(user.uid).get();
      setState(() {
        _userRole = userDoc['role'] ?? 'user'; // Default to 'user' if role not found
        _isRoleFetched = true;
      });
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _logout() async {
    await _auth.signOut();
    Navigator.pushReplacementNamed(context, '/login');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Camera Mode'),
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: _logout,
          )
        ],
      ),
      body: Center(
        child: !_isRoleFetched
            ? const CircularProgressIndicator()
            : _userRole == 'official'
                ? _controller.value.isInitialized
                    ? Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          SizedBox(
                            height: 200, // Adjust the height as needed
                            width: 300,  // Adjust the width as needed
                            child: AspectRatio(
                              aspectRatio: _controller.value.aspectRatio,
                              child: VideoPlayer(_controller),
                            ),
                          ),
                          _buildControls(),
                        ],
                      )
                    : const CircularProgressIndicator()
                : const Text('You do not have permission to view this video.'),
      ),
    );
  }

  Widget _buildControls() {
    return Container(
      padding: const EdgeInsets.all(10),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          IconButton(
            icon: const Icon(Icons.play_arrow),
            onPressed: () {
              _controller.play();
            },
          ),
          IconButton(
            icon: const Icon(Icons.pause),
            onPressed: () {
              _controller.pause();
            },
          ),
          IconButton(
            icon: const Icon(Icons.stop),
            onPressed: () {
              _controller.pause();
              _controller.seekTo(Duration.zero);
            },
          ),
        ],
      ),
    );
  }
}
 