import 'package:economic_fe/data/models/learning_list_model.dart';
import 'package:economic_fe/data/services/remote_data_source.dart';
import 'package:economic_fe/view_model/quiz/level_select_controller.dart';
import 'package:economic_fe/view_model/quiz/quiz_test_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class LearningListController extends GetxController {
  final remoteDataSource = RemoteDataSource();

  // 학습 세트 목록
  var learningSetList = <LearningListModel>[].obs;

  // 데이터 로딩 여부
  var isLoading = false.obs;

  // @override
  // void onInit() {
  //   super.onInit();
  //   // fetchLearningSetList();
  // }

  // 학습 세트 목록을 불러오는 메서드
  Future<void> fetchLearningSetList() async {
    try {
      isLoading.value = true;

      dynamic response = await remoteDataSource.fetchLearningList();

      if (response != null && response is List) {
        // List<Map<String, dynamic>> 형태로 변환
        List<Map<String, dynamic>> learningSetData =
            response.cast<Map<String, dynamic>>();

        // 변환된 데이터를 LearningListModel 리스트로 변환하여 저장
        var learningSets = learningSetData
            .map((learningSet) => LearningListModel.fromJson(learningSet))
            .toList();
        learningSetList.assignAll(learningSets);
      } else {
        debugPrint("학습 세트 목록 조회 실패: ${response?["message"]}");
      }
    } catch (e) {
      debugPrint("Error: $e");
    } finally {
      isLoading.value = false; // 로딩 종료
    }
  }

  // //각 아이템의 퀴즈, 개념학습 수행 여부
  // var learningState = {
  //   0: [false, false],
  //   1: [false, false],
  //   2: [false, false],
  //   3: [false, false],
  //   4: [false, false],
  //   5: [false, false],
  //   6: [false, false],
  //   7: [false, false],
  //   8: [false, false],
  //   9: [false, false],
  //   10: [false, false],
  // }.obs;
  // 각 아이템의 클릭 여부를 저장할 상태 변수
  var selectedItemIndex = (-1).obs; // 초기값으로 -1을 설정하여 아무 것도 선택되지 않음을 나타냄

  // 아이템 클릭 시 선택된 아이템의 인덱스를 업데이트
  void toggleItemSelection(int index) {
    if (selectedItemIndex.value == index) {
      selectedItemIndex.value = -1; // 다시 선택을 취소하면 -1로 초기화
    } else {
      selectedItemIndex.value = index; // 선택된 아이템의 인덱스를 저장
    }
  }

  // 홈화면으로 전환
  void navigateToHome(BuildContext context) {
    Get.offNamed('/home');
  }

  void clickedLearningConcept(int learningSetId, String name) {
    Get.toNamed(
      '/learning_list/level_select',
      arguments: {
        "learningSetId": learningSetId,
        "name": name,
        "mode": "concept",
      },
    );
  }

  void clickedQuiz(int learningSetId, String name) {
    Get.delete<QuizTestController>();
    Get.delete<LevelSelectController>();
    Get.toNamed(
      '/learning_list/level_select',
      arguments: {
        "learningSetId": learningSetId,
        "name": name,
        "mode": "quiz",
      },
    );
  }

  // 챗봇 화면으로 전환
  void toChatbot() {
    Get.toNamed('/chatbot');
  }

  // Future<List<LearningModel>> getLearningConcept(
  //     int learningSetId, String level) async {
  //   try {
  //     print("start");

  //     dynamic response;

  //     response =
  //         await remoteDataSource.getLearningConcept(learningSetId, level);

  //     print("response :: $response");

  //     final data = response as Map<String, dynamic>;
  //     final conceptList = data['results']['conceptList'] as List;

  //     print("conceptList ::: $conceptList");

  //     return conceptList
  //         .map((concept) => LearningModel.fromJson(concept))
  //         .toList();
  //   } catch (e) {
  //     debugPrint('Error: $e');
  //     return [];
  //   }
  // }

  // Future<List<LearningListModel>> postLearningSet() async {
  //   try {
  //     print("start");

  //     dynamic response;
  //     response = await remoteDataSource.postLearningSet();

  //     print("learning set : $response");

  //     final data = response as Map<String, dynamic>;
  //     final learningList = data['results']['learningSetPreviewList'] as List;

  //     // print(learningList);
  //     return learningList
  //         .map((learningSet) => LearningListModel.fromJson(learningSet))
  //         .toList();
  //   } catch (e) {
  //     debugPrint("Error : $e");
  //     return [];
  //   }
  // }
}
