import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:firebase_auth/firebase_auth.dart';

final userSession = StateProvider<User?>((ref) => null);

class InitialView extends ConsumerStatefulWidget {
  const InitialView({super.key});

  @override
  ConsumerState<InitialView> createState() => _InitialView();
}

class _InitialView extends ConsumerState<InitialView> {
  @override
  void initState() {
    super.initState();
    FirebaseAuth.instance.authStateChanges().listen((User? user) {
      if (user == null) {
        ref.read(userSession.notifier).state = null;
      } else {
        ref.read(userSession.notifier).state = user;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final user = ref.watch(userSession);
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text('Initial View'),
            // ignore: unnecessary_null_comparison
            user != null
                ? Text(user.email as String)
                : Text("User logged in ${user}"),
          ],
        ),
      ),
    );
  }
}
