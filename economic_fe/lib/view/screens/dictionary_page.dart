import 'package:economic_fe/data/models/dictionary_model.dart';
import 'package:economic_fe/view/theme/palette.dart';
import 'package:economic_fe/view/widgets/custom_app_bar.dart';
import 'package:economic_fe/view/widgets/custom_bottom_bar.dart';
import 'package:economic_fe/view/widgets/custom_snack_bar.dart';
import 'package:economic_fe/view_model/dictionary_controller.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

class DictionaryPage extends StatefulWidget {
  const DictionaryPage({super.key});

  @override
  State<DictionaryPage> createState() => _DictionaryPageState();
}

class _DictionaryPageState extends State<DictionaryPage> {
  late final DictionaryController controller;
  final TextEditingController _controller = TextEditingController();
  final FocusNode _focusNode = FocusNode();
  final List<String> consonants = [
    'ㄱ',
    'ㄴ',
    'ㄷ',
    'ㄹ',
    'ㅁ',
    'ㅂ',
    'ㅅ',
    'ㅇ',
    'ㅈ',
    'ㅊ',
    'ㅋ',
    'ㅌ',
    'ㅍ',
    'ㅎ'
  ];
  int _selectedIndex = 0;

  @override
  void initState() {
    super.initState();
    controller = Get.put(DictionaryController()..getStats());

    // 첫 자음 기준 초기 데이터 호출
    controller.fetchDictionaryInitial(consonants[_selectedIndex], true);
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => _focusNode.unfocus(),
      child: Scaffold(
        backgroundColor: Palette.background,
        appBar: CustomAppBar(
          title: "용어사전",
          onTapTitle: () => showCategoryModal(context),
        ),
        body: Column(
          children: [
            // 검색창
            Container(
              padding: EdgeInsets.symmetric(horizontal: 16.w),
              height: 60.h,
              child: TextFormField(
                controller: _controller,
                focusNode: _focusNode,
                decoration: InputDecoration(
                  hintText: '검색',
                  prefixIcon:
                      const Icon(Icons.search, color: Color(0xFFA2A2A2)),
                  filled: true,
                  fillColor: const Color(0xFFF2F3F5),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(52),
                    borderSide: BorderSide.none,
                  ),
                ),
                onFieldSubmitted: (value) {
                  controller.keyword.value = value;
                  controller.typeValue.value = false;
                  controller.dictionarySearchResult.value = false;
                  controller.fetchDictionarySearch(
                      value, false); // ← 페이징 초기화 포함
                },
              ),
            ),

            // 자음 선택 리스트
            Container(
              padding: EdgeInsets.symmetric(horizontal: 20.h),
              child: SizedBox(
                height: 50.h,
                child: ListView.builder(
                  scrollDirection: Axis.horizontal,
                  itemCount: consonants.length,
                  itemBuilder: (_, index) {
                    final isSelected = _selectedIndex == index;
                    return Row(
                      children: [
                        GestureDetector(
                          onTap: () {
                            setState(() {
                              _selectedIndex = index;
                              controller.typeValue.value = true;
                              controller.selectedConsonant.value =
                                  consonants[index];
                              controller.fetchDictionaryInitial(
                                  consonants[index], true); // ← 페이징 초기화 포함
                            });
                          },
                          child: Container(
                            width: 45.w,
                            height: 30.h,
                            alignment: Alignment.center,
                            decoration: BoxDecoration(
                              color: isSelected
                                  ? const Color(0xFF1EB692)
                                  : Colors.white,
                              borderRadius: BorderRadius.circular(10),
                              border: Border.all(
                                color: isSelected
                                    ? Colors.transparent
                                    : const Color(0xFF1EB692),
                              ),
                            ),
                            child: Text(
                              consonants[index],
                              style: TextStyle(
                                fontSize: 16.sp,
                                fontWeight: FontWeight.w500,
                                color: isSelected
                                    ? Colors.white
                                    : const Color(0xFF767676),
                              ),
                            ),
                          ),
                        ),
                        SizedBox(width: 8.w),
                      ],
                    );
                  },
                ),
              ),
            ),

            // 리스트 영역
            Expanded(
              child: Obx(() {
                return NotificationListener<ScrollNotification>(
                  onNotification: (scrollInfo) {
                    if (scrollInfo.metrics.pixels >=
                        scrollInfo.metrics.maxScrollExtent - 50) {
                      controller.loadMoreIfNeeded(
                        controller.typeValue.value
                            ? controller.selectedConsonant.value
                            : controller.keyword.value,
                        controller.typeValue.value,
                      );
                    }
                    return false;
                  },
                  child: controller.isLoading.value &&
                          controller.dictionaryList.isEmpty
                      ? const Center(child: CircularProgressIndicator())
                      : controller.dictionaryList.isEmpty
                          ? Center(
                              child: controller.dictionarySearchResult.value
                                  ? const Text("검색어가 존재하지 않습니다.")
                                  : const Text("용어 사전 데이터가 없습니다."),
                            )
                          : ListView.builder(
                              itemCount: controller.dictionaryList.length +
                                  (controller.currentPage.value <
                                          controller.totalPage.value
                                      ? 1
                                      : 0), // 로딩 인디케이터용 1개 추가
                              itemBuilder: (context, index) {
                                if (index == controller.dictionaryList.length) {
                                  return const Padding(
                                    padding: EdgeInsets.all(16.0),
                                    child: Center(
                                        child: CircularProgressIndicator()),
                                  );
                                }

                                final terms = controller.dictionaryList[index];
                                return Column(
                                  children: [
                                    GestureDetector(
                                      onTap: () {
                                        controller
                                            .getTermDetail(terms.termId ?? 0);
                                        showDialog(
                                          context: context,
                                          builder: (_) =>
                                              _buildTermDialog(terms),
                                        );
                                      },
                                      child: Container(
                                        margin: const EdgeInsets.symmetric(
                                            vertical: 8),
                                        padding: const EdgeInsets.all(16),
                                        color: Colors.white,
                                        child: Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          children: [
                                            Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                Text(
                                                  truncateWithEllipsis(
                                                      terms.termName ?? "", 20),
                                                  style: TextStyle(
                                                    fontSize: 16.sp,
                                                    fontWeight: FontWeight.w500,
                                                  ),
                                                ),
                                                SizedBox(height: 8.h),
                                                SizedBox(
                                                  width: 300.w,
                                                  child: Text(
                                                    truncateWithEllipsis(
                                                        terms.termDescription ??
                                                            "",
                                                        25),
                                                    style: TextStyle(
                                                      fontSize: 14.sp,
                                                      color: const Color(
                                                          0xFF767676),
                                                    ),
                                                  ),
                                                ),
                                              ],
                                            ),
                                            GestureDetector(
                                              onTap: () async {
                                                final ctx = context;
                                                setState(() {
                                                  terms.isScraped =
                                                      !(terms.isScraped ??
                                                          false);
                                                });
                                                if (terms.isScraped == true) {
                                                  await controller
                                                      .postTermScrap(
                                                          terms.termId!);
                                                  if (mounted) {
                                                    CustomSnackBar.show(
                                                        context: ctx,
                                                        message: '용어를 스크랩했어요');
                                                  }
                                                } else {
                                                  await controller
                                                      .deleteTermScrap(
                                                          terms.termId!);
                                                  if (mounted) {
                                                    CustomSnackBar.show(
                                                        context: ctx,
                                                        message: '스크랩을 취소했어요');
                                                  }
                                                }
                                              },
                                              child: Padding(
                                                padding: EdgeInsets.only(
                                                    left: 11.w,
                                                    top: 8.h,
                                                    bottom: 8.h),
                                                child: Image.asset(
                                                  terms.isScraped ?? false
                                                      ? "assets/bookmark_selected.png"
                                                      : "assets/bookmark.png",
                                                  width: 13.w,
                                                  height: 18.2.h,
                                                ),
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                    const Divider(
                                      color: Color(0xFFEBEBEB),
                                      height: 1,
                                      thickness: 1,
                                    ),
                                  ],
                                );
                              },
                            ),
                );
              }),
            )
          ],
        ),
        bottomNavigationBar: const CustomBottomBar(currentIndex: 1),
      ),
    );
  }

  Widget _buildTermDialog(DictionaryModel terms) {
    return Dialog(
      backgroundColor: Colors.white,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      child: ConstrainedBox(
        constraints: BoxConstraints(maxHeight: 400.h, maxWidth: 340.w),
        child: Stack(
          children: [
            Padding(
              padding: const EdgeInsets.all(16),
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(height: 14.h),
                    Text(
                      terms.termName ?? "용어 제목",
                      style: TextStyle(
                          fontSize: 18.sp, fontWeight: FontWeight.w600),
                    ),
                    SizedBox(height: 12.h),
                    Text(
                      terms.termDescription ?? "상세 내용이 없습니다.",
                      style: TextStyle(fontSize: 14.sp, color: Colors.black87),
                    ),
                    SizedBox(height: 16.h),
                  ],
                ),
              ),
            ),
            Positioned(
              top: 8.h,
              right: 8.w,
              child: GestureDetector(
                onTap: () => Navigator.of(context).pop(),
                child: const Icon(Icons.close, color: Colors.black),
              ),
            ),
          ],
        ),
      ),
    );
  }

  String truncateWithEllipsis(String text, int maxLength) {
    return (text.length > maxLength)
        ? '${text.substring(0, maxLength)}...'
        : text;
  }

  void showCategoryModal(BuildContext context) {
    // 동일한 카테고리 모달 구현 유지
  }
}
