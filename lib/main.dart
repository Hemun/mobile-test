import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:last_exam/firebase_options.dart';
import 'package:last_exam/provider/authProvider.dart';
import 'package:last_exam/provider/globalProvider.dart';
import 'package:last_exam/screens/home_page.dart';
import 'package:last_exam/screens/signIn_page.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);

  runApp(MultiProvider(providers: [
    ChangeNotifierProvider(
      create: (context) => Global_provider(),
    ),
    ChangeNotifierProvider(create: (context) => AuthProvider())
  ], child: const MyApp()));
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<String>(
      future: _getLanguagePreference(),
      builder: (BuildContext context, AsyncSnapshot<String> snapshot) {
        if (snapshot.connectionState == ConnectionState.done) {
          return MaterialApp(
            theme: ThemeData(
              useMaterial3: false,
            ),
            debugShowCheckedModeBanner: false,
            locale: Locale(snapshot.data ?? 'en'),
            supportedLocales: [
              const Locale('en', 'US'),
              const Locale('es', 'ES'),
              // Add more supported locales as needed
            ],
            localizationsDelegates: [
              // Add your localizations delegates
              // For example:
            ],
            home: SignIn(),
          );
        } else {
          return CircularProgressIndicator();
        }
      },
    );
  }

  Future<String> _getLanguagePreference() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString('language_code') ??
        'en'; // Provide a default value if language preference is not found
  }
}
