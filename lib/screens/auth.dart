import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:food_reserve/providers/login_signUp.dart';

class AuthScreen extends ConsumerStatefulWidget {
  const AuthScreen({super.key});

  @override
  ConsumerState<AuthScreen> createState() => _AuthScreenState();
}

class _AuthScreenState extends ConsumerState<AuthScreen> {
  final _emailControler = TextEditingController();
  final _userNameControler = TextEditingController();
  final _passwardControler = TextEditingController();
  var isLogin = true;
  final _formKey = GlobalKey<FormState>();
  var _authError = false;

  @override
  void dispose() {
    _emailControler.dispose();
    _userNameControler.dispose();
    _passwardControler.dispose();
    super.dispose();
  }

  void _submitForm() async {
    final isValide = _formKey.currentState!.validate();
    if (!isValide) {
      return;
    }
    _formKey.currentState!.save();

    try {
      if (isLogin) {
        ref
            .watch(authenticationProvider.notifier)
            .authUsers(_emailControler, _passwardControler, isLogin);
      } else {
        ref
            .watch(authenticationProvider.notifier)
            .authUsers(_emailControler, _passwardControler, isLogin);
      }
    } on FirebaseAuthException catch (error) {
      if (error.code == 'email-already-in-use') {
        setState(() {
          _authError = true;
        });
      }
      ScaffoldMessenger.of(context).clearSnackBars();
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(error.message ?? 'Authentication error.'),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.surface,
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.primary,
        title: Text(
          'Welcome',
          style: Theme.of(context).textTheme.titleLarge!.copyWith(
                color: Theme.of(context).colorScheme.onPrimary,
              ),
        ),
      ),
      body: Center(
        child: SingleChildScrollView(
          child: Column(
            children: [
              Container(
                width: 275,
                margin: const EdgeInsets.only(
                  top: 30,
                  bottom: 20,
                  left: 20,
                  right: 20,
                ),
                child: Image.asset('assets/images/food_app_logo.jpg'),
              ),
              if (_authError)
                Center(
                  child: Text(
                    'Email is already in Use!',
                    style:
                        TextStyle(color: Theme.of(context).colorScheme.error),
                  ),
                ),
              Card(
                color: Theme.of(context).colorScheme.secondary,
                margin: const EdgeInsets.only(
                  top: 20,
                  bottom: 100,
                  left: 20,
                  right: 20,
                ),
                child: SingleChildScrollView(
                  child: Padding(
                    padding: const EdgeInsets.all(20),
                    child: Form(
                      key: _formKey,
                      child: Column(
                        children: [
                          TextFormField(
                            controller: _emailControler,
                            decoration: const InputDecoration(
                              label: Text('enter email'),
                            ),
                            autocorrect: false,
                            keyboardType: TextInputType.emailAddress,
                            onSaved: (value) {
                              _emailControler.text = value!;
                            },
                            validator: (value) {
                              if (value == null ||
                                  value.trim().isEmpty ||
                                  !value.contains('@')) {
                                return 'please enter a valid email.';
                              }
                              return null;
                            },
                          ),
                          if (!isLogin)
                            TextFormField(
                              controller: _userNameControler,
                              decoration: const InputDecoration(
                                label: Text('enter username'),
                              ),
                              autocorrect: false,
                              keyboardType: TextInputType.emailAddress,
                              onSaved: (value) {
                                _userNameControler.text = value!;
                              },
                              validator: (value) {
                                if (value == null ||
                                    value.trim().isEmpty ||
                                    value.length < 4) {
                                  return 'please enter atleast 4 characters.';
                                }
                                return null;
                              },
                            ),
                          const SizedBox(
                            height: 15,
                          ),
                          TextFormField(
                            controller: _passwardControler,
                            decoration: const InputDecoration(
                              label: Text('enter passward'),
                            ),
                            autocorrect: false,
                            obscureText: true,
                            onSaved: (value) {
                              _passwardControler.text = value!;
                            },
                            validator: (value) {
                              if (value == null ||
                                  value.trim().isEmpty ||
                                  value.length < 6) {
                                return 'please enter atleast 7 characters.';
                              }
                              return null;
                            },
                          ),
                          const SizedBox(
                            height: 15,
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              TextButton(
                                onPressed: () {
                                  setState(() {
                                    isLogin = !isLogin;
                                  });
                                },
                                child: Text(isLogin
                                    ? 'Create a new account'
                                    : 'Already have an account'),
                              ),
                              ElevatedButton(
                                onPressed: _submitForm,
                                child: Text(isLogin ? 'SignIn' : 'SignUp'),
                              ),
                            ],
                          )
                        ],
                      ),
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
