import 'package:economic_fe/view/theme/palette.dart';
import 'package:economic_fe/view/widgets/custom_button.dart';
import 'package:economic_fe/view/widgets/custom_button_unfilled.dart';
import 'package:economic_fe/view/widgets/custom_app_bar.dart';
import 'package:economic_fe/view/widgets/profile_setting/select_button_wrap.dart';
import 'package:economic_fe/view_model/profile_setting/job_select_controller.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

class JobSelectPage extends StatelessWidget {
  const JobSelectPage({super.key});

  @override
  Widget build(BuildContext context) {
    final JobSelectController controller = Get.put(JobSelectController());

    return Scaffold(
      backgroundColor: Palette.background,
      appBar: CustomAppBar(
        title: '업종/직무',
        onPress: () {
          controller.navigateToProfileSetting();
        },
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
                      '업종',
                      style: Palette.pretendard(
                        context,
                        const Color(0xff111111),
                        20.sp,
                        FontWeight.w500,
                        1.5,
                        -0.5,
                      ),
                    ),
                    SizedBox(height: 16.h),
                    // ✅ Wrap 바로 사용 (width 제한 X)
                    const SelectableButtonWrap(subject: 'job'),
                    SizedBox(height: 24.h),
                  ],
                ),
              ),
            ),
            Padding(
              padding: EdgeInsets.fromLTRB(16.w, 0, 16.w, 24.h),
              child: Obx(() {
                final isEnabled = controller.selectedJob.value != null;
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
}
