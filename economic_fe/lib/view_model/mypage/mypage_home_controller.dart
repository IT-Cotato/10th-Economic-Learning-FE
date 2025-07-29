import 'package:economic_fe/data/models/user_profile.dart';
import 'package:economic_fe/data/services/image_picker_service.dart';
import 'package:economic_fe/data/services/remote_data_source.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class MypageHomeController extends GetxController {
  static MypageHomeController get to => Get.find(); // 전역 접근 가능하도록 설정

  final RemoteDataSource _remoteDataSource = RemoteDataSource();
  final ImagePickerService _imagePickerService = ImagePickerService();

  var userInfo = Rx<UserProfile?>(null); // 사용자 프로필
  var isLoading = true.obs; // 전체 로딩 상태
  var selectedProfileImage = Rx<String?>(null);
  var currentStreak = 0.obs; // 연속 출석 날짜
  // 요일 체크 상태 관리 (월~일)
  var isCheckedList =
      <bool>[false, false, false, false, false, false, false].obs;

  /// 마이페이지 전체 데이터 갱신 함수
  Future<void> refreshMypageData() async {
    isLoading.value = true; // 새로 로딩 시작
    await Future.wait([
      fetchUserInfo(),
      fetchCurrentStreak(),
      fetchWeeklyAttendanceStatus(),
    ]);
    isLoading.value = false;
  }

  @override
  void onInit() {
    super.onInit();
    refreshMypageData(); // 최초 1회
  }

  // 사용자 정보 조회
  Future<void> fetchUserInfo() async {
    try {
      var response = await _remoteDataSource.fetchUserInfo(null);
      if (response.isNotEmpty) {
        userInfo.value = UserProfile.fromJsonMypage(response);
      }
    } catch (e) {
      debugPrint("fetchUserInfo() 오류 발생: $e");
    }
  }

  // 생년월일 형식 변환 (yyyy-mm-dd → yyyy.mm.dd)
  String formatBirthDate(String date) {
    return date.replaceAll("-", ".");
  }

  // 한 줄 소개 최대 길이 제한 (최대 20자)
  String truncateIntro(String intro, {int maxLength = 20}) {
    return intro.length > maxLength
        ? "${intro.substring(0, maxLength)}..."
        : intro;
  }

  // 레벨 변환 (영어 → 한글)
  String convertLevel(String level) {
    switch (level) {
      case "BEGINNER":
        return "초급";
      case "INTERMEDIATE":
        return "중급";
      case "ADVANCED":
        return "고급";
      default:
        return "알 수 없음";
    }
  }

  // 연속 출석 날짜 조회
  Future<void> fetchCurrentStreak() async {
    try {
      var response = await _remoteDataSource.fetchCurrentStreak();
      currentStreak.value = response;
    } catch (e) {
      debugPrint("fetchCurrentStreak() 오류 발생: $e");
      currentStreak.value = 0; // 오류 발생 시 기본값 설정
    }
  }

  // 요일별 출석 현황 조회 후 isCheckedList 업데이트
  Future<void> fetchWeeklyAttendanceStatus() async {
    try {
      var attendanceData = await _remoteDataSource.fetchWeeklyAttendance();

      if (attendanceData.isNotEmpty) {
        isCheckedList.value = [
          attendanceData["sunday"] ?? false,
          attendanceData["monday"] ?? false,
          attendanceData["tuesday"] ?? false,
          attendanceData["wednesday"] ?? false,
          attendanceData["thursday"] ?? false,
          attendanceData["friday"] ?? false,
          attendanceData["saturday"] ?? false,
        ];
      }
    } catch (e) {
      debugPrint("fetchWeeklyAttendanceStatus() 오류 발생: $e");
    }
  }

  // 프로필 사진 선택 함수
  Future<void> selectProfileImage(BuildContext context) async {
    final image = await _imagePickerService.showImagePickerDialog(context);
    if (image != null) {
      selectedProfileImage.value = image.path; // 이미지 경로 저장
      print('Selected image path: ${image.path}');
    }
  }
}
