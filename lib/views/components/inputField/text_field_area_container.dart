

import 'package:bams_tms/views/components/common/common.dart';
import 'package:flutter/material.dart';


class TextAreaFieldContainer extends StatelessWidget {
  final Widget ? child;
  final double ? txtWidth;
  final double ? txtRadius;
  final String ? labelName;
  final String ? labelYn;
  final Color ? labelColor;



  const TextAreaFieldContainer({
    Key ?  key,
    this.child  ,
    this.txtWidth,
    this.txtRadius,
    this.labelName,
    this.labelYn, this.labelColor,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery
        .of(context)
        .size;
    return Container(
      height: labelYn == 'Y'? 90: 55,
      margin: const EdgeInsets.only(bottom: 0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          labelYn == 'Y'? tc(labelName, labelColor??Colors.black,12) : Container(),
          Container(
            
            height: 75,
            margin: const EdgeInsets.symmetric(vertical: 0),
            padding: const EdgeInsets.symmetric(horizontal:3, vertical: 0),
            width: size.width * txtWidth!,
            decoration: boxOutlineDecoration(Colors.white, txtRadius!) ,
            child: child,
          ),
        ],
      ),
    );
  }
}