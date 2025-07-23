import 'package:economic_fe/view/theme/palette.dart';
import 'package:economic_fe/view/widgets/custom_button.dart';
import 'package:economic_fe/view/widgets/custom_button_unfilled.dart';
import 'package:economic_fe/view/widgets/custom_app_bar.dart';
import 'package:economic_fe/view/widgets/profile_setting/select_button_wrap.dart';
import 'package:economic_fe/view_model/profile_setting/part_select_controller.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

class PartSelectPage extends StatelessWidget {
  const PartSelectPage({super.key});

  @override
  Widget build(BuildContext context) {
    final PartSelectController controller = Get.put(PartSelectController());

    return Scaffold(
      backgroundColor: Palette.background,
      appBar: CustomAppBar(
        title: '업종/직무',
        onPress: controller.navigateToProfileSetting,
        icon: Icons.close,
      ),
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: SingleChildScrollView(
                padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 20.h),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      '직무',
                      style: Palette.pretendard(
                        context,
                        const Color(0xff111111),
                        20.sp,
                        FontWeight.w500,
                        1.5,
                        -0.5,
                      ),
                    ),
                    SizedBox(height: 20.h),

                    /// 각 직무 분류 그룹
                    _buildJobPartCategory(context, '[전문직]', 1),
                    _buildJobPartCategory(context, '[기업/사무직]', 2),
                    _buildJobPartCategory(context, '[IT/기술직]', 3),
                    _buildJobPartCategory(context, '[서비스/창업]', 4),
                    _buildJobPartCategory(context, '[기타]', 5),

                    SizedBox(height: 32.h),
                  ],
                ),
              ),
            ),

            /// 저장 버튼
            Padding(
              padding: EdgeInsets.fromLTRB(16.w, 0, 16.w, 24.h),
              child: Obx(() {
                final isEnabled = controller.selectedPart.value != null;
                return isEnabled
                    ? CustomButton(
                        text: '저장하기',
                        onPress: () {
                          controller.onSaveButtonClicked();
                          controller.navigateToProfileSetting();
                        },
                        bgColor: Palette.buttonColorBlue,
                      )
                    : CustomButtonUnfilled(
                        text: '저장하기',
                        onPress: () {},
                      );
              }),
            ),
          ],
        ),
      ),
    );
  }

  /// 직무 분류 텍스트 + 버튼 그룹 위젯
  Widget _buildJobPartCategory(
      BuildContext context, String title, int partType) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: Palette.pretendard(
            context,
            const Color(0xFF767676),
            16.sp,
            FontWeight.w500,
            1.5,
            -0.4,
          ),
        ),
        SizedBox(height: 8.h),
        SelectableButtonWrap(subject: 'part', partType: partType),
        SizedBox(height: 16.h),
      ],
    );
  }
}
