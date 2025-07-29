import 'dart:io';

import 'package:economic_fe/view/theme/palette.dart';
import 'package:economic_fe/view/widgets/custom_bottom_bar.dart';
import 'package:economic_fe/view_model/mypage/mypage_home_controller.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

class MypageHomePage extends StatefulWidget {
  const MypageHomePage({super.key});

  @override
  State<MypageHomePage> createState() => _MypageHomePageState();
}

class _MypageHomePageState extends State<MypageHomePage> {
  final MypageHomeController controller = Get.find();

  @override
  void initState() {
    super.initState();
    // 페이지 진입 시마다 데이터 갱신
    WidgetsBinding.instance.addPostFrameCallback((_) {
      controller.refreshMypageData();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Palette.background,
      appBar: AppBar(
        backgroundColor: Palette.background,
        forceMaterialTransparency: true,
        automaticallyImplyLeading: false,
        title: Row(
          children: [
            Image.asset(
              'assets/icon.png',
              width: 25.88.w,
              height: 31.74.h,
            ),
            SizedBox(
              width: 4.w,
            ),
            Text(
              'Ripple',
              style: TextStyle(
                color: const Color(0xFF111111),
                fontSize: 22.40.sp,
                fontFamily: 'Palanquin',
                fontWeight: FontWeight.w400,
                letterSpacing: -0.45,
              ),
            ),
          ],
        ),
        actions: [
          GestureDetector(
            onTap: () {
              Get.toNamed('/notification');
            }, // 알림 화면으로
            child: Icon(
              Icons.notifications_none,
              size: 24.w,
              color: const Color(0xff1c1b1f),
            ),
          ),
          Padding(
            padding: EdgeInsets.only(right: 20.w, left: 8.w),
            child: GestureDetector(
              onTap: () {
                Get.toNamed('/mypage/setting');
              }, // 설정 화면으로
              child: Icon(
                Icons.settings_outlined,
                size: 24.w,
                color: const Color(0xff1c1b1f),
              ),
            ),
          ),
        ],
      ),
      bottomNavigationBar: const CustomBottomBar(currentIndex: 4),
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: 16.w),
        child: Obx(() {
          if (controller.isLoading.value) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }

          final user = controller.userInfo.value;
          if (user == null) {
            return const Center(
              child: Text("사용자 정보를 불러오지 못했습니다."),
            );
          }

          return ListView(
            children: [
              Padding(
                padding: EdgeInsets.only(top: 10.h),
                child: Row(
                  children: [
                    // 사용자 프로필 사진
                    SizedBox(
                      height: 81.h,
                      child: Stack(
                        children: [
                          Container(
                            width: 81.w,
                            height: 81.h,
                            decoration: ShapeDecoration(
                              color: const Color(0xFFF3F3F3),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(43),
                              ),
                            ),
                            child: controller.selectedProfileImage.value != null
                                ? ClipOval(
                                    child: Image.file(
                                      File(controller
                                          .selectedProfileImage.value!),
                                      fit: BoxFit.cover,
                                      width: 81.w,
                                      height: 81.h,
                                    ),
                                  )
                                : user.profileImageURL != null
                                    ? ClipOval(
                                        child: Image(
                                          image: NetworkImage(
                                              user.profileImageURL!),
                                          fit: BoxFit.cover,
                                          width: 81.w,
                                          height: 81.h,
                                        ),
                                      )
                                    : Icon(
                                        Icons.person,
                                        size: 35.w,
                                      ),
                          ),
                          Positioned(
                            bottom: 0,
                            right: 0,
                            // 카메라 버튼
                            child: GestureDetector(
                              onTap: () {
                                Get.toNamed('/profile_setting',
                                    arguments: controller.userInfo.value);
                              },
                              child: Container(
                                width: 26.w,
                                height: 26.h,
                                decoration: ShapeDecoration(
                                  color: Colors.white,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(26),
                                  ),
                                  shadows: const [
                                    BoxShadow(
                                      color: Color(0x3F000000),
                                      blurRadius: 4,
                                      offset: Offset(0, 0),
                                      spreadRadius: 0,
                                    )
                                  ],
                                ),
                                child: Icon(
                                  Icons.edit_outlined,
                                  size: 15.w,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(
                      width: 16.w,
                    ),
                    GestureDetector(
                      onTap: () {
                        Get.toNamed('/mypage/profile');
                      },
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // 사용자 이름
                          Text(
                            user.nickname,
                            style: TextStyle(
                              color: Colors.black,
                              fontSize: 20.sp,
                              fontWeight: FontWeight.w600,
                              height: 1.40,
                              letterSpacing: -0.50,
                            ),
                          ),
                          // 생년월일
                          Text(
                            controller.formatBirthDate(user.birthDate),
                            style: TextStyle(
                              color: const Color(0xFF767676),
                              fontSize: 12.sp,
                              fontWeight: FontWeight.w400,
                              height: 1.50,
                              letterSpacing: -0.30,
                            ),
                          ),
                          SizedBox(
                            height: 6.h,
                          ),
                          // 한 줄 소개
                          Text(
                            controller.truncateIntro(user.profileIntro),
                            style: TextStyle(
                              color: const Color(0xFF404040),
                              fontSize: 14.sp,
                              fontWeight: FontWeight.w400,
                              height: 1.30,
                              letterSpacing: -0.35,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              Padding(
                padding: EdgeInsets.only(top: 17.h),
                child: Row(
                  children: [
                    // 직무
                    JobContainer(text: user.job),
                    SizedBox(
                      width: 8.w,
                    ),
                    // 업종
                    JobContainer(text: user.businessType),
                  ],
                ),
              ),
              SizedBox(
                height: 24.h,
              ),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 16.w),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                      children: [
                        Text(
                          '연속 학습일',
                          style: TextStyle(
                            color: const Color(0xFF4A4A4A),
                            fontSize: 12.sp,
                            fontWeight: FontWeight.w400,
                            height: 0.80,
                          ),
                        ),
                        SizedBox(
                          height: 11.h,
                        ),
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: [
                            // 연속 학습일 수
                            Obx(() => Text(
                                  '${controller.currentStreak.value}',
                                  style: TextStyle(
                                    color: const Color(0xFF2AD6D6),
                                    fontSize: 32.sp,
                                    fontWeight: FontWeight.w600,
                                    height: 0.80,
                                  ),
                                )),
                            Text(
                              '일째',
                              style: TextStyle(
                                color: const Color(0xFF4A4A4A),
                                fontSize: 12.sp,
                                fontWeight: FontWeight.w400,
                                height: 0.80,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                    Container(
                      width: 1.w,
                      height: 76.h,
                      color: const Color(0xffa2a2a2),
                    ),
                    Column(
                      children: [
                        Text(
                          '나의 레벨',
                          style: TextStyle(
                            color: const Color(0xFF4A4A4A),
                            fontSize: 12.sp,
                            fontWeight: FontWeight.w400,
                            height: 0.80,
                          ),
                        ),
                        SizedBox(
                          height: 9.h,
                        ),
                        // 나의 레벨
                        Text(
                          controller.convertLevel(user.level!),
                          style: TextStyle(
                            color: const Color(0xFF2AD6D6),
                            fontSize: 24.sp,
                            fontWeight: FontWeight.w700,
                            height: 1.30,
                            letterSpacing: -0.60,
                          ),
                        ),
                      ],
                    ),
                    Container(
                      width: 1.w,
                      height: 76.h,
                      color: const Color(0xffa2a2a2),
                    ),
                    Column(
                      children: [
                        Text(
                          '퀴즈 정답률',
                          style: TextStyle(
                            color: const Color(0xFF4A4A4A),
                            fontSize: 12.sp,
                            fontWeight: FontWeight.w400,
                            height: 0.80,
                          ),
                        ),
                        SizedBox(
                          height: 9.h,
                        ),
                        // 퀴즈 정답률
                        Text(
                          '${user.quizCorrectRate}%',
                          style: TextStyle(
                            color: const Color(0xFF2AD6D6),
                            fontSize: 24.sp,
                            fontWeight: FontWeight.w700,
                            height: 1.30,
                            letterSpacing: -0.60,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              SizedBox(
                height: 28.h,
              ),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 5.w),
                child: Obx(() {
                  if (controller.isCheckedList.length < 7) {
                    return const CircularProgressIndicator(); // 데이터 로딩 중
                  }
                  final days = ['일', '월', '화', '수', '목', '금', '토'];
                  return Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: List.generate(7, (index) {
                      return DailyCheck(
                        day: days[index],
                        isChecked: controller.isCheckedList[index],
                      );
                    }),
                  );
                }),
              ),
              SizedBox(
                height: 28.h,
              ),
              MyContentsContainer(
                title: '틀린 문제 다시 풀기',
                subTitle: '퀴즈에서 틀린 문제를 다시 풀 수 있어요',
                onTap: () {
                  Get.toNamed('/mypage/wrong');
                },
              ),
              SizedBox(
                height: 12.h,
              ),
              MyContentsContainer(
                title: '스크랩 한 나의 학습',
                subTitle: '스크랩 한 퀴즈, 학습, 단어를 확인해요',
                onTap: () {
                  Get.toNamed('/mypage/learning');
                },
              ),
              SizedBox(
                height: 12.h,
              ),
              MyContentsContainer(
                title: '커뮤니티 활동',
                subTitle: '스크랩 및 좋아요 한 커뮤니티 내용을 확인해요',
                onTap: () {
                  Get.toNamed('/mypage/community');
                },
              ),
              SizedBox(
                height: 12.h,
              ),
              MyContentsContainer(
                title: '스크랩 한 기사',
                subTitle: '스크랩 한 기사 내용을 확인해요',
                onTap: () {
                  Get.toNamed('/mypage/article');
                },
              ),
              SizedBox(
                height: 24.h,
              ),
            ],
          );
        }),
      ),
    );
  }
}

class MyContentsContainer extends StatelessWidget {
  final String title;
  final String subTitle;
  final Function() onTap;

  const MyContentsContainer({
    super.key,
    required this.title,
    required this.subTitle,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: MediaQuery.of(context).size.width - 32.w,
        height: 80.h,
        padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
        decoration: ShapeDecoration(
          color: Colors.white,
          shape: RoundedRectangleBorder(
            side: const BorderSide(width: 1, color: Color(0xFFA2A2A2)),
            borderRadius: BorderRadius.circular(8),
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              title,
              style: TextStyle(
                color: const Color(0xFF111111),
                fontSize: 14.sp,
                fontWeight: FontWeight.w400,
                height: 1.30,
                letterSpacing: -0.35,
              ),
            ),
            SizedBox(
              height: 4.h,
            ),
            Text(
              subTitle,
              style: TextStyle(
                color: const Color(0xFF404040),
                fontSize: 12.sp,
                fontWeight: FontWeight.w400,
                height: 1.30,
                letterSpacing: -0.30,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class DailyCheck extends StatelessWidget {
  final String day;
  final bool isChecked;

  const DailyCheck({
    super.key,
    required this.day,
    required this.isChecked,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(
          day,
          style: TextStyle(
            color: const Color(0xFF111111),
            fontSize: 12.sp,
            fontFamily: 'Noto',
            fontWeight: FontWeight.w500,
          ),
        ),
        SizedBox(
          height: 6.h,
        ),
        Container(
          width: 38.w,
          height: 38.h,
          decoration: ShapeDecoration(
            color:
                isChecked ? const Color(0xFF2AD6D6) : const Color(0xfff2f3f5),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(36),
            ),
          ),
          child: Center(
            child: Container(
              width: 20.w,
              height: 20.h,
              padding: const EdgeInsets.all(2),
              decoration: ShapeDecoration(
                color: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
              child: Icon(
                Icons.check,
                color: isChecked
                    ? const Color(0xFF2AD6D6)
                    : const Color(0xfff2f3f5),
                size: 15.w,
              ),
            ),
          ),
        ),
      ],
    );
  }
}

class JobContainer extends StatelessWidget {
  final String text;

  const JobContainer({
    super.key,
    required this.text,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 4.h),
      decoration: ShapeDecoration(
        color: Colors.white,
        shape: RoundedRectangleBorder(
          side: const BorderSide(width: 1, color: Color(0xFFA2A2A2)),
          borderRadius: BorderRadius.circular(20),
        ),
      ),
      child: Text(
        text,
        style: TextStyle(
          color: const Color(0xFF767676),
          fontSize: 12.sp,
          fontWeight: FontWeight.w400,
          height: 1.50,
          letterSpacing: -0.30,
        ),
      ),
    );
  }
}
