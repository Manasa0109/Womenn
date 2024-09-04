import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';
import 'package:womenn/features/app/splash_screen/splash_screen.dart';
import 'package:womenn/features/user_auth/presentation/pages/login_page.dart';
import 'package:womenn/features/user_auth/presentation/pages/home_page.dart' as home;
import 'package:womenn/features/user_auth/presentation/pages/non_camera_mode_page.dart' as non_camera;
import 'package:firebase_auth/firebase_auth.dart';
import 'package:womenn/features/user_auth/presentation/pages/trusted_contacts_page.dart';
import 'package:womenn/features/user_auth/presentation/pages/camera_mode_page.dart' as camera;
import 'package:womenn/features/user_auth/presentation/pages/destination_tracking_page.dart' as destination_tracking;
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:womenn/features/user_auth/presentation/pages/video_player_page.dart';
Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  print('Handling a background message: ${message.messageId}');
}

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Firebase initialization
  if (kIsWeb) {
    await Firebase.initializeApp(
      options: FirebaseOptions(
        apiKey: "AIzaSyBFUjXGA1mPAPKP-RIcSmNmg91o7b_J7C4",
        appId: "1:214119305555:web:9b6e803ff8aeeb81a811a6",
        messagingSenderId: "214119305555",
        projectId: "womenn-9ac19",
      ),
    );
  } else {
    await Firebase.initializeApp();
  }

  // Initialize Firebase Messaging
  FirebaseMessaging messaging = FirebaseMessaging.instance;

  // Request permission for iOS (if applicable)
  NotificationSettings settings = await messaging.requestPermission(
    alert: true,
    badge: true,
    sound: true,
    provisional: false,
  );

  print('User granted permission: ${settings.authorizationStatus}');

  // Handle foreground messages
  FirebaseMessaging.onMessage.listen((RemoteMessage message) {
    print('Received a message: ${message.notification?.title}');
  });

  // Handle background messages
  FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Women Safety App',
      home: SplashScreen(child: const AuthWrapper()), // Start with SplashScreen
      routes: {
        '/home': (context) => home.HomePage(),
        '/login': (context) => LoginPage(),
        '/cameraMode': (context) => camera.CameraModePage(),
        '/nonCameraMode': (context) => non_camera.NonCameraModePage(),
        '/trustedContacts': (context) => TrustedContacts(),
        '/destinationTracking': (context) => destination_tracking.DestinationTrackingPage(),
      },
    );
  }
}

class AuthWrapper extends StatelessWidget {
  const AuthWrapper({super.key});

  @override
  Widget build(BuildContext context) {
    final FirebaseAuth auth = FirebaseAuth.instance;

    return StreamBuilder<User?>(
      stream: auth.authStateChanges(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.active) {
          if (snapshot.hasData) {
            return home.HomePage();
          } else {
            return LoginPage();
          }
        }
        return const CircularProgressIndicator(); // Loading indicator while checking auth state
      },
    );
  }
}
