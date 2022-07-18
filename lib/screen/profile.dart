import 'package:flutter/material.dart';
import 'package:spectrum/service/auth.dart';

class Profile extends StatelessWidget {
  const Profile({Key? key}) : super(key: key);

  // TODO: just a placeholder for now, will write up later
  @override
  Widget build(BuildContext context) {
    return Center(
      child: SizedBox(
        width: 200,
        height: 50,
        child: ElevatedButton(
          child: const Text('signout'),
          onPressed: () async {
            await AuthService.signOut();
            Navigator.of(context)
                .pushNamedAndRemoveUntil('/', (route) => false);
          },
        ),
      ),
    );
  }
}
