import 'package:economic_fe/data/models/article_model.dart';
import 'package:economic_fe/view/theme/palette.dart';
import 'package:economic_fe/view/widgets/category_tab.dart';
import 'package:economic_fe/view/widgets/chatbot_fab.dart';
import 'package:economic_fe/view/widgets/custom_bottom_bar.dart';
import 'package:economic_fe/view/widgets/order_tab.dart';
import 'package:economic_fe/view_model/article/article_list_controller.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

class ArticleListPage extends StatefulWidget {
  const ArticleListPage({super.key});

  @override
  State<ArticleListPage> createState() => _ArticleListPageState();
}

class _ArticleListPageState extends State<ArticleListPage> {
  final ArticleListController controller = Get.put(ArticleListController());
  @override
  void initState() {
    super.initState();
    controller.fetchNewsInitial(0, "RECENT", null);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Palette.background,
      appBar: AppBar(
        forceMaterialTransparency: true,
        backgroundColor: Palette.background,
        centerTitle: true,
        title: Text(
          '경제 기사',
          style: TextStyle(
            color: const Color(0xFF111111),
            fontSize: 20.sp,
            fontWeight: FontWeight.w500,
            height: 1.30,
            letterSpacing: -0.50,
          ),
        ),
      ),
      body: Column(
        children: [
          SizedBox(
            height: 45.h,
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h),
              child: Obx(() {
                return ListView(
                  scrollDirection: Axis.horizontal,
                  children: [
                    GestureDetector(
                      onTap: () {
                        controller.selectCategory("전체");
                        controller.fetchNewsInitial(
                            0, controller.selectedSort.value, null);
                      },
                      child: CategoryTab(
                        isSelected: controller.selectedCate.value == "전체",
                        text: '전체',
                      ),
                    ),
                    GestureDetector(
                      onTap: () {
                        controller.selectCategory("FINANCE");
                        controller.fetchNewsInitial(
                            0, controller.selectedSort.value, "FINANCE");
                      },
                      child: CategoryTab(
                          isSelected:
                              controller.selectedCate.value == "FINANCE",
                          text: '금융'),
                    ),
                    GestureDetector(
                      onTap: () {
                        controller.selectCategory("INVESTMENT");
                        controller.fetchNewsInitial(
                            0, controller.selectedSort.value, "INVESTMENT");
                      },
                      child: CategoryTab(
                          isSelected:
                              controller.selectedCate.value == "INVESTMENT",
                          text: '투자'),
                    ),
                    GestureDetector(
                      onTap: () {
                        controller.selectCategory("NORMAL");
                        controller.fetchNewsInitial(
                            0, controller.selectedSort.value, "NORMAL");
                      },
                      child: CategoryTab(
                          isSelected: controller.selectedCate.value == "NORMAL",
                          text: '경제 일반'),
                    ),
                    GestureDetector(
                      onTap: () {
                        controller.selectCategory("GLOBAL");
                        controller.fetchNewsInitial(
                            0, controller.selectedSort.value, "GLOBAL");
                      },
                      child: CategoryTab(
                          isSelected: controller.selectedCate.value == "GLOBAL",
                          text: '국제 경제'),
                    ),
                    GestureDetector(
                      onTap: () {
                        controller.selectCategory("INDUSTRY");
                        controller.fetchNewsInitial(
                            0, controller.selectedSort.value, "INDUSTRY");
                      },
                      child: CategoryTab(
                          isSelected:
                              controller.selectedCate.value == "INDUSTRY",
                          text: '산업 경제'),
                    ),
                    GestureDetector(
                      onTap: () {
                        controller.selectCategory("REAL_ESTATE");
                        controller.fetchNewsInitial(
                            0, controller.selectedSort.value, "REAL_ESTATE");
                      },
                      child: CategoryTab(
                          isSelected:
                              controller.selectedCate.value == "REAL_ESTATE",
                          text: '부동산'),
                    ),
                    GestureDetector(
                      onTap: () {
                        controller.selectCategory("ECONOMIC_ANALYSIS");
                        controller.fetchNewsInitial(0,
                            controller.selectedSort.value, "ECONOMIC_ANALYSIS");
                      },
                      child: CategoryTab(
                          isSelected: controller.selectedCate.value ==
                              "ECONOMIC_ANALYSIS",
                          text: '경제 분석'),
                    ),
                    GestureDetector(
                      onTap: () {
                        controller.selectCategory("ECONOMIC_POLICY");
                        controller.fetchNewsInitial(0,
                            controller.selectedSort.value, "ECONOMIC_POLICY");
                      },
                      child: CategoryTab(
                          isSelected: controller.selectedCate.value ==
                              "ECONOMIC_POLICY",
                          text: '정부와 경제 정책'),
                    ),
                    GestureDetector(
                      onTap: () {
                        controller.selectCategory("OTHER");
                        controller.fetchNewsInitial(
                            0, controller.selectedSort.value, "OTHER");
                      },
                      child: CategoryTab(
                          isSelected: controller.selectedCate.value == "OTHER",
                          text: '기타'),
                    ),
                  ],
                );
              }),
            ),
          ),
          SizedBox(
            height: 11.h,
          ),
          Obx(() {
            switch (controller.selectedCategoryIndex.value) {
              case 0: // 전체 카테고리 내용
                return Expanded(
                  child: Column(
                    children: [
                      Padding(
                        padding: EdgeInsets.symmetric(horizontal: 16.w),
                        child: Row(
                          children: [
                            // 인기순/최신순 선택
                            GestureDetector(
                              onTap: () {
                                controller.selectOrder(0);
                                controller.fetchNewsInitial(0, "POPULAR",
                                    controller.selectedCate.value);
                              },
                              child: OrderTab(
                                text: '인기순',
                                isSelected: controller.selectedOrder.value == 0,
                              ),
                            ),
                            SizedBox(
                              width: 6.w,
                            ),
                            GestureDetector(
                              onTap: () {
                                controller.selectOrder(1);
                                controller.fetchNewsInitial(
                                    0, "RECENT", controller.selectedCate.value);
                              },
                              child: OrderTab(
                                text: '최신순',
                                isSelected: controller.selectedOrder.value == 1,
                              ),
                            ),
                          ],
                        ),
                      ),
                      // 기사 목록
                      Obx(() {
                        final newsList = controller.newsList;

                        if (newsList.isEmpty) {
                          return const Center(child: Text('뉴스 데이터가 없습니다.'));
                        }

                        return Expanded(
                          child: Obx(() {
                            final newsList = controller.newsList;

                            if (controller.isLoading.value &&
                                newsList.isEmpty) {
                              return const Center(
                                  child: CircularProgressIndicator());
                            }

                            if (newsList.isEmpty) {
                              return const Center(child: Text('뉴스 데이터가 없습니다.'));
                            }

                            return NotificationListener<ScrollNotification>(
                              onNotification: (scrollInfo) {
                                if (scrollInfo.metrics.pixels >=
                                    scrollInfo.metrics.maxScrollExtent - 100) {
                                  controller.loadMoreIfNeeded();
                                }
                                return false;
                              },
                              child: ListView.builder(
                                itemCount: newsList.length +
                                    (controller.currentPage.value <
                                            controller.totalPage.value
                                        ? 1
                                        : 0),
                                itemBuilder: (context, index) {
                                  if (index == newsList.length) {
                                    return const Padding(
                                      padding: EdgeInsets.all(16.0),
                                      child: Center(
                                          child: CircularProgressIndicator()),
                                    );
                                  }

                                  final news = newsList[index];
                                  return Padding(
                                    padding: EdgeInsets.symmetric(
                                        horizontal: 8.w, vertical: 8.h),
                                    child: Container(
                                      padding: EdgeInsets.symmetric(
                                          horizontal: 16.w, vertical: 16.h),
                                      decoration: BoxDecoration(
                                        color: Colors.white,
                                        borderRadius:
                                            BorderRadius.circular(12.0),
                                        border: Border(
                                          bottom: BorderSide(
                                            color: const Color(0xFFD9D9D9),
                                            width: 1.w,
                                          ),
                                        ),
                                      ),
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          // 기사 정보
                                          Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              Text(
                                                _getCategoryName(
                                                    news.category!),
                                                style: TextStyle(
                                                  color:
                                                      const Color(0xFF2BD6D6),
                                                  fontSize: 12.sp,
                                                  fontWeight: FontWeight.w600,
                                                ),
                                              ),
                                              GestureDetector(
                                                onTap: () {
                                                  controller
                                                      .getNewsDetail(news.id!);
                                                  controller.toDetailPage(news);
                                                },
                                                child: Text(
                                                  (news.title != null &&
                                                          news.title!.length >
                                                              18)
                                                      ? '${news.title!.substring(0, 18)}...'
                                                      : news.title ?? "제목 없음",
                                                  style: TextStyle(
                                                    fontSize: 16.sp,
                                                    fontWeight: FontWeight.w500,
                                                  ),
                                                ),
                                              ),
                                              SizedBox(height: 6.h),
                                              Text(
                                                news.publisher ?? "알 수 없음",
                                                style: TextStyle(
                                                  color:
                                                      const Color(0xFF767676),
                                                  fontSize: 12.sp,
                                                ),
                                              ),
                                            ],
                                          ),
                                          // 스크랩 아이콘
                                          Column(
                                            children: [
                                              GestureDetector(
                                                onTap: () {
                                                  if (news.isScraped ?? false) {
                                                    controller.deleteNewsScrap(
                                                        news.id!,
                                                        article: news);
                                                  } else {
                                                    controller.postNewsScrap(
                                                        news.id!,
                                                        article: news);
                                                  }
                                                },
                                                child: Image.asset(
                                                  news.isScraped ?? false
                                                      ? 'assets/bookmark_selected.png'
                                                      : 'assets/bookmark.png',
                                                  width: 13.w,
                                                  height: 18.3.h,
                                                ),
                                              ),
                                              const SizedBox(height: 20),
                                              Text(
                                                news.createdDate ?? '',
                                                style: TextStyle(
                                                  color:
                                                      const Color(0xFF767676),
                                                  fontSize: 12.sp,
                                                ),
                                              ),
                                            ],
                                          ),
                                        ],
                                      ),
                                    ),
                                  );
                                },
                              ),
                            );
                          }),
                        );
                      }),
                    ],
                  ),
                );
              default:
                return const Center(child: Text('카테고리 내용'));
            }
          }),
        ],
      ),
      floatingActionButton: ChatbotFAB(onTap: () {
        controller.toChatbot();
      }),
      bottomNavigationBar: const CustomBottomBar(currentIndex: 2),
    );
  }

  String _getCategoryName(String category) {
    switch (category) {
      case "FINANCE":
        return "금융";
      case "INVESTMENT":
        return "투자";
      case "NORMAL":
        return "경제 일반";
      case "GLOBAL":
        return "국제 경제";
      case "INDUSTRY":
        return "산업 경제";
      case "REAL_ESTATE":
        return "부동산";
      case "ECONOMIC_ANALYSIS":
        return "경제 분석";
      case "ECONOMIC_POLICY":
        return "정부와 경제 정책";
      case "ECONOMIC_POLICY":
        return "정부와 경제 정책";
      default:
        return "기타"; // 예외 처리
    }
  }
}
