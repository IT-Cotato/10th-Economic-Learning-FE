import 'package:economic_fe/data/models/level_test/level_test_answer_model.dart';
import 'package:economic_fe/data/models/level_test/level_test_model.dart';
import 'package:economic_fe/data/services/remote_data_source.dart';
import 'package:economic_fe/view_model/test/anonymous_key_controller.dart';
import 'package:economic_fe/view_model/test/level_test_test_controller.dart';
import 'package:flutter/widgets.dart';
import 'package:get/get.dart';
import 'package:flutter/material.dart';

class TestController extends GetxController {
  late BuildContext context;
  static TestController get to => Get.find();
  String? anonymousKey; // 레벨테스트 세션 키

  //레벨테스트 answer
  List<LevelTestAnswerModel> levelTestAnswerModel = [];

  void getStats() {
    print("Stats initialized!");
  }

  bool isFromHome = false;

  @override
  void onInit() {
    super.onInit();
    final args = Get.arguments as Map<String, dynamic>?;
    isFromHome = args?['fromHome'] ?? false;
  }

  void test(BuildContext context) async {
    try {
      final List<QuizModel> quizList = await getLevelTest();

      if (Get.isRegistered<LevelTestTestController>()) {
        final testController = Get.find<LevelTestTestController>();
        testController.resetTest();
      }

      Get.toNamed(
        'test/test',
        arguments: {
          'quizList': quizList,
          'fromHome': isFromHome,
        },
      );
    } catch (e) {
      Get.snackbar("에러", "퀴즈를 불러오지 못했습니다");
      debugPrint("에러 발생: $e");
    }
  }

  void setAnonymousKey(String key) {
    anonymousKey = key;
  }

  void clickedTestBtn(BuildContext context) async {
    // Get.toNamed('/test');
    try {
      print("레벨 테스트 시작");

      final List<QuizModel> quizList = await getLevelTest();

      if (quizList.isEmpty) {
        Get.snackbar("오류", "퀴즈 데이터를 가져오지 못했습니다");
        return;
      }

      final int choiceCount = quizList.first.choiceList.length;

      // 선택지 개수가 3개 이상
      // 객관식 퀴즈 페이지로 이동
      if (choiceCount == 2) {
        Get.toNamed('test/ox', arguments: {
          "quizList": quizList,
          "index": 0,
          // "answer": levelTestAnswerModel
        });
      } else {
        Get.toNamed('/test/multi', arguments: {
          "quizList": quizList,
          "index": 0,
          // "answer": levelTestAnswerModel
        });
      }
    } catch (e) {
      Get.snackbar("에러", "퀴즈를 불러오지 못했습니다");
      debugPrint("에러 발생: $e");
    }
  }

  void clickedTestMultiBtn(BuildContext context) {
    Get.toNamed('/test/multi');
  }

  void clickedAfterBtn() {
    if (isFromHome) {
      Get.toNamed('/home');
    } else {
      Get.toNamed('/login/skip');
    }
  }

  Future<List<QuizModel>> getLevelTest() async {
    try {
      print("start");
      dynamic response = await RemoteDataSource.getLevelTest();

      print("response ::: $response");

      final data = response as Map<String, dynamic>;
      final anonKeyController =
          Get.put(AnonymousKeyController(), permanent: true);
      anonKeyController.setKey(data['results']['anonymousKey']);
      final quizList = data['results']['quizzes'] as List;
      return quizList.map((quiz) => QuizModel.fromJson(quiz)).toList();
    } catch (e) {
      debugPrint('Error: $e');
      return [];
    }
  }
}
