import 'package:economic_fe/data/models/level_test/level_test_answer_model.dart';
import 'package:economic_fe/data/services/remote_data_source.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:get/get.dart';
import 'package:kakao_flutter_sdk_user/kakao_flutter_sdk_user.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LoginExistController extends GetxController {
  // var levelTestAnswers = <LevelTestAnswerModel>[].obs;
  List<LevelTestAnswerModel> levelTestAnswers = [];

  final String clientId = dotenv.env['CLIENT_ID']!;
  final String redirectUri = dotenv.env['REDIRECT_URI']!;

  Future<void> login() async {
    try {
      // 카카오톡 또는 계정 로그인
      OAuthToken token;
      if (await isKakaoTalkInstalled()) {
        token = await UserApi.instance.loginWithKakaoTalk();
      } else {
        token = await UserApi.instance.loginWithKakaoAccount();
      }

      String kakaoAccessToken = token.accessToken;
      print("카카오 로그인 성공, accessToken: $kakaoAccessToken");

      // 백엔드에 카카오 토큰 전송 후 서버 인증 토큰 받아오기
      await getlogin(kakaoAccessToken);
    } catch (error) {
      print("카카오 로그인 실패: $error");
    }
  }

  // 백엔드에서 토큰 받아오기
  Future<void> getlogin(String accessToken) async {
    try {
      print("백엔드 로그인 요청 시작");

      dynamic response = await RemoteDataSource.getlogin(accessToken);

      if (response != null && response['results'] != null) {
        String serverToken = response['results'];
        await saveToken("accessToken", serverToken);
        print("백엔드 인증 성공, 저장된 accessToken: $serverToken");
      } else {
        print("백엔드 인증 실패: 응답 데이터 없음");
      }
    } catch (e) {
      debugPrint("백엔드 로그인 요청 실패: $e");
    }
  }

  // 토큰 저장
  Future<void> saveToken(String sessionKey, String token) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(sessionKey, token);
  }

  // 토큰 불러오기
  Future<String?> getToken(String sessionKey) async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(sessionKey);
  }

  // 토큰 삭제
  Future<void> deleteToken(String sessionKey) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(sessionKey);
  }

  // 테스트용
  void toArticle() {
    Get.toNamed('/article');
  }
}
