import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:let_us_roam/widgets/loader.dart';

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
        Navigator.pushNamed(context, 'loginView');
      } else {
        ref.read(userSession.notifier).state = user;
        Navigator.pushNamed(context, 'indexView');
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    // final user = ref.watch(userSession);
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [Colors.black, Colors.grey]),
        ),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                'Let Us Roam',
                style: Theme.of(context).textTheme.titleLarge,
              ),
              const SizedBox(
                height: 20,
              ),
              const Loader(size: 34)
            ],
          ),
        ),
      ),
    );
  }
}
