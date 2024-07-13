import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:let_us_roam/pages/initial_view.dart';
import 'package:let_us_roam/widgets/loader.dart';

class LoginView extends ConsumerStatefulWidget {
  const LoginView({super.key});

  @override
  ConsumerState<LoginView> createState() => _LoginView();
}

class _LoginView extends ConsumerState<LoginView> {
  final _formKey = GlobalKey<FormState>();
  bool isLoading = false;
  bool isForgotPassword = false;
  final RegExp emailValid = RegExp(
      r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+");
  TextEditingController email = TextEditingController();
  TextEditingController password = TextEditingController();

  onLogin() async {
    if (_formKey.currentState!.validate()) {
      setState(() {
        isLoading = true;
      });
      try {
        final credential = await FirebaseAuth.instance
            .signInWithEmailAndPassword(
                email: email.text, password: password.text);
        ref.read(userSession.notifier).state = credential.user;
        if (mounted) {
          Navigator.pushNamed(context, 'indexView');
        }
        setState(() {
          isLoading = false;
        });
        return;
      } on FirebaseAuthException catch (e) {
        if (mounted && e.code == 'invalid-email') {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: const Text('Enter valid email'),
              backgroundColor: Colors.red,
              behavior: SnackBarBehavior.floating,
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

        if (mounted &&
            (e.code == 'INVALID_LOGIN_CREDENTIALS' ||
                e.code == 'invalid-credential')) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: const Text('Email or password is not valid.'),
              backgroundColor: Colors.red,
              behavior: SnackBarBehavior.floating,
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

  onForgotPassword() async {
    setState(() {
      isLoading = true;
    });
    if (_formKey.currentState!.validate()) {
      try {
        await FirebaseAuth.instance.sendPasswordResetEmail(email: email.text);
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: const Text('Password reset link sent to your email'),
              backgroundColor: Colors.blue,
              behavior: SnackBarBehavior.floating,
              margin: EdgeInsets.only(
                  bottom: MediaQuery.of(context).size.height - 100,
                  right: 20,
                  left: 20),
            ),
          );

          isForgotPassword = false;
        }

        setState(() {
          isLoading = false;
        });
        return;
      } on FirebaseAuthException catch (e) {
        if (mounted && e.code == 'invalid-email') {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: const Text('Enter valid email'),
              backgroundColor: Colors.red,
              behavior: SnackBarBehavior.floating,
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

        if (mounted &&
            (e.code == 'INVALID_LOGIN_CREDENTIALS' ||
                e.code == 'invalid-credential')) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: const Text('Email or password is not valid.'),
              backgroundColor: Colors.red,
              behavior: SnackBarBehavior.floating,
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
                Colors.orange.shade900,
                Colors.orange.shade800,
                Colors.orange.shade400
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
              Padding(
                padding: const EdgeInsets.all(20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      isForgotPassword ? "Reset" : "Login",
                      style: const TextStyle(
                          color: Colors.white,
                          fontSize: 40,
                          fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    Text(
                      isForgotPassword ? "Your Password" : 'Welcome Back',
                      style: const TextStyle(color: Colors.white, fontSize: 18),
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
                        isForgotPassword
                            ? Form(
                                key: _formKey,
                                child: Column(
                                  children: [
                                    TextFormField(
                                      controller: email,
                                      autofocus: true,
                                      textInputAction: TextInputAction.done,
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
                                    )
                                  ],
                                ),
                              )
                            : Form(
                                key: _formKey,
                                child: Column(
                                  children: [
                                    TextFormField(
                                      controller: email,
                                      autofocus: false,
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
                                        if (value.isNotEmpty &&
                                            value.length < 6) {
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
                        isForgotPassword
                            ? isLoading
                                ? const Loader(size: 20)
                                : ElevatedButton(
                                    onPressed: () {
                                      onForgotPassword();
                                    },
                                    child: const Text('Send Reset Link'),
                                  )
                            : isLoading
                                ? const Loader(size: 20)
                                : ElevatedButton(
                                    onPressed: () {
                                      onLogin();
                                    },
                                    child: const Text("Login"),
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
                                Navigator.pushNamed(
                                    context, 'registrationView');
                              },
                              child: const Text('New Registration'),
                            ),
                            isForgotPassword
                                ? OutlinedButton(
                                    onPressed: () {
                                      setState(() {
                                        isForgotPassword = false;
                                      });
                                    },
                                    child: const Text('Back to Login'),
                                  )
                                : OutlinedButton(
                                    onPressed: () {
                                      setState(() {
                                        isForgotPassword = true;
                                      });
                                    },
                                    child: const Text('Forgot Password'),
                                  ),
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
      ),
    );
  }
}
