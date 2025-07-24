import 'package:economic_fe/view/theme/palette.dart';
import 'package:economic_fe/view/widgets/custom_app_bar.dart';
import 'package:economic_fe/view_model/notification/notification_controller.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

class NotificationPage extends StatefulWidget {
  const NotificationPage({super.key});

  @override
  State<NotificationPage> createState() => _NotificationPageState();
}

class _NotificationPageState extends State<NotificationPage> {
  final NotificationController controller = Get.put(NotificationController());

  // 스와이프 거리 상태를 저장할 맵
  final Map<int, double> swipeOffset = {};

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Palette.background,
      appBar: CustomAppBar(
        title: '알림',
        icon: Icons.close,
        onPress: () {
          Get.back();
        },
      ),
      body: Obx(() {
        if (controller.isLoading.value) {
          return const Center(
            child: CircularProgressIndicator(),
          );
        }

        if (controller.notifications.isEmpty) {
          return const Center(
            child: Text("알림이 없습니다."),
          );
        }

        return ListView.separated(
          separatorBuilder: (context, index) => const Divider(
            color: Color(0xffd9d9d9),
            height: 0,
          ),
          itemCount: controller.notifications.length,
          itemBuilder: (context, index) {
            final notification = controller.notifications[index];
            double maxSwipeOffset = 80.w; // 최대 스와이프 거리

            return SizedBox(
              height: 100.h, // 높이를 제한하여 오류 방지
              child: GestureDetector(
                onHorizontalDragUpdate: (details) {
                  setState(() {
                    double newOffset =
                        (swipeOffset[index] ?? 0) + details.primaryDelta!;
                    if (newOffset < -maxSwipeOffset) {
                      newOffset = -maxSwipeOffset;
                    } else if (newOffset > 0) {
                      newOffset = 0;
                    }
                    swipeOffset[index] = newOffset;
                  });
                },
                onHorizontalDragEnd: (details) {
                  setState(() {
                    if ((swipeOffset[index] ?? 0) <= -maxSwipeOffset / 2) {
                      swipeOffset[index] = -maxSwipeOffset;
                    } else {
                      swipeOffset[index] = 0;
                    }
                  });
                },
                child: Stack(
                  children: [
                    // 삭제 버튼 (고정된 배경)
                    Positioned.fill(
                      child: Align(
                        alignment: Alignment.centerRight,
                        child: Container(
                          width: maxSwipeOffset,
                          height: 100.h,
                          decoration:
                              const BoxDecoration(color: Color(0xFFFF5468)),
                          child: TextButton(
                            onPressed: () {
                              controller.deleteNotification(notification.id);
                              setState(() {
                                swipeOffset.remove(index);
                              });
                            },
                            child: Text(
                              '삭제',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 14.sp,
                                fontWeight: FontWeight.w500,
                                height: 1.30,
                                letterSpacing: -0.35,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),

                    // 알림 아이템 (스와이프 가능)
                    AnimatedPositioned(
                      duration: const Duration(milliseconds: 200),
                      curve: Curves.easeOut,
                      left: swipeOffset[index] ?? 0,
                      right: -(swipeOffset[index] ?? 0), // 수정: null 값 방지
                      child: GestureDetector(
                        onTap: () {
                          controller.onNotificationClick(
                              notification.id, notification.postId);
                        },
                        child: Container(
                          color: notification.isRead
                              ? const Color(0xFFF3F3F3)
                              : Colors.white,
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Padding(
                                padding: EdgeInsets.only(
                                  left: 16.w,
                                  top: 16.h,
                                  right: 8.w,
                                ),
                                child: Icon(
                                  notification.type == 'COMMENT'
                                      ? Icons.mark_unread_chat_alt_outlined
                                      : Icons.subdirectory_arrow_right,
                                ),
                              ),
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceAround,
                                children: [
                                  SizedBox(
                                    height: 16.h,
                                  ),
                                  Text(
                                    notification.type == 'COMMENT'
                                        ? '댓글 알림'
                                        : '대댓글 알림',
                                    style: TextStyle(
                                      color: const Color(0xFF404040),
                                      fontSize: 14.sp,
                                      fontWeight: notification.isRead
                                          ? FontWeight.normal
                                          : FontWeight.w500,
                                      height: 1.30,
                                      letterSpacing: -0.35,
                                    ),
                                  ),
                                  SizedBox(height: 8.h),
                                  Text(
                                    notification.content,
                                    style: TextStyle(
                                      color: notification.isRead
                                          ? const Color(0xFF909090)
                                          : const Color(0xFF404040),
                                      fontSize: 16.sp,
                                      fontWeight: notification.isRead
                                          ? FontWeight.normal
                                          : FontWeight.w500,
                                      height: 1.30,
                                      letterSpacing: -0.40,
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                  ),
                                  SizedBox(height: 9.h),
                                  SizedBox(
                                    width: MediaQuery.of(context).size.width -
                                        70.w,
                                    height: 30.h,
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Expanded(
                                          child: Text(
                                            '[${notification.postTitle}]',
                                            style: TextStyle(
                                              color: const Color(0xFFA2A2A2),
                                              fontSize: 12.sp,
                                              fontWeight: FontWeight.w400,
                                              height: 1.30,
                                              letterSpacing: -0.30,
                                            ),
                                          ),
                                        ),
                                        SizedBox(
                                          width: 8.w,
                                        ),
                                        Text(
                                          notification.createdDate,
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
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
        );
      }),
    );
  }
}
