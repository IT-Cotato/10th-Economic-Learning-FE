import 'package:economic_fe/view/theme/palette.dart';
import 'package:economic_fe/view_model/learning_set/learning_list_controller.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

class LearningListItem extends StatefulWidget {
  final int setNum;
  final String setTitle;
  final int index;

  const LearningListItem({
    super.key,
    required this.setNum,
    required this.setTitle,
    required this.index,
  });

  @override
  State<LearningListItem> createState() => _LearningListItemState();
}

class _LearningListItemState extends State<LearningListItem> {
  @override
  Widget build(BuildContext context) {
    final controller = Get.find<LearningListController>();

    return Obx(() {
      // 현재 아이템이 선택되었는지 여부
      bool isSelected = controller.selectedItemIndex.value == widget.index;

      // 현재 학습 세트 데이터 가져오기
      final learningSet = controller.learningSetList.isNotEmpty &&
              widget.index < controller.learningSetList.length
          ? controller.learningSetList[widget.index]
          : null;

      return Column(
        children: [
          Container(
            width: 332.w,
            height: 91.h,
            padding: EdgeInsets.symmetric(
              horizontal: 21.w,
              vertical: 18.h,
            ),
            decoration: ShapeDecoration(
              color: Colors.white,
              shape: RoundedRectangleBorder(
                side: BorderSide(
                  width: isSelected ? 3 : 1,
                  color: isSelected
                      ? const Color(0xFF1DB691)
                      : const Color(0xFFD9D9D9),
                ),
                borderRadius: BorderRadius.circular(10),
              ),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      '세트 ${widget.setNum}',
                      style: Palette.pretendard(
                        context,
                        const Color(0xFF767676),
                        14,
                        FontWeight.w400,
                        1.4,
                        -0.35,
                      ),
                    ),
                    Row(
                      children: [
                        Text(
                          widget.setTitle,
                          style: Palette.pretendard(
                            context,
                            const Color(0xFF404040),
                            18,
                            FontWeight.w600,
                            1.4,
                            -0.45,
                          ),
                        ),
                        SizedBox(
                          width: 6.w,
                        ),
                        Padding(
                          padding: EdgeInsets.only(
                            top: 3.h,
                          ),
                          child: Obx(() {
                            return Icon(
                              controller.learningSetList[widget.index]
                                          .isLearningSetCompleted ==
                                      true
                                  ? Icons.check_circle
                                  : Icons.check_circle_outline,
                              color: controller.learningSetList[widget.index]
                                          .isLearningSetCompleted ==
                                      true
                                  ? Palette.buttonColorGreen
                                  : const Color(0xffA2A2A2),
                            );
                          }),
                        ),
                      ],
                    ),
                  ],
                ),
                IconButton(
                  icon: Icon(
                    isSelected
                        ? Icons.keyboard_arrow_up
                        : Icons.keyboard_arrow_down,
                  ),
                  onPressed: () {
                    controller.toggleItemSelection(widget.index);
                  },
                ),
              ],
            ),
          ),
          SizedBox(
            height: 8.h,
          ),
          if (isSelected) ...[
            SizedBox(
              height: 8.h,
            ),
            GestureDetector(
              onTap: () {
                controller.clickedLearningConcept(
                    learningSet!.id!, learningSet.name!);
              },
              child: Container(
                width: 332.w,
                height: 58.h,
                padding: EdgeInsets.symmetric(horizontal: 21.w, vertical: 18.h),
                decoration: ShapeDecoration(
                  color: const Color(0xFFF2F3F5),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      '개념학습',
                      style: Palette.pretendard(
                        context,
                        const Color(0xFF404040),
                        16,
                        FontWeight.w600,
                        1.4,
                        -0.4,
                      ),
                    ),
                    Obx(() {
                      return Icon(
                        controller.learningSetList[widget.index]
                                    .isConceptCompleted ==
                                true
                            ? Icons.check_circle
                            : Icons.check_circle_outline,
                        color: controller.learningSetList[widget.index]
                                    .isConceptCompleted ==
                                true
                            ? Palette.buttonColorGreen
                            : const Color(0xffa2a2a2),
                      );
                    }),
                  ],
                ),
              ),
            ),
            SizedBox(
              height: 8.h,
            ),
            GestureDetector(
              onTap: () {
                controller.clickedQuiz(learningSet!.id!, learningSet.name!);
              },
              child: Container(
                width: 332.w,
                height: 58.h,
                padding: EdgeInsets.symmetric(horizontal: 21.w, vertical: 18.h),
                decoration: ShapeDecoration(
                  color: const Color(0xFFF2F3F5),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      '퀴즈풀기',
                      style: Palette.pretendard(
                        context,
                        const Color(0xFF404040),
                        16,
                        FontWeight.w600,
                        1.4,
                        -0.4,
                      ),
                    ),
                    Obx(() {
                      return Icon(
                        controller.learningSetList[widget.index]
                                    .isQuizCompleted ==
                                true
                            ? Icons.check_circle
                            : Icons.check_circle_outline,
                        color: controller.learningSetList[widget.index]
                                    .isQuizCompleted ==
                                true
                            ? Palette.buttonColorGreen
                            : const Color(0xffa2a2a2),
                      );
                    }),
                  ],
                ),
              ),
            ),
          ],
        ],
      );
    });
  }
}
