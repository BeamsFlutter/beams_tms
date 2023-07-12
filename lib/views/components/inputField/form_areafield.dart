

import 'package:bams_tms/views/components/common/common.dart';
import 'package:bams_tms/views/styles/colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';

class FormArea extends StatelessWidget {

  final String ? hintText;
  final IconData ? icon;
  final IconData ? suffixIcon;
  final ValueChanged<String> ? onChanged;
  final ValueChanged<String> ? onSubmit;
  final VoidCallback? onEditingComplete;
  final TextInputType ? textType;
  final TextEditingController ? txtController;
  final double ? txtHeight;
  final double ? txtWidth;
  final double ? txtRadius;
  final FocusNode ? focusNode;
  final Function ? suffixIconOnclick;
  final Function ? onClear;
  final bool ? enablests;
  final bool ? autoFocus;
  final bool ? validate;
  final bool ? emptySts;
  final bool ? focusSts;
  final String ? errorMsg;
  final String ? labelYn;
  final Color ?  labelColor;
  final double ? fontSize;
  final int ? maxLines;
  const FormArea({Key? key, this.hintText, this.icon, this.suffixIcon, this.onChanged, this.onSubmit, this.onEditingComplete, this.textType, this.txtController, this.txtHeight, this.txtWidth, this.txtRadius, this.focusNode, this.suffixIconOnclick, this.onClear, this.enablests, this.autoFocus, this.validate, this.emptySts, this.errorMsg, this.labelYn, this.labelColor, this.fontSize, this.maxLines, this.focusSts}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    List<TextInputFormatter> inputFormatters = [];
    if(textType == TextInputType.number){
      inputFormatters.add(FilteringTextInputFormatter.digitsOnly);
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        labelYn != "N"?
        tcn(hintText,labelColor ?? bgColorDark, 12):gapHC(0),
        gapHC(2),
        Container(
          width:size.width * txtWidth!,
          padding: const EdgeInsets.symmetric(horizontal: 15),
          decoration: boxOutlineInput(enablests??true,focusSts??false),
          child: TextFormField(
            maxLines:maxLines?? 5,
            controller: txtController,
            autofocus: autoFocus??false,
            enabled: enablests??true,
            keyboardType: textType,
            onChanged:onChanged??fn() ,
            cursorColor: subColor,
            onFieldSubmitted: onSubmit??fn(),
            inputFormatters: inputFormatters,
            style: GoogleFonts.poppins(fontSize: 11,color: Colors.black),
            decoration:  InputDecoration(
              hintText:hintText.toString(),
              border: InputBorder.none,
              suffixIcon: suffixIcon != null? InkWell(
                onTap: suffixIconOnclick??fn(),
                child: Icon(
                  suffixIcon,
                  color: bgColorDark ,
                  size: 20,
                ),
              ): GestureDetector(
                onTap: onClear??fn(),
                child:  (emptySts??true)?  Icon(Icons.cancel_outlined,size: 20,color: Colors.grey.withOpacity(0.6)): Icon(Icons.cancel_outlined,size: 20,color: greyLight,),
              ),
            ),
            validator: (value) {
              if(validate??false){
                if (value == null || value.isEmpty) {
                  //return errorMsg;
                }
              }
              return null;
            },
          ),
        ),
        gapHC(2),
        (validate??false) && !emptySts! && (errorMsg??"").isNotEmpty?
        tcn(errorMsg??"",subColor, 12):gapHC(0),

      ],
    );
  }
  fn(){

  }
}
