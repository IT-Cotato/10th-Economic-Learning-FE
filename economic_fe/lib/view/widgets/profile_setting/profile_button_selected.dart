import 'package:economic_fe/utils/screen_utils.dart';
import 'package:economic_fe/view/theme/palette.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class ProfileButtonSelected extends StatefulWidget {
  final double paddingWidth;
  final double paddingHeight;
  final double fontSize;
  final String text;

  const ProfileButtonSelected({
    super.key,
    required this.text,
    required this.paddingWidth,
    required this.paddingHeight,
    required this.fontSize,
  });

  @override
  State<ProfileButtonSelected> createState() => _ProfileButtonSelectedState();
}

class _ProfileButtonSelectedState extends State<ProfileButtonSelected> {
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(
          horizontal: ScreenUtils.getWidth(context, widget.paddingWidth),
          vertical: ScreenUtils.getHeight(context, widget.paddingHeight)),
      decoration: ShapeDecoration(
        color: const Color(0xFFDEF7F7),
        shape: RoundedRectangleBorder(
          side: BorderSide(width: 1.w, color: const Color(0xFF767676)),
          borderRadius: BorderRadius.circular(14),
        ),
      ),
      child: Text(
        widget.text,
        style: Palette.pretendard(
          context,
          const Color(0xFF111111),
          widget.fontSize,
          FontWeight.w500,
          1.0,
          -0.4,
        ),
        textAlign: TextAlign.center,
      ),
    );
  }
}
