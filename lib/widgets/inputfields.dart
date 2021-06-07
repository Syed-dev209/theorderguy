import 'package:flutter/material.dart';

class inputFields extends StatelessWidget {
  final String hintText;
  final Function(String) onChange;
  final Function(String) onSubmit;
  final FocusNode focusNode;
  final TextInputAction textInputAction;
  final bool isPasswardField;
  final bool isEmailField;
  var controller;

  inputFields({this.hintText,this.onChange,this.onSubmit,this.focusNode,this.textInputAction,this.isPasswardField , this.controller, this.isEmailField});
  @override
  Widget build(BuildContext context) {
    bool _isPasswardField = isPasswardField ?? false;
    bool _isEmailField = isEmailField ?? false;
    return Container(
        margin: EdgeInsets.symmetric(
            horizontal: 10,
            vertical: 7,
        ),
        decoration: BoxDecoration(
          color: Colors.grey[200],
          borderRadius: BorderRadius.circular(5),
        ),
        child: TextFormField(
          focusNode: focusNode,
          onChanged: onChange,
          validator: (value) {
            if (value == null || value.isEmpty) {
              return 'Please enter some text';
            }
            else if(_isEmailField){
              bool emailValid = RegExp(r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+").hasMatch(value);
              if (!emailValid) {
                return 'Please enter Valid Email Address';
              }
            }
            return null;
          },
          controller: controller,
          //onSubmitted: onSubmit,
          textInputAction: textInputAction,
          obscureText: _isPasswardField,
          decoration: InputDecoration(
              border: InputBorder.none,
              hintText: hintText ?? "Hint Text",
              contentPadding: EdgeInsets.symmetric(
                  horizontal: 24,
                  vertical: 16
              )
          ),
        )
    );
  }
}
