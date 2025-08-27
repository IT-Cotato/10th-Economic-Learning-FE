import 'package:economic_fe/view/widgets/profile_setting/profile_button_selected.dart';
import 'package:economic_fe/view/widgets/profile_setting/profile_button_unselected.dart';
import 'package:economic_fe/view_model/profile_setting/job_select_controller.dart';
import 'package:economic_fe/view_model/profile_setting/part_select_controller.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

class SelectableButtonWrap extends StatelessWidget {
  final String subject; // 'job' or 'part'
  final int? partType;

  const SelectableButtonWrap({
    super.key,
    required this.subject,
    this.partType,
  });

  @override
  Widget build(BuildContext context) {
    final JobSelectController? jobController =
        subject == 'job' ? Get.find<JobSelectController>() : null;
    final PartSelectController? partController =
        subject == 'part' ? Get.find<PartSelectController>() : null;

    final bool isJob = subject == 'job';
    final List<String> itemList = isJob
        ? [
            '금융/보험',
            'IT/소프트웨어',
            '전자/반도체',
            '제조업',
            '건설/부동산',
            '의료/제약',
            '교육/출판',
            '유통/물류',
            '에너지/환경',
            '농업/축산업',
            '미디어/광고',
            '여행/관광',
            '공공기관/비영리단체',
            '스타트업/벤처',
            '기타',
          ]
        : _getPartList(partType!);

    return Wrap(
      spacing: 8.w,
      runSpacing: 12.h,
      children: itemList.map((label) {
        final bool isSelected = isJob
            ? jobController!.selectedJob.value == label
            : partController!.selectedPart.value == label;

        return GestureDetector(
          onTap: () => isJob
              ? jobController!.selectJob(label)
              : partController!.selectPart(label),
          child: Obx(() {
            final bool selected = isJob
                ? jobController!.selectedJob.value == label
                : partController!.selectedPart.value == label;

            return selected
                ? ProfileButtonSelected(
                    text: label,
                    paddingWidth: 8.w,
                    paddingHeight: 8.h,
                    fontSize: 16.sp,
                  )
                : ProfileButtonUnselected(
                    text: label,
                    paddingWidth: 8.w,
                    paddingHeight: 8.h,
                    fontSize: 16.sp,
                  );
          }),
        );
      }).toList(),
    );
  }

  List<String> _getPartList(int partType) {
    switch (partType) {
      case 1:
        return [
          '의사/간호사/보건의료',
          '변호사/법무사',
          '회계사/세무사',
          '교사/강사',
          '연구원/교수',
        ];
      case 2:
        return [
          '기획/전략',
          '마케팅/광고/홍보',
          '영업/판매',
          '재무/회계',
          '인사/교육',
          '고객 서비스/상담',
          '법무/감사',
        ];
      case 3:
        return [
          '개발자(프론트엔드/백엔드)',
          '데이터 분석/엔지니어',
          'UI/UX 디자이너',
          '네트워크/보안 전문가',
          'IT 관리자',
          '건설/토목/설계',
          '연구개발(R&D)',
        ];
      case 4:
        return [
          '외식업/요리사',
          '관광/여행 플래너',
          '창업/스타트업 운영자',
          '프리랜서',
        ];
      default:
        return [
          '공공/행정직 공무원',
          '군인/경찰/소방관',
          '엔터네이너/예술가',
          '기타',
        ];
    }
  }
}
