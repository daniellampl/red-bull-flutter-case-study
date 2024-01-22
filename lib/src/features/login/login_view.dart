import 'package:flutter/cupertino.dart';

class LoginView extends StatelessWidget {
  const LoginView({super.key});

  static const routeName = 'login';

  @override
  Widget build(BuildContext context) {
    return const CupertinoPageScaffold(
      child: Padding(
        padding: EdgeInsets.all(16),
        child: Center(
          child: Text('Login goes here!'),
        ),
      ),
    );
  }
}
