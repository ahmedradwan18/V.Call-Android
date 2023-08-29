import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';

class GenericText extends StatelessWidget {
  final String text;
  final double fontSize;
  final FontWeight fontWeight;
  final Color color;
  final TextAlign textAlign;
  final String fontFamily;
  final int? maxLines;
  final double? textHeight;
  final TextOverflow? overflow;

  const GenericText({
    Key? key,
    required this.text,
    this.fontSize = 16.0,
    this.fontWeight = FontWeight.normal,
    this.color = Colors.black,
    this.textAlign = TextAlign.start,
    this.fontFamily = 'Poppins',
    this.maxLines ,
    this.textHeight ,
    this.overflow ,

  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AutoSizeText(
      text,
      overflow: overflow,
      strutStyle: StrutStyle(
        fontFamily: fontFamily,
        forceStrutHeight: true,
      ),
      style: TextStyle(
        fontSize: fontSize,
        height: textHeight,
        fontWeight: fontWeight,fontFamily:fontFamily ,
        color: color,

      ),
      textAlign: textAlign,
      minFontSize: 4,
      maxLines: maxLines,
    );
  }
}