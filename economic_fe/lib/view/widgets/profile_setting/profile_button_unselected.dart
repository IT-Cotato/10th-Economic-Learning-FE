import 'package:economic_fe/utils/screen_utils.dart';
import 'package:economic_fe/view/theme/palette.dart';
import 'package:flutter/material.dart';

class ProfileButtonUnselected extends StatefulWidget {
  final double paddingWidth;
  final double paddingHeight;
  final double fontSize;
  final String text;

  const ProfileButtonUnselected({
    super.key,
    required this.text,
    required this.paddingWidth,
    required this.paddingHeight,
    required this.fontSize,
  });

  @override
  State<ProfileButtonUnselected> createState() =>
      _ProfileButtonUnselectedState();
}

class _ProfileButtonUnselectedState extends State<ProfileButtonUnselected> {
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: ScreenUtils.getWidth(context, widget.paddingWidth),
        vertical: ScreenUtils.getHeight(context, widget.paddingHeight),
      ),
      decoration: ShapeDecoration(
        shape: RoundedRectangleBorder(
          side: BorderSide(
              width: ScreenUtils.getWidth(context, 1),
              color: const Color(0xFFA2A2A2)),
          borderRadius: BorderRadius.circular(14),
        ),
      ),
      child: Text(
        widget.text,
        style: Palette.pretendard(
          context,
          const Color(0xFFA2A2A2),
          widget.fontSize,
          FontWeight.w400,
          1.0,
          -0.4,
        ),
        textAlign: TextAlign.center,
      ),
    );
  }
}
