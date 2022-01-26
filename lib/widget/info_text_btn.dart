import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class InfoTextBtn extends StatelessWidget {
  final void Function()? onPressed;
  final Color? color;
  final double? size;

  const InfoTextBtn({
    Key? key,
    required this.onPressed,
    this.color = Colors.black54,
    this.size = 30,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return TextButton(
      onPressed: onPressed,
      child: Text(
        'i',
        style: TextStyle(
          fontSize: size,
          color: color,
          fontFamily: GoogleFonts.tangerine().fontFamily,
        ),
      ),
    );
  }
}
