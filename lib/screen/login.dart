import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
// import 'package:sign_in_with_apple/sign_in_with_apple.dart';
import 'package:spectrum/service/auth.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class Login extends StatelessWidget {
  const Login({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Container(
          padding: const EdgeInsets.all(30),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Padding(
                padding: const EdgeInsets.only(bottom: 25),
                child: Text(
                  'Spectrum',
                  style: TextStyle(
                    fontFamily: GoogleFonts.bitter().fontFamily,
                    fontWeight: FontWeight.bold,
                    fontSize: 36,
                  ),
                ),
              ),
              Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: const [
                  Text('Sign in with Google'),
                  LoginIconButton(
                    text: 'Sign in with Google',
                    icon: FontAwesomeIcons.google,
                    color: Colors.black87,
                    loginMethod: AuthService.googleLogin,
                  ),

                  // FutureBuilder<Object>(
                  //   future: SignInWithApple.isAvailable(),
                  //   builder: (context, snapshot) {
                  //     if (snapshot.data == true) {
                  //       return LoginButton(
                  //         text: 'Sign in with Apple',
                  //         icon: FontAwesomeIcons.apple,
                  //         color: Colors.white,
                  //         loginMethod: AuthService().signInWithApple,
                  //       );
                  //     } else {
                  //       return Container();
                  //     }
                  //   },
                  // ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class LoginIconButton extends StatelessWidget {
  final Color color;
  final IconData icon;
  final String text;
  final Function loginMethod;

  const LoginIconButton({
    Key? key,
    required this.text,
    required this.icon,
    required this.color,
    required this.loginMethod,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.all(10),
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        border: Border.all(
          color: color,
          width: 1,
        ),
        borderRadius: BorderRadius.circular(10),
        color: Colors.white,
      ),
      child: IconButton(
        icon: Icon(icon),
        color: color,
        tooltip: text,
        onPressed: () => loginMethod(),
      ),
    );
  }
}
