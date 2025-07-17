import 'package:economic_fe/data/services/remote_data_source.dart';
import 'package:economic_fe/view/screens/finish_page.dart';
import 'package:flutter/widgets.dart';
import 'package:get/get.dart';
import 'package:flutter/material.dart';

class QuizController extends GetxController {
  late BuildContext context;
  static QuizController get to => Get.find();

  var isCorrect = true.obs;
  var explanation = "".obs;
  final remoteDataSource = RemoteDataSource();

  void getStats() {
    // 통계 데이터 로드 또는 초기화 작업
    print("Stats initialized!");
  }

  void clickedTestBtn(BuildContext context) {
    Get.toNamed('/home/learning_list/level_select/quiz');
  }

  void clickedTestMultiBtn(BuildContext context) {
    Get.toNamed('/test/ox');
  }

  void clickedAfterBtn(BuildContext context) {
    // context.go('/login');
    Get.toNamed('/login');
  }

  // 레벨테스트 종료 버튼 클릭
  void finishLeveltest() {
    Get.toNamed('/leveltest_result');
  }

  // 퀴즈 종료 버튼 클릭
  void finishQuiz() {
    Get.to(() => const FinishPage(), arguments: {
      'contents': '퀴즈 주제',
      'number': 1,
      'category': 1,
      'level': '초급',
    });
  }

  // 선택된 옵션을 관리하는 상태
  var selectedOption = Rx<int>(-1); // 선택된 옵션 (null은 선택 안 됨)

  // "다음 문제" 버튼 활성화 여부
  bool get isNextButtonEnabled => selectedOption.value != -1;

  // (퀴즈의 경우) 확인 버튼 클릭 여부
  Rx<bool> clickCheckBtn = false.obs;

  // (퀴즈의 경우) 정답 여부 (1: 정답, 2: 오답)
  Rx<int> isCorrectAnswer = 0.obs;

  // (퀴즈의 경우) 북마크 상태를 관리하는 변수
  Rx<bool> isBookmarked = false.obs;

  // (퀴즈의 경우) 해설 보기 버튼 클릭 여부
  Rx<bool> viewDescription = false.obs;

  // 선택지 변경 시 호출되는 메서드
  void selectOption(int index) {
    // 이미 선택된 옵션을 변경
    selectedOption.value = index;
  }

  // // 선택된 옵션을 리셋하는 메서드 (필요 시)
  // void resetOption() {
  //   selectedOption.value = -1;
  // }

  // 퀴즈 한 문제 풀고 바로 제출
  Future<void> postSubmitQuiz(int quizId, int answerIndex, bool retry) async {
    try {
      print("start quizIddd : $quizId, $answerIndex");
      dynamic response = retry
          ? await remoteDataSource.postSubmitQuizRetry(quizId, answerIndex)
          : await remoteDataSource.postSubmitQuiz(quizId, answerIndex);
      final data = response as Map<String, dynamic>;
      isCorrect.value = data['results']['isCorrect'];
      explanation.value = data['results']['explanation'];
      print("result : ${isCorrect.value}, $explanation");
    } catch (e) {
      debugPrint('Error: $e');
    }
  }

  // 퀴즈 스크랩
  Future<void> postScrapQuiz(int quizId) async {
    try {
      print("start");
      dynamic response = await remoteDataSource.postScrapQuiz(quizId);
      print("response scrap isSuccess : ${response['isSuccess']}");
    } catch (e) {
      debugPrint('post Scrap Error: $e');
    }
  }

  // 퀴즈 스크랩 취소
  Future<void> postScrapDeleteQuiz(int quizId) async {
    try {
      print("start");
      dynamic response = await remoteDataSource.postScrapDeleteQuiz(quizId);
      print("response delete isSuccess : ${response['isSuccess']}");
    } catch (e) {
      debugPrint('post Scrap Delete Error: $e');
    }
  }

  // 퀴즈 완료 (한 세트 다 풀고 끝)
  Future<void> postQuizFinish(int learningSetId, String level) async {
    try {
      print("start");

      dynamic response =
          await remoteDataSource.postQuizFinish(learningSetId, level);

      print("response quizFinish isSuccess : ${response['isSuccess']}");
      Get.toNamed('/learning_list/level_select');
      // Navigator.pop(context);
    } catch (e) {
      debugPrint('post quizFinish Error: $e');
    }
  }
}
