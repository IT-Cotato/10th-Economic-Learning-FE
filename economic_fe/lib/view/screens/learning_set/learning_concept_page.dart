import 'package:economic_fe/view/theme/palette.dart';
import 'package:economic_fe/view/widgets/chatbot_fab.dart';
import 'package:economic_fe/view/widgets/custom_app_bar.dart';
import 'package:economic_fe/view/widgets/custom_snack_bar.dart';
import 'package:economic_fe/view/widgets/learning_set/explanation_text.dart';
import 'package:economic_fe/view/widgets/stop_option_modal.dart';
import 'package:economic_fe/view_model/learning_set/learning_concept_controller.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

class LearningConceptPage extends StatefulWidget {
  const LearningConceptPage({super.key});

  @override
  State<LearningConceptPage> createState() => _LearningConceptPageState();
}

class _LearningConceptPageState extends State<LearningConceptPage> {
  final LearningConceptController controller =
      Get.put(LearningConceptController());

  final ValueNotifier<int> currentIndexNotifier = ValueNotifier(1);
  final ValueNotifier<int> totalIndexNotifier = ValueNotifier(1);

  @override
  void initState() {
    super.initState();

    /// 개념 학습 데이터 변경 시 UI 업데이트
    controller.conceptList.listen((concepts) {
      totalIndexNotifier.value = concepts.length;
      currentIndexNotifier.value = controller.currentStepIdx.value + 1;
    });

    controller.currentStepIdx.listen((index) {
      currentIndexNotifier.value = index + 1;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Palette.background,
      appBar: CustomAppBar(
        title: controller.conceptName.value,
        icon: Icons.close,
        onPress: controller.showModal,
        currentIndexNotifier: currentIndexNotifier, // ValueNotifier 전달
        totalIndexNotifier: totalIndexNotifier, // ValueNotifier 전달
      ),
      body: Obx(() {
        if (controller.isLoading.value) {
          return const Center(child: CircularProgressIndicator());
        }

        if (controller.conceptList.isEmpty) {
          return const Center(child: Text('개념 학습 데이터가 없습니다.'));
        }

        final concept = controller.conceptList[controller.currentStepIdx.value];

        return Stack(
          children: [
            Padding(
              padding: EdgeInsets.only(bottom: 65.h),
              child: SizedBox(
                height: MediaQuery.of(context).size.height, // 화면 높이의 90%,
                child: SingleChildScrollView(
                  physics: const BouncingScrollPhysics(),
                  child: Center(
                    child: Container(
                      padding: EdgeInsets.only(top: 18.h),
                      width: MediaQuery.of(context).size.width *
                          0.8.w, // 화면 너비의 90%

                      child: Column(
                        mainAxisSize:
                            MainAxisSize.min, // Column이 부모의 크기를 채우도록 설정
                        children: [
                          Container(
                            padding: EdgeInsets.symmetric(vertical: 10.h),
                            decoration: const BoxDecoration(
                              color: Color(0xFF1EB692), // 컨테이너 배경색
                              borderRadius: BorderRadius.only(
                                topLeft: Radius.circular(10.0), // 왼쪽 위 둥글게
                                topRight: Radius.circular(10.0), // 오른쪽 위 둥글게
                                // 아래쪽은 둥글게 하지 않음
                              ),
                              // border: Border
                            ),
                            alignment: Alignment.center,
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Obx(
                                  () => Text(
                                    controller.levelOptions[
                                        controller.selectedLevelIndex.value],
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 16.sp,
                                      fontWeight: FontWeight.w500,
                                      height: 1.4,
                                      letterSpacing: -0.4,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          Container(
                            decoration: BoxDecoration(
                              color: const Color.fromARGB(
                                  255, 255, 255, 255), // 컨테이너 배경색
                              borderRadius: const BorderRadius.only(
                                bottomLeft: Radius.circular(10.0), // 왼쪽 위 둥글게
                                bottomRight: Radius.circular(10.0), // 오른쪽 위 둥글게
                                // 아래쪽은 둥글게 하지 않음
                              ),
                              border: Border(
                                top: BorderSide.none, // 윗변 테두리 없음
                                left: BorderSide(
                                  color: const Color(0xFFA2A2A2), // 테두리 두께
                                  width: 1.0.w,
                                ),
                                right: BorderSide(
                                  color: const Color(0xFFA2A2A2), // 오른쪽 테두리 색상
                                  width: 1.0.w, // 테두리 두께
                                ),
                                bottom: BorderSide(
                                  color: const Color(0xFFA2A2A2), // 아랫변 테두리 색상
                                  width: 1.0.w, // 테두리 두께
                                ),
                              ),
                            ),
                            alignment: Alignment.topLeft,
                            padding: EdgeInsets.only(
                              left: 20.w,
                              right: 20.w,
                              top: 24.h,
                              bottom: 24.h,
                            ),
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Row(
                                  children: [
                                    Text(
                                      concept["name"],
                                      style: TextStyle(
                                        fontSize: 16.sp,
                                        fontWeight: FontWeight.w500,
                                        height: 1.4,
                                        letterSpacing: -0.4,
                                      ),
                                    ),
                                    SizedBox(
                                      width: 11.w,
                                    ),
                                    Obx(() {
                                      final conceptId = controller.conceptList[
                                              controller.currentStepIdx.value]
                                          ["conceptId"];
                                      final isScrapped = controller
                                          .isConceptScrapped(conceptId);

                                      return GestureDetector(
                                        onTap: () async {
                                          bool? wasScrapped = await controller
                                              .toggleScrapConcept(
                                                  conceptId, context);
                                          if (wasScrapped != null) {
                                            CustomSnackBar.show(
                                              context: context,
                                              message: wasScrapped
                                                  ? '개념 학습을 스크랩했어요'
                                                  : '스크랩을 취소했어요',
                                            );
                                          }
                                        },
                                        child: Image.asset(
                                          isScrapped
                                              ? "assets/bookmark_selected.png"
                                              : "assets/bookmark.png",
                                          width: 13.w,
                                        ),
                                      );
                                    }),
                                  ],
                                ),
                                SizedBox(
                                  height: 16.h,
                                ),
                                Image.asset(
                                  // 예시 이미지
                                  "assets/example.png",
                                  fit: BoxFit.cover,
                                  width:
                                      MediaQuery.of(context).size.width - 72.w,
                                ),
                                SizedBox(
                                  height: 22.h,
                                ),
                                ExplanationText(
                                    explanation: concept["explanation"]),
                              ],
                            ),
                          ),
                          SizedBox(
                            height: 50.h,
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ),
            Positioned(
              bottom: 110.h,
              right: 10.w,
              child: ChatbotFAB(
                onTap: () => controller.toChatbot(),
              ),
            ),
            Positioned(
              bottom: 0,
              left: 0,
              right: 0,
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.white, // 배경 색상을 decoration에 포함
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black
                          .withOpacity(0.1), // rgba(0, 0, 0, 0.10) 변환
                      blurRadius: 15.0, // 그림자의 흐림 정도
                      offset: const Offset(0, -2), // 0px x, -2px y (위로 2px 이동)
                    ),
                  ],
                ),
                padding: EdgeInsets.only(
                    left: 16.0.w, right: 16.0.w, bottom: 30.h, top: 16.h),
                // color: Colors.white, // 배경 색상
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    ElevatedButton(
                      onPressed: () {
                        controller.prevConcept();
                      },
                      style: ElevatedButton.styleFrom(
                        minimumSize: Size(150.w, 50.h), // 버튼 크기 동일하게 설정
                        backgroundColor: controller.currentStepIdx.value != 0
                            ? const Color(0xFF1EB692)
                            : const Color(0xFFF2F3F5), // 버튼 색상
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                      child: Text(
                        "이전",
                        style: TextStyle(
                          color: controller.currentStepIdx.value != 0
                              ? Colors.white
                              : const Color(0xFFA2A2A2),
                          fontSize: 18.sp,
                          fontWeight: FontWeight.w500,
                          height: 1.4,
                          letterSpacing: -0.45,
                        ),
                      ),
                    ),
                    SizedBox(
                      width: 15.w,
                    ),
                    ElevatedButton(
                      onPressed: () {
                        controller.currentStepIdx.value !=
                                controller.conceptList.length - 1
                            ? controller.nextConcept()
                            : controller.completeLearningSet();
                      },
                      style: ElevatedButton.styleFrom(
                        minimumSize: Size(150.w, 50.h), // 동일한 크기로 설정
                        backgroundColor: controller.currentStepIdx.value !=
                                controller.conceptList.length - 1
                            ? Palette.buttonColorGreen
                            : const Color(0xFF00D6D6), // 버튼 색상
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                      child: Obx(() {
                        return Text(
                          controller.currentStepIdx.value !=
                                  controller.conceptList.length - 1
                              ? "다음"
                              : "학습완료",
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 18.sp,
                            fontWeight: FontWeight.w500,
                            height: 1.4,
                            letterSpacing: -0.45,
                          ),
                        );
                      }),
                    ),
                  ],
                ),
              ),
            ),
            // 모달창
            Obx(() {
              return controller.isModalVisible.value
                  ? StopOptionModal(
                      closeModal: () => controller.hideModal(),
                      contents: '정말 학습을 중단하시겠어요?',
                      keepBtnText: '계속할래요',
                      stopBtnText: '그만할래요',
                      keepFunc: () => controller.hideModal(),
                      stopFunc: () => controller.clickedCloseBtn(),
                    )
                  : const SizedBox();
            }),
          ],
        );
      }),
    );
  }
}
