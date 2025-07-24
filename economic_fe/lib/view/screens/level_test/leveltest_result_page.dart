import 'package:economic_fe/data/models/level_test/level_test_answer_model.dart';
import 'package:economic_fe/data/models/level_test/level_test_model.dart';
import 'package:economic_fe/utils/screen_utils.dart';
import 'package:economic_fe/view/theme/palette.dart';
import 'package:economic_fe/view_model/test/leveltest_result_controller.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

class LeveltestResultPage extends StatefulWidget {
  const LeveltestResultPage({super.key});

  @override
  State<LeveltestResultPage> createState() => _LeveltestResultPageState();
}

class _LeveltestResultPageState extends State<LeveltestResultPage> {
  final LevelTestResultController controller =
      Get.put(LevelTestResultController());
  late final Map<String, dynamic> response;
  late final List<LevelTestAnswerModel> answers;
  late final List<QuizModel> quizList;

  late final bool fromHome;

  final levelMap = {
    "BEGINNER": "초급",
    "INTERMEDIATE": "중급",
    "ADVANCED": "고급",
  };

  static const int totalQuizCount = 9;

  @override
  void initState() {
    super.initState();
    final arguments = Get.arguments as Map<String, dynamic>;
    response = arguments['response'];
    answers = arguments['answer'];
    quizList = arguments['quizList'];
    fromHome = arguments['fromHome'] ?? false;
  }

  @override
  Widget build(BuildContext context) {
    final levelKey = response["results"]["level"];
    final levelLabel = levelMap[levelKey] ?? "알 수 없음";
    final progress =
        (response["results"]["correctCount"] / totalQuizCount).clamp(0.0, 1.0);

    return Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            SizedBox(
              height: 54.h,
            ),
            Text(
              '레벨 테스트 결과',
              style: TextStyle(
                color: const Color(0xFF111111),
                fontSize: 18.sp,
                fontWeight: FontWeight.w500,
                height: 1.30,
                letterSpacing: -0.50,
              ),
            ),
            SizedBox(
              height: 15.h,
            ),
            Stack(
              alignment: Alignment.center,
              children: [
                CustomPaint(
                  size: Size(130.w, 130.h),
                  painter: CirclePainter(progress: progress),
                ),
                // 원형 차트의 중앙에 텍스트 추가
                Column(
                  children: [
                    Text(
                      '내 레벨',
                      style: TextStyle(
                        color: const Color(0xFFA2A2A2),
                        fontSize: 14.sp,
                        fontWeight: FontWeight.w400,
                        height: 1.20,
                        letterSpacing: -0.35,
                      ),
                    ),
                    SizedBox(
                      height: 9.h,
                    ),
                    // 레벨
                    Text(
                      levelLabel,
                      style: TextStyle(
                        color: const Color(0xFF111111),
                        fontSize: 25.sp,
                        fontWeight: FontWeight.w600,
                        height: 1.20,
                        letterSpacing: -0.80,
                      ),
                    ),
                  ],
                ),
              ],
            ),
            // 점수 해설 더보기창 버튼
            GestureDetector(
              onTap: () => showCategoryModal(context),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  SizedBox(
                    height: 40.h,
                  ),
                  Text(
                    '리플이 점수를 계산하는 방법',
                    style: TextStyle(
                      color: const Color(0xFF767676),
                      fontSize: 14.sp,
                      fontWeight: FontWeight.w400,
                      height: 1.20,
                      letterSpacing: -0.35,
                    ),
                  ),
                  SizedBox(
                    width: 5.w,
                  ),
                  Icon(
                    Icons.arrow_forward_ios,
                    size: 15.w,
                    color: const Color(0xFFD9D9D9),
                  ),
                ],
              ),
            ),
            SizedBox(
              height: 13.5.h,
            ),

            // 설명 영역 (스크롤 가능)
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 16.w),
              child: Container(
                padding: EdgeInsets.all(16.h),
                height: 280.h, // 최대 높이 제한
                decoration: ShapeDecoration(
                  shape: RoundedRectangleBorder(
                    side:
                        BorderSide(width: 1.w, color: const Color(0xFFA2A2A2)),
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
                child: SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // 레벨에 따른 텍스트 변경 필요
                      Text(
                        '${levelLabel == "초급" ? "축하합니다!" : levelLabel == "중급" ? "잘했어요!" : levelLabel == "고급" ? "대단합니다!" : "알 수 없음"} 🎉\n당신은 $levelLabel 단계입니다!',
                        style: TextStyle(
                          color: const Color(0xFF111111),
                          fontSize: 18.sp,
                          fontWeight: FontWeight.w600,
                          height: 1.50,
                          letterSpacing: -0.50.w,
                        ),
                      ),
                      SizedBox(
                        height: 10.h,
                      ),
                      Text(
                        _getLevelDescription(levelKey),
                        style: TextStyle(
                          color: const Color(0xFF111111),
                          fontSize: 15.sp,
                          fontWeight: FontWeight.w400,
                          height: 1.50.h,
                          letterSpacing: -0.40.w,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),

            SizedBox(height: 20.h),
            buildResultButton(
              text: '문제 및 해설',
              color: Palette.buttonColorGreen,
              onPressed: () {
                controller.toAnswer(response, answers, quizList);
              },
            ),
            SizedBox(height: 12.h),
            buildResultButton(
              text: '학습 시작하기',
              color: Palette.buttonColorBlue,
              onPressed: () {
                if (fromHome) {
                  Get.offAllNamed('/home'); // 홈으로 바로 이동
                } else {
                  controller.toProfileSetting(); // 기존 플로우
                }
              },
            ),
            SizedBox(height: 34.h),
          ],
        ),
      ),
    );
  }

  Widget buildResultButton({
    required String text,
    required Color color,
    required VoidCallback onPressed,
  }) {
    return ElevatedButton(
      onPressed: onPressed,
      style: ElevatedButton.styleFrom(
        minimumSize: Size(
          ScreenUtils.getWidth(context, 310),
          ScreenUtils.getHeight(context, 56),
        ),
        backgroundColor: color,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
        alignment: Alignment.center,
        padding: EdgeInsets.zero,
      ),
      child: Text(
        text,
        style: const TextStyle(
          color: Colors.white,
          fontSize: 20,
          fontWeight: FontWeight.w500,
        ),
      ),
    );
  }

  void showCategoryModal(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      builder: (BuildContext context) {
        final modalHeight = MediaQuery.of(context).size.height * 0.75;
        return StatefulBuilder(
          builder: (context, setState) {
            return Container(
              height: modalHeight,
              decoration: const BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
              ),
              child: Column(
                children: [
                  Padding(
                    padding: EdgeInsets.all(24.h),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          '점수 계산 방법',
                          style: TextStyle(
                            color: const Color(0xFF111111),
                            fontSize: 18.sp,
                            fontWeight: FontWeight.w600,
                            height: 1.20,
                            letterSpacing: -0.45,
                          ),
                        ),
                        GestureDetector(
                          onTap: () => Navigator.pop(context),
                          child: const Icon(Icons.close),
                        ),
                      ],
                    ),
                  ),
                  Expanded(
                    child: SingleChildScrollView(
                      padding: EdgeInsets.symmetric(
                          horizontal: 24.w, vertical: 24.h),
                      child: Text(
                        _getScoreDescription(),
                        style: TextStyle(
                          color: const Color(0xFF111111),
                          fontSize: 16.sp,
                          fontWeight: FontWeight.w400,
                          height: 1.50,
                          letterSpacing: -0.40,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            );
          },
        );
      },
    );
  }

  String _getLevelDescription(String level) {
    switch (level) {
      case "BEGINNER":
        return "경제를 처음 시작하려는 당신에게 딱 맞는 학습이 준비되어 있어요. 초급 단계에서는 어렵고 복잡하게 느껴질 수 있는 경제를 친근하게 다가갈 수 있도록 구성했어요. 기초적인 용어와 개념부터 차근차근 배우면서 경제의 기본기를 탄탄히 다질 수 있습니다. 배운 내용을 퀴즈로 복습하며 자신감을 쌓아보세요! 오늘부터 경제의 첫걸음을 가볍게 시작해 보세요! 😊";
      case "INTERMEDIATE":
        return "경제를 이해하고 활용하고자 하는 당신에게 적합한 수준이에요. 중급 단계에서는 경제가 일상 속에서 어떻게 작동하는지 다양한 사례와 함께 배우게 됩니다. 더 나아가, 경제 기사를 읽고 분석하며 복잡한 상황에서도 올바른 결정을 내릴 수 있는 능력을 기를 수 있습니다. 이 단계는 당신이 경제적 통찰력을 키우고 실생활에 적용할 수 있는 중요한 과정이에요. 이제 한층 더 깊이 있는 경제 학습을 시작해보세요!** 💪";
      case "ADVANCED":
        return "이미 탄탄한 경제 지식을 바탕으로 더욱 심화된 학습을 시작할 준비가 되었어요! 고급 단계에서는 복잡한 경제 이론과 글로벌 트렌드를 심도 있게 다루며, 경제적 관점을 확장할 수 있습니다. 경제를 분석하고 깊이 있는 통찰력을 통해 한발 앞서 나가는 힘을 기를 수 있어요. 당신은 이제 경제 분야에서 전문가 수준으로 도약할 수 있는 준비가 되어 있습니다. 오늘부터 심화된 학습으로 경제 지식을 한 단계 더 높여보세요! 🚀";
      default:
        return "알 수 없음";
    }
  }

  String _getScoreDescription() {
    return '''
✔️ 문제 구성 및 점수 배분
- 초급(OX 문제, 3개): 각 문제 1점
- 중급(사지선다 단답, 3개): 각 문제 2점
- 고급(사지선다 문장 답, 3개): 각 문제 3점
→ 총점: 0~18점

✔️ 단계 구분 기준
- 초급(Beginner): 0~6점
   - 초급 문제를 모두 맞히지 못하거나 일부만 맞힌 경우.
   - 기본 경제 개념 이해가 부족하거나, 처음 학습 단계에 해당.

- 중급(Intermediate): 7~12점
   - 초급 문제를 대부분 맞히고 중급 문제를 일부 맞힌 경우.
   - 경제의 기본 원리를 이해하며, 특정 주제에 대한 개념이 존재함.

- 고급(Advanced): 13~18점
   - 중급 문제를 대부분 맞히고 고급 문제도 상당 부분 맞힌 경우.
   - 복잡한 경제 원리와 실생활 적용 능력이 있음.
''';
  }
}

class CirclePainter extends CustomPainter {
  final double progress;

  CirclePainter({required this.progress});

  @override
  void paint(Canvas canvas, Size size) {
    final Paint grayPaint = Paint()
      ..color = const Color(0x33111111)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 18.w;

    final Paint greenPaint = Paint()
      ..color = const Color(0xFF2BD6D6)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 18.w;

    canvas.drawCircle(
      Offset(size.width / 2, size.height / 2),
      size.width / 2,
      grayPaint,
    );

    final double sweepAngle = 2 * 3.14159265359 * progress;

    canvas.drawArc(
      Rect.fromCircle(
        center: Offset(size.width / 2, size.height / 2),
        radius: size.width / 2,
      ),
      -3.14159265359 / 2,
      sweepAngle,
      false,
      greenPaint,
    );
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => false;
}
