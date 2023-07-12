
import 'package:bams_tms/views/components/inputField/text_field_container.dart';
import 'package:flutter/material.dart';

class RoundedInputField extends StatelessWidget {
  final String ? hintText;
  final IconData ? icon;
  final IconData ? suffixIcon;
  final ValueChanged<String> ? onChanged;
  final ValueChanged<String> ? onSubmit;
  final VoidCallback? onEditingComplete;
  final TextInputType ? textType;
  final TextEditingController ? txtController;
  final double ? txtWidth;
  final double ? txtRadius;
  final FocusNode ? focusNode;
  final Function ? suffixIconOnclick;
  final bool ? enablests;
  final bool ? autoFocus;
  final String ? labelYn;
  final Color ?  labelColor;
  final double ? fontSize;

  const RoundedInputField({
    Key ? key,
    required this.hintText,
    this.icon,
    this.onChanged,
    this.textType,
    this.txtController,
    this.txtWidth,
    this.txtRadius,
    this.suffixIcon, this.onSubmit, this.focusNode, this.suffixIconOnclick, this.enablests, this.autoFocus, this.labelYn,
    this.onEditingComplete,
    this.fontSize, this.labelColor
  }) : super(key: key);


  @override
  Widget build(BuildContext context) {



    return TextFieldContainer(
      txtRadius: txtRadius ?? 29,
      txtWidth: txtWidth ?? 0.8,
      labelName: hintText ?? '',
      labelYn :  labelYn ??'N',
      labelColor : labelColor,


      child: TextFormField(
        enabled: enablests ?? true,
        focusNode: focusNode,
        autofocus: autoFocus??false,
        controller: txtController,
        onChanged: onChanged,
        cursorColor: Colors.black,
        onEditingComplete: onEditingComplete,
        decoration: InputDecoration(
          suffixIcon: InkWell(
            onTap: suffixIconOnclick??fn(),
            child: Icon(
              suffixIcon,
              color: Colors.black ,
              size: 15,
            ),
          ),
          hintText: hintText,
          hintStyle: TextStyle(
            fontSize: 12,
            color: Colors.black
          ),
          border: InputBorder.none,
        ),
        style: TextStyle(
            fontSize: fontSize),
        keyboardType: textType,
        validator: (value) {
          if (value == null || value.isEmpty) {
            return 'Please enter some text';
          }
          return null;
        },
        onFieldSubmitted: onSubmit,


      ),
    );
  }
  fn(){

  }
}