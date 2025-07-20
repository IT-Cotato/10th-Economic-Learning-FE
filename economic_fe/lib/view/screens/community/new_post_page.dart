import 'dart:io';

import 'package:economic_fe/view/theme/palette.dart';
import 'package:economic_fe/view/widgets/category_tab.dart';
import 'package:economic_fe/view_model/community/new_post_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class NewPostPage extends StatelessWidget {
  const NewPostPage({super.key});

  @override
  Widget build(BuildContext context) {
    final NewPostController controller = Get.put(NewPostController());

    return Scaffold(
      backgroundColor: Palette.background,
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        backgroundColor: Palette.background,
        forceMaterialTransparency: true,
        leading: GestureDetector(
          onTap: () => Get.back(),
          child: const Icon(Icons.close),
        ),
        title: const Text(
          '일반 게시판',
          style: TextStyle(
            color: Color(0xFF111111),
            fontSize: 20,
            fontWeight: FontWeight.w500,
            height: 1.30,
            letterSpacing: -0.50,
          ),
        ),
        centerTitle: true,
        actions: [
          Obx(() {
            return Padding(
              padding: const EdgeInsets.only(right: 16),
              child: GestureDetector(
                onTap: controller.isUploadBtnEnabled.value
                    ? controller.submitPost
                    : null,
                child: Text(
                  '등록',
                  style: TextStyle(
                    color: controller.isUploadBtnEnabled.value
                        ? const Color(0xFF111111)
                        : const Color(0xFFD9D9D9),
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    height: 1.50,
                  ),
                ),
              ),
            );
          }),
        ],
      ),
      body: Stack(
        children: [
          Positioned.fill(
            child: Column(
              children: [
                // 카테고리 탭
                Obx(() {
                  return SizedBox(
                    height: 53,
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 16, vertical: 8),
                      child: ListView(
                        scrollDirection: Axis.horizontal,
                        children: [
                          GestureDetector(
                            onTap: () => controller.selectCategory(0),
                            child: CategoryTab(
                              isSelected:
                                  controller.selectedCategoryIndex.value == 0,
                              text: '자유',
                            ),
                          ),
                          GestureDetector(
                            onTap: () => controller.selectCategory(1),
                            child: CategoryTab(
                              isSelected:
                                  controller.selectedCategoryIndex.value == 1,
                              text: '질문',
                            ),
                          ),
                          GestureDetector(
                            onTap: () => controller.selectCategory(2),
                            child: CategoryTab(
                              isSelected:
                                  controller.selectedCategoryIndex.value == 2,
                              text: '책추천',
                            ),
                          ),
                          GestureDetector(
                            onTap: () => controller.selectCategory(3),
                            child: CategoryTab(
                              isSelected:
                                  controller.selectedCategoryIndex.value == 3,
                              text: '정보 공유',
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                }),
                // 제목 입력창
                Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                  child: TextField(
                    controller: controller.titleController,
                    decoration: const InputDecoration(
                      border: InputBorder.none,
                      hintText: '제목을 입력해주세요.',
                      hintStyle: TextStyle(
                        color: Color(0xFFA2A2A2),
                        fontSize: 18,
                        fontWeight: FontWeight.w400,
                        height: 1.30,
                        letterSpacing: -0.45,
                      ),
                    ),
                  ),
                ),
                // 구분선
                Container(
                  width: MediaQuery.of(context).size.width - 32,
                  height: 1,
                  color: const Color(0xffd9d9d9),
                ),
                // 콘텐츠 입력 영역
                Expanded(
                  child: Obx(() {
                    return SingleChildScrollView(
                      padding: const EdgeInsets.fromLTRB(16, 14, 16, 100),
                      child: Column(
                        children: [
                          TextField(
                            controller: controller.contentController,
                            decoration: const InputDecoration(
                              border: InputBorder.none,
                              hintText: '경제에 대한 생각을 자유롭게 나눠보세요.',
                              hintStyle: TextStyle(
                                color: Color(0xFFA2A2A2),
                                fontSize: 16,
                                fontWeight: FontWeight.w400,
                                height: 1.50,
                                letterSpacing: -0.40,
                              ),
                            ),
                            keyboardType: TextInputType.multiline,
                            maxLines: null,
                          ),
                          const SizedBox(height: 5),
                          if (controller.attachedImages.isNotEmpty)
                            Center(
                              child: Padding(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 10, vertical: 12),
                                child: SizedBox(
                                  height:
                                      MediaQuery.of(context).size.width * 0.45,
                                  child: ListView.builder(
                                    scrollDirection: Axis.horizontal,
                                    itemCount: controller.attachedImages.length,
                                    itemBuilder: (context, index) {
                                      return GestureDetector(
                                        onTap: () => controller
                                            .confirmDeleteImage(index, context),
                                        child: Padding(
                                          padding:
                                              const EdgeInsets.only(right: 10),
                                          child: Container(
                                            width: MediaQuery.of(context)
                                                    .size
                                                    .width *
                                                0.45,
                                            height: MediaQuery.of(context)
                                                    .size
                                                    .width *
                                                0.45,
                                            decoration: ShapeDecoration(
                                              image: DecorationImage(
                                                image: controller
                                                            .attachedImages[
                                                        index]['file'] is File
                                                    ? FileImage(controller
                                                            .attachedImages[
                                                        index]['file'])
                                                    : NetworkImage(controller
                                                                .attachedImages[
                                                            index]['file'])
                                                        as ImageProvider,
                                                fit: BoxFit.cover,
                                              ),
                                              shape: RoundedRectangleBorder(
                                                side: const BorderSide(
                                                    width: 1,
                                                    color: Color(0xFFD9D9D9)),
                                                borderRadius:
                                                    BorderRadius.circular(8),
                                              ),
                                            ),
                                          ),
                                        ),
                                      );
                                    },
                                  ),
                                ),
                              ),
                            ),
                        ],
                      ),
                    );
                  }),
                ),
              ],
            ),
          ),
          Positioned(
            left: 0,
            right: 0,
            bottom: MediaQuery.of(context).viewInsets.bottom,
            child: BottomPostBar(controller),
          ),
        ],
      ),
    );
  }
}

Widget BottomPostBar(NewPostController controller) {
  return Container(
    decoration: const BoxDecoration(
      border: Border(top: BorderSide(width: 1, color: Color(0xFFD9D9D9))),
    ),
    padding: const EdgeInsets.only(bottom: 10, top: 10, left: 10, right: 10),
    child: Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        GestureDetector(
          onTap: () async {
            await controller.pickImage(Get.context!);
          },
          child: Image.asset(
            'assets/add_photo.png',
            width: 24,
            height: 24,
          ),
        ),
        Obx(() {
          return Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text(
              '${controller.contentLength.value}/3500',
              style: TextStyle(
                color: controller.contentLength.value > 3500
                    ? Colors.red
                    : Colors.black,
              ),
            ),
          );
        }),
      ],
    ),
  );
}
