import 'package:economic_fe/view/theme/palette.dart';
import 'package:economic_fe/view/widgets/custom_app_bar.dart';
import 'package:economic_fe/view_model/quiz/level_select_controller.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';

class LevelSelectPage extends StatefulWidget {
  const LevelSelectPage({super.key});

  @override
  State<LevelSelectPage> createState() => _LevelSelectPageState();
}

class _LevelSelectPageState extends State<LevelSelectPage> {
  late final LevelSelectController controller;
  String _selectedLevel = ''; // 선택된 레벨을 저장할 변수

  @override
  void initState() {
    super.initState();
    final args = Get.arguments ?? {};
    controller = Get.put(LevelSelectController()
      ..conceptName.value = args["name"] ?? "개념 학습"
      ..learningSetId.value = args["learningSetId"] ?? 0
      ..mode.value = args["mode"] ?? "quiz"
      ..getStats());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Palette.background,
      appBar: CustomAppBar(
        title: "레벨선택",
        icon: Icons.arrow_back_ios_new,
        onPress: () {
          // Navigator.pop(context);
          Get.toNamed('/learning_list');
        },
      ),
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: 32.w),
        child: Center(
          child: Obx(() => Column(
                children: [
                  SizedBox(height: 62.h),
                  _buildLevelButton(
                    label: '초급',
                    isSelected: _selectedLevel == 'BEGINNER',
                    onTap: () {
                      setState(() {
                        _selectedLevel = 'BEGINNER';
                        controller.selectedLevel = _selectedLevel;

                        if (controller.mode.value == 'quiz') {
                          controller.clickedQuizBtn(
                              context,
                              controller.learningSetId.value,
                              controller.conceptName.value,
                              _selectedLevel);
                        } else {
                          controller.clickedConceptBtn(
                              context,
                              controller.learningSetId.value,
                              controller.conceptName.value,
                              _selectedLevel);
                        }
                      });
                    },
                    isCompleted:
                        controller.levelCompletion['BEGINNER'] ?? false,
                  ),
                  SizedBox(height: 16.h),
                  _buildLevelButton(
                    label: '중급',
                    isSelected: _selectedLevel == 'INTERMEDIATE',
                    onTap: () {
                      setState(() {
                        _selectedLevel = 'INTERMEDIATE';
                        controller.selectedLevel = _selectedLevel;

                        if (controller.mode.value == 'quiz') {
                          controller.clickedQuizBtn(
                              context,
                              controller.learningSetId.value,
                              controller.conceptName.value,
                              _selectedLevel);
                        } else {
                          controller.clickedConceptBtn(
                              context,
                              controller.learningSetId.value,
                              controller.conceptName.value,
                              _selectedLevel);
                        }
                      });
                    },
                    isCompleted:
                        controller.levelCompletion['INTERMEDIATE'] ?? false,
                  ),
                  SizedBox(height: 16.h),
                  _buildLevelButton(
                    label: '고급',
                    isSelected: _selectedLevel == 'ADVANCED',
                    onTap: () {
                      setState(() {
                        _selectedLevel = 'ADVANCED';
                        controller.selectedLevel = _selectedLevel;

                        if (controller.mode.value == 'quiz') {
                          controller.clickedQuizBtn(
                              context,
                              controller.learningSetId.value,
                              controller.conceptName.value,
                              _selectedLevel);
                        } else {
                          controller.clickedConceptBtn(
                              context,
                              controller.learningSetId.value,
                              controller.conceptName.value,
                              _selectedLevel);
                        }
                      });
                    },
                    isCompleted:
                        controller.levelCompletion['ADVANCED'] ?? false,
                  ),
                ],
              )),
        ),
      ),
    );
  }

  Widget _buildLevelButton({
    required String label,
    required bool isSelected,
    required VoidCallback onTap,
    required bool isCompleted,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: MediaQuery.of(context).size.width - 64,
        padding: EdgeInsets.symmetric(horizontal: 24.w, vertical: 24.h),
        decoration: ShapeDecoration(
          color: isSelected ? Palette.buttonColorGreen : Colors.white,
          shape: RoundedRectangleBorder(
            side: BorderSide(
              width: 1.w,
              color: isSelected
                  ? Palette.buttonColorGreen
                  : const Color(0xFFD9D9D9),
            ),
            borderRadius: BorderRadius.circular(12),
          ),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              label,
              style: TextStyle(
                color: isSelected ? Colors.white : const Color(0xFF111111),
                fontSize: 20.sp,
                fontWeight: FontWeight.w500,
                height: 1.50,
                letterSpacing: -0.50,
              ),
            ),
            controller.mode.value == 'quiz'
                ? Icon(
                    isCompleted
                        ? Icons.check_circle
                        : Icons.check_circle_outline,
                    color: isCompleted
                        ? Palette.buttonColorGreen
                        : const Color(0xffa2a2a2),
                  )
                : const SizedBox(), // concept 모드일 경우 아이콘 숨김
          ],
        ),
      ),
    );
  }
}
