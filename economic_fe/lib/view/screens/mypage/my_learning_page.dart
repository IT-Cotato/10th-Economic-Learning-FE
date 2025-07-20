import 'package:economic_fe/view/screens/mypage/scrap_learning_set_page.dart';
import 'package:economic_fe/view/screens/quiz/scrap_quiz_page.dart';
import 'package:economic_fe/view/theme/palette.dart';
import 'package:economic_fe/view/widgets/custom_app_bar.dart';
import 'package:economic_fe/view/widgets/mypage/level_container.dart';
import 'package:economic_fe/view/widgets/mypage/scrap_word_list_view.dart';
import 'package:economic_fe/view_model/mypage/my_learning_controller.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

class MyLearningPage extends StatefulWidget {
  const MyLearningPage({super.key});

  @override
  State<MyLearningPage> createState() => _MyLearningPageState();
}

class _MyLearningPageState extends State<MyLearningPage> {
  final MyLearningController controller = Get.put(MyLearningController());

  @override
  void initState() {
    super.initState();
    controller.fetchScrapQuizzes(); // 초기 데이터 로드
    controller.fetchScrapConcepts();
  }

  // "스크랩 한 모든 퀴즈 다시 풀기" 버튼 클릭 시 모든 퀴즈 진행 함수
  void startRetryAllScrapQuestions() {
    if (controller.scrapQuizzes.isNotEmpty) {
      List<Map<String, dynamic>> incorrectQuizzes = controller.scrapQuizzes;
      navigateToQuiz(0, incorrectQuizzes);
    }
  }

  // 퀴즈를 순차적으로 진행하는 함수
  void navigateToQuiz(int index, List<Map<String, dynamic>> quizzes) {
    Get.off(
      const ScrapQuizPage(),
      arguments: {
        'quizId': quizzes[index]['quizId'],
        'learningSetName': quizzes[index]['learningSetName'],
        // 'option': quizzes[index]['type'] == "OX" ? 1 : 0,
        'isMultiQuizMode': true, // 연속 퀴즈 모드 활성화
        'currentIndex': index + 1,
        'totalIndex': quizzes.length,
        'quizzes': quizzes, // 전체 리스트 전달
      },
    );
  }

  // "스크랩 한 모든 학습 다시 보기" 버튼 클릭 시 모든 학습 진행 함수
  void startRetryAllScrapConcepts() {
    if (controller.scrapConcepts.isNotEmpty) {
      List<Map<String, dynamic>> scrapConcepts = controller.scrapConcepts;
      navigateToConcept(0, scrapConcepts);
    }
  }

  // 학습을 순차적으로 진행하는 함수
  void navigateToConcept(int index, List<Map<String, dynamic>> concepts) {
    Get.off(
      const ScrapLearningSetPage(),
      arguments: {
        'isMultiLearningMode': true,
        'currentIndex': index + 1,
        'totalIndex': concepts.length,
        'learningSets': concepts,
        'learningSetId': concepts[index]['id'],
        'learningSetName': concepts[index]['LearningSetName'],
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Palette.background,
      appBar: CustomAppBar(
        title: '나의 학습',
        icon: Icons.arrow_back_ios_new,
        onPress: () => Get.toNamed('/mypage'),
      ),
      body: Padding(
        padding: EdgeInsets.only(top: 12.h),
        child: Column(
          children: [
            Container(
              height: 1.h,
              color: Colors.black,
            ),
            // 탭바
            Container(
              color: Colors.white,
              child: TabBar(
                controller: controller.tabController,
                labelColor: Colors.black,
                labelStyle: TextStyle(
                  fontSize: 14.sp,
                  fontWeight: FontWeight.w600,
                ),
                unselectedLabelColor: const Color(0xff767676),
                indicatorColor: Colors.black,
                indicatorWeight: 3.0,
                indicatorSize: TabBarIndicatorSize.tab,
                tabs: const [
                  Tab(text: '스크랩 한 퀴즈'),
                  Tab(text: '스크랩 한 학습'),
                  Tab(text: '스크랩 한 단어'),
                ],
              ),
            ),
            // 탭 컨텐츠
            Expanded(
              child: TabBarView(
                controller: controller.tabController,
                children: [
                  // 스크랩 한 퀴즈 화면
                  _buildScrapQuizzesTab(
                      controller, startRetryAllScrapQuestions),
                  // 스크랩 한 학습 화면
                  _buildScrapLearningTab(
                      controller, startRetryAllScrapConcepts),
                  // 스크랩 한 단어 화면
                  const ScrapedWordListView(),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

Widget _buildScrapQuizzesTab(
    MyLearningController controller, Function() startRetry) {
  return Column(
    children: [
      Padding(
        padding: EdgeInsets.only(top: 22.h, left: 15.w),
        child: Row(
          children: [
            Obx(
              () => LevelContainer(
                level: '초급',
                isSelected: controller.selectedLevel.value == 'BEGINNER',
                onTap: () {
                  controller.updateSelectedLevel('BEGINNER');
                },
              ),
            ),
            SizedBox(width: 8.w),
            Obx(
              () => LevelContainer(
                level: '중급',
                isSelected: controller.selectedLevel.value == 'INTERMEDIATE',
                onTap: () {
                  controller.updateSelectedLevel('INTERMEDIATE');
                },
              ),
            ),
            SizedBox(width: 8.w),
            Obx(
              () => LevelContainer(
                level: '고급',
                isSelected: controller.selectedLevel.value == 'ADVANCED',
                onTap: () {
                  controller.updateSelectedLevel('ADVANCED');
                },
              ),
            ),
          ],
        ),
      ),
      SizedBox(height: 18.h),
      // 스크랩 한 모든 퀴즈 다시 풀기 버튼
      Padding(
        padding: EdgeInsets.only(left: 16.w),
        child: GestureDetector(
          onTap: () {
            startRetry();
          },
          child: Obx(
            () => Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Text(
                      controller.buttonText.value,
                      style: TextStyle(
                        color: const Color(0xFF067BD5),
                        fontSize: 14.sp,
                        fontWeight: FontWeight.w700,
                        height: 1.40,
                        letterSpacing: -0.35,
                      ),
                    ),
                    SizedBox(width: 3.w),
                    Icon(
                      Icons.arrow_circle_right,
                      color: const Color(0xff067bd5),
                      size: 15.sp,
                    ),
                  ],
                ),
                Container(
                  width: 185.w,
                  height: 1.h,
                  color: const Color(0xff067bd5),
                ),
              ],
            ),
          ),
        ),
      ),
      SizedBox(height: 15.h),
      // 학습 리스트
      Expanded(
        child: Obx(() {
          if (controller.scrapQuizzes.isEmpty) {
            return Center(
              child: Text(
                '데이터가 없습니다.',
                style: TextStyle(
                  fontSize: 16.sp,
                  color: const Color(0xFF767676),
                ),
              ),
            );
          }
          return ListView.builder(
            itemCount: controller.scrapQuizzes.length,
            itemBuilder: (context, index) {
              final quiz = controller.scrapQuizzes[index];
              return Padding(
                padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h),
                child: GestureDetector(
                  onTap: () {
                    Get.to(const ScrapQuizPage(), arguments: {
                      'quizId': quiz['quizId'],
                      'learningSetName': quiz['learningSetName'],
                    });
                  },
                  child: Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(10),
                      border: Border.all(
                        color: const Color(0xFFD9D9D9),
                        width: 1,
                      ),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Flexible(
                          // 또는 Expanded
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                quiz['learningSetName'] ?? '',
                                style: TextStyle(
                                  color: const Color(0xFF767676),
                                  fontSize: 14.sp,
                                  fontWeight: FontWeight.w400,
                                ),
                              ),
                              const SizedBox(height: 2),
                              Text(
                                (quiz['quizName'] ?? '').length > 20
                                    ? '${quiz['quizName'].substring(0, 20)}...'
                                    : (quiz['quizName'] ?? ''),
                                overflow:
                                    TextOverflow.ellipsis, // 혹시나 더 넘칠 때 대비
                                style: TextStyle(
                                  color: const Color(0xFF404040),
                                  fontSize: 18.sp,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ],
                          ),
                        ),
                        GestureDetector(
                          onTap: () {},
                          child: const Icon(
                            Icons.bookmark,
                            color: Palette.buttonColorGreen,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              );
            },
          );
        }),
      ),
    ],
  );
}

Widget _buildScrapLearningTab(
    MyLearningController controller, Function() startRetry) {
  return Column(
    children: [
      Padding(
        padding: EdgeInsets.only(top: 22.h, left: 15.w),
        child: Row(
          children: [
            Obx(
              () => LevelContainer(
                level: '초급',
                isSelected: controller.selectedLevel.value == 'BEGINNER',
                onTap: () {
                  controller.updateSelectedLevel('BEGINNER');
                },
              ),
            ),
            SizedBox(width: 8.w),
            Obx(
              () => LevelContainer(
                level: '중급',
                isSelected: controller.selectedLevel.value == 'INTERMEDIATE',
                onTap: () {
                  controller.updateSelectedLevel('INTERMEDIATE');
                },
              ),
            ),
            SizedBox(width: 8.w),
            Obx(
              () => LevelContainer(
                level: '고급',
                isSelected: controller.selectedLevel.value == 'ADVANCED',
                onTap: () {
                  controller.updateSelectedLevel('ADVANCED');
                },
              ),
            ),
          ],
        ),
      ),
      SizedBox(height: 18.h),
      // 스크랩 한 모든 학습 다시 보기 버튼
      Padding(
        padding: EdgeInsets.only(left: 16.w),
        child: GestureDetector(
          onTap: () {
            startRetry();
          },
          child: Obx(
            () => Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Text(
                      controller.buttonText.value,
                      style: TextStyle(
                        color: const Color(0xFF067BD5),
                        fontSize: 14.sp,
                        fontWeight: FontWeight.w700,
                        height: 1.40,
                        letterSpacing: -0.35,
                      ),
                    ),
                    SizedBox(width: 3.w),
                    Icon(
                      Icons.arrow_circle_right,
                      color: const Color(0xff067bd5),
                      size: 15.w,
                    ),
                  ],
                ),
                Container(
                  width: 185.w,
                  height: 1,
                  color: const Color(0xff067bd5),
                ),
              ],
            ),
          ),
        ),
      ),
      SizedBox(height: 15.h),
      // 학습 리스트
      Expanded(
        child: Obx(() {
          if (controller.scrapConcepts.isEmpty) {
            return Center(
              child: Text(
                '스크랩한 학습이 없습니다.',
                style: TextStyle(
                  fontSize: 16.sp,
                  color: const Color(0xFF767676),
                ),
              ),
            );
          }
          return ListView.builder(
            itemCount: controller.scrapConcepts.length,
            itemBuilder: (context, index) {
              final concept = controller.scrapConcepts[index];
              return Padding(
                padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h),
                child: GestureDetector(
                  onTap: () {
                    Get.toNamed(
                      '/mypage/learning/learning_concept',
                      arguments: {
                        "learningSetId": concept['id'],
                        "learningSetName": concept['LearningSetName'],
                      },
                    );
                  },
                  child: Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(10),
                      border: Border.all(
                        color: const Color(0xFFD9D9D9),
                        width: 1.w,
                      ),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              concept['LearningSetName'] ?? '',
                              style: TextStyle(
                                color: const Color(0xFF767676),
                                fontSize: 14.sp,
                                fontWeight: FontWeight.w400,
                              ),
                            ),
                            SizedBox(height: 2.h),
                            Text(
                              concept['name'] ?? '',
                              style: TextStyle(
                                color: const Color(0xFF404040),
                                fontSize: 18.sp,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ],
                        ),
                        GestureDetector(
                          onTap: () {
                            controller.deleteScrapedConcept(concept['id']);
                          },
                          child: const Icon(
                            Icons.bookmark,
                            color: Palette.buttonColorGreen,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              );
            },
          );
        }),
      ),
    ],
  );
}
