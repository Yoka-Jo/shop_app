import 'package:flutter/material.dart';

class TextContainer extends StatelessWidget {
  final String Function (String) validator;
  final Function onSaved;
  final String hintText;
  final IconData prefixIcon;
  final bool isEnabled;
  final bool isObscured;
  final TextEditingController textEditingController;
  final TextInputType textInputType;
  
   TextContainer({
     this.textInputType,
     this.isObscured = false,
     this.textEditingController,
     @required this.validator,
      this.onSaved,
    @required this.hintText,
    @required this.prefixIcon,
   this.isEnabled = true,
  });

  final _outlineInputBorder = OutlineInputBorder(borderSide: BorderSide(color: Colors.blue ,width: 1) , borderRadius: BorderRadius.all(Radius.circular(10)));
  final _outlineErrorInputBorder = OutlineInputBorder(borderSide: BorderSide(color: Colors.red ,width: 1) , borderRadius: BorderRadius.all(Radius.circular(10)));
 final _hintStyle = TextStyle(color: Colors.grey);
 final _labelStyle = TextStyle(color: Colors.black);
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 10 , vertical: 8),
            child: TextFormField(
              keyboardType: textInputType,
              obscureText: isObscured,
              controller: textEditingController,
              validator: validator,
              enabled: isEnabled,
        onSaved: onSaved,
      decoration: InputDecoration(
        errorBorder: _outlineErrorInputBorder,
        focusedErrorBorder: _outlineInputBorder,
        contentPadding: EdgeInsets.only(top:5),
        prefixIcon: Icon(prefixIcon),
        hintText: hintText,
        labelText: hintText,
        hintStyle: _hintStyle,
        labelStyle: _labelStyle,
        enabledBorder: _outlineInputBorder,
        focusedBorder: _outlineInputBorder
      ),
      ),
    );
  }
}
