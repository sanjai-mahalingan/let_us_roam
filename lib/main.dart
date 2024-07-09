import 'package:flutter/material.dart';
import 'package:let_us_roam/pages/auth/registration_view.dart';
import 'package:let_us_roam/pages/index_view.dart';
import 'package:let_us_roam/pages/initial_view.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:let_us_roam/pages/auth/login_view.dart';
import 'firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  runApp(const ProviderScope(child: MainApp()));
}

class MainApp extends ConsumerWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return MaterialApp(
      theme: ThemeData(
        useMaterial3: true,

        // Define the default brightness and colors
        colorScheme: ColorScheme.fromSeed(
            seedColor: Colors.purple, brightness: Brightness.light),

        // Default Text Theme
        textTheme: const TextTheme(
          titleLarge: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
          titleMedium: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          displayMedium: TextStyle(
            fontSize: 16,
          ),
        ),
      ),
      initialRoute: "initialView",
      routes: {
        "initialView": (context) => const InitialView(),
        "indexView": (context) => const IndexView(),
        "registrationView": (context) => const RegistrationView(),
        "loginView": (context) => const LoginView(),
      },
    );
  }
}
