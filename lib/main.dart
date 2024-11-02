import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:food_reserve/data/food_data.dart';
import 'package:food_reserve/firebase_options.dart';
import 'package:flutter/material.dart';
import 'package:food_reserve/screens/auth.dart';
import 'package:food_reserve/screens/food.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(const ProviderScope(child: MyApp()));
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Food Reserve',
      theme: Theme.of(context).copyWith(
        colorScheme: ColorScheme.fromSeed(
            seedColor: const Color.fromARGB(200, 23, 107, 135),
            secondary: const Color.fromARGB(200, 100, 204, 197)),
      ),
      home: StreamBuilder(
        stream: FirebaseAuth.instance.authStateChanges(),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            return FoodScreen(
              foodList: dishesData,
            );
          }
          if(snapshot.hasError){
            return const Text('Something went wrong!...please try again');
          }
          if(snapshot.connectionState == ConnectionState.waiting){
            return const Center(child: CircularProgressIndicator(),);
          }
          return const AuthScreen();
        },
      ),
    );
  }
}
