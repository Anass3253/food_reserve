import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:firebase_auth/firebase_auth.dart';

class AuthenticationNotifier extends StateNotifier<String> {
  AuthenticationNotifier() : super('');
  void authUsers(TextEditingController emailControler,
      TextEditingController passwardControler, bool isLogin) async {
    if (isLogin) {
      await FirebaseAuth.instance.signInWithEmailAndPassword(
          email: emailControler.text, password: passwardControler.text);
      final currentUser = FirebaseAuth.instance.currentUser!;
      state = currentUser.uid;
    } else {
      await FirebaseAuth.instance.createUserWithEmailAndPassword(
          email: emailControler.text, password: passwardControler.text);
      final newUser = FirebaseAuth.instance.currentUser;
      state = newUser!.uid;
    }
  }
}

final authenticationProvider =
    StateNotifierProvider<AuthenticationNotifier, String>(
  (ref) {
    return AuthenticationNotifier();
  },
);
