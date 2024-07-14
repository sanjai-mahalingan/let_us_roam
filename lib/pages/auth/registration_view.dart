import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:let_us_roam/pages/initial_view.dart';
import 'package:let_us_roam/widgets/loader.dart';

class RegistrationView extends ConsumerStatefulWidget {
  const RegistrationView({super.key});

  @override
  ConsumerState<RegistrationView> createState() => _RegistrationView();
}

class _RegistrationView extends ConsumerState<RegistrationView> {
  final _formKey = GlobalKey<FormState>();
  bool isLoading = false;
  final RegExp emailValid = RegExp(
      r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+");
  TextEditingController email = TextEditingController();
  TextEditingController password = TextEditingController();

  onRegistration() async {
    if (_formKey.currentState!.validate()) {
      setState(() {
        isLoading = true;
      });
      try {
        await FirebaseAuth.instance.createUserWithEmailAndPassword(
            email: email.text, password: password.text);
        FirebaseAuth.instance.authStateChanges().listen((User? user) {
          if (user != null) {
            ref.read(userSession.notifier).state = user;
          } else {
            ref.read(userSession.notifier).state = null;
            Navigator.pushNamed(context, 'initialView');
          }
        });

        setState(() {
          isLoading = false;
        });
        if (mounted) {
          Navigator.pushNamed(context, 'indexView',
              arguments: {'newUser': true});
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Thank for your registration.'),
              backgroundColor: Colors.green,
            ),
          );
        }
        return;
      } on FirebaseAuthException catch (e) {
        if (mounted && e.code == 'invalid-email') {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              behavior: SnackBarBehavior.floating,
              content: const Text('The email address is badly formatted.'),
              backgroundColor: Colors.red,
              margin: EdgeInsets.only(
                  bottom: MediaQuery.of(context).size.height - 100,
                  right: 20,
                  left: 20),
            ),
          );
          setState(() {
            isLoading = false;
          });
          return;
        }
        if (mounted && e.code == 'email-already-in-use') {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              behavior: SnackBarBehavior.floating,
              content: const Text('Email already registered'),
              backgroundColor: Colors.red,
              margin: EdgeInsets.only(
                  bottom: MediaQuery.of(context).size.height - 100,
                  right: 20,
                  left: 20),
            ),
          );
          setState(() {
            isLoading = false;
          });
          return;
        }
      }
    }

    setState(() {
      isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
        canPop: false,
        child: Scaffold(
          resizeToAvoidBottomInset: false,
          body: Container(
            width: double.infinity,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  Colors.blue.shade900,
                  Colors.blue.shade800,
                  Colors.blue.shade400,
                ],
                begin: Alignment.topCenter,
              ),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(
                  height: 80,
                ),
                const Padding(
                  padding: EdgeInsets.all(20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'New Registration',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 40,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      Text(
                        'Happy Roaming',
                        style: TextStyle(color: Colors.white, fontSize: 18),
                      ),
                    ],
                  ),
                ),
                const SizedBox(
                  height: 20,
                ),
                Expanded(
                  child: Container(
                    decoration: const BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(60),
                        topRight: Radius.circular(60),
                      ),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(30),
                      child: Column(
                        children: [
                          const SizedBox(
                            height: 40,
                          ),
                          Form(
                            key: _formKey,
                            child: Column(
                              children: [
                                TextFormField(
                                  controller: email,
                                  autofocus: true,
                                  textInputAction: TextInputAction.next,
                                  keyboardType: TextInputType.emailAddress,
                                  decoration: const InputDecoration(
                                    label: Text('Email'),
                                  ),
                                  validator: (value) {
                                    if (value == null || value.isEmpty) {
                                      return "Enter email";
                                    }
                                    if (value.isNotEmpty &&
                                        !emailValid.hasMatch(value)) {
                                      return "Enter valid email";
                                    }
                                    return null;
                                  },
                                ),
                                const SizedBox(
                                  height: 10,
                                ),
                                TextFormField(
                                  controller: password,
                                  textInputAction: TextInputAction.done,
                                  obscureText: true,
                                  decoration: const InputDecoration(
                                    label: Text('Password'),
                                  ),
                                  validator: (value) {
                                    if (value == null || value.isEmpty) {
                                      return "Enter password";
                                    }
                                    if (value.isNotEmpty && value.length < 6) {
                                      return "Password should be minimum 6 characters";
                                    }
                                    return null;
                                  },
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(
                            height: 20,
                          ),
                          isLoading
                              ? const Loader(size: 20)
                              : ElevatedButton(
                                  onPressed: () {
                                    onRegistration();
                                  },
                                  child: const Text('Start Roaming'),
                                ),
                          const SizedBox(
                            height: 20,
                          ),
                          Divider(
                            endIndent: 50.0,
                            indent: 50.0,
                            color: Colors.orange.shade400,
                          ),
                          const SizedBox(
                            height: 20,
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceAround,
                            children: [
                              OutlinedButton(
                                onPressed: () {
                                  setState(() {
                                    Navigator.pushNamed(context, 'loginView');
                                  });
                                },
                                child: const Text('Back to Login'),
                              )
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ));
  }
}
