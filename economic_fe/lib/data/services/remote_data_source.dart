import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:dio/dio.dart';
import 'package:economic_fe/view_model/login/login_controller.dart';
import 'package:flutter/material.dart';
import 'package:flutter_client_sse/constants/sse_request_type_enum.dart';
import 'package:flutter_client_sse/flutter_client_sse.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class RemoteDataSource {
  final Dio dio = Dio();
  //기본 api 엔드포인트
  static String baseUrl = dotenv.env['API_URL']!;

  // //로그인 전 임시 accessToken
  // static String accessToken = dotenv.env['BASE_TOKEN']!;

  /// API POST
  ///
  /// 데이터 생성시 사용
  /// jsonData 포함O
  Future<dynamic> postApiWithJson(
    String endPoint,
    Map<String, dynamic> jsonData,
  ) async {
    String apiUrl = '$baseUrl/$endPoint';

    String? access = await getToken("accessToken");

    Map<String, String> headers = {
      'Content-Type': 'application/json',
      'Authorization': 'Bearer $access',
    };

    try {
      final response = await http.post(
        Uri.parse(apiUrl),
        headers: headers,
        body: jsonEncode(jsonData),
      );

      if (response.statusCode == 200) {
        debugPrint('POST 요청 성공');
        return response.statusCode;
      } else {
        debugPrint('POST 요청 실패: (${response.statusCode}) ${response.body}');
      }

      return response.statusCode;
    } catch (e) {
      debugPrint('POST 요청 중 예외 발생: $e');
      return null;
    }
  }

  // /// API POST
  // ///
  // /// 데이터 생성시 사용
  // /// jsonData 포함O
  // /// 앱에 저장된 accessToken 사용
  // Future<dynamic> postApiWithJsonTest(
  //   String endPoint,
  //   Map<String, dynamic> jsonData,
  // ) async {
  //   String apiUrl = '$baseUrl/$endPoint';

  //   String? access = await getToken("accessToken");

  //   Map<String, String> headers = {
  //     'Content-Type': 'application/json',
  //     'Authorization': 'Bearer $access',
  //   };

  //   try {
  //     final response = await http.post(
  //       Uri.parse(apiUrl),
  //       headers: headers,
  //       body: jsonEncode(jsonData),
  //     );

  //     if (response.statusCode == 200) {
  //       debugPrint('POST 요청 성공');
  //       return response.statusCode;
  //     } else {
  //       debugPrint('POST 요청 실패: (${response.statusCode}) ${response.body}');
  //     }

  //     return response.statusCode;
  //   } catch (e) {
  //     debugPrint('POST 요청 중 예외 발생: $e');
  //     return null;
  //   }
  // }

  /// API POST
  ///
  /// 데이터 생성시 사용
  /// jsonData 포함O
  /// 앱에 저장된 accessToken 사용
  /// statuscode 반환하지 않고 전체 response 반환
  Future<dynamic> postApiWithJsonReturnResponse(
    String endPoint,
    Map<String, dynamic> jsonData,
  ) async {
    String apiUrl = '$baseUrl/$endPoint';

    String? access = await getToken("accessToken");

    Map<String, String> headers = {
      'Content-Type': 'application/json',
      'Authorization': 'Bearer $access',
    };

    try {
      final response = await http.post(
        Uri.parse(apiUrl),
        headers: headers,
        body: jsonEncode(jsonData),
      );

      if (response.statusCode == 200) {
        debugPrint('POST 요청 성공');
        return jsonDecode(utf8.decode(response.bodyBytes));
      } else {
        debugPrint('POST 요청 실패: (${response.statusCode}) ${response.body}');
      }

      return response.statusCode;
    } catch (e) {
      debugPrint('POST 요청 중 예외 발생: $e');
      return null;
    }
  }

  /// API POST
  ///
  /// 데이터 생성시 사용
  /// jsonData 포함X
  /// 앱에 저장된 accessToken 사용
  /// statuscode 반환하지 않고 전체 response 반환
  Future<dynamic> postApiWithoutJsonReturnResponse(
    String endPoint,
    // Map<String, dynamic> jsonData,
  ) async {
    String apiUrl = '$baseUrl/$endPoint';

    String? access = await getToken("accessToken");

    Map<String, String> headers = {
      'Content-Type': 'application/json',
      'Authorization': 'Bearer $access',
    };

    try {
      final response = await http.post(
        Uri.parse(apiUrl),
        headers: headers,
        // body: jsonEncode(jsonData),
      );

      if (response.statusCode == 200) {
        debugPrint('POST 요청 성공');
        return jsonDecode(utf8.decode(response.bodyBytes));
      } else {
        debugPrint('POST 요청 실패: (${response.statusCode}) ${response.body}');
      }

      return response.statusCode;
    } catch (e) {
      debugPrint('POST 요청 중 예외 발생: $e');
      return null;
    }
  }

  /// API POST
  ///
  /// 데이터 생성시 사용
  /// jsonData 포함X
  Future<dynamic> _postApi(
    String endPoint,
    // Map<String, dynamic> jsonData,
  ) async {
    String apiUrl = '$baseUrl/$endPoint';
    // String authToken = dotenv.env['AUTHORIZATION_KEY']!; // 환경 변수에서 가져오기

    String? access = await getToken("accessToken");

    Map<String, String> headers = {
      // 'Content-Type': 'application/json',
      'accept': '*/*',
      'Authorization': 'Bearer $access',
    };

    try {
      final response = await http.post(
        Uri.parse(apiUrl),
        headers: headers,
        // body: jsonEncode(jsonData),
      );

      if (response.statusCode == 200) {
        debugPrint('POST 요청 성공');
        return response.statusCode;
      } else {
        debugPrint('POST 요청 실패: (${response.statusCode}) ${response.body}');
      }

      return response.statusCode;
    } catch (e) {
      debugPrint('POST 요청 중 예외 발생: $e');
      return null;
    }
  }

  // /// API POST
  // ///
  // /// 데이터 생성시 사용
  // /// jsonData 포함X
  // /// response 전부 return
  // Future<dynamic> _postApiReturnResponse(
  //   String endPoint,
  //   // Map<String, dynamic> jsonData,
  // ) async {
  //   String apiUrl = '$baseUrl/$endPoint';
  //   // String authToken = dotenv.env['AUTHORIZATION_KEY']!; // 환경 변수에서 가져오기

  //   String? access = await getToken("accessToken");

  //   Map<String, String> headers = {
  //     'Content-Type': 'application/json',
  //     'Authorization': 'Bearer $access',
  //   };

  //   try {
  //     final response = await http.post(
  //       Uri.parse(apiUrl),
  //       headers: headers,
  //       // body: jsonEncode(jsonData),
  //     );

  //     if (response.statusCode == 200) {
  //       debugPrint('POST 요청 성공');
  //       return response;
  //     } else {
  //       debugPrint('POST 요청 실패: (${response.statusCode}) ${response.body}');
  //     }

  //     return response;
  //   } catch (e) {
  //     debugPrint('POST 요청 중 예외 발생: $e');
  //     return null;
  //   }
  // }

  /// API POST
  ///
  /// 데이터 생성시 사용
  /// jsonData 포함X
  /// 앱에 저장된 accessToken 사용
  Future<dynamic> _postApiTest(String endPoint) async {
    String apiUrl = '$baseUrl/$endPoint';
    String? access = await getToken("accessToken");

    Map<String, String> headers = {
      'Content-Type': 'application/json',
      'Authorization': 'Bearer $access',
    };

    try {
      final response = await http.post(
        Uri.parse(apiUrl),
        headers: headers,
      );

      if (response.statusCode == 200) {
        debugPrint('POST 요청 성공');
        final decoded = jsonDecode(utf8.decode(response.bodyBytes)); // JSON 파싱
        return decoded; // 전체 Map<String, dynamic> 반환
      } else {
        debugPrint('POST 요청 실패: (${response.statusCode}) ${response.body}');
        return null; // 또는 에러 객체를 던질 수도 있음
      }
    } catch (e) {
      debugPrint('POST 요청 중 예외 발생: $e');
      return null;
    }
  }

  /// API PATCH
  ///
  /// 데이터 일부 수정시 사용
  Future<dynamic> _patchApi(String endPoint, String? jsonData) async {
    String apiUrl = '$baseUrl/$endPoint';
    String? access = await getToken("accessToken");

    Map<String, String> headers = {
      'Content-Type': 'application/json',
      'Authorization': 'Bearer $access',
    };
    debugPrint('PATCH 요청: $endPoint');

    try {
      final response =
          await http.patch(Uri.parse(apiUrl), headers: headers, body: jsonData);
      if (response.statusCode == 200) {
        debugPrint('PATCH 요청 성공');
      } else {
        debugPrint('PATCH 요청 실패: (${response.statusCode})${response.body}');
      }

      return response.statusCode;
    } catch (e) {
      debugPrint('PATCH 요청 중 예외 발생: $e');
      return;
    }
  }

  /// API GET (token 없이 사용)
  ///
  /// 데이터 받아올 때 사용
  static Future<dynamic> _getApi(String endPoint) async {
    String apiUrl = '$baseUrl/$endPoint';
    debugPrint('GET 요청: $endPoint');

    try {
      final response = await http.get(Uri.parse(apiUrl));

      if (response.statusCode == 200) {
        debugPrint('GET 요청 성공');

        // return jsonDecode(response.body);
        // 한글 깨지지 않도록 설정
        final decodedResponse = jsonDecode(utf8.decode(response.bodyBytes));
        return decodedResponse;
      } else {
        debugPrint('GET 요청 실패: (${response.statusCode})${response.body}');
        return response;
      }
    } catch (e) {
      debugPrint('GET 요청 중 예외 발생: $e');
      return;
    }
  }

  // /// API GET (token 없이 사용)
  // ///
  // /// 데이터 받아올 때 사용
  // static Future<dynamic> _getApiReturnStatus(String endPoint) async {
  //   String apiUrl = '$baseUrl/$endPoint';
  //   debugPrint('GET 요청: $endPoint');

  //   try {
  //     final response = await http.get(Uri.parse(apiUrl));

  //     if (response.statusCode == 200) {
  //       debugPrint('GET 요청 성공');

  //       // return jsonDecode(response.body);
  //       // 한글 깨지지 않도록 설정
  //       final decodedResponse = jsonDecode(utf8.decode(response.bodyBytes));
  //       return response;
  //     } else {
  //       debugPrint('GET 요청 실패: (${response.statusCode})${response.body}');
  //       return response;
  //     }
  //   } catch (e) {
  //     debugPrint('GET 요청 중 예외 발생: $e');
  //     return;
  //   }
  // }

  /// API GET (token 사용)
  ///
  /// 데이터 받아올 때 사용
  Future<dynamic> _getApiWithHeader(String endPoint) async {
    String apiUrl = '$baseUrl/$endPoint';
    String? access = await getToken("accessToken");

    debugPrint('GET 요청: $endPoint');

    try {
      final headers = {
        'Authorization': 'Bearer $access',
        'accept': '*/*',
      };
      final response = await http.get(
        Uri.parse(apiUrl),
        headers: headers,
      );

      if (response.statusCode == 200) {
        debugPrint('GET 요청 성공');

        // return jsonDecode(response.body);
        // 한글 깨지지 않도록 설정
        final decodedResponse = jsonDecode(utf8.decode(response.bodyBytes));
        return decodedResponse;
      } else {
        debugPrint('GET 요청 실패: (${response.statusCode})${response.body}');
        return response;
      }
    } catch (e) {
      debugPrint('GET 요청 중 예외 발생: $e');
      return;
    }
  }

  /// API GET (token 사용)
  ///
  /// 데이터 받아올 때 사용
  /// 앱에 저장된 accessToken 사용
  Future<dynamic> _getApiWithHeaderTest(String endPoint) async {
    String apiUrl = '$baseUrl/$endPoint';
    debugPrint('GET 요청: $endPoint');

    String? access = await getToken("accessToken");

    try {
      final headers = {
        'Authorization': 'Bearer $access',
        'accept': '*/*',
      };
      final response = await http.get(
        Uri.parse(apiUrl),
        headers: headers,
      );

      if (response.statusCode == 200) {
        debugPrint('GET 요청 성공');

        // return jsonDecode(response.body);
        // 한글 깨지지 않도록 설정
        final decodedResponse = jsonDecode(utf8.decode(response.bodyBytes));
        return decodedResponse;
      } else {
        debugPrint('GET 요청 실패: (${response.statusCode})${response.body}');
        return response;
      }
    } catch (e) {
      debugPrint('GET 요청 중 예외 발생: $e');
      return;
    }
  }

  // /// API GET (token X)
  // ///
  // /// 데이터 받아올 때 사용
  // Future<dynamic> _getApiWithoutToken(String endPoint) async {
  //   String apiUrl = '$baseUrl/$endPoint';
  //   debugPrint('GET 요청: $endPoint');

  //   String? access = await getToken("accessToken");

  //   try {
  //     final headers = {
  //       'Authorization': 'Bearer $access',
  //       'accept': '*/*',
  //     };
  //     final response = await http.get(
  //       Uri.parse(apiUrl),
  //       headers: headers,
  //     );

  //     if (response.statusCode == 200) {
  //       debugPrint('GET 요청 성공');

  //       // return jsonDecode(response.body);
  //       // 한글 깨지지 않도록 설정
  //       final decodedResponse = jsonDecode(utf8.decode(response.bodyBytes));
  //       return decodedResponse;
  //     } else {
  //       debugPrint('GET 요청 실패: (${response.statusCode})${response.body}');
  //       return response;
  //     }
  //   } catch (e) {
  //     debugPrint('GET 요청 중 예외 발생: $e');
  //     return;
  //   }
  // }

  /// API DELETE
  ///
  /// 데이터 삭제시 사용
  Future<dynamic> _deleteApi(String endPoint) async {
    String apiUrl = '$baseUrl/$endPoint';
    String? access = await getToken("accessToken");
    debugPrint('DELETE 요청: $endPoint');

    try {
      final headers = {
        'Authorization': 'Bearer $access',
        'accept': '*/*',
      };
      final response = await http.delete(
        Uri.parse(apiUrl),
        headers: headers,
      );

      if (response.statusCode == 200) {
        debugPrint('DELETE 요청 성공');
      } else {
        debugPrint('DELETE 요청 실패: (${response.statusCode})${response.body}');
      }

      return response.statusCode;
    } catch (e) {
      debugPrint('DELETE 요청 중 예외 발생: $e');
      return;
    }
  }

  /// API DELETE
  ///
  /// 데이터 삭제시 사용
  /// 앱에 저장된 accessToken 사용
  Future<dynamic> _deleteApiTest(String endPoint) async {
    String apiUrl = '$baseUrl/$endPoint';
    debugPrint('DELETE 요청: $endPoint');
    String? access = await getToken("accessToken");
    try {
      final headers = {
        'Authorization': 'Bearer $access',
        'accept': '*/*',
      };
      final response = await http.delete(
        Uri.parse(apiUrl),
        headers: headers,
      );

      if (response.statusCode == 200) {
        debugPrint('DELETE 요청 성공');
        final decoded =
            jsonDecode(utf8.decode(response.bodyBytes)); // 응답 본문 디코딩 후 파싱
        return decoded; // Map<String, dynamic> 반환
      } else {
        debugPrint('DELETE 요청 실패: (${response.statusCode}) ${response.body}');
        return null;
      }
    } catch (e) {
      debugPrint('DELETE 요청 중 예외 발생: $e');
      return;
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

  /// 개념 학습 세트 조회
  /// api/v1/learning/{learningSetId}/concepts
  Future<dynamic> getLearningConcept(int learningSetId, String level) async {
    dynamic response = await _getApiWithHeaderTest(
        'api/v1/learning/$learningSetId/concepts?level=$level');
    print(response);
    return response;
  }

  /// api/v1/learning
  /// 레벨별 학습 세트 조회
  Future<dynamic> postLearningSet() async {
    String endPoint = 'api/v1/learning';

    try {
      final response = await _postApiTest(endPoint); // API 요청
      print("Raw Response: $response");

      if (response is http.Response) {
        final jsonResponse = jsonDecode(response.body); // JSON 변환
        print("Decoded Response: $jsonResponse");
        return jsonResponse;
      }

      return response; // 혹시 다른 데이터 타입일 경우 그대로 반환
    } catch (e) {
      debugPrint("API Error: $e");
      return {}; // 에러 발생 시 빈 Map 반환
    }
  }

  /// 레벨 테스트 퀴즈 목록 조회
  /// api/v1/level-test/quiz
  static Future<dynamic> getLevelTest() async {
    dynamic response = await _getApi('api/v1/level-test/quiz');
    return response;
  }

  /// 뉴스 목록 조회
  /// api/news
  Future<dynamic> getNewsList(int page, String sort, String? category) async {
    dynamic response;
    if (category != null) {
      response = await _getApiWithHeaderTest(
          'api/news?page=$page&sort=$sort&category=$category');
    } else {
      response = await _getApiWithHeaderTest('api/news?page=$page&sort=$sort');
    }

    if (response != null) {
      // print('응답 데이터 : $response');
    } else {
      print('데이터 get 실패');
    }
    return response;
  }

  /// api/news/{id}
  /// 뉴스 상세 조회
  Future<dynamic> getNewsDetail(int id) async {
    dynamic response;

    response = await _getApiWithHeaderTest('api/news/$id');

    return response;
  }

  /// 뉴스 목록 조회 (카카오 로그인 X)
  /// api/news
  Future<dynamic> getNewsList2(int page, String sort, String? category) async {
    dynamic response;
    if (category != null) {
      response = await _getApiWithHeader(
          'api/news?page=$page&sort=$sort&category=$category');
    } else {
      response = await _getApiWithHeader('api/news?page=$page&sort=$sort');
    }

    if (response != null) {
      print('응답 데이터 : $response');
    } else {
      print('데이터 get 실패');
    }
    return response;
  }

  /// api/news/{id}/scrap
  /// 뉴스 스크랩
  Future<bool> postNewsScrap(int id) async {
    String endPoint = "api/news/$id/scrap";

    try {
      final response = await _postApiTest(endPoint);

      if (response != null &&
          response['isSuccess'] == true &&
          response['results']?['isSuccess'] == true) {
        debugPrint("스크랩 post 성공");
        return true;
      } else {
        debugPrint("스크랩 실패: $response");
        return false;
      }
    } catch (e) {
      debugPrint("scrap Error : $e");
      return false;
    }
  }

  /// 뉴스 스크랩 취소
  /// api/news/{id}/scrap
  Future<bool> deleteNewsScrap(int id) async {
    String endPoint = "api/news/$id/scrap";

    try {
      final response = await _deleteApiTest(endPoint);

      if (response != null &&
          response['isSuccess'] == true &&
          response['results']?['isSuccess'] == true) {
        debugPrint("스크랩 delete 성공");
        return true;
      } else {
        debugPrint("스크랩 delete 실패: $response");
        return false;
      }
    } catch (e) {
      debugPrint("scrap delete Error : $e");
      return false;
    }
  }

  /// 자음 별 용어 조회
  /// api/v1/terms/search/consonant
  Future<dynamic> getDictionary(int page, String consonant) async {
    dynamic response;

    // 한글 자음을 URL 인코딩
    String encodedConsonant = Uri.encodeComponent(consonant);

    response = await _getApiWithHeaderTest(
        'api/v1/terms/search/consonant?page=$page&consonant=$encodedConsonant');

    if (response != null) {
      print("용어사전 응답 데이터 : $response");
    } else {
      print("get 데이터 실패");
    }
    return response;
  }

  /// 용어 상세 조회
  /// api/v1/terms/{id}
  Future<dynamic> getDetailTerms(int id) async {
    dynamic response;

    response = await _getApiWithHeaderTest('api/v1/terms/$id');

    if (response != null) {
      print("용어 상세 : $response");
    } else {
      print("get 데이터 실패");
    }

    return response;
  }

  /// 키워드 별 용어 조회
  /// api/v1/terms/search/keyword
  Future<dynamic> getKewordResult(int page, String keyword) async {
    dynamic response;

    // 한글을 URL 인코딩
    String encodedkeyword = Uri.encodeComponent(keyword);

    response = await _getApiWithHeaderTest(
        'api/v1/terms/search/keyword?page=$page&keyword=$encodedkeyword');

    if (response != null) {
      print("키워드 검색 결과 : $response");
    } else {
      print("get 데이터 실패");
    }

    return response;
  }

  /// api/v1/terms/{id}/scrap
  /// 용어 스크랩
  Future<dynamic> postTermsScrap(int id) async {
    String endPoint = "api/v1/terms/$id/scrap";

    try {
      final response = await _postApiTest(endPoint);

      if (response != null) {
        debugPrint("스크랩 post 성공");
        return true;
      } else {
        debugPrint("스크랩 실패");
        return false;
      }
    } catch (e) {
      debugPrint("scrap Error : $e");
      return false;
    }
  }

  /// api/v1/terms/{id}/scrap
  /// 용어 스크랩 취소
  Future<dynamic> deleteScrap(int id) async {
    String endPoint = "api/v1/terms/$id/scrap";

    try {
      final response = await _deleteApiTest(endPoint);

      if (response != null) {
        debugPrint("스크랩 delete 성공");
        return true;
      } else {
        debugPrint("스크랩 delete 실패");
        return false;
      }
    } catch (e) {
      debugPrint("scrap delete Error : $e");
      return false;
    }
  }

  /// 틀린 문제 데이터 요청
  /// api/v1/user/wrong-quizzes
  Future<dynamic> fetchIncorrectQuestions(String level) async {
    String endpoint = 'api/v1/user/wrong-quizzes?level=$level';

    try {
      // final response = await _getApiWithHeaderTest(endpoint, accessToken);
      final response = await _getApiWithHeader(endpoint);

      if (response != null && response['isSuccess'] == true) {
        debugPrint('틀린 문제 데이터 요청 성공');
        return response;
      } else {
        debugPrint('데이터 요청 실패: ${response?['message'] ?? '알 수 없는 에러'}');
        return null;
      }
    } catch (e) {
      debugPrint('요청 중 예외 발생: $e');
      return null;
    }
  }

  /// 개별 퀴즈 조회
  /// API: api/v1/learning/learning/quiz/{quizId}
  Future<dynamic> fetchQuizById(int quizId) async {
    try {
      // API Endpoint 구성
      String endPoint = 'api/v1/learning/quiz/$quizId';

      // GET 요청 수행
      // final response = await _getApiWithHeaderTest(endPoint, accessToken);
      final response = await _getApiWithHeader(endPoint);

      // 응답 데이터 처리
      if (response != null) {
        print("퀴즈 데이터 응답: $response");
        return response;
      } else {
        print("퀴즈 데이터 요청 실패");
        return null;
      }
    } catch (e) {
      print("fetchQuizById 요청 중 예외 발생: $e");
      return null;
    }
  }

  /// 스크랩 한 게시물 조회
  /// API: api/v1/user/scrap-posts
  Future<dynamic> fetchScrapedPosts() async {
    const String endPoint = 'api/v1/user/scrap-posts';

    // final response = await _getApiWithHeaderTest(endPoint, accessToken);
    final response = await _getApiWithHeader(endPoint);

    if (response != null && response['isSuccess']) {
      debugPrint("스크랩 게시글 목록 응답: ${response['results']}");
      return response['results'];
    } else {
      debugPrint("스크랩 게시글 목록 가져오기 실패");
      return null;
    }
  }

  /// 좋아요 한 게시물 조회
  /// API: api/v1/user/like-posts
  Future<dynamic> fetchLikedPosts() async {
    const String endPoint = 'api/v1/user/like-posts';

    // final response = await _getApiWithHeaderTest(endPoint, accessToken);
    final response = await _getApiWithHeader(endPoint);

    if (response != null && response['isSuccess']) {
      debugPrint("좋아요 게시글 목록 응답: ${response['results']}");
      return response['results'];
    } else {
      debugPrint("좋아요 게시글 목록 가져오기 실패");
      return null;
    }
  }

  /// 좋아요 한 댓글 조회
  /// API: api/v1/user/like-comments
  Future<dynamic> fetchLikedComments() async {
    const String endPoint = 'api/v1/user/like-comments';

    // final response = await _getApiWithHeaderTest(endPoint, accessToken);
    final response = await _getApiWithHeader(endPoint);

    if (response != null && response['isSuccess']) {
      debugPrint("좋아요 댓글 목록 응답: ${response['results']}");
      return response['results'];
    } else {
      debugPrint("좋아요 댓글 목록 가져오기 실패");
      return null;
    }
  }

  /// 스크랩 한 개념 학습 조회
  /// API: api/v1/user/scrap-concepts
  Future<dynamic> getScrapConcepts(String level) async {
    String endpoint = 'api/v1/user/scrap-concepts?level=$level';

    try {
      // _getApiWithHeader 호출
      // final response = await _getApiWithHeaderTest(endpoint, accessToken);
      final response = await _getApiWithHeader(endpoint);

      if (response != null && response is Map<String, dynamic>) {
        debugPrint('스크랩한 학습 데이터 로드 성공');
        return response;
      } else {
        debugPrint('스크랩한 학습 데이터 로드 실패');
        return null;
      }
    } catch (e) {
      debugPrint('getScrapConcepts Error: $e');
      return null;
    }
  }

  /// 스크랩 한 퀴즈 조회
  /// API: api/v1/user/scrap-quizzes
  Future<dynamic> getScrapQuizzes(String level) async {
    String endpoint = 'api/v1/user/scrap-quizzes?level=$level';

    try {
      // _getApiWithHeader 호출
      // final response = await _getApiWithHeaderTest(endpoint, accessToken);
      final response = await _getApiWithHeader(endpoint);

      if (response != null && response is Map<String, dynamic>) {
        debugPrint('스크랩한 퀴즈 데이터 로드 성공');
        return response;
      } else {
        debugPrint('스크랩한 퀴즈 데이터 로드 실패');
        return null;
      }
    } catch (e) {
      debugPrint('getScrapConcepts Error: $e');
      return null;
    }
  }

  /// 레벨별 학습 진도율 조회
  /// API: api/v1/user/progress
  Future<dynamic> getProgress() async {
    String endpoint = 'api/v1/user/progress';

    try {
      // _getApiWithHeader 호출
      // final response = await _getApiWithHeaderTest(endpoint, accessToken);
      final response = await _getApiWithHeader(endpoint); // 카카오 로그인 오류로 인함

      if (response != null && response is Map<String, dynamic>) {
        debugPrint('학습 진도율 데이터 로드 성공');
        return response;
      } else {
        debugPrint('학습 진도율 데이터 로드 실패');
        return null;
      }
    } catch (e) {
      debugPrint('getProgress Error: $e');
      return null;
    }
  }

  /// 사용자 프로필 등록 API
  /// API: api/v1/user/profile
  Future<Map<String, dynamic>> registerUserProfile(
      Map<String, dynamic> userProfile) async {
    String endpoint = 'api/v1/user/profile';

    try {
      final response = await postApiWithJson(endpoint, userProfile);

      // 응답이 int일 경우 (성공 시 200)
      if (response is int) {
        if (response == 200) {
          debugPrint('사용자 프로필 등록 성공');
          return {
            'isSuccess': true,
            'code': 'REQUEST_OK',
            'message': '요청이 승인되었습니다.',
          };
        } else {
          debugPrint('POST 요청 실패: ($response) 서버 내부 오류');
          return {
            'isSuccess': false,
            'code': 'INTERNAL_SERVER_ERROR',
            'message': '서버 내부 오류가 발생했습니다.',
          };
        }
      }

      // 응답이 http.Response일 경우
      if (response is http.Response) {
        final responseBody = response.body;
        final Map<String, dynamic> responseData =
            responseBody is String ? jsonDecode(responseBody) : responseBody;

        if (response.statusCode == 200) {
          debugPrint('사용자 프로필 등록 성공');

          // 서버에서 isSuccess가 false로 응답할 수도 있으므로 추가 체크
          if (responseData['isSuccess'] == true) {
            return responseData;
          } else {
            debugPrint('서버에서 isSuccess가 false로 응답됨: $responseData');
            return responseData;
          }
        }

        // 상태 코드가 200이 아닌 경우
        debugPrint('사용자 프로필 등록 실패 - 상태 코드: ${response.statusCode}');
        return {
          'isSuccess': false,
          'code': response.statusCode.toString(),
          'message': '서버 응답 오류가 발생했습니다.',
        };
      }

      // response가 예상하지 않은 타입일 경우
      debugPrint('예상하지 못한 응답 타입: ${response.runtimeType}');
      return {
        'isSuccess': false,
        'code': 'UNEXPECTED_RESPONSE',
        'message': '예상하지 못한 응답 형식입니다.',
      };
    } catch (e) {
      debugPrint('registerUserProfile Error: $e');
      return {
        'isSuccess': false,
        'code': 'NETWORK_ERROR',
        'message': '네트워크 오류가 발생했습니다.',
      };
    }
  }

  /// 사용자 프로필 수정 API
  /// API: api/v1/user/profile
  Future<dynamic> updateUserProfile(Map<String, dynamic> userProfile) async {
    String endpoint = 'api/v1/user/profile';

    try {
      final response = await _patchApi(endpoint, jsonEncode(userProfile));

      if (response == 200) {
        debugPrint('사용자 프로필 수정 성공');
        return true;
      } else {
        debugPrint('사용자 프로필 수정 실패: $response');
        return false;
      }
    } catch (e) {
      debugPrint('updateUserProfile Error: $e');
      return false;
    }
  }

  /// api/v1/chatbot/list
  /// 대화 내역 조회
  Future<dynamic> getMessageList(int page) async {
    String endPoint = 'api/v1/chatbot/list?page=$page';

    try {
      // _getApiWithHeader 호출
      final response = await _getApiWithHeaderTest(endPoint);

      if (response != null && response is Map<String, dynamic>) {
        debugPrint('대화 내역 조회 성공');
        return response;
      } else {
        debugPrint('대화 내역 조회  실패');
        return null;
      }
    } catch (e) {
      debugPrint('Error: $e');
      return null;
    }
  }

  // /// api/v1/chatbot/tips
  // /// 이용 꿀팁 조회
  // Future<dynamic> getChatbotTips() async {
  //   String endPoint = 'api/v1/chatbot/tips';
  //   try {
  //     print("start");
  //     final response = await _getApiWithHeaderTest(endPoint, accessToken);
  //     if (response != null) {
  //       debugPrint('꿀팁 조회');
  //       print("response : $response");
  //       return response;
  //     } else {
  //       debugPrint('꿀팁 조회 실패');
  //       return;
  //     }
  //   } catch (e) {
  //     debugPrint('Error : $e');
  //     return;
  //   }
  // }

  /// api/v1/chatbot
  /// 챗봇에게 메세지 보내기
  Future<dynamic> postChatbotMessage(String message) async {
    String encodedmsg = Uri.encodeComponent(message);
    String endPoint = "api/v1/chatbot?message=$encodedmsg";
    try {
      final response = await _postApiTest(endPoint);

      if (response != null) {
        debugPrint("대화 전송 성공");
        return response;
      } else {
        debugPrint("대화 전송 실패");
        return null;
      }
    } catch (e) {
      debugPrint('Error : $e');
    }
  }

  /// api/v1/chatbot/tips
  /// 이용 꿀팁 조회
  Future<dynamic> getChatbotTips() async {
    String endPoint = 'api/v1/chatbot/tips';
    try {
      print("start");
      final response = await _getApiWithHeaderTest(endPoint);
      if (response != null) {
        debugPrint('꿀팁 조회');
        print("response : $response");
        return response;
      } else {
        debugPrint('꿀팁 조회 실패');
        return;
      }
    } catch (e) {
      debugPrint('Error : $e');
      return;
    }
  }

  /// api/v1/chatbot/clear
  /// 대화 내역 초기화
  Future<bool> deleteMessage() async {
    String endPoint = "api/v1/chatbot/clear";

    try {
      final response = await _deleteApiTest(endPoint);

      if (response != null) {
        debugPrint("메시지 delete 성공");
        return true;
      } else {
        debugPrint("메시지 delete 실패");
        return false;
      }
    } catch (e) {
      debugPrint("delete Error : $e");
      return false;
    }
  }

  /// api/v2/auth/login/kakao
  /// 카카오 로그인 (v2)
  static Future<http.Response?> getlogin(String accessToken) async {
    String url = "$baseUrl/api/v2/auth/login/kakao?accessToken=$accessToken";

    try {
      final response = await http.post(
        Uri.parse(url),
        headers: {
          "accept": "*/*",
        },
      );

      if (response.statusCode == 401) {
        // 토큰 만료 → 자동 로그아웃
        print("토큰 만료됨. 자동 로그아웃 실행.");
        LoginController().logout();
        return null;
      } else if (response.statusCode == 500) {
        // 서버 내부 오류
        print("서버 오류 (500): ${response.body}");

        return null;
      }

      debugPrint("GET 요청 성공");
      return response;
    } catch (e) {
      debugPrint('Error 발생: $e');
      return null;
    }
  }

  /// 단일 페이지 게시글 목록 조회
  /// api: api/v1/post
  Future<Map<String, dynamic>> fetchCategoryPosts({
    required int page,
    required String sort,
    required String type,
  }) async {
    try {
      String endPoint = type == "ALL"
          ? 'api/v1/post?page=$page&sort=$sort'
          : 'api/v1/post?page=$page&sort=$sort&type=$type';

      final response = await _getApiWithHeader(endPoint);

      if (response != null && response["isSuccess"] == true) {
        return response["results"] as Map<String, dynamic>;
      } else {
        debugPrint("게시글 조회 실패: ${response["message"]}");
      }
    } catch (e) {
      debugPrint("게시글 목록 조회 중 오류 발생: $e");
    }

    return {};
  }

  /// 이미지 업로드 API
  /// 서버에 이미지 업로드 후 `imageId` 반환
  /// API: api/v1/image
  Future<int?> uploadImage(File imageFile) async {
    String apiUrl = '$baseUrl/api/v1/image';
    String? access = await getToken("accessToken");

    var request = http.MultipartRequest('POST', Uri.parse(apiUrl))
      ..headers['Authorization'] = 'Bearer $access'
      ..files.add(await http.MultipartFile.fromPath('file', imageFile.path));

    try {
      var response = await request.send();
      if (response.statusCode == 200) {
        var responseBody = await response.stream.bytesToString();
        var jsonResponse = jsonDecode(responseBody);
        if (jsonResponse['isSuccess']) {
          return jsonResponse['results']['imageId']; // imageId 반환
        }
      }
      debugPrint('이미지 업로드 실패: ${response.statusCode}');
    } catch (e) {
      debugPrint('이미지 업로드 중 예외 발생: $e');
    }
    return null; // 실패 시 null 반환
  }

  /// 이미지 삭제 API
  /// API: `DELETE api/v1/image/{imageId}`
  Future<bool> deleteImage(int imageId) async {
    String endPoint = 'api/v1/image/$imageId';
    int statusCode = await _deleteApi(endPoint);

    if (statusCode == 200) {
      debugPrint('이미지 삭제 성공');
      return true;
    } else {
      debugPrint('이미지 삭제 실패: $statusCode');
      return false;
    }
  }

  /// 게시물 작성 API (`multipart/form-data`)
  /// API: api/v1/post
  Future<bool> createPost({
    required String title,
    required String content,
    required String type,
    List<int>? imageIds,
  }) async {
    String apiUrl = '$baseUrl/api/v1/post';
    String? access = await getToken("accessToken");

    try {
      Map<String, dynamic> postData = {
        "title": title,
        "content": content,
        "type": type,
        if (imageIds != null && imageIds.isNotEmpty) "imageIds": imageIds,
      };

      final response = await http.post(
        Uri.parse(apiUrl),
        headers: {
          'Authorization': 'Bearer $access',
          'accept': '*/*',
          'Content-Type': 'application/json',
        },
        body: jsonEncode(postData),
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        debugPrint('게시물 작성 성공');
        return true;
      } else {
        debugPrint('게시물 작성 실패: (${response.statusCode}) ${response.body}');
        return false;
      }
    } catch (e) {
      debugPrint('createPost Error: $e');
      return false;
    }
  }

  /// 게시글 상세 조회 API
  /// API: api/v1/post/{id}
  Future<Map<String, dynamic>?> getPostDetail(int postId) async {
    final response = await _getApiWithHeader("api/v1/post/$postId");

    if (response != null && response["isSuccess"] == true) {
      print("게시글 상세 조회 응답: $response"); // Debugging
      return response["results"]; // "results" 필드만 반환하도록 수정
    } else {
      print("게시글 조회 실패: ${response?["message"]}");
      return null;
    }
  }

  /// 내가 작성한 게시글 조회
  /// API: api/v1/user/posts
  Future<List<int>> fetchMyPosts() async {
    String endPoint = 'api/v1/user/posts';
    var response = await _getApiWithHeader(endPoint);

    if (response != null && response['isSuccess'] == true) {
      List<dynamic> posts = response['results']['postList'];

      List<int> myPostIds = posts.map<int>((post) => post['id']).toList();

      debugPrint("내가 작성한 게시글 ID 리스트: $myPostIds"); // 로그 추가

      return myPostIds; // 내가 작성한 게시글 ID 리스트 반환
    } else {
      debugPrint("내 게시글 조회 실패: ${response?['message']}");
      return [];
    }
  }

  /// 내가 작성한 게시글 조회 (상세)
  /// API: api/v1/user/posts
  Future<List<Map<String, dynamic>>> fetchMyPostDetail(int? userId) async {
    late String endPoint;
    if (userId != null) {
      endPoint = 'api/v1/user/posts?userId=$userId';
    } else {
      endPoint = 'api/v1/user/posts';
    }
    var response = await _getApiWithHeader(endPoint);

    if (response != null && response['isSuccess'] == true) {
      List<dynamic> posts = response['results'];

      List<Map<String, dynamic>> myPosts =
          posts.map((post) => Map<String, dynamic>.from(post)).toList();

      debugPrint("내가 작성한 게시글 목록 로드 완료, 개수: ${myPosts.length}개");

      return myPosts; // 게시글 전체 데이터 리스트 반환
    } else {
      debugPrint("내 게시글 조회 실패: ${response?['message']}");
      return [];
    }
  }

  /// 내가 댓글 단 게시글 조회
  /// API: api/v1/user/comment-posts
  Future<List<Map<String, dynamic>>> fetchCommentPosts(int? userId) async {
    late String endPoint;
    if (userId != null) {
      endPoint = 'api/v1/user/comment-posts?userId=$userId';
    } else {
      endPoint = 'api/v1/user/comment-posts';
    }
    var response = await _getApiWithHeader(endPoint);

    if (response != null && response['isSuccess'] == true) {
      List<dynamic> posts = response['results'];

      List<Map<String, dynamic>> myPosts =
          posts.map((post) => Map<String, dynamic>.from(post)).toList();

      debugPrint("내가 댓글 단 게시글 목록 로드 완료, 개수: ${myPosts.length}개");

      return myPosts; // 게시글 전체 데이터 리스트 반환
    } else {
      debugPrint("내가 댓글 단 게시글 조회 실패: ${response?['message']}");
      return [];
    }
  }

  /// 내가 참여한 경제톡톡 조회
  /// API: api/v1/user/toktok
  Future<List<Map<String, dynamic>>> fetchTokTok(int? userId) async {
    late String endPoint;
    if (userId != null) {
      endPoint = 'api/v1/user/toktok?userId=$userId';
    } else {
      endPoint = 'api/v1/user/toktok';
    }
    var response = await _getApiWithHeader(endPoint);

    if (response != null && response['isSuccess'] == true) {
      List<dynamic> posts = response['results'];

      List<Map<String, dynamic>> myPosts =
          posts.map((post) => Map<String, dynamic>.from(post)).toList();

      debugPrint("내가 참여한 경제톡톡 목록 로드 완료, 개수: ${myPosts.length}개");

      return myPosts; // 게시글 전체 데이터 리스트 반환
    } else {
      debugPrint("내가 참여한 경제톡톡 조회 실패: ${response?['message']}");
      return [];
    }
  }

  /// 게시물 댓글 추가 API
  /// API: api/v1/post/{id}/comments
  Future<bool> addComment(int postId, String content) async {
    String endpoint = 'api/v1/post/$postId/comments';
    Map<String, dynamic> jsonData = {
      "content": content,
    };

    try {
      final response = await postApiWithJson(endpoint, jsonData);

      if (response == 200) {
        debugPrint('댓글 추가 성공');
        return true;
      } else {
        debugPrint('댓글 추가 실패: (${response.statusCode} ${response.body})');
        return false;
      }
    } catch (e) {
      debugPrint('댓글 추가 중 예외 발생: $e');
      return false;
    }
  }

  /// 댓글 답글 추가 API
  /// API: api/v1/post/{id}/comments/{commentsId}/reply
  Future<bool> addReply(int postId, int commentsId, String content) async {
    String endpoint = 'api/v1/post/$postId/comments/$commentsId/reply';
    Map<String, dynamic> jsonData = {
      "content": content,
    };

    try {
      final response = await postApiWithJson(endpoint, jsonData);

      if (response == 200) {
        debugPrint('댓글 추가 성공');
        return true;
      } else {
        debugPrint('댓글 추가 실패: (${response.statusCode} ${response.body})');
        return false;
      }
    } catch (e) {
      debugPrint('댓글 추가 중 예외 발생: $e');
      return false;
    }
  }

  /// 게시물 좋아요 API
  /// API: api/v1/post/{id}/like
  Future<bool> likePost(int postId) async {
    String endpoint = 'api/v1/post/$postId/like';

    try {
      final statusCode = await _postApi(endpoint);

      if (statusCode == 200) {
        debugPrint('게시물 좋아요');
        return true;
      } else {
        debugPrint('게시물 좋아요 실패: ($statusCode)');
        return false;
      }
    } catch (e) {
      debugPrint('게시물 좋아요 중 예외 발생: $e');
      return false;
    }
  }

  /// 게시물 좋아요 취소 API
  /// API: api/v1/post/{id}/like
  Future<bool> deleteLikedPost(int postId) async {
    String endPoint = 'api/v1/post/$postId/like';

    try {
      final response = await _deleteApi(endPoint);

      if (response == 200) {
        debugPrint('게시물 좋아요 취소');
        return true;
      } else {
        debugPrint('게시물 좋아요 취소 실패: (${response.statusCode} ${response.body})');
        return false;
      }
    } catch (e) {
      debugPrint('게시물 좋아요 취소 중 예외 발생: $e');
      return false;
    }
  }

  /// 게시물 댓글 좋아요 API
  /// API: api/v1/post/{id}/comments/{commentId}/like
  Future<bool> likeComment(int postId, int commentId) async {
    String endpoint = 'api/v1/post/$postId/comments/$commentId/like';

    try {
      final response = await _postApi(endpoint);

      if (response == 200) {
        debugPrint('게시물 댓글 좋아요');
        return true;
      } else {
        debugPrint('게시물 댓글 좋아요 실패: (${response.statusCode} ${response.body})');
        return false;
      }
    } catch (e) {
      debugPrint('게시물 댓글 좋아요 중 예외 발생: $e');
      return false;
    }
  }

  /// 댓글 좋아요 취소 API
  /// API: api/v1/post/{id}/comments/{commentId}/like
  Future<bool> deleteLikedComment(int postId, int commentId) async {
    String endPoint = 'api/v1/post/$postId/comments/$commentId/like';

    try {
      final response = await _deleteApi(endPoint);

      if (response == 200) {
        debugPrint('댓글 좋아요 취소');
        return true;
      } else {
        debugPrint('댓글 좋아요 취소 실패: (${response.statusCode} ${response.body})');
        return false;
      }
    } catch (e) {
      debugPrint('댓글 좋아요 취소 중 예외 발생: $e');
      return false;
    }
  }

  /// 게시물 스크랩 API
  /// API: api/v1/post/{id}/scrap
  Future<bool> scrapPost(int postId) async {
    String endpoint = 'api/v1/post/$postId/scrap';

    try {
      final response = await _postApi(endpoint);

      if (response == 200) {
        debugPrint('게시물 스크랩');
        return true;
      } else {
        debugPrint('게시물 스크랩 좋아요 실패: (${response.statusCode} ${response.body})');
        return false;
      }
    } catch (e) {
      debugPrint('게시물 스크랩 좋아요 중 예외 발생: $e');
      return false;
    }
  }

  /// 게시물 스크랩 취소 API
  /// API: api/v1/post/{id}/scrap
  Future<bool> deletePostScrap(int postId) async {
    String endPoint = 'api/v1/post/$postId/scrap';

    try {
      final response = await _deleteApi(endPoint);

      if (response == 200) {
        debugPrint('게시물 스크랩 취소');
        return true;
      } else {
        debugPrint('게시물 스크랩 취소 실패: (${response.statusCode} ${response.body})');
        return false;
      }
    } catch (e) {
      debugPrint('게시물 스크랩 취소 중 예외 발생: $e');
      return false;
    }
  }

  /// 게시물 수정 api
  /// API: api/v1/post/{id}
  Future<bool> editPost(int postId, Map<String, dynamic> postData) async {
    String endpoint = 'api/v1/post/$postId';

    try {
      final response = await _patchApi(endpoint, jsonEncode(postData));

      if (response == 200) {
        debugPrint('게시물 수정 성공');
        return true;
      } else {
        debugPrint('게시물 수정 실패: (${response.statusCode} ${response.body})');
        return false;
      }
    } catch (e) {
      debugPrint('게시물 수정 중 예외 발생: $e');
      return false;
    }
  }

  /// 게시물 댓글 수정 api
  /// API: api/v1/post/{id}/comments/{commentId}
  Future<bool> editComment(int postId, int commentId, String content) async {
    String endpoint = 'api/v1/post/$postId/comments/$commentId';
    Map<String, dynamic> jsonData = {
      "content": content,
    };

    try {
      final response = await _patchApi(endpoint, jsonEncode(jsonData));

      if (response == 200) {
        debugPrint('댓글 수정 성공');
        return true;
      } else {
        debugPrint('댓글 수정 실패: (${response.statusCode} ${response.body})');
        return false;
      }
    } catch (e) {
      debugPrint('댓글 수정 중 예외 발생: $e');
      return false;
    }
  }

  /// 게시물 삭제 api
  /// API: api/v1/post/{id}
  Future<bool> deletePost(int postId) async {
    String endpoint = 'api/v1/post/$postId';

    try {
      final response = await _deleteApi(endpoint);

      if (response == 200) {
        debugPrint('게시물 삭제 성공');
        return true;
      } else {
        debugPrint('게시물 삭제 실패: (${response.statusCode} ${response.body})');
        return false;
      }
    } catch (e) {
      debugPrint('게시물 삭제 중 예외 발생: $e');
      return false;
    }
  }

  /// 게시물 댓글 삭제 api
  /// API: api/v1/post/{id}/comments/{commentId}
  Future<bool> deleteComment(int postId, int commentId) async {
    String endpoint = 'api/v1/post/$postId/comments/$commentId';

    try {
      final response = await _deleteApi(endpoint);

      if (response == 200) {
        debugPrint('댓글 삭제 성공');
        return true;
      } else {
        debugPrint('댓글 삭제 실패: (${response.statusCode} ${response.body})');
        return false;
      }
    } catch (e) {
      debugPrint('댓글 삭제 중 예외 발생: $e');
      return false;
    }
  }

  /// 단일 페이지 경제톡톡 목록 조회
  /// api: api/v1/post/toktok
  Future<Map<String, dynamic>> fetchTokLists({
    required int page,
    required String sort,
  }) async {
    try {
      final endPoint = 'api/v1/post/toktok?page=$page&sort=$sort';
      final response = await _getApiWithHeader(endPoint);

      if (response != null && response["isSuccess"] == true) {
        return response["results"] as Map<String, dynamic>;
      } else {
        debugPrint("경제톡톡 조회 실패: ${response["message"]}");
      }
    } catch (e) {
      debugPrint("경제톡톡 목록 조회 중 오류 발생: $e");
    }

    return {};
  }

  /// 경제톡톡 게시물 상세 조회 API
  /// API: api/v1/post/toktok/{id}
  Future<Map<String, dynamic>?> getTokDetail(int postId) async {
    final response = await _getApiWithHeader("api/v1/post/toktok/$postId");

    if (response != null && response["isSuccess"] == true) {
      print("경제톡톡 게시글 상세 조회 응답: ${response["results"]}"); // Debugging
      return response["results"]; // "results" 필드만 반환하도록 수정
    } else {
      print("경제톡톡 게시글 조회 실패: ${response?["message"]}");
      return null;
    }
  }

  /// 오늘의 경제톡톡 주제 조회
  /// API: api/v1/post/toktok-today
  Future<Map<String, dynamic>?> getTodaysTok() async {
    final response = await _getApiWithHeader("api/v1/post/toktok-today");

    if (response != null && response["isSuccess"] == true) {
      print("오늘의 경제톡톡 조회 응답: $response"); // Debugging
      return response["results"]; // "results" 필드만 반환하도록 수정
    } else {
      print("오늘의 경제톡톡 조회 실패: ${response?["message"]}");
      return null;
    }
  }

  /// 알림 조회
  /// API: api/v1/notification
  Future<dynamic> getNotification() async {
    String endpoint = 'api/v1/notification';

    try {
      final response = await _getApiWithHeader(endpoint);

      if (response != null && response is Map<String, dynamic>) {
        debugPrint('알림 데이터 로드 성공');
        return response;
      } else {
        debugPrint('알림 데이터 로드 실패');
        return null;
      }
    } catch (e) {
      debugPrint('getNotification Error: $e');
      return null;
    }
  }

  /// 알림 확인
  /// API: api/v1/notification/{notificationId}/check
  Future<bool> checkNotification(int notificationId) async {
    String endpoint = 'api/v1/notification/$notificationId/check';

    try {
      final response = await _postApi(endpoint);

      if (response == 200) {
        debugPrint('알림 확인 성공');
        return true;
      } else {
        debugPrint('알림 확인 실패: (${response.statusCode} ${response.body})');
        return false;
      }
    } catch (e) {
      debugPrint('알림 확인 중 예외 발생: $e');
      return false;
    }
  }

  /// 알림 삭제
  /// API: api/v1/notification/{notificationId}
  Future<bool> deleteNotification(int notificationId) async {
    String endpoint = 'api/v1/notification/$notificationId';

    try {
      final response = await _deleteApi(endpoint);

      if (response == 200) {
        debugPrint('알림 삭제 성공');
        return true;
      } else {
        debugPrint('알림 삭제 실패: (${response.statusCode} ${response.body})');
        return false;
      }
    } catch (e) {
      debugPrint('알림 삭제 중 예외 발생: $e');
      return false;
    }
  }

  /// 최근 검색어 조회
  /// API: api/v1/notification
  Future<dynamic> getRecentSearch() async {
    String endpoint = 'api/v1/search/recent';

    try {
      final response = await _getApiWithHeader(endpoint);

      if (response != null && response is Map<String, dynamic>) {
        debugPrint('최근 검색어 데이터 로드 성공');
        return response;
      } else {
        debugPrint('최근 검색어 데이터 로드 실패');
        return null;
      }
    } catch (e) {
      debugPrint('getRecentSearch Error: $e');
      return null;
    }
  }

  /// 검색어 삭제
  /// API: api/v1/search/recent
  Future<bool> deleteRecentSearch(String keyword) async {
    String endpoint = 'api/v1/search/recent?keyword=$keyword';

    try {
      final response = await _deleteApi(endpoint);

      if (response == 200) {
        debugPrint('검색어 삭제 성공');
        return true;
      } else {
        debugPrint('검색어 삭제 실패: (${response.statusCode} ${response.body})');
        return false;
      }
    } catch (e) {
      debugPrint('검색어 삭제 중 예외 발생: $e');
      return false;
    }
  }

  /// 검색어 전체 삭제
  /// API: api/v1/search/recent/all
  Future<bool> deleteRecentSearchAll() async {
    String endpoint = 'api/v1/search/recent/all';

    try {
      final response = await _deleteApi(endpoint);

      if (response == 200) {
        debugPrint('검색어 전체 삭제 성공');
        return true;
      } else {
        debugPrint('검색어 전체 삭제 실패: (${response.statusCode} ${response.body})');
        return false;
      }
    } catch (e) {
      debugPrint('검색어 전체 삭제 중 예외 발생: $e');
      return false;
    }
  }

  /// 용어 검색
  /// api: api/v1/search/terms
  Future<Map<String, dynamic>> searchTermsPaged(
      String keyword, int page) async {
    try {
      final endPoint = 'api/v1/search/terms?keyword=$keyword&page=$page';
      final response = await _getApiWithHeader(endPoint);

      if (response != null && response["isSuccess"] == true) {
        return {
          "termList": response["results"]["termList"],
          "totalPage": response["results"]["totalPage"],
          "currentPage": page,
        };
      } else {
        debugPrint("용어 검색 실패: ${response["message"]}");
        return {
          "termList": [],
          "totalPage": 0,
          "currentPage": page,
        };
      }
    } catch (e) {
      debugPrint("searchTermsPaged 오류: $e");
      return {
        "termList": [],
        "totalPage": 0,
        "currentPage": page,
      };
    }
  }

  /// 게시글 검색
  /// api: api/v1/search/posts
  Future<Map<String, dynamic>> searchPostsPaged(
      String keyword, int page) async {
    try {
      final endPoint = 'api/v1/search/posts?keyword=$keyword&page=$page';
      final response = await _getApiWithHeader(endPoint);

      if (response != null && response["isSuccess"] == true) {
        return {
          "postList": response["results"]["postPreviewList"],
          "totalPage": response["results"]["totalPage"],
          "currentPage": page,
        };
      } else {
        debugPrint("게시글 검색 실패: ${response["message"]}");
        return {
          "postList": [],
          "totalPage": 0,
          "currentPage": page,
        };
      }
    } catch (e) {
      debugPrint("searchPostsPaged 오류: $e");
      return {
        "postList": [],
        "totalPage": 0,
        "currentPage": page,
      };
    }
  }

  /// 뉴스 검색
  /// api: api/v1/search/news
  Future<Map<String, dynamic>> searchNewsPaged(String keyword, int page) async {
    try {
      final endPoint = 'api/v1/search/news?keyword=$keyword&page=$page';
      final response = await _getApiWithHeader(endPoint);

      if (response != null && response["isSuccess"] == true) {
        return {
          "newsList": response["results"]["newsList"],
          "totalPage": response["results"]["totalPage"],
          "currentPage": page,
        };
      } else {
        debugPrint("뉴스 검색 실패: ${response["message"]}");
        return {
          "newsList": [],
          "totalPage": 0,
          "currentPage": page,
        };
      }
    } catch (e) {
      debugPrint("searchNewsPaged 오류: $e");
      return {
        "newsList": [],
        "totalPage": 0,
        "currentPage": page,
      };
    }
  }

  /// api/v1/level-test/quiz
  /// 레벨 테스트 퀴즈 목록 조회
  Future<dynamic> getLevelTestQuizList() async {
    dynamic response;
    String endPoint = "api/v1/level-test/quiz";

    response = await _getApi(endPoint);

    if (response != null) {
      print("응답 데이터 : $response");
    } else {
      print("get 데이터 실패");
    }
    return response;
  }

  /// api/v1/level-test/result
  /// 레벨 테스트 결과 제출
  Future<dynamic> postLevelTestResult({
    required List<Map<String, dynamic>> answersJson,
    required String anonymousKey,
  }) async {
    String endPoint =
        "api/v1/level-test/result?levelTestSessionKey=$anonymousKey";

    Map<String, dynamic> requestBody = {
      "answers": answersJson,
    };

    print("요청 URL: $endPoint");
    print("post 본문: ${jsonEncode(requestBody)}");

    try {
      dynamic response =
          await postApiWithJsonReturnResponse(endPoint, requestBody);

      if (response != null) {
        debugPrint("레벨테스트 POST 성공: $response");
        return response;
      } else {
        debugPrint("레벨테스트 POST 실패");
      }
    } catch (e) {
      debugPrint("Error 발생: $e");
    }

    return null;
  }

  /// 톡톡 게시글 검색
  /// api: api/v1/search/toktoks
  Future<Map<String, dynamic>> searchTokToksPaged(
      String keyword, int page) async {
    try {
      final endPoint = 'api/v1/search/toktoks?keyword=$keyword&page=$page';
      final response = await _getApiWithHeader(endPoint);

      if (response != null && response["isSuccess"] == true) {
        return {
          "tokList": response["results"]["postPreviewList"],
          "totalPage": response["results"]["totalPage"],
          "currentPage": page,
        };
      } else {
        debugPrint("톡톡 검색 실패: ${response["message"]}");
        return {
          "tokList": [],
          "totalPage": 0,
          "currentPage": page,
        };
      }
    } catch (e) {
      debugPrint("searchTokToksPaged 오류: $e");
      return {
        "tokList": [],
        "totalPage": 0,
        "currentPage": page,
      };
    }
  }

  /// 사용자 퀘스트 목표 조회
  /// api: api/v1/user/goal
  Future<Map<String, dynamic>?> getUserGoal() async {
    final response = await _getApiWithHeader("api/v1/user/goal");

    if (response != null && response["isSuccess"] == true) {
      print("사용자 퀘스트 목표 조회 응답: $response"); // Debugging
      return response["results"];
    } else {
      print("사용자 퀘스트 목표 조회 실패: ${response?["message"]}");
      return null;
    }
  }

  /// 사용자 퀘스트 목표 수정
  /// API: api/v1/user/goal
  Future<bool> setUserGoal(Map<String, int> goal) async {
    String endpoint = 'api/v1/user/goal';

    try {
      final response = await postApiWithJson(endpoint, goal);

      if (response == 200) {
        debugPrint('사용자 퀘스트 목표 수정');
        return true;
      } else {
        debugPrint(
            '사용자 퀘스트 목표 수정 실패: (${response.statusCode} ${response.body})');
        return false;
      }
    } catch (e) {
      debugPrint('사용자 퀘스트 목표 수정 중 예외 발생: $e');
      return false;
    }
  }

  /// 프로필 이미지 업로드 API
  /// 서버에 이미지 업로드 후 `imageId` 반환
  /// API: api/v1/image/profile
  Future<int?> uploadProfileImage(File imageFile) async {
    String apiUrl = '$baseUrl/api/v1/image/profile';
    String? access = await getToken("accessToken");

    var request = http.MultipartRequest('POST', Uri.parse(apiUrl))
      ..headers['Authorization'] = 'Bearer $access'
      ..files.add(await http.MultipartFile.fromPath('file', imageFile.path));

    try {
      var response = await request.send();
      if (response.statusCode == 200) {
        var responseBody = await response.stream.bytesToString();
        var jsonResponse = jsonDecode(responseBody);
        if (jsonResponse['isSuccess']) {
          return jsonResponse['results']['imageId']; // imageId 반환
        }
      }
      debugPrint('이미지 업로드 실패: ${response.statusCode}');
    } catch (e) {
      debugPrint('이미지 업로드 중 예외 발생: $e');
    }
    return null; // 실패 시 null 반환
  }

  /// 내가 스크랩한 용어 조회 (자음 별)
  /// api: api/v1/user/scrap-terms
  Future<List<dynamic>> fetchScrapedTerms(String? initial) async {
    List<dynamic> terms = [];

    try {
      String endPoint;

      if (initial == null) {
        // 자음이 없는 경우
        endPoint = 'api/v1/user/scrap-terms';
      } else {
        // 자음이 있는 경우
        endPoint = 'api/v1/user/scrap-terms?initial=$initial';
      }

      var response = await _getApiWithHeader(endPoint);

      if (response != null && response["isSuccess"] == true) {
        var results = response["results"];
        terms.addAll(results["termList"]);
      } else {
        debugPrint("스크랩한 용어 (자음 별) 조회 실패: ${response["message"]}");
      }
    } catch (e) {
      debugPrint("스크랩한 용어 (자음 별) 조회 중 오류 발생: $e");
    }

    return terms;
  }

  /// 내가 스크랩한 용어 검색
  /// api: api/v1/user/scrap-terms/search
  Future<List<dynamic>> searchScrapedTerms(String? keyword) async {
    List<dynamic> terms = [];

    try {
      String endPoint;

      if (keyword == null) {
        // 키워드가 없는 경우
        endPoint = 'api/v1/user/scrap-terms/search';
      } else {
        // 키워드가 있는 경우
        endPoint = 'api/v1/user/scrap-terms/search?keyword=$keyword';
      }

      var response = await _getApiWithHeader(endPoint);

      if (response != null && response["isSuccess"] == true) {
        var results = response["results"];
        terms.addAll(results["termList"]);
      } else {
        debugPrint("스크랩한 용어 검색 실패: ${response["message"]}");
      }
    } catch (e) {
      debugPrint("스크랩한 용어 검색 중 오류 발생: $e");
    }

    return terms;
  }

  /// 내가 스크랩한 뉴스 조회
  /// api: api/v1/user/scrap-news
  Future<List<dynamic>> fetchScrapedNews() async {
    List<dynamic> news = [];

    try {
      String endPoint = 'api/v1/user/scrap-news';

      var response = await _getApiWithHeader(endPoint);

      if (response != null && response["isSuccess"] == true) {
        var results = response["results"];
        news.addAll(results["newsList"]);
      } else {
        debugPrint("스크랩한 뉴스 조회 실패: ${response["message"]}");
      }
    } catch (e) {
      debugPrint("스크랩한 뉴스 조회 중 오류 발생: $e");
    }

    return news;
  }

  /// 요일별 출석 현황 조회
  /// API: api/v1/attencance/weekly-attendance
  Future<Map<String, bool>> fetchWeeklyAttendance() async {
    Map<String, bool> attendance = {
      "monday": false,
      "tuesday": false,
      "wednesday": false,
      "thursday": false,
      "friday": false,
      "saturday": false,
      "sunday": false,
    };

    try {
      String endPoint = 'api/v1/attencance/weekly-attendance';
      var response = await _getApiWithHeader(endPoint);

      if (response != null && response["isSuccess"] == true) {
        var results = response["results"] as Map<String, dynamic>?;

        if (results != null) {
          attendance =
              results.map((key, value) => MapEntry(key, value as bool));
        }
      } else {
        debugPrint("요일별 출석 현황 조회 실패: ${response["message"]}");
      }
    } catch (e) {
      debugPrint("요일별 출석 현황 조회 중 오류 발생: $e");
    }

    return attendance;
  }

  /// 연속 출석 날짜 조회
  /// api: api/v1/attencance/current-streak
  Future<int> fetchCurrentStreak() async {
    int result = -1;

    try {
      String endPoint = 'api/v1/attencance/current-streak';

      var response = await _getApiWithHeader(endPoint);

      if (response != null && response["isSuccess"] == true) {
        result = response["results"];
      } else {
        debugPrint("연속 출석 날짜 조회 실패: ${response["message"]}");
      }
    } catch (e) {
      debugPrint("연속 출석 날짜 조회 중 오류 발생: $e");
    }

    return result;
  }

  /// 회원 정보 조회
  /// api: api/v1/user/info
  Future<Map<String, dynamic>> fetchUserInfo(int? userId) async {
    try {
      late String endPoint;
      if (userId != null) {
        endPoint = 'api/v1/user/info?userId=$userId';
      } else {
        endPoint = 'api/v1/user/info';
      }
      var response = await _getApiWithHeader(endPoint);

      // 응답이 null인지 체크
      if (response == null) {
        debugPrint("API 응답이 null입니다.");
        return {}; // 빈 Map 반환
      }

      // 응답이 성공적인지 체크
      if (response["isSuccess"] == true) {
        // results가 존재하는지 체크하여 기본값 설정
        final results = response["results"];
        if (results != null && results is Map<String, dynamic>) {
          return results;
        } else {
          debugPrint("사용자 프로필 조회 실패: results가 null이거나 올바른 형식이 아님");
          return {}; // 빈 Map 반환
        }
      } else {
        debugPrint("사용자 프로필 조회 실패: ${response["message"]}");
        return {}; // 빈 Map 반환
      }
    } catch (e) {
      debugPrint("사용자 프로필 조회 중 오류 발생: $e");
      return {}; // 예외 발생 시 빈 Map 반환
    }
  }

  /// 사용자 정보 조회 (토큰 기반)
  /// GET: api/v1/user/info (Authorization 헤더 필요)
  Future<Map<String, dynamic>> fetchUserInfoByToken() async {
    try {
      const endPoint = 'api/v1/user/info';

      final response = await _getApiWithHeader(endPoint); // 헤더 포함 요청

      // 응답이 null인지 체크
      if (response == null) {
        debugPrint("[fetchUserInfoByToken] 응답이 null입니다.");
        return {};
      }

      // 성공 응답 처리
      if (response["isSuccess"] == true) {
        final results = response["results"];
        if (results != null && results is Map<String, dynamic>) {
          return results;
        } else {
          debugPrint("[fetchUserInfoByToken] results가 null이거나 잘못된 형식입니다.");
          return {};
        }
      }

      // 프로필 미설정 여부 확인
      if (response["code"] == "ATTENDANCE_NOT_FOUND") {
        debugPrint("[fetchUserInfoByToken] 프로필 미설정 상태 (ATTENDANCE_NOT_FOUND)");
        return {};
      }

      debugPrint("[fetchUserInfoByToken] 실패 메시지: ${response["message"]}");
      return {};
    } catch (e) {
      debugPrint("[fetchUserInfoByToken] 예외 발생: $e");
      return {};
    }
  }

  /// 푸시 알림 설정
  /// API: api/v1/user/alarm
  Future<bool> setAlarm(bool alarm) async {
    String endpoint = 'api/v1/user/alarm?alarm=$alarm';

    try {
      final response = await _postApi(endpoint);

      if (response == 200) {
        debugPrint('푸시 알림 설정');
        return true;
      } else {
        debugPrint('푸시 알림 설정 실패: (${response.statusCode} ${response.body})');
        return false;
      }
    } catch (e) {
      debugPrint('푸시 알림 설정 중 예외 발생: $e');
      return false;
    }
  }

  /// 레벨별 학습 세트 조회
  /// API: api/v1/learning
  Future<List<Map<String, dynamic>>> fetchLearningList() async {
    List<Map<String, dynamic>> learningList = [];

    try {
      String endPoint = 'api/v1/learning';

      var response = await _getApiWithHeader(endPoint);

      if (response != null && response["isSuccess"] == true) {
        learningList = List<Map<String, dynamic>>.from(response["results"]);
      } else {
        debugPrint("학습 세트 미리보기 조회 실패: ${response?["message"]}");
      }
    } catch (e) {
      debugPrint("학습 세트 미리보기 조회 중 오류 발생: $e");
    }

    return learningList;
  }

  /// 개념 학습 세트 조회
  /// API: api/v1/learning/{learningSetId}/concepts
  Future<List<Map<String, dynamic>>> fetchLearningConcepts(
      int learningSetId, String level) async {
    List<Map<String, dynamic>> conceptList = [];

    try {
      String endPoint = 'api/v1/learning/$learningSetId/concepts?level=$level';

      var response = await _getApiWithHeader(endPoint);

      if (response != null && response["isSuccess"] == true) {
        conceptList = List<Map<String, dynamic>>.from(response["results"]);
      } else {
        debugPrint("레벨별 개념 학습 세트 조회 실패: ${response?["message"]}");
      }
    } catch (e) {
      debugPrint("레벨별 개념 학습 세트 조회 중 오류 발생: $e");
    }

    return conceptList;
  }

  /// 개념 학습 스크랩
  /// API: api/v1/learning/concept/{conceptId}/scrap
  Future<bool> scrapLearningConcept(int conceptId) async {
    String endpoint = 'api/v1/learning/concept/$conceptId/scrap';

    try {
      final response = await _postApi(endpoint);

      if (response == 200) {
        debugPrint('개념 학습 스크랩');
        return true;
      } else {
        debugPrint('개념 학습 스크랩 실패: (${response.statusCode} ${response.body})');
        return false;
      }
    } catch (e) {
      debugPrint('개념 학습 스크랩 중 예외 발생: $e');
      return false;
    }
  }

  /// 개념 학습 스크랩 취소
  /// API: api/v1/learning/concept/{conceptId}/scrap
  Future<bool> deleteConceptScrap(int conceptId) async {
    String endpoint = 'api/v1/learning/concept/$conceptId/scrap';

    try {
      final response = await _deleteApi(endpoint);

      if (response == 200) {
        debugPrint('개념 학습 스크랩 취소 성공');
        return true;
      } else {
        debugPrint(
            '개념 학습 스크랩 삭제 실패: (${response.statusCode} ${response.body})');
        return false;
      }
    } catch (e) {
      debugPrint('개념 학습 스크랩 삭제 중 예외 발생: $e');
      return false;
    }
  }

  /// 개념 학습 완료 처리
  /// API: api/v1/learning/{learningSetId}/concepts/complete
  Future<bool> completeLearningConcept(int learningSetId, String level) async {
    String endpoint =
        'api/v1/learning/$learningSetId/concepts/complete?level=$level';

    try {
      final response = await _postApi(endpoint);

      if (response == 200) {
        debugPrint('개념 학습 완료 처리');
        return true;
      } else {
        debugPrint('개념 학습 완료 처리 실패: (${response.statusCode} ${response.body})');
        return false;
      }
    } catch (e) {
      debugPrint('개념 학습 완료 처리 중 예외 발생: $e');
      return false;
    }
  }

  /// 개별 개념 학습 조회
  /// API: api/v1/learning/concept/{conceptId}
  Future<Map<String, dynamic>> fetchSingleConcept(int conceptId) async {
    Map<String, dynamic> concept = {};

    try {
      String endPoint = 'api/v1/learning/concept/$conceptId';

      var response = await _getApiWithHeader(endPoint);

      if (response != null && response["isSuccess"] == true) {
        concept = Map<String, dynamic>.from(response["results"]);
      } else {
        debugPrint("개별 개념 학습 조회 실패: ${response?["message"]}");
      }
    } catch (e) {
      debugPrint("개별 개념 학습 조회 중 오류 발생: $e");
    }

    return concept;
  }

  /// 오늘의 퀘스트 완료 여부 조회
  /// API: api/v1/attendance/today-quest
  Future<Map<String, dynamic>> fetchTodayQuestProgress() async {
    String endPoint = 'api/v1/attencance/today-quest';

    try {
      var response = await _getApiWithHeader(endPoint);

      if (response != null && response['isSuccess'] == true) {
        return Map<String, dynamic>.from(response['results']);
      } else {
        debugPrint("오늘의 퀘스트 완료 여부 조회 실패: ${response?['message']}");
        return {};
      }
    } catch (e) {
      debugPrint("fetchTodayQuestProgress() 오류 발생: $e");
      return {};
    }
  }

  /// 인기 게시글 목록 조회
  /// api: api/v1/post/popular
  Future<Map<String, dynamic>?> getPopularPosts() async {
    return await _getApiWithHeader('api/v1/post/popular');
  }

  /// 유저가 완료한 학습과 퀴즈 갯수 반환
  /// API: api/v1/user/completed
  Future<Map<String, dynamic>> fetchUserCompleted() async {
    String endPoint = 'api/v1/user/completed';

    try {
      var response = await _getApiWithHeader(endPoint);

      if (response != null && response['isSuccess'] == true) {
        return Map<String, int>.from(response['results']);
      } else {
        debugPrint("유저가 완료한 학습과 퀴즈 갯수 조회 실패: ${response?['message']}");
        return {};
      }
    } catch (e) {
      debugPrint("fetchUserCompleted() 오류 발생: $e");
      return {};
    }
  }

  /// 학습 세트 별 완료한 퀴즈 조회
  /// API: api/v1/learning/{learningSetId}/quizzes
  Future<Map<String, dynamic>> fetchCompletedQuizzes(int learningSetId) async {
    String endPoint = 'api/v1/learning/$learningSetId/quizzes';

    try {
      var response = await _getApiWithHeader(endPoint);

      if (response != null && response['isSuccess'] == true) {
        return Map<String, bool>.from(response['results']['results']);
      } else {
        debugPrint("학습 세트 별 유저가 완료한 퀴즈 조회 실패: ${response?['message']}");
        return {};
      }
    } catch (e) {
      debugPrint("fetchCompleteQuizzes 오류 발생: $e");
      return {};
    }
  }

  /// api/v1/learning/{learningSetId}/quizzes
  /// 퀴즈 시작
  Future<dynamic> getQuizList(int learningSetId, String level) async {
    dynamic response;
    String endPoint =
        "api/v1/learning/quizzes?learningSetId=$learningSetId&level=$level";

    response = await postApiWithoutJsonReturnResponse(endPoint);
    // print("response : $")

    if (response != null) {
      debugPrint("퀴즈 POST 성공: $response");
      return response; // 성공하면 응답 반환
    } else {
      debugPrint("퀴즈 POST 실패");
    }
    return response;
  }

  /// api/v1/learning/{learningSetId}/quizzes/{quizId}
  /// 퀴즈 제출
  Future<dynamic> postSubmitQuiz(int quizId, int answerIndex) async {
    dynamic response;
    print("postSubmitQuiz 안 : $quizId, $answerIndex");
    String endPoint =
        "api/v1/learning/quizzes/$quizId?answerIndex=$answerIndex";

    response = await postApiWithoutJsonReturnResponse(endPoint);

    if (response != null) {
      debugPrint("퀴즈 제출 POST 성공 : $response");
      return response; // 성공하면 응답 반환
    } else {
      debugPrint("퀴즈 제출 POST 실패");
    }
    return response;
  }

  /// api/v1/learning/quiz/{quizId}/retry?answerIndex={answerIndex}
  /// 개별 퀴즈 재도전
  Future<dynamic> postSubmitQuizRetry(int quizId, int answerIndex) async {
    dynamic response;
    print("postSubmitQuiz 안 : $quizId, $answerIndex");
    String endPoint =
        "api/v1/learning/quiz/$quizId/retry?answerIndex=$answerIndex";

    response = await postApiWithoutJsonReturnResponse(endPoint);

    if (response != null) {
      debugPrint("퀴즈 재제출 POST 성공 : $response");
      return response; // 성공하면 응답 반환
    } else {
      debugPrint("퀴즈 재제출 POST 실패");
    }
    return response;
  }

  /// api/v1/learning/{learningSetId}/quizzes/end
  /// 퀴즈 완료
  Future<dynamic> postQuizFinish(int learningSetId, String level) async {
    dynamic response;

    String endPoint = "api/v1/learning/quizzes/end";
    response = await postApiWithoutJsonReturnResponse(endPoint);

    if (response != null) {
      debugPrint("퀴즈 완료 POST 성공 : $response");
      return response; // 성공하면 응답 반환
    } else {
      debugPrint("퀴즈 완료 POST 실패");
    }
    return response;
  }

  /// api/v1/learning/quiz/{quizId}/scrap
  /// 퀴즈 스크랩
  Future<dynamic> postScrapQuiz(int quizId) async {
    dynamic response;
    String endPoint = "api/v1/learning/quiz/$quizId/scrap";

    response = await postApiWithoutJsonReturnResponse(endPoint);
    if (response != null) {
      debugPrint("퀴즈 스크랩 POST 성공 : $response");
    } else {
      debugPrint("퀴즈 스크랩 POST 실패");
    }
  }

  /// api/v1/learning/quiz/1/scrap
  /// 퀴즈 스크랩 취소
  Future<dynamic> postScrapDeleteQuiz(int quizId) async {
    dynamic response;
    String endPoint = 'api/v1/learning/quiz/$quizId/scrap';

    response = await postApiWithoutJsonReturnResponse(endPoint);
    if (response != null) {
      debugPrint("퀴즈 스크랩 취소 POST성공 : $response");
    } else {
      debugPrint("퀴즈 스크랩 취소 POST 실패");
    }
  }

  /// 알림 구독 (SSE)
  /// api: api/v1/notification/subscribe
  Future<StreamSubscription?> subscribeToNotifications({
    Function(String)? onNotificationReceived,
  }) async {
    final access = await getToken("accessToken");
    if (access == null) {
      print("SSE 연결 실패: 액세스 토큰 없음");
      return null;
    }

    try {
      print("--SUBSCRIBING TO SSE---");

      final stream = SSEClient.subscribeToSSE(
        url: '$baseUrl/api/v1/notification/subscribe',
        header: {
          "Authorization": "Bearer $access",
          "Accept": "text/event-stream",
        },
        method: SSERequestType.GET,
      );

      final subscription = stream.listen(
        (SSEModel event) {
          print("[RemoteDataSource] SSE 이벤트 수신 시도");

          if (event.data == null) {
            print("[RemoteDataSource] SSE 이벤트가 도착했지만 data 없음: $event");
          } else {
            print("[RemoteDataSource] SSE 이벤트 수신: ${event.data}");
            onNotificationReceived?.call(event.data!);
          }
        },
        onError: (error) {
          print("[RemoteDataSource] SSE 오류: $error");
        },
      );

      print("SSE 연결 성공");
      return subscription;
    } catch (e, st) {
      print("SSE 구독 실패: $e");
      print(st);
      return null;
    }
  }

  /// 알림 구독 해제
  /// api: api/v1/notification/unsubscribe
  Future<bool> unsubscribeFromNotifications() async {
    final access = await getToken("accessToken");
    if (access == null) {
      print("알림 해제 실패: 액세스 토큰 없음");
      return false;
    }

    try {
      final response = await dio.post(
        '$baseUrl/api/v1/notification/unsubscribe',
        options: Options(
          headers: {
            "Authorization": "Bearer $access",
            "Content-Type": "application/json",
          },
        ),
      );

      print("알림 구독 해제 응답: ${response.statusCode} / ${response.data}");
      return response.statusCode == 200;
    } catch (e) {
      print("알림 구독 해제 실패: $e");
      return false;
    }
  }

  /// 유저 탈퇴
  /// API: api/v1/user
  Future<bool> deleteUser() async {
    String endpoint = 'api/v1/user';

    try {
      final response = await _deleteApi(endpoint);

      if (response == 200) {
        debugPrint('유저 탈퇴 성공');
        return true;
      } else {
        debugPrint('유저 탈퇴 실패: (${response.statusCode} ${response.body})');
        return false;
      }
    } catch (e) {
      debugPrint('유저 탈퇴 처리 중 예외 발생: $e');
      return false;
    }
  }
}
