import 'package:economic_fe/data/models/level_test/level_test_answer_model.dart';
import 'package:economic_fe/data/models/level_test/level_test_model.dart';
import 'package:economic_fe/view/widgets/custom_app_bar.dart';
import 'package:economic_fe/view/widgets/quiz_card.dart';
import 'package:economic_fe/view/widgets/stop_option_modal.dart';
import 'package:economic_fe/view_model/test/level_test_test_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';

// 레벨테스트 문제 9개 전체

class LevelTestTestPage extends StatefulWidget {
  const LevelTestTestPage({super.key});

  @override
  State<LevelTestTestPage> createState() => _LevelTestTestPageState();
}

class _LevelTestTestPageState extends State<LevelTestTestPage> {
  final LevelTestTestController controller = Get.put(LevelTestTestController());
  late final List<QuizModel> quizList;
  late final bool isFromHome;

  @override
  void initState() {
    super.initState();
    final args = Get.arguments as Map<String, dynamic>?;

    quizList = (args?['quizList'] as List<QuizModel>?) ?? [];
    isFromHome = args?['fromHome'] ?? false;

    controller.setFromHome(isFromHome);
  }

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(kToolbarHeight), // 기본 높이 설정
        child: Obx(() {
          return CustomAppBar(
            title: '레벨테스트',
            icon: Icons.close,
            onPress: () => controller.showModal(),
            currentIndex: controller.currentQuizIdx.value + 1,
            totalIndex: 9,
          );
        }),
      ),
      body: Stack(
        children: [
          Obx(() {
            return Align(
                alignment: Alignment.topCenter,
                child: quizList[controller.currentQuizIdx.value]
                            .choiceList
                            .length ==
                        2
                    ? QuizCard(
                        screenHeight: screenHeight,
                        screenWidth: screenWidth,
                        onPress: () {},
                        option: 1, // ox 문제
                        question:
                            quizList[controller.currentQuizIdx.value].question,
                        isLast: !(controller.currentQuizIdx.value < 8),
                        isQuiz: false,
                        onOptionSelected: (int selected) {
                          setState(() {
                            // 선택한 답안 저장
                            controller.levelTestAnswers.add(
                              LevelTestAnswerModel(
                                quizId:
                                    quizList[controller.currentQuizIdx.value]
                                        .id,
                                answer:
                                    quizList[controller.currentQuizIdx.value]
                                        .choiceList[selected]
                                        .content, // 선택한 옵션의 ID 저장
                              ),
                            );

                            // print(
                            //     "selected answer : ${controller.levelTestAnswers}");

                            // print(
                            //     "선택한 답변 리스트: ${controller.levelTestAnswers.map((e) => e.toJson()).toList()}");
                            // print("현재 idx : ${controller.currentQuizIdx}");
                            controller.currentQuizIdx++;
                          });
                        },
                      )
                    : QuizCard(
                        screenHeight: screenHeight,
                        screenWidth: screenWidth,
                        onPress: () {},
                        option: 0,
                        answerOptions: quizList[controller.currentQuizIdx.value]
                            .choiceList
                            .map((choice) => choice.content)
                            .toList(),
                        question:
                            quizList[controller.currentQuizIdx.value].question,
                        isQuiz: false,
                        isLast: controller.currentQuizIdx.value == 8,
                        onOptionSelected: (int selected) {
                          setState(() {
                            controller.levelTestAnswers.add(
                              LevelTestAnswerModel(
                                quizId:
                                    quizList[controller.currentQuizIdx.value]
                                        .id,
                                answer:
                                    quizList[controller.currentQuizIdx.value]
                                        .choiceList[selected]
                                        .content,
                              ),
                            );

                            // print(
                            //     "selected answer : ${controller.levelTestAnswers}");
                            // print(
                            //     "선택한 답변 리스트: ${controller.levelTestAnswers.map((e) => e.toJson()).toList()}");
                            // print("현재 idx : ${controller.currentQuizIdx}");
                            controller.currentQuizIdx++;
                          });
                        },
                        onFinishTest: () => controller.clickedToKakao(quizList),
                      ));
          }),
          Obx(() {
            return controller.isModalVisible.value
                ? StopOptionModal(
                    closeModal: controller.hideModal,
                    contents: '정말 레벨테스트를 중단하시겠어요?',
                    keepBtnText: '계속할래요',
                    stopBtnText: '그만할래요',
                    keepFunc: controller.hideModal,
                    stopFunc: () {
                      controller.resetTest(); // 상태 초기화
                    },
                  )
                : const SizedBox.shrink(); // 안 보이게
          }),
        ],
      ),
    );
  }
}
