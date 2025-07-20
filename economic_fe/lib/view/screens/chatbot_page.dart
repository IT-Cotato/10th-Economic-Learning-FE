import 'package:economic_fe/view_model/chatbot_controller.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

class ChatbotPage extends StatelessWidget {
  ChatbotPage({super.key});
  final controller = Get.put(ChatbotController());
  final ScrollController scrollController = ScrollController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFFFFFF),
      appBar: AppBar(
        forceMaterialTransparency: true,
        backgroundColor: Colors.white,
        elevation: 0,
        title: const Text('챗봇',
            style: TextStyle(
              color: Color(0xFF111111),
              fontSize: 18,
              fontWeight: FontWeight.w600,
            )),
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new, color: Colors.black),
          onPressed: () => Get.back(),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.more_horiz, color: Colors.black),
            onPressed: () => _showDeleteDialog(context),
          )
        ],
      ),
      body: SafeArea(
        child: GestureDetector(
          behavior: HitTestBehavior.translucent,
          onTap: () => FocusScope.of(context).unfocus(),
          child: Obx(() {
            WidgetsBinding.instance.addPostFrameCallback((_) {
              scrollToBottom();
            });

            return Column(
              children: [
                Expanded(
                  child: ListView.builder(
                    controller: scrollController,
                    padding: EdgeInsets.symmetric(horizontal: 16.w),
                    itemCount: controller.messages.length,
                    itemBuilder: (_, index) {
                      final msg = controller.messages[index];
                      final isUser = msg.isUserMessage;
                      final isDate = msg.isDateMessage == true;

                      if (isDate) {
                        // 날짜 메시지 표시
                        return Center(
                          child: Container(
                            margin: EdgeInsets.symmetric(vertical: 12.h),
                            padding: EdgeInsets.symmetric(
                                horizontal: 16.w, vertical: 4.h),
                            decoration: BoxDecoration(
                              border:
                                  Border.all(color: const Color(0xFFA2A2A2)),
                              borderRadius: BorderRadius.circular(30),
                              color: Colors.white,
                            ),
                            child: Text(
                              msg.text,
                              style: TextStyle(
                                color: const Color(0xFF404040),
                                fontSize: 12.sp,
                              ),
                            ),
                          ),
                        );
                      }

                      // 사용자 메시지
                      if (isUser) {
                        return Align(
                          alignment: Alignment.centerRight,
                          child: Padding(
                            padding: EdgeInsets.symmetric(vertical: 6.h),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.end,
                              children: [
                                Container(
                                  padding: EdgeInsets.symmetric(
                                      horizontal: 14.w, vertical: 10.h),
                                  decoration: BoxDecoration(
                                    color: const Color(0xFF1DB691),
                                    borderRadius: BorderRadius.circular(12),
                                    border: Border.all(
                                      color: const Color(0xFFA2A2A2),
                                      width: 0.5,
                                    ),
                                  ),
                                  child: Text(
                                    msg.text,
                                    style: TextStyle(
                                      fontSize: 15.sp,
                                      color: Colors.white,
                                    ),
                                  ),
                                ),
                                const SizedBox(height: 4),
                                Text(
                                  msg.time ?? '',
                                  style: TextStyle(
                                    fontSize: 12.sp,
                                    color: const Color(0xFFA2A2A2),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        );
                      }

                      // 챗봇 메시지
                      return Padding(
                        padding: EdgeInsets.symmetric(vertical: 6.h),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Padding(
                              padding: EdgeInsets.only(right: 8.w),
                              child: Column(
                                children: [
                                  Container(
                                    width: 40.w,
                                    height: 40.w, // 정사각형으로 유지
                                    decoration: BoxDecoration(
                                      shape: BoxShape.circle,
                                      border: Border.all(
                                        color: const Color(0xFFA2A2A2),
                                        width: 0.5,
                                      ),
                                      color: Colors.white,
                                    ),
                                    child: Center(
                                      child: Image.asset(
                                        'assets/icon.png',
                                        width: 20.w,
                                        height: 20.w,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    '챗봇',
                                    style: TextStyle(
                                      fontSize: 12.sp,
                                      color: const Color(0xFF767676),
                                    ),
                                  ),
                                  const SizedBox(height: 4),
                                  Container(
                                    padding: EdgeInsets.symmetric(
                                        horizontal: 14.w, vertical: 10.h),
                                    decoration: BoxDecoration(
                                      color: const Color(0xFFF2F3F5),
                                      borderRadius: BorderRadius.circular(12),
                                      border: Border.all(
                                        color: const Color(0xFFA2A2A2),
                                        width: 0.5,
                                      ),
                                    ),
                                    child: Text(
                                      msg.text,
                                      style: TextStyle(
                                        fontSize: 15.sp,
                                        color: const Color(0xFF404040),
                                      ),
                                    ),
                                  ),
                                  const SizedBox(height: 4),
                                  // 시간 표시: 자동 인사 메시지는 제외
                                  if (!msg.text.contains('무엇을 도와드릴까요?'))
                                    Text(
                                      msg.time ?? '',
                                      style: TextStyle(
                                        fontSize: 12.sp,
                                        color: const Color(0xFFA2A2A2),
                                      ),
                                    ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      );
                    },
                  ),
                ),

                // 챗봇 꿀팁 슬라이드 모달
                Obx(() {
                  return Column(
                    children: [
                      // 슬라이더 바 (항상 보임)
                      GestureDetector(
                        onTap: () {
                          controller.isExpanded.value =
                              !controller.isExpanded.value;
                        },
                        child: Container(
                          width: double.infinity,
                          padding: const EdgeInsets.all(10),
                          decoration: const ShapeDecoration(
                            color: Color(0xFFDEF7F1),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.only(
                                topLeft: Radius.circular(10),
                                topRight: Radius.circular(10),
                              ),
                            ),
                          ),
                          child: Center(
                            child: Image.asset(
                              'assets/chatbot_slider.png',
                              width: 40,
                              height: 4,
                            ),
                          ),
                        ),
                      ),

                      // 확장된 꿀팁 영역 (isExpanded가 true일 때만 표시)
                      if (controller.isExpanded.value)
                        GestureDetector(
                          onTap: () {
                            controller.getChatbotTips();
                          },
                          child: Container(
                            width: double.infinity,
                            padding: const EdgeInsets.all(12),
                            decoration: const BoxDecoration(
                              color: Color(0xFFDEF7F1),
                              borderRadius: BorderRadius.only(
                                topLeft: Radius.circular(12),
                                topRight: Radius.circular(12),
                              ),
                            ),
                            child: Row(
                              children: [
                                Image.asset('assets/chatbot.png', width: 24),
                                const SizedBox(width: 8),
                                const Text(
                                  '챗봇 이용 꿀팁',
                                  style: TextStyle(
                                    color: Color(0xFF404040),
                                    fontWeight: FontWeight.w500,
                                    fontSize: 14,
                                    height: 1.4,
                                    letterSpacing: -0.35,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                    ],
                  );
                }),

                // 메시지 입력창
                Padding(
                  padding:
                      EdgeInsets.symmetric(horizontal: 16.w, vertical: 14.h),
                  child: Container(
                    decoration: ShapeDecoration(
                      color: const Color(0xFFF2F3F5),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(17),
                      ),
                    ),
                    padding:
                        EdgeInsets.symmetric(horizontal: 12.w, vertical: 10.h),
                    child: Row(
                      children: [
                        Expanded(
                          child: TextField(
                            controller: controller.messageController,
                            onChanged: controller.updateMessage,
                            decoration: const InputDecoration(
                              hintText: '메시지를 입력해주세요.',
                              border: InputBorder.none,
                            ),
                            minLines: 1,
                            maxLines: 5,
                          ),
                        ),
                        Obx(() {
                          return IconButton(
                            onPressed: controller.messageText.value.isNotEmpty
                                ? () async {
                                    scrollToBottom();
                                    await controller.postChatbotMessage();
                                  }
                                : null,
                            icon: Icon(
                              Icons.send,
                              color: controller.messageText.value.isNotEmpty
                                  ? const Color(0xFF1DB691)
                                  : Colors.grey,
                            ),
                          );
                        })
                      ],
                    ),
                  ),
                )
              ],
            );
          }),
        ),
      ),
    );
  }

  void _showDeleteDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(0),
          ),
          backgroundColor: Colors.white,
          contentPadding: const EdgeInsets.all(10),
          content: Container(
            width: 324,
            height: 54,
            padding: const EdgeInsets.only(
              top: 10,
              left: 27,
              right: 10,
              bottom: 10,
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                GestureDetector(
                  onTap: () {
                    Navigator.of(context).pop();
                    _showDeleteConfirmDialog(context);
                  },
                  child: const Text(
                    '채팅 삭제하기',
                    style: TextStyle(
                      color: Color(0xFF111111),
                      fontSize: 22,
                      fontWeight: FontWeight.w500,
                      height: 1.30,
                      letterSpacing: -0.55,
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  void _showDeleteConfirmDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8),
          ),
          backgroundColor: Colors.white,
          content: Padding(
            padding: EdgeInsets.symmetric(horizontal: 4.w, vertical: 12.h),
            child: SizedBox(
              width: 304.w,
              height: 84.h,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Text(
                        '정말 채팅 기록을 삭제하시겠어요?',
                        style: TextStyle(
                          color: Color(0xFF111111),
                          fontSize: 16,
                          fontWeight: FontWeight.w400,
                          height: 1.40,
                          letterSpacing: -0.40,
                        ),
                      ),
                    ],
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      GestureDetector(
                        onTap: () => Navigator.of(context).pop(),
                        child: const Text(
                          '취소',
                          style: TextStyle(
                            color: Color(0xFF9B9A99),
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                            height: 1.40,
                            letterSpacing: -0.40,
                          ),
                        ),
                      ),
                      const SizedBox(width: 32),
                      GestureDetector(
                        onTap: () {
                          controller.deleteMessage();
                          Navigator.of(context).pop();
                        },
                        child: const Text(
                          '삭제',
                          style: TextStyle(
                            color: Color(0xFF2AD6D6),
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                            height: 1.40,
                            letterSpacing: -0.40,
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  void scrollToBottom() {
    Future.delayed(const Duration(milliseconds: 100), () {
      if (scrollController.hasClients) {
        scrollController.animateTo(
          scrollController.position.maxScrollExtent,
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeOut,
        );
      }
    });
  }
}
