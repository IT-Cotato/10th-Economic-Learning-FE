import 'package:economic_fe/data/services/remote_data_source.dart';
import 'package:economic_fe/data/services/sse_manager.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:get/get.dart';

class SettingController extends GetxController {
  final RemoteDataSource remoteDataSource = RemoteDataSource();

  var isToggled = false.obs;
  var isLoading = false.obs;

  @override
  void onInit() {
    super.onInit();
    fetchInitialAlarmStatus(); // 화면 진입 시 알림 설정 상태 반영
  }

  Future<void> toggle() async {
    if (isLoading.value) return;
    isLoading.value = true;

    bool newStatus = !isToggled.value;
    bool success = await remoteDataSource.setAlarm(newStatus);

    if (success) {
      isToggled.value = newStatus;

      if (newStatus) {
        // 알림 켜짐 - SSE 구독 시작
        await SSEManager().init();
        debugPrint("알림 켜짐 - SSE 구독 시작 성공");
      } else {
        // 알림 꺼짐 - SSE 해제 + 서버 구독 해제 요청
        await SSEManager().dispose();
        await remoteDataSource.unsubscribeFromNotifications();
        debugPrint("알림 꺼짐 - SSE 해제 + 서버 구독 해제 요청 성공");
      }
      debugPrint("알림 설정 업데이트 완료");
    } else {
      debugPrint("알림 설정 업데이트 실패");
    }

    isLoading.value = false;
  }

  /// 로그아웃 기능
  Future<void> logout() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove("accessToken");
    await prefs.setBool("isLoggedIn", false);

    // 추후 SSE 연결 해제 필요 시 여기에 추가
    // Get.find<PushNotificationController>().disconnectSse();

    // 온보딩 화면으로 이동
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Get.offAllNamed("/");
    });
  }

  /// 회원 탈퇴 기능
  Future<void> deleteAccount() async {
    isLoading.value = true;

    try {
      bool success = await remoteDataSource.deleteUser();

      if (success) {
        // SharedPreferences에서 사용자 정보 제거
        final prefs = await SharedPreferences.getInstance();
        await prefs.clear();

        // 온보딩 또는 로그인 화면으로 이동
        WidgetsBinding.instance.addPostFrameCallback((_) {
          Get.offAllNamed("/");
        });

        Get.snackbar("탈퇴 완료", "회원탈퇴가 정상적으로 처리되었습니다.",
            snackPosition: SnackPosition.BOTTOM);
      } else {
        Get.snackbar("탈퇴 실패", "회원탈퇴에 실패했습니다.",
            snackPosition: SnackPosition.BOTTOM);
      }
    } catch (e) {
      Get.snackbar("오류", "회원탈퇴 중 문제가 발생했습니다.",
          snackPosition: SnackPosition.BOTTOM);
    } finally {
      isLoading.value = false;
    }
  }

  /// 알림 설정 상태 받아오기
  Future<void> fetchInitialAlarmStatus() async {
    isLoading.value = true;

    final userInfo = await remoteDataSource.fetchUserInfo(null);
    if (userInfo.containsKey("isAlarmOn")) {
      isToggled.value = userInfo["isAlarmOn"] == true;
    } else {
      debugPrint("isAlarmOn 필드가 존재하지 않음");
    }

    isLoading.value = false;
  }
}
