import 'package:flutter/material.dart';

class CustomTextForm extends StatefulWidget {
  final String hinttext;
  final TextEditingController mycontroller;
  final String? Function(String?)? validator;
  const CustomTextForm(
      {super.key,
      required this.hinttext,
      required this.mycontroller,
      required this.validator});

  @override
  State<CustomTextForm> createState() => _CustomTextFormState();
}

class _CustomTextFormState extends State<CustomTextForm> {
  @override
  Widget build(BuildContext context) {
    return TextFormField(
        validator: widget.validator,
        controller: widget.mycontroller,
        decoration: InputDecoration(
          hintText: widget.hinttext,
          hintStyle: const TextStyle(fontSize: 14, color: Colors.grey),
          contentPadding:
              const EdgeInsets.symmetric(vertical: 2, horizontal: 20),
          filled: true,
          fillColor: Colors.grey[300],
          focusedBorder: OutlineInputBorder(
              borderSide: BorderSide(color: Color(0xFFAF8260)),
              borderRadius: BorderRadius.circular(20)),
          enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(20),
              borderSide: const BorderSide(color: Colors.grey)),
          // border: OutlineInputBorder(
          //     borderRadius: BorderRadius.circular(50),
          //     borderSide: BorderSide(color: Colors.grey)),
          // enabledBorder: OutlineInputBorder(
          //    borderSide: BorderSide(color: Colors.deepOrange),
          //     borderRadius: BorderRadius.circular(50),
          //  borderSide: const BorderSide(color: Colors.grey)
        )
        //),
        );
  }
}
