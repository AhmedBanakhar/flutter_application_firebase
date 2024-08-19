import 'package:flutter/material.dart';

class CustomButton extends StatelessWidget {
  final String login;
  final void Function()? onPressed;
  const CustomButton({super.key, required this.login, required this.onPressed});

  @override
  Widget build(BuildContext context) {
    return MaterialButton(
      height: 40,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(50)),
      color: const Color(0xFFE4C59E),
      onPressed: onPressed,
      child: Text(
        login,
        style: TextStyle(color: Colors.black, fontSize: 18),
      ),
    );
  }
}

class CustomUpload extends StatelessWidget {
  final String login;
  final bool isSlected;
  final void Function()? onPressed;
  const CustomUpload({super.key, required this.login, required this.onPressed, required this.isSlected});

  @override
  Widget build(BuildContext context) {
    return MaterialButton(
      height: 40,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(50)),
      color:isSlected ? Colors.green: const Color.fromARGB(255, 255, 55, 0),
      onPressed: onPressed,
      child: Text(
        login,
        style: TextStyle(color: Colors.white, fontSize: 18),
      ),
    );
  }
}
