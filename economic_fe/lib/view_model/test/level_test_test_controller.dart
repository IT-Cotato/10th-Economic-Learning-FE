import 'package:economic_fe/data/models/level_test/level_test_answer_model.dart';
import 'package:economic_fe/data/models/level_test/level_test_model.dart';
import 'package:economic_fe/data/services/remote_data_source.dart';
import 'package:economic_fe/data/storage/level_test_storage.dart';
import 'package:economic_fe/view_model/test/anonymous_key_controller.dart';
import 'package:flutter/widgets.dart';
import 'package:get/get.dart';
import 'package:flutter/material.dart';

class LevelTestTestController extends GetxController {
  late BuildContext context;
  final remoteDataSource = RemoteDataSource();
  LevelTestTestController get to => Get.find();

  bool isFromHome = false;

  void setFromHome(bool value) {
    isFromHome = value;
  }

  // 레벨테스트 사용자 답
  var levelTestAnswers = <LevelTestAnswerModel>[].obs;

  // 현재 학습 문제 번호
  var currentQuizIdx = 0.obs;

  // 학습 중단 확인창 표시 여부 관리
  var isModalVisible = false.obs;

  void showModal() {
    isModalVisible.value = true;
  }

  void hideModal() {
    isModalVisible.value = false;
  }

  void getStats() {
    print("Stats initialized!");
  }

  // Future<List<QuizModel>> getLevelTest() async {
  //   try {
  //     print("start");
  //     dynamic response = await RemoteDataSource.getLevelTest();

  //     final data = response as Map<String, dynamic>;
  //     final quizList = data['results']['quizList'] as List;
  //     return quizList.map((quiz) => QuizModel.fromJson(quiz)).toList();
  //   } catch (e) {
  //     debugPrint('Error: $e');
  //     return [];
  //   }
  // }

  void clickedFinishBtn() async {
    // 아래 형태로 보내면 됨
    List<Map<String, dynamic>> answersJson =
        levelTestAnswers.map((e) => e.toJson()).toList();

    try {
      print("start");

      final anonKeyController = Get.find<AnonymousKeyController>();
      final anonymousKey = anonKeyController.key;

      dynamic response = await remoteDataSource.postLevelTestResult(
        answersJson: answersJson,
        anonymousKey: anonymousKey,
      );

      print("response : $response");
    } catch (e) {
      debugPrint("error : $e");
    }
  }

  // 카카오 로그인
  void clickedToKakao(List<QuizModel> quizList) async {
    final answers = levelTestAnswers.toList();
    await LevelTestStorage.saveLevelTestData(answers, quizList);

    if (isFromHome) {
      // 바로 약관 없이 결과 화면으로
      final anonKeyController = Get.find<AnonymousKeyController>();
      final anonymousKey = anonKeyController.key;

      try {
        final response = await remoteDataSource.postLevelTestResult(
          answersJson: answers.map((e) => e.toJson()).toList(),
          anonymousKey: anonymousKey,
        );

        await LevelTestStorage.clear();

        Get.toNamed(
          '/leveltest_result',
          arguments: {
            'response': response,
            'answer': answers,
            'quizList': quizList,
            'fromHome': true,
          },
        );
      } catch (e) {
        debugPrint("레벨테스트 결과 전송 오류: $e");
      }
    } else {
      // 기존 플로우: 로그인 → 약관 동의 → 결과
      Get.toNamed('/login');
    }
  }

  void quitLevelTest() {
    Get.toNamed('/test');
  }

  void resetTest() {
    levelTestAnswers.clear();
    currentQuizIdx.value = 0;
    isModalVisible.value = false;
    quitLevelTest();
  }
}
