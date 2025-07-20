import 'package:economic_fe/utils/notification_utils.dart';
import 'package:economic_fe/view/theme/palette.dart';
import 'package:economic_fe/view/widgets/progress_tool_tip.dart';
import 'package:economic_fe/view/widgets/circular_chart.dart';
import 'package:economic_fe/view/widgets/custom_bottom_bar.dart';
import 'package:economic_fe/view/widgets/home_app_bar.dart';
import 'package:economic_fe/view_model/home_controller.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  // GetX 컨트롤러 가져오기
  final HomeController controller = Get.put(HomeController());

  @override
  void initState() {
    super.initState();
    checkAndRequestNotificationPermissionOnce(); // 최초 진입 시 한 번 실행
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    controller.fetchAllHomeData(); // 매 진입 시 갱신
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Palette.background,
      appBar: const HomeAppBar(),
      body: Stack(
        children: [
          SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: EdgeInsets.symmetric(
                    horizontal: 16.w,
                    vertical: 9.h,
                  ),
                  child: const HomeTitle(
                    title: '나의 학습 현황',
                  ),
                ),
                SizedBox(
                  height: 16.h,
                ),
                // 학습 현황 컨테이너
                Center(
                  child: Container(
                    width: 317.w,
                    height: 292.h,
                    decoration: ShapeDecoration(
                      color: Colors.white,
                      shape: RoundedRectangleBorder(
                        side: const BorderSide(
                            width: 1, color: Color(0xFFA2A2A2)),
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    child: Stack(
                      children: [
                        Padding(
                          padding: EdgeInsets.symmetric(
                              horizontal: 24.w, vertical: 20.h),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  // 진도율
                                  Row(
                                    children: [
                                      Text(
                                        '진도율',
                                        textAlign: TextAlign.center,
                                        style: TextStyle(
                                          color: const Color(0xFF111111),
                                          fontSize: 14.sp,
                                          fontWeight: FontWeight.w500,
                                          letterSpacing: -0.35,
                                        ),
                                      ),
                                      Padding(
                                        padding: EdgeInsets.symmetric(
                                            horizontal: 2.w),
                                        child: const ProgressTooltip(),
                                      ),
                                    ],
                                  ),
                                  // 전체 세트 보기 버튼
                                  HomeSmallButton(
                                    controller: controller,
                                    onTap: () {
                                      controller.navigateToLearningList();
                                    },
                                    text: '전체 세트 보기',
                                  ),
                                ],
                              ),
                              // 진도율 그래프
                              Obx(() {
                                return SizedBox(
                                  width: 240.w,
                                  height: 156.h,
                                  child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      // Beginner
                                      SizedBox(
                                        width: 72.w,
                                        height: 156.h,
                                        child: Column(
                                          mainAxisAlignment:
                                              MainAxisAlignment.end,
                                          children: [
                                            SizedBox(
                                              width: 44.w,
                                              child: Text(
                                                '${(controller.beginnerProgress.value).toInt()}%',
                                                textAlign: TextAlign.center,
                                                style: TextStyle(
                                                  color:
                                                      const Color(0xFF111111),
                                                  fontSize: 12.sp,
                                                  fontWeight: FontWeight.w400,
                                                  height: 1.50,
                                                  letterSpacing: -0.30,
                                                ),
                                              ),
                                            ),
                                            Container(
                                              width: 36.w,
                                              height: controller.maxHeight *
                                                  controller
                                                      .beginnerProgress.value *
                                                  0.01,
                                              decoration: const ShapeDecoration(
                                                color: Color(0xFFB1F2F2),
                                                shape: RoundedRectangleBorder(
                                                  borderRadius:
                                                      BorderRadius.only(
                                                    topLeft: Radius.circular(4),
                                                    topRight:
                                                        Radius.circular(4),
                                                  ),
                                                ),
                                              ),
                                            ),
                                            Text(
                                              '초급',
                                              style: TextStyle(
                                                color: const Color(0xFF404040),
                                                fontSize: 10.sp,
                                                fontWeight: FontWeight.w400,
                                                height: 1.50,
                                                letterSpacing: -0.30,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                      // Intermediate
                                      SizedBox(
                                        width: 72.w,
                                        height: 156.h,
                                        child: Column(
                                          mainAxisAlignment:
                                              MainAxisAlignment.end,
                                          children: [
                                            SizedBox(
                                              width: 44.w,
                                              child: Text(
                                                '${(controller.intermediateProgress.value).toInt()}%',
                                                textAlign: TextAlign.center,
                                                style: TextStyle(
                                                  color:
                                                      const Color(0xFF111111),
                                                  fontSize: 12.sp,
                                                  fontWeight: FontWeight.w400,
                                                  height: 1.50,
                                                  letterSpacing: -0.30,
                                                ),
                                              ),
                                            ),
                                            Container(
                                              width: 36.w,
                                              height: controller.maxHeight *
                                                  controller
                                                      .intermediateProgress
                                                      .value *
                                                  0.01,
                                              decoration: const ShapeDecoration(
                                                color: Color(0xFFB1F2F2),
                                                shape: RoundedRectangleBorder(
                                                  borderRadius:
                                                      BorderRadius.only(
                                                    topLeft: Radius.circular(4),
                                                    topRight:
                                                        Radius.circular(4),
                                                  ),
                                                ),
                                              ),
                                            ),
                                            Text(
                                              '중급',
                                              style: TextStyle(
                                                color: const Color(0xFF404040),
                                                fontSize: 10.sp,
                                                fontWeight: FontWeight.w400,
                                                height: 1.50,
                                                letterSpacing: -0.30,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                      // Advanced
                                      SizedBox(
                                        width: 72.w,
                                        height: 156.h,
                                        child: Column(
                                          mainAxisAlignment:
                                              MainAxisAlignment.end,
                                          children: [
                                            SizedBox(
                                              width: 44.w,
                                              child: Text(
                                                '${(controller.advancedProgress.value).toInt()}%',
                                                textAlign: TextAlign.center,
                                                style: TextStyle(
                                                  color:
                                                      const Color(0xFF111111),
                                                  fontSize: 12.sp,
                                                  fontWeight: FontWeight.w400,
                                                  height: 1.50,
                                                  letterSpacing: -0.30,
                                                ),
                                              ),
                                            ),
                                            Container(
                                              width: 36.w,
                                              height: controller.maxHeight *
                                                  controller
                                                      .advancedProgress.value *
                                                  0.01,
                                              decoration: const ShapeDecoration(
                                                color: Color(0xFFB1F2F2),
                                                shape: RoundedRectangleBorder(
                                                  borderRadius:
                                                      BorderRadius.only(
                                                    topLeft: Radius.circular(4),
                                                    topRight:
                                                        Radius.circular(4),
                                                  ),
                                                ),
                                              ),
                                            ),
                                            Text(
                                              '고급',
                                              style: TextStyle(
                                                color: const Color(0xFF404040),
                                                fontSize: 10.sp,
                                                fontWeight: FontWeight.w400,
                                                height: 1.50,
                                                letterSpacing: -0.30,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ],
                                  ),
                                );
                              }),

                              Container(
                                width: 269.w,
                                height: 44.h,
                                decoration: ShapeDecoration(
                                  color: const Color(0xFF2AD6D6),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                ),
                                // 학습 하러 가기 버튼
                                child: GestureDetector(
                                  onTap: () {
                                    // 학습 진행 상황에 따라 다음 화면 반환하는 로직 필요
                                    controller.navigateToLearningList();
                                  },
                                  child: Center(
                                    child: Text(
                                      '학습 하러 가기',
                                      style: TextStyle(
                                        color: Colors.white,
                                        fontSize: 18.sp,
                                        fontWeight: FontWeight.w600,
                                        height: 1.50,
                                        letterSpacing: -0.45,
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                        Obx(() {
                          return controller.isProgressContainerVisible.value ==
                                  false
                              ? Container(
                                  width: 337.w,
                                  height: 292.h,
                                  decoration: ShapeDecoration(
                                    color: const Color(0xBF111111),
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(12),
                                    ),
                                  ),
                                  child: Padding(
                                    padding: const EdgeInsets.all(16),
                                    child: Stack(
                                      children: [
                                        // // 창 닫기 버튼
                                        // Positioned(
                                        //   right: 0,
                                        //   child: GestureDetector(
                                        //     onTap: () => controller
                                        //         .isProgressContainerVisible
                                        //         .value = true,
                                        //     child: const Icon(
                                        //       Icons.close,
                                        //       color: Colors.white,
                                        //     ),
                                        //   ),
                                        // ),
                                        Column(
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          children: [
                                            Center(
                                              child: Text(
                                                '레벨테스트를 진행해야 \n더 정확한 학습이 가능해요.',
                                                textAlign: TextAlign.center,
                                                style: TextStyle(
                                                  color: Colors.white,
                                                  fontSize: 20.sp,
                                                  fontWeight: FontWeight.w600,
                                                  height: 1.30,
                                                  letterSpacing: -0.50,
                                                ),
                                              ),
                                            ),
                                            SizedBox(
                                              height: 30.h,
                                            ),
                                            GestureDetector(
                                              onTap: () =>
                                                  controller.toLevelTest(),
                                              child: Center(
                                                child: Container(
                                                  width: 280.w,
                                                  height: 60.h,
                                                  decoration: ShapeDecoration(
                                                    color:
                                                        Palette.buttonColorBlue,
                                                    shape:
                                                        RoundedRectangleBorder(
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              16),
                                                    ),
                                                  ),
                                                  child: Center(
                                                    child: Text(
                                                      '레벨테스트 시작하기',
                                                      style: TextStyle(
                                                        color: Colors.white,
                                                        fontSize: 18.sp,
                                                        fontWeight:
                                                            FontWeight.w600,
                                                        height: 1.20,
                                                        letterSpacing: -0.45,
                                                      ),
                                                    ),
                                                  ),
                                                ),
                                              ),
                                            ),
                                          ],
                                        ),
                                      ],
                                    ),
                                  ),
                                )
                              : const SizedBox();
                        }),
                      ],
                    ),
                  ),
                ),
                SizedBox(
                  height: 36.h,
                ),
                // 오늘의 퀘스트
                Padding(
                  padding: EdgeInsets.symmetric(
                    horizontal: 16.w,
                    vertical: 8.h,
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        children: [
                          Text(
                            '오늘의 퀘스트',
                            style: TextStyle(
                              color: const Color(0xFF111111),
                              fontSize: 20.sp,
                              fontWeight: FontWeight.w500,
                              height: 1.30,
                              letterSpacing: -0.50,
                            ),
                          ),
                          SizedBox(
                            width: 5.w,
                          ),
                          GestureDetector(
                            onTap: () {
                              showDialog(
                                  context: context,
                                  builder: (_) => _buildToolTip());
                            },
                            child: Icon(
                              Icons.help_outline,
                              size: 16.sp,
                              color: const Color.fromARGB(255, 201, 201, 201),
                            ),
                          ),
                        ],
                      ),

                      // 목표 변경하기 버튼
                      HomeSmallButton(
                        controller: controller,
                        onTap: controller.showGoalDialog,
                        text: '목표 변경하기',
                      ),
                    ],
                  ),
                ),
                SizedBox(
                  height: 18.h,
                ),
                Center(
                  child: Obx(() {
                    return Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        TodaysQuestChart(
                          icon: 'book_ribbon',
                          text: '개념 학습',
                          quest: controller.goalSets[0],
                          progress: controller.conceptProgress,
                        ),
                        TodaysQuestChart(
                          icon: 'news',
                          text: '경제 기사',
                          quest: controller.goalSets[1],
                          progress: controller.articleProgress,
                        ),
                        TodaysQuestChart(
                          icon: 'quiz',
                          text: '퀴즈',
                          quest: controller.goalSets[2],
                          progress: controller.quizProgress,
                        ),
                      ],
                    );
                  }),
                ),
                SizedBox(
                  height: 36.h,
                ),
                // 경제 기사
                TitleWithMoreBtn(
                  title: '경제 기사',
                  onTap: () {
                    // 경제 기사 화면으로 이동
                    Get.toNamed('/article');
                  },
                ),
                SizedBox(
                  height: 16.h,
                ),
                // 경제 기사 리스트 불러오기
                Obx(() {
                  if (controller.isLoading.value) {
                    return const Center(child: CircularProgressIndicator());
                  }

                  if (controller.articles.isEmpty) {
                    return const Center(child: Text("불러올 경제 기사가 없습니다."));
                  }

                  // 상위 3개의 기사만 가져오기
                  final articlesToShow = controller.articles.take(3).toList();

                  return ListView.separated(
                    shrinkWrap: true, // 부모 위젯 크기에 맞게 리스트 크기 조절
                    physics:
                        const NeverScrollableScrollPhysics(), // 스크롤 방지 (부모가 스크롤 가능할 경우)
                    itemCount: articlesToShow.length,
                    itemBuilder: (context, index) {
                      final article = articlesToShow[index];

                      return GestureDetector(
                        onTap: () {
                          Get.toNamed(
                            '/article/detail',
                            arguments: article,
                          );
                        },
                        child: ExampleArticle(
                          category: article.translatedCategory,
                          headline: article.title ?? "제목 없음",
                        ),
                      );
                    },
                    separatorBuilder: (context, index) {
                      return Padding(
                        padding: EdgeInsets.symmetric(vertical: 8.h),
                        child: Divider(
                          color: Colors.grey.shade300,
                          thickness: 1,
                        ),
                      );
                    },
                  );
                }),

                SizedBox(
                  height: 36.h,
                ),
                // 경제 톡톡
                TitleWithMoreBtn(
                  title: '경제 톡톡',
                  onTap: () {
                    Get.toNamed('/community');
                  },
                ),
                SizedBox(
                  height: 16.h,
                ),
                // 경제 톡톡 주제 컨테이너
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 16.w),
                  child: Obx(() {
                    if (controller.isLoading.value) {
                      return const Center(child: CircularProgressIndicator());
                    }

                    var todaysTok = controller.todaysTokDetail;
                    if (todaysTok.isEmpty) {
                      return const Center(child: Text("오늘의 경제톡톡을 불러올 수 없습니다."));
                    }

                    return GestureDetector(
                      onTap: () {
                        controller.toTalkDetailPage(todaysTok['id']);
                      },
                      child: Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10),
                          border: Border.all(
                              width: 1, color: const Color(0xFFA2A2A2)),
                          image: DecorationImage(
                            image: todaysTok['imageUrl'] != null
                                ? NetworkImage(todaysTok['imageUrl'])
                                : const AssetImage(
                                    'assets/talk_image_sample.png'), // 오늘의 경제톡톡 대표 이미지 연결 필요
                            fit: BoxFit.cover,
                            colorFilter: ColorFilter.mode(
                              Colors.black.withOpacity(0.35), // 어두운 필터 추가
                              BlendMode.darken, // 어두운 필터 적용
                            ),
                          ),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.all(20),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                todaysTok['title'],
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 22.sp,
                                  fontWeight: FontWeight.w700,
                                  letterSpacing: -0.55,
                                ),
                              ),
                              SizedBox(
                                height: 5.h,
                              ),
                              Text(
                                '현재 뜨거운 톡톡!',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 14.sp,
                                  fontFamily: 'Pretendard Variable',
                                  fontWeight: FontWeight.w400,
                                  letterSpacing: -0.35,
                                ),
                              ),
                              const SizedBox(
                                height: 49,
                              ),
                              // API에서 받아온 랜덤 프로필 리스트 활용
                              Row(
                                children: [
                                  Obx(() {
                                    int profileCount = controller
                                        .participantProfileImages.length
                                        .clamp(0, 4); // 최대 4개
                                    double spacing = profileCount > 0
                                        ? 14.0 * (profileCount - 1) + 20
                                        : 0;

                                    return SizedBox(
                                      width: spacing, // 프로필 개수에 따른 크기 조절
                                      height: 18.h,
                                      child: Stack(
                                        children: List.generate(
                                          profileCount,
                                          (index) {
                                            return Positioned(
                                              left: 14.w * index, // 위치를 겹치게 조정
                                              child: Container(
                                                width: 18.w,
                                                height: 18.h,
                                                decoration: ShapeDecoration(
                                                  color:
                                                      const Color(0xFFF3F3F3),
                                                  shape: RoundedRectangleBorder(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            43),
                                                  ),
                                                  shadows: const [
                                                    BoxShadow(
                                                      color: Color(0x3F000000),
                                                      blurRadius: 1,
                                                      offset:
                                                          Offset(0.20, 0.20),
                                                      spreadRadius: 0,
                                                    )
                                                  ],
                                                ),
                                                child: ClipRRect(
                                                  borderRadius:
                                                      BorderRadius.circular(43),
                                                  child: controller
                                                          .participantProfileImages[
                                                              index]
                                                          .isNotEmpty
                                                      ? Image.network(
                                                          controller
                                                                  .participantProfileImages[
                                                              index],
                                                          fit: BoxFit.cover,
                                                          errorBuilder: (context,
                                                                  error,
                                                                  stackTrace) =>
                                                              Image.asset(
                                                                  'assets/profile_example.png'),
                                                        )
                                                      : Image.asset(
                                                          'assets/profile_example.png'), // 기본 이미지
                                                ),
                                              ),
                                            );
                                          },
                                        ),
                                      ),
                                    );
                                  }),

                                  // 프로필 개수에 따라 동적으로 간격 조정
                                  Obx(() {
                                    int profileCount = controller
                                        .participantProfileImages.length
                                        .clamp(0, 4);
                                    double textPadding =
                                        profileCount > 0 ? 5.0 : 0;

                                    return Padding(
                                      padding: EdgeInsets.only(
                                          left: textPadding), // 동적 간격 조절
                                      child: Text(
                                        '${controller.todaysTokDetail["participantCount"] ?? 0}명이 참여했어요',
                                        style: TextStyle(
                                          color: Colors.white,
                                          fontSize: 12.sp,
                                          fontWeight: FontWeight.w400,
                                          height: 1.50,
                                          letterSpacing: -0.30,
                                        ),
                                      ),
                                    );
                                  }),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ),
                    );
                  }),
                ),
                SizedBox(
                  height: 36.h,
                ),
                // 인기게시물
                TitleWithMoreBtn(
                  title: '인기게시물',
                  onTap: () {
                    // 커뮤니티 화면으로 이동
                    Get.toNamed('/community');
                  },
                ),
                SizedBox(
                  height: 16.h,
                ),
                // 인기게시물 2개
                Center(
                  child: Padding(
                    padding: EdgeInsets.symmetric(horizontal: 16.w),
                    child: Obx(() {
                      if (controller.isLoading.value) {
                        return const Center(
                            child: CircularProgressIndicator()); // 로딩 중
                      }

                      if (controller.popularPosts.isEmpty) {
                        return const Center(
                            child: Text("불러올 인기 게시글이 없습니다.")); // 게시글 없음
                      }

                      return Column(
                        children: List.generate(
                          controller.popularPosts.length.clamp(0, 2), // 최대 2개
                          (index) {
                            final post = controller.popularPosts[index];
                            return Container(
                              padding: EdgeInsets.symmetric(
                                  horizontal: 24.w, vertical: 20.h),
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.only(
                                  topLeft: Radius.circular(index == 0 ? 16 : 0),
                                  topRight:
                                      Radius.circular(index == 0 ? 16 : 0),
                                  bottomLeft:
                                      Radius.circular(index == 1 ? 16 : 0),
                                  bottomRight:
                                      Radius.circular(index == 1 ? 16 : 0),
                                ),
                                border: Border(
                                    left: const BorderSide(
                                        width: 1, color: Color(0xFFA2A2A2)),
                                    right: const BorderSide(
                                        width: 1, color: Color(0xFFA2A2A2)),
                                    top: const BorderSide(
                                        width: 1, color: Color(0xFFA2A2A2)),
                                    bottom: index == 1
                                        ? const BorderSide(
                                            // width: index == 1 ? 1 : 0,
                                            width: 1,
                                            color: Color(0xFFA2A2A2))
                                        : BorderSide.none),
                              ),
                              child: PopularPosts(
                                category: post.translatedType,
                                title: post.title!,
                                likesCount: post.likeCount!,
                                commentsCount: post.commentCount!,
                                time: post.createdDate!,
                              ),
                            );
                          },
                        ),
                      );
                    }),
                  ),
                ),
                SizedBox(
                  height: 48.h,
                ),
              ],
            ),
          ),
          Obx(() {
            if (!controller.isDialogVisible.value) {
              return const SizedBox.shrink();
            }
            return GestureDetector(
              onTap: () {
                controller.hideGoalDialog();
                controller.resetGoalSets();
              },
              child: Container(
                color: Colors.black.withOpacity(0.5),
                child: Center(
                  child: Container(
                    width: MediaQuery.of(context).size.width - 32.w,
                    height: 360.h,
                    padding:
                        EdgeInsets.symmetric(horizontal: 26.w, vertical: 24.h),
                    decoration: ShapeDecoration(
                      color: Colors.white,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                    child: Column(
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              '오늘의 퀘스트 변경',
                              style: TextStyle(
                                color: Colors.black,
                                fontSize: 18.sp,
                                fontWeight: FontWeight.w500,
                                height: 1.20,
                                letterSpacing: -0.45,
                              ),
                            ),
                            GestureDetector(
                              onTap: () {
                                controller.hideGoalDialog();
                                controller.resetGoalSets();
                              },
                              child: const Icon(Icons.close),
                            ),
                          ],
                        ),
                        Padding(
                          padding: EdgeInsets.only(
                              top: 20.h, left: 26.w, right: 26.w, bottom: 2.h),
                          child: Container(
                            height: 1,
                            color: const Color(0xffd9d9d9),
                          ),
                        ),
                        Column(
                          children: List.generate(3, (index) {
                            String questTitle = '';
                            switch (index) {
                              case 0:
                                questTitle = '개념학습';
                                break;
                              case 1:
                                questTitle = '경제 기사';
                                break;
                              default:
                                questTitle = '퀴즈';
                                break;
                            }
                            final isMinimum = controller.tempGoalSets[index] ==
                                controller.minGoalSets;
                            final isMaximum = controller.tempGoalSets[index] ==
                                controller.maxGoalSets;
                            return Padding(
                              padding: EdgeInsets.symmetric(vertical: 18.h),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    questTitle,
                                    style: TextStyle(
                                      color: const Color(0xFF111111),
                                      fontSize: 18.sp,
                                      fontWeight: FontWeight.w500,
                                      height: 1.60,
                                      letterSpacing: -0.45,
                                    ),
                                  ),
                                  Obx(() {
                                    return Row(
                                      children: [
                                        // - 버튼
                                        GestureDetector(
                                          onTap: () => controller
                                              .minusTempGoalSets(index),
                                          child: Icon(
                                            Icons.remove_circle_outline,
                                            color: isMinimum
                                                ? const Color(0xffd9d9d9)
                                                : const Color(0xffa2a2a2),
                                          ),
                                        ),
                                        SizedBox(
                                          width: 16.w,
                                        ),
                                        // 세트 수
                                        Text(
                                          '${controller.tempGoalSets[index]}',
                                          style: TextStyle(
                                            color: const Color(0xFF111111),
                                            fontSize: 16.sp,
                                            fontWeight: FontWeight.w600,
                                            height: 1.20,
                                          ),
                                        ),
                                        Text(
                                          '세트',
                                          style: TextStyle(
                                            color: const Color(0xFF111111),
                                            fontSize: 12.sp,
                                            fontWeight: FontWeight.w400,
                                            height: 1.20,
                                          ),
                                        ),
                                        SizedBox(
                                          width: 16.w,
                                        ),
                                        // + 버튼
                                        GestureDetector(
                                          onTap: () => controller
                                              .plusTempGoalSets(index),
                                          child: Icon(
                                            Icons.add_circle_outline,
                                            color: isMaximum
                                                ? const Color(0xffd9d9d9)
                                                : const Color(0xffa2a2a2),
                                          ),
                                        ),
                                      ],
                                    );
                                  }),
                                ],
                              ),
                            );
                          }),
                        ),
                        SizedBox(
                          height: 6.h,
                        ),
                        // 저장하기 버튼
                        GestureDetector(
                          onTap: () {
                            controller.saveGoalSets();
                            controller.setUserGoal();
                            controller.hideGoalDialog();
                          },
                          child: Container(
                            width: MediaQuery.of(context).size.width - 84.w,
                            height: 60.h,
                            decoration: ShapeDecoration(
                              color: const Color(0xFF2AD6D6),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(16),
                              ),
                            ),
                            child: Center(
                              child: Text(
                                '저장하기',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 18.sp,
                                  fontWeight: FontWeight.w600,
                                  height: 1.20,
                                  letterSpacing: -0.45,
                                ),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            );
          }),
        ],
      ),
      // 하단바
      bottomNavigationBar: const CustomBottomBar(
        currentIndex: 0,
      ),
    );
  }

  Widget _buildToolTip() {
    return Dialog(
      backgroundColor: Colors.transparent,
      child: Stack(
        clipBehavior: Clip.none,
        children: [
          // 말풍선 박스 본체
          Container(
            padding: const EdgeInsets.fromLTRB(16, 28, 16, 16),
            margin: const EdgeInsets.only(top: 12),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(10),
              boxShadow: const [
                BoxShadow(
                  color: Colors.black26,
                  blurRadius: 6,
                  offset: Offset(0, 2),
                ),
              ],
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "유저의 레벨과 동일한 개념 학습 및 퀴즈 완료,\n경제 기사 클릭 시 오늘의 퀘스트가 달성돼요!",
                  style: TextStyle(fontSize: 14.sp, color: Colors.black87),
                ),
              ],
            ),
          ),

          // 위쪽 태그 타이틀
          Positioned(
            left: 16,
            top: 0,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(6),
                border: Border.all(color: Colors.black12),
              ),
              child: Text(
                "오늘의 퀘스트 꿀팁",
                style: TextStyle(
                  fontSize: 13.sp,
                  fontWeight: FontWeight.w600,
                  color: Colors.black87,
                ),
              ),
            ),
          ),
          // 오른쪽 상단 닫기 버튼
          Positioned(
            top: 0,
            right: -4,
            child: IconButton(
              icon: Icon(Icons.close, size: 20, color: Colors.grey[700]),
              onPressed: () => Navigator.of(context).pop(),
            ),
          ),
        ],
      ),
    );
  }
}

class PopularPosts extends StatelessWidget {
  final String category;
  final String title;
  final int likesCount;
  final int commentsCount;
  final String time;

  const PopularPosts({
    super.key,
    required this.category,
    required this.title,
    required this.likesCount,
    required this.commentsCount,
    required this.time,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 2.h),
          decoration: ShapeDecoration(
            color: const Color(0xFF2AD6D6),
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(6)),
          ),
          child: Text(
            category,
            style: TextStyle(
              color: Colors.white,
              fontSize: 12.sp,
              fontWeight: FontWeight.w600,
              height: 1.50,
              letterSpacing: -0.30,
            ),
          ),
        ),
        SizedBox(
          height: 10.h,
        ),
        Text(
          title,
          style: TextStyle(
            color: const Color(0xFF404040),
            fontSize: 16.sp,
            fontWeight: FontWeight.w500,
            height: 1.50,
          ),
        ),
        SizedBox(
          height: 5.h,
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            Icon(
              Icons.favorite_border,
              size: 20.w,
              color: const Color(0xff767676),
            ),
            SizedBox(
              width: 4.w,
            ),
            // 좋아요 수
            Text(
              '$likesCount',
              textAlign: TextAlign.center,
              style: TextStyle(
                color: const Color(0xFF767676),
                fontSize: 14.sp,
                fontWeight: FontWeight.w400,
                height: 1.50,
                letterSpacing: -0.35,
              ),
            ),
            SizedBox(
              width: 8.w,
            ),
            Icon(
              Icons.chat_bubble_outline,
              size: 20.w,
              color: const Color(0xff767676),
            ),
            SizedBox(
              width: 4.w,
            ),
            // 댓글 수
            Text(
              '$commentsCount',
              textAlign: TextAlign.center,
              style: TextStyle(
                color: const Color(0xFF767676),
                fontSize: 14.sp,
                fontWeight: FontWeight.w400,
                height: 1.50,
                letterSpacing: -0.35,
              ),
            ),
            SizedBox(
              width: 10.w,
            ),
            // 게시글 업로드 시간
            Text(
              time,
              textAlign: TextAlign.center,
              style: TextStyle(
                color: const Color(0xFF767676),
                fontSize: 12.sp,
                fontWeight: FontWeight.w400,
                height: 1.50,
                letterSpacing: -0.30,
              ),
            ),
          ],
        ),
      ],
    );
  }
}

class TitleWithMoreBtn extends StatelessWidget {
  final String title;
  final void Function() onTap;

  const TitleWithMoreBtn({
    super.key,
    required this.title,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h),
      child: SizedBox(
        width: MediaQuery.of(context).size.width,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            HomeTitle(title: title),
            // 더보기 버튼
            GestureDetector(
              onTap: onTap,
              child: Row(
                children: [
                  Text(
                    '더보기',
                    style: TextStyle(
                      color: const Color(0xFF767676),
                      fontSize: 14.sp,
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                  SizedBox(
                    width: 5.w,
                  ),
                  Icon(
                    Icons.arrow_forward_ios,
                    size: 10.w,
                    color: const Color(0xff767676),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class ExampleArticle extends StatelessWidget {
  final String category;
  final String headline;

  const ExampleArticle({
    super.key,
    required this.category,
    required this.headline,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 16.w),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            category,
            style: TextStyle(
              color: const Color(0xFF2AD6D6),
              fontSize: 12.sp,
              fontWeight: FontWeight.w600,
              height: 1.30,
              letterSpacing: -0.30,
            ),
          ),
          SizedBox(
            height: 6.h,
          ),
          Text(
            headline,
            style: TextStyle(
              color: Colors.black,
              fontSize: 16.sp,
              fontWeight: FontWeight.w500,
              height: 1.30,
              letterSpacing: -0.40,
            ),
          ),
        ],
      ),
    );
  }
}

class TodaysQuestChart extends StatelessWidget {
  final String icon;
  final String text;
  final int quest;
  final RxDouble progress;

  const TodaysQuestChart({
    super.key,
    required this.icon,
    required this.text,
    required this.quest,
    required this.progress,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 12.w),
      child: Column(
        children: [
          Obx(() {
            debugPrint("$text Progress Updated in UI: ${progress.value}");

            return CircularChart(
              progress: progress.value / 100, // 0.0 ~ 1.0 사이 값으로 정규화
              icon: icon,
              text: text,
            );
          }),
          SizedBox(height: 15.h),
          Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                '$quest',
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: const Color(0xFF111111),
                  fontSize: 16.sp,
                  fontWeight: FontWeight.w600,
                  height: 1.20,
                ),
              ),
              Text(
                '세트',
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: const Color(0xFF111111),
                  fontSize: 12.sp,
                  fontWeight: FontWeight.w400,
                  height: 1.20,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class HomeSmallButton extends StatelessWidget {
  final void Function() onTap;
  final String text;

  const HomeSmallButton({
    super.key,
    required this.controller,
    required this.onTap,
    required this.text,
  });

  final HomeController controller;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        height: 26.h,
        padding: EdgeInsets.symmetric(horizontal: 8.w),
        decoration: ShapeDecoration(
          color: Colors.white,
          shape: RoundedRectangleBorder(
            side: const BorderSide(width: 1, color: Color(0xFFA2A2A2)),
            borderRadius: BorderRadius.circular(16),
          ),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              text,
              style: TextStyle(
                color: const Color(0xFF767676),
                fontSize: 12.sp,
                fontWeight: FontWeight.w400,
                height: 1.50,
                letterSpacing: -0.30,
              ),
            ),
            SizedBox(
              width: 5.w,
            ),
            Icon(
              Icons.arrow_forward_ios,
              size: 9.42.w,
              color: const Color(0xff767676),
            ),
          ],
        ),
      ),
    );
  }
}

class HomeTitle extends StatelessWidget {
  final String title;

  const HomeTitle({
    super.key,
    required this.title,
  });

  @override
  Widget build(BuildContext context) {
    return Text(
      title,
      style: TextStyle(
        color: const Color(0xFF111111),
        fontSize: 20.sp,
        fontWeight: FontWeight.w500,
        height: 1.30,
        letterSpacing: -0.50,
      ),
    );
  }
}
