import 'package:economic_fe/data/services/remote_data_source.dart';
import 'package:flutter/widgets.dart';
import 'package:get/get.dart';
import 'package:flutter/material.dart';

class LevelSelectController extends GetxController {
  final RemoteDataSource remoteDataSource = RemoteDataSource();

  late BuildContext context;
  static LevelSelectController get to => Get.find();

  var selectedLevel = '';
  void getStats() {
    // 통계 데이터 로드 또는 초기화 작업
    print("Stats initialized!");
  }

  var conceptName = "개념 학습".obs;
  var learningSetId = 0.obs; // 학습 세트 ID
  var mode = 'quiz'.obs;

  // 실제 완료 여부 저장용
  var levelCompletion = <String, bool>{
    'BEGINNER': false,
    'INTERMEDIATE': false,
    'ADVANCED': false,
  }.obs;

  @override
  void onInit() {
    super.onInit();

    final args = Get.arguments ?? {};
    learningSetId.value = args["learningSetId"] ?? 0;
    conceptName.value = args["name"] ?? "";
    mode.value = args["mode"] ?? "quiz";

    if (mode.value == 'quiz') {
      fetchCompletedLevels();
    }
  }

  Future<void> fetchCompletedLevels() async {
    final data =
        await remoteDataSource.fetchCompletedQuizzes(learningSetId.value);
    debugPrint("[LevelSelectController] received quiz data: $data");

    levelCompletion['BEGINNER'] = data['beginner'] ?? false;
    levelCompletion['INTERMEDIATE'] = data['intermediate'] ?? false;
    levelCompletion['ADVANCED'] = data['advanced'] ?? false;

    debugPrint("[LevelSelectController] levelCompletion 상태: $levelCompletion");
  }

  void clickedTestBtn(BuildContext context) {
    Get.toNamed('/test');
  }

  void clickedQuizBtn(
      BuildContext context, int learningSetId, String name, String level) {
    Get.toNamed(
      '/learning_list/level_select/quiz',
      arguments: {
        "learningSetId": learningSetId,
        "name": name,
        "level": level,
      },
    );
  }

  void clickedConceptBtn(
      BuildContext context, int learningSetId, String name, String level) {
    Get.toNamed(
      '/learning_list/learning_concept',
      arguments: {
        "learningSetId": learningSetId,
        "name": name,
        "level": level,
      },
    );
  }
}
