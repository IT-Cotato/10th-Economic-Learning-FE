import 'package:economic_fe/data/models/article_model.dart';
import 'package:economic_fe/data/models/community/post_model.dart';
import 'package:economic_fe/data/models/user_profile.dart';
import 'package:economic_fe/data/services/remote_data_source.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart'; // GoRouter import

class HomeController extends GetxController with WidgetsBindingObserver {
  final remoteDataSource = RemoteDataSource();

  var currentStreak = 0.obs; // 연속 출석 날짜
  var isLevelTestCompleted = false.obs; // 레벨테스트 완료 여부

  var isClickedToolTip = false.obs; // 툴팁 클릭 여부

  // 진도율 가시성 관리 (레벨테스트 진행 여부에 따른 로직으로 수정 필요)
  var isProgressContainerVisible = false.obs;

  // 오늘의 퀘스트 툴팁 클릭
  void clickToolTip() {
    isClickedToolTip = true.obs;
  }

  // 레벨테스트 시작 화면으로
  void toLevelTest() {
    Get.toNamed('/test');
  }

  // 전체 학습 세트 목록 화면으로 전환
  void navigateToLearningList() {
    Get.offNamed('/learning_list');
  }

  // 목표 선택 다이얼로그 표시 상태 관리
  var isDialogVisible = false.obs;

  void showGoalDialog() {
    isDialogVisible.value = true;
  }

  void hideGoalDialog() {
    isDialogVisible.value = false;
  }

  // 오늘의 퀘스트 목표 세트 수 (임시)
  var goalSets = <int>[1, 1, 1].obs;
  var tempGoalSets = <int>[].obs;
  final maxGoalSets = 3;
  final minGoalSets = 1;

  // 오늘의 퀘스트 진행률
  var conceptProgress = 0.0.obs; // 개념 학습
  var quizProgress = 0.0.obs; // 퀴즈
  var articleProgress = 0.0.obs; // 경제 기사

  // 경제 기사
  var articles = <ArticleModel>[].obs;
  var isLoading = true.obs;

  // 오늘의 경제톡톡 주제
  RxMap<String, dynamic> todaysTokDetail = <String, dynamic>{}.obs;
  // 오늘의 경제톡톡 참여자 프로필 리스트
  RxList<String> participantProfileImages = <String>[].obs;

  // 인기 게시물 목록
  RxList<PostModel> popularPosts = <PostModel>[].obs;

  void minusTempGoalSets(int index) {
    if (tempGoalSets[index] > minGoalSets) {
      tempGoalSets[index]--;
    }
  }

  void plusTempGoalSets(int index) {
    if (tempGoalSets[index] < maxGoalSets) {
      tempGoalSets[index]++;
    }
  }

  void saveGoalSets() {
    goalSets.assignAll(tempGoalSets);
    goalSets.refresh();
  }

  void resetGoalSets() {
    tempGoalSets.assignAll(goalSets);
    tempGoalSets.refresh();
  }

  // 진도율 (초기값은 0)
  RxDouble beginnerProgress = 0.0.obs;
  RxDouble intermediateProgress = 0.0.obs;
  RxDouble advancedProgress = 0.0.obs;

  // 최대 그래프 높이
  final double maxHeight = 120.0;

  @override
  void onInit() {
    super.onInit();
    WidgetsBinding.instance.addObserver(this);
    fetchAllHomeData();
  }

  @override
  void onClose() {
    WidgetsBinding.instance.removeObserver(this);
    super.onClose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    // 앱이 포그라운드로 복귀했을 때 홈 데이터 다시 불러오기
    if (state == AppLifecycleState.resumed) {
      fetchAllHomeData();
    }
  }

  void fetchAllHomeData() {
    fetchProgress();
    fetchUserGoal();
    fetchCurrentStreak();
    getNewsList(0, "RECENT", null);
    fetchTodaysTok();
    getPopularPosts();
    fetchUserProfile();
    fetchTodayQuestProgress();
  }

  /// 사용자 정보 조회 (레벨테스트 진행 여부 확인)
  Future<void> fetchUserProfile() async {
    try {
      var response = await remoteDataSource.fetchUserInfo(null);

      if (response.isNotEmpty) {
        // `UserProfile` 모델을 통해 안전하게 변환
        UserProfile userProfile = UserProfile.fromJson(response);

        // 레벨테스트 완료 여부 업데이트
        isLevelTestCompleted.value = userProfile.isLevelTestCompleted ?? false;
        debugPrint("레벨테스트 진행 여부: ${isLevelTestCompleted.value}");

        // UI 업데이트
        isProgressContainerVisible.value = isLevelTestCompleted.value;
      } else {
        debugPrint("사용자 정보 조회 실패: 응답이 비어 있음");
      }
    } catch (e) {
      debugPrint("fetchUserProfile() 오류 발생: $e");
    }
  }

  // 연속 출석 날짜 조회
  Future<void> fetchCurrentStreak() async {
    try {
      var response = await remoteDataSource.fetchCurrentStreak();
      currentStreak.value = response;
    } catch (e) {
      debugPrint("fetchCurrentStreak() 오류 발생: $e");
      currentStreak.value = 0; // 오류 발생 시 기본값 설정
    }
  }

  /// 레벨별 학습 진도율 조회
  Future<void> fetchProgress() async {
    try {
      final response = await remoteDataSource.getProgress();

      if (response != null && response['isSuccess'] == true) {
        final progressData = response['results']['progress'] ?? {};

        // 서버 응답 값이 존재하면 업데이트
        beginnerProgress.value = (progressData['BEGINNER'] ?? 0.0).toDouble();
        intermediateProgress.value =
            (progressData['INTERMEDIATE'] ?? 0.0).toDouble();
        advancedProgress.value = (progressData['ADVANCED'] ?? 0.0).toDouble();

        debugPrint('학습 진도율 데이터 업데이트 완료');
      } else {
        debugPrint('fetchProgress 실패: 응답이 null이거나 isSuccess가 false');
      }
    } catch (e) {
      debugPrint('fetchProgress Error: $e');
    }
  }

  /// 사용자 퀘스트 목표 조회
  Future<void> fetchUserGoal() async {
    try {
      final response = await remoteDataSource.getUserGoal();

      if (response != null) {
        goalSets[0] = response['conceptGoal'];
        goalSets[1] = response['articleGoal'];
        goalSets[2] = response['quizGoal'];

        tempGoalSets.assignAll(goalSets);

        debugPrint('사용자 퀘스트 목표 데이터 업데이트 완료');
      } else {
        debugPrint('fetchUserGoal 실패: 응답이 null');
      }
    } catch (e) {
      debugPrint('fetchUserGoal Error: $e');
    }
  }

  /// 사용자 퀘스트 목표 수정
  Future<void> setUserGoal() async {
    var goal = {
      "conceptGoal": goalSets[0],
      "quizGoal": goalSets[2],
      "articleGoal": goalSets[1]
    };

    debugPrint("전송 데이터: $goal");

    bool success = await remoteDataSource.setUserGoal(goal);

    if (success) {
      Get.snackbar('성공', '퀘스트 목표 수정이 완료되었습니다.');
      await fetchTodayQuestProgress();
    } else {
      Get.snackbar('오류', '퀘스트 목표 수정에 실패하였습니다.');
    }
  }

  /// 오늘의 퀘스트 진행률 조회
  Future<void> fetchTodayQuestProgress() async {
    try {
      final response = await remoteDataSource.fetchTodayQuestProgress();

      if (response.isNotEmpty) {
        conceptProgress.value = response['conceptProgress'].toDouble();
        quizProgress.value = response['quizProgress'].toDouble();
        articleProgress.value = response['articleProgress'].toDouble();

        // UI 강제 업데이트
        conceptProgress.refresh();
        quizProgress.refresh();
        articleProgress.refresh();

        debugPrint(
            "오늘의 퀘스트 진행률 업데이트 완료: 개념 ${conceptProgress.value}, 기사 ${articleProgress.value}, 퀴즈 ${quizProgress.value}");
      } else {
        debugPrint("fetchTodayQuestProgress 실패: 응답이 비어 있음");
      }
    } catch (e) {
      debugPrint("fetchTodayQuestProgress() 오류 발생: $e");
    }
  }

  // 경제 기사 목록 불러오기
  Future<void> getNewsList(int page, String sort, String? category) async {
    try {
      isLoading.value = true; // 로딩 시작
      dynamic response;

      if (category != null) {
        response = await remoteDataSource.getNewsList2(page, sort, category);
      } else {
        response = await remoteDataSource.getNewsList2(page, sort, null);
      }

      final data = response as Map<String, dynamic>;
      final articleList = data['results']['newsList'] as List;

      articles.assignAll(
        articleList.map((news) => ArticleModel.fromJson(news)).toList(),
      );

      debugPrint("기사 데이터 로드 완료, 총 개수: ${articles.length}");
    } catch (e) {
      debugPrint('뉴스 리스트 불러오기 오류: $e');
    } finally {
      isLoading.value = false; // 로딩 종료
    }
  }

  /// 오늘의 경제톡톡 주제 조회
  Future<void> fetchTodaysTok() async {
    try {
      isLoading(true);
      final todaysTok = await remoteDataSource.getTodaysTok();

      if (todaysTok != null) {
        todaysTokDetail.value = todaysTok;

        // 프로필 이미지 리스트 저장
        var userProfiles = todaysTokDetail["userProfiles"] as List<dynamic>?;

        if (userProfiles != null) {
          participantProfileImages.value = userProfiles
              .map((user) => user["profileImageUrl"] as String? ?? "")
              .toList(); // .where 제거 → null도 기본 이미지로 표시
        }
      }
    } catch (e) {
      print('오늘의 경제톡톡 주제 조회 중 오류 발생: $e');
    } finally {
      isLoading(false);
    }
  }

  void toTalkDetailPage(int tokPostId) {
    Get.toNamed('/community/talk_detail', arguments: tokPostId);
  }

  // 인기 게시글 가져오기
  Future<void> getPopularPosts() async {
    try {
      isLoading.value = true; // 로딩 시작
      final response = await remoteDataSource.getPopularPosts();

      if (response != null && response["isSuccess"] == true) {
        final List<dynamic> postList =
            response["results"]["popularPostPreviewList"];

        popularPosts.value =
            postList.map((e) => PostModel.fromJson(e)).toList();
      } else {
        debugPrint("인기 게시글 불러오기 실패: ${response?["message"]}");
      }
    } catch (e) {
      debugPrint("Error fetching popular posts: $e");
    } finally {
      isLoading.value = false; // 로딩 종료
    }
  }
}
