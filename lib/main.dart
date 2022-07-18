import 'package:firebase_core/firebase_core.dart';
import 'package:spectrum/firebase_options.dart';
import 'package:flutter/material.dart';
import 'package:spectrum/screen/loading.dart';
import 'package:spectrum/screen/login.dart';
import 'package:spectrum/theme.dart';
import 'package:spectrum/model/user_model.dart';
import 'package:spectrum/screen/home.dart';
import 'package:spectrum/widget/error.dart';
import 'package:spectrum/service/auth.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(const App());
}

class App extends StatefulWidget {
  const App({Key? key}) : super(key: key);

  @override
  State<App> createState() => _AppState();
}

class _AppState extends State<App> {
  final Future<FirebaseApp> _initialization = Firebase.initializeApp();

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: _initialization,
      builder: (context, snapshot) {
        return MaterialApp(
          debugShowCheckedModeBanner: false,
          theme: appTheme,
          routes: {
            '/login': (context) => const Login(),
          },
          home: snapshot.connectionState == ConnectionState.waiting
              ? const Loading()
              : snapshot.hasError
                  ? const ErrorMessage()
                  : const Dispatcher(),
        );
      },
    );
  }
}

class Dispatcher extends StatelessWidget {
  const Dispatcher({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      stream: AuthService.userStream,
      builder: (context, snapshot) {
        return MaterialApp(
          debugShowCheckedModeBanner: false,
          theme: appTheme,
          home: snapshot.connectionState == ConnectionState.waiting
              ? const Loading()
              : snapshot.hasError
                  ? const ErrorMessage()
                  : snapshot.hasData
                      ? const DataHandler()
                      : const Login(),
        );
      },
    );
  }
}

class DataHandler extends StatelessWidget {
  const DataHandler({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final currentUser = User(
      AuthService.user!.uid,
      AuthService.user!.displayName!,
      AuthService.user!.email!,
    );

    return FutureBuilder<Object>(
      future: currentUser.isNewUser(currentUser.id),
      builder: (context, snapshot) {
        if (snapshot.data == true) currentUser.createUser(currentUser);
        return MaterialApp(
          debugShowCheckedModeBanner: false,
          home: const Home(),
          theme: appTheme,
        );
      },
    );
  }
}
