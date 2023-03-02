import 'dart:core';

import 'package:flutter/material.dart';
import 'package:flutter/material.dart';

class DefaultFormField extends StatelessWidget {
  final TextEditingController controller;
  final TextInputType type;
   Function? onChange;
   Function? onTap;
   bool isPassword = false;
   ValueChanged<String>? onSubmit;
  final Function validate;
  final IconData prefix;
  IconData? suffix;
  final String text;
  Function? suffixPressed;
   DefaultFormField({super.key, required this.controller, required this.type, required this.validate, required this.prefix, required this.text});

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: controller,
      keyboardType: type,
      onChanged: onChange != null ? onChange!() : null,
      onTap: onTap != null ? () => onTap!() : null,
      obscureText: isPassword,
      onFieldSubmitted: onSubmit,
      validator: (s){
        return validate(s);
      },
      decoration: InputDecoration(
        prefixIcon: Icon(prefix),
        border: const OutlineInputBorder(),
        suffixIcon:  suffix != null ?
        IconButton(
            onPressed: (){
              suffixPressed!();
            },
            icon: Icon(suffix)
        ) : null,
        labelText: text,

      ),
    );
  }
}
