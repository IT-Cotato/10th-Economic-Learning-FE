import 'package:economic_fe/data/models/dictionary_model.dart';
import 'package:economic_fe/data/services/remote_data_source.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class DictionaryController extends GetxController {
  final remoteDataSource = RemoteDataSource();

  // UI 상태
  var selectedConsonant = "ㄱ".obs;
  var keyword = "".obs;
  var typeValue = true.obs; // true: 자음 선택, false: 키워드 검색

  // 페이징 상태
  var currentPage = 0.obs;
  var totalPage = 1.obs;
  var isLoading = false.obs;
  var isFetchingMore = false.obs;

  // 데이터 상태
  var dictionaryList = <DictionaryModel>[].obs;

  // 검색 결과 상태
  var dictionarySearchResult = false.obs;

  void getStats() {
    print("Stats initialized!");
  }

  // 페이징 초기화
  void resetPaging() {
    currentPage.value = 0;
    totalPage.value = 1;
    dictionaryList.clear();
  }

  /// 자음/키워드에 따른 첫 페이지 로딩
  Future<void> fetchDictionaryInitial(String text, bool type) async {
    resetPaging();
    await fetchDictionaryPage(text, type);
  }

  /// 키워드 검색 첫 페이지 로딩
  Future<void> fetchDictionarySearch(String text, bool type) async {
    resetPaging();
    await fetchDictionaryPage(text, type);
    if (dictionaryList.isEmpty) {
      dictionarySearchResult = true.obs;
    }
  }

  /// 특정 페이지 데이터만 가져오는 메서드 (내부 호출용)
  Future<void> fetchDictionaryPage(String text, bool type) async {
    if (currentPage.value >= totalPage.value) return;

    isLoading.value = true;

    try {
      dynamic response;
      if (type) {
        response =
            await remoteDataSource.getDictionary(currentPage.value, text);
      } else {
        response =
            await remoteDataSource.getKewordResult(currentPage.value, text);
      }

      final data = response as Map<String, dynamic>;
      final termList = data['results']['termList'] as List;
      final terms =
          termList.map((term) => DictionaryModel.fromJson(term)).toList();

      // 누적 추가
      dictionaryList.addAll(terms);

      // 페이지 정보 업데이트
      totalPage.value = data['results']['totalPage'];
      currentPage.value += 1;
    } catch (e) {
      debugPrint('fetchDictionaryPage Error: $e');
    } finally {
      isLoading.value = false;
    }
  }

  /// 스크롤 도달 시 추가 로딩 트리거
  Future<void> loadMoreIfNeeded(String text, bool type) async {
    if (isFetchingMore.value || currentPage.value >= totalPage.value) return;

    isFetchingMore.value = true;
    await fetchDictionaryPage(text, type);
    isFetchingMore.value = false;
  }

  /// 특정 용어 상세 불러오기 (팝업용)
  Future<void> getTermDetail(int id) async {
    try {
      final response = await remoteDataSource.getDetailTerms(id);
      debugPrint("getTermDetail response: $response");
    } catch (e) {
      debugPrint('getTermDetail Error: $e');
    }
  }

  /// 스크랩 등록
  Future<void> postTermScrap(int id) async {
    try {
      final response = await remoteDataSource.postTermsScrap(id);
      debugPrint("postTermScrap response: $response");
    } catch (e) {
      debugPrint("postTermScrap Error: $e");
    }
  }

  /// 스크랩 삭제
  Future<void> deleteTermScrap(int id) async {
    try {
      final response = await remoteDataSource.deleteScrap(id);
      debugPrint("deleteTermScrap response: $response");
    } catch (e) {
      debugPrint("deleteTermScrap Error: $e");
    }
  }
}
