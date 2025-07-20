import 'package:economic_fe/view/theme/palette.dart';
import 'package:economic_fe/view/widgets/community/comment_widget.dart';
import 'package:economic_fe/view/widgets/community/option_dialog.dart';
import 'package:economic_fe/view_model/community/detail_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class DetailPage extends StatefulWidget {
  const DetailPage({super.key});

  @override
  State<DetailPage> createState() => _DetailPageState();
}

class _DetailPageState extends State<DetailPage> {
  final DetailController controller = Get.put(DetailController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Palette.background,
      appBar: AppBar(
        forceMaterialTransparency: true,
        backgroundColor: Palette.background,
        leading: GestureDetector(
          onTap: () => Get.back(),
          child:
              const Icon(Icons.arrow_back_ios, size: 24, color: Colors.black),
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
          // 더보기 버튼
          Padding(
            padding: const EdgeInsets.only(right: 16),
            child: GestureDetector(
              onTap: () {
                bool isAuthor = controller.isAuthor.value;
                _handleOptions(context, isAuthor);
              },
              child: const Icon(
                Icons.more_horiz,
                size: 28,
              ),
            ),
          ),
        ],
      ),
      body: Obx(() {
        if (controller.isLoading.value) {
          return const Center(child: CircularProgressIndicator());
        }

        var post = controller.postDetail;
        if (post.isEmpty) {
          return const Center(child: Text("게시글을 불러올 수 없습니다."));
        }

        return Stack(
          children: [
            Column(
              children: [
                Expanded(
                  child: ListView(
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(16),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                GestureDetector(
                                  onTap: () {
                                    Get.toNamed('/mypage/profile',
                                        arguments: post['authorId']);
                                  },
                                  child: CircleAvatar(
                                    backgroundImage: post[
                                                "authorProfileImage"] !=
                                            null
                                        ? NetworkImage(
                                            post["authorProfileImage"])
                                        : const AssetImage(
                                                'assets/profile_example.png')
                                            as ImageProvider,
                                    radius: 17,
                                  ),
                                ),
                                const SizedBox(width: 7),
                                Text(
                                  post["author"] ?? "익명",
                                  style: const TextStyle(
                                    color: Color(0xFF404040),
                                    fontSize: 16,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                                const SizedBox(width: 8),
                                Text(
                                  post["createdDate"] ?? "날짜 없음",
                                  style: const TextStyle(
                                    color: Color(0xFF767676),
                                    fontSize: 12,
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 11),
                            Text(
                              post["title"] ?? "제목 없음",
                              style: const TextStyle(
                                color: Color(0xFF111111),
                                fontSize: 18,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                            const SizedBox(height: 8),
                            Text(
                              post["content"] ?? "내용 없음",
                              style: const TextStyle(
                                color: Color(0xFF111111),
                                fontSize: 16,
                                fontWeight: FontWeight.w400,
                              ),
                            ),
                            const SizedBox(height: 20),
                            // 이미지 리스트
                            if (post["imageList"] != null &&
                                post["imageList"].isNotEmpty)
                              SizedBox(
                                height: 180,
                                child: ListView.builder(
                                  scrollDirection: Axis.horizontal,
                                  itemCount: post["imageList"].length,
                                  itemBuilder: (context, index) {
                                    return Padding(
                                      padding: const EdgeInsets.only(right: 10),
                                      child: ClipRRect(
                                        borderRadius: BorderRadius.circular(8),
                                        child: Image.network(
                                          post["imageList"][index][
                                              "url"], // 여기서 "url" 필드에 명확히 접근해야 함
                                          width: 180,
                                          height: 180,
                                          fit: BoxFit.cover,
                                        ),
                                      ),
                                    );
                                  },
                                ),
                              ),
                            const SizedBox(height: 10),
                            Row(
                              children: [
                                // 좋아요
                                Obx(() => GestureDetector(
                                      onTap: () => controller.likePostToggle(),
                                      child: Icon(
                                        controller.isLikedPost.value
                                            ? Icons.favorite
                                            : Icons.favorite_border,
                                        size: 18,
                                        color: controller.isLikedPost.value
                                            ? Palette.buttonColorBlue
                                            : const Color(0xff767676),
                                      ),
                                    )),
                                const SizedBox(width: 5),
                                Text("${post["likeCount"] ?? 0}"),
                                const SizedBox(width: 8),
                                // 댓글
                                const Icon(Icons.chat_bubble_outline,
                                    size: 18, color: Color(0xff767676)),
                                const SizedBox(width: 5),
                                Text(
                                    "${(post["commentCount"] is int ? post["commentCount"] : int.tryParse(post["commentCount"]?.toString() ?? "0"))?.clamp(0, double.infinity) ?? 0}"),
                                const SizedBox(width: 8),
                                // 스크랩
                                Obx(() => GestureDetector(
                                      onTap: () => controller.scrapPostToggle(),
                                      child: Icon(
                                        controller.isScrappedPost.value
                                            ? Icons.bookmark
                                            : Icons.bookmark_border,
                                        size: 18,
                                        color: controller.isScrappedPost.value
                                            ? Palette.buttonColorBlue
                                            : const Color(0xff767676),
                                      ),
                                    )),
                                const SizedBox(width: 5),
                                Text("${post["scrapCount"] ?? 0}"),
                              ],
                            ),
                          ],
                        ),
                      ),
                      const Divider(thickness: 8, color: Color(0xFFF2F3F5)),
                      Obx(() {
                        return ListView.builder(
                          shrinkWrap: true,
                          physics: const NeverScrollableScrollPhysics(),
                          itemCount: controller.comments.length,
                          itemBuilder: (context, index) {
                            final comment = controller.comments[index];
                            return CommentWidget(
                              comment: comment,
                              isReply: false,
                              isAuthor: comment.isAuthor,
                            );
                          },
                        );
                      }),
                    ],
                  ),
                ),
                // 댓글 입력창 (답글 작성 모드 UI 추가)
                Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 10, vertical: 15),
                  child: Column(
                    children: [
                      // 댓글 수정 중 UI
                      Obx(() {
                        if (controller.isEditingComment.value) {
                          return Container(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 10, vertical: 8),
                            margin: const EdgeInsets.only(bottom: 5),
                            decoration: BoxDecoration(
                              color: Colors.grey[200],
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                const Text(
                                  "댓글 수정 중...",
                                  style: TextStyle(
                                      color: Colors.black87, fontSize: 14),
                                ),
                                GestureDetector(
                                  onTap: controller.disableEditMode,
                                  child: const Icon(Icons.close,
                                      size: 18, color: Colors.grey),
                                ),
                              ],
                            ),
                          );
                        } else {
                          return const SizedBox();
                        }
                      }),
                      // 답글 작성 모드 UI
                      Obx(() {
                        if (controller.replyingToCommentId.value != -1) {
                          return Container(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 10, vertical: 8),
                            margin: const EdgeInsets.only(bottom: 5),
                            decoration: BoxDecoration(
                              color: Colors.grey[200],
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  "${controller.replyToAuthor.value}님에게 답글 작성 중",
                                  style: const TextStyle(
                                      color: Colors.black87, fontSize: 14),
                                ),
                                GestureDetector(
                                  onTap: controller.disableReplyMode,
                                  child: const Icon(Icons.close,
                                      size: 18, color: Colors.grey),
                                ),
                              ],
                            ),
                          );
                        } else {
                          return const SizedBox(); // 일반 댓글 모드일 때는 아무것도 표시 안함
                        }
                      }),
                      // 대댓글 수정 UI 추가
                      Obx(() {
                        if (controller.isEditingReply.value) {
                          return Container(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 10, vertical: 8),
                            margin: const EdgeInsets.only(bottom: 5),
                            decoration: BoxDecoration(
                              color: Colors.grey[200],
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                const Text(
                                  "대댓글 수정 중...",
                                  style: TextStyle(
                                      color: Colors.black87, fontSize: 14),
                                ),
                                GestureDetector(
                                  onTap: controller.disableReplyEditMode,
                                  child: const Icon(Icons.close,
                                      size: 18, color: Colors.grey),
                                ),
                              ],
                            ),
                          );
                        } else {
                          return const SizedBox();
                        }
                      }),
                      // 실제 댓글 입력창
                      Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 16, vertical: 7),
                        decoration: ShapeDecoration(
                          color: const Color(0xFFF2F3F5),
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(17)),
                        ),
                        child: Obx(() {
                          return Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Expanded(
                                child: TextField(
                                  controller: controller.messageController,
                                  onChanged: (value) =>
                                      controller.updateMessage(value),
                                  decoration: const InputDecoration(
                                    hintText: '댓글을 입력하세요.',
                                    border: InputBorder.none,
                                  ),
                                  maxLines: 5,
                                  minLines: 1,
                                ),
                              ),
                              // 댓글 입력 창
                              GestureDetector(
                                onTap: controller.messageText.value.isNotEmpty
                                    ? (controller.isEditingComment.value
                                        ? controller.editComment
                                        : controller.isEditingReply.value
                                            ? controller.editReply
                                            : controller.sendMessage)
                                    : null,
                                child: Image.asset(
                                  controller.messageText.value.isNotEmpty
                                      ? 'assets/send_active.png'
                                      : 'assets/send.png',
                                  width: 24,
                                ),
                              ),
                            ],
                          );
                        }),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ],
        );
      }),
    );
  }

  void _handleOptions(BuildContext context, bool isAuthor) {
    OptionsDialog.showOptionsDialog(
      context: context,
      isAuthor: isAuthor,
      isComment: false,
      onEdit: () {
        // 현재 게시글 정보 가져오기
        Map<String, dynamic> postInfo = {
          "id": controller.postDetail["id"],
          "title": controller.postDetail["title"],
          "content": controller.postDetail["content"],
          "category": controller.postDetail["type"],
          "images": controller.postDetail["imageList"] ?? [],
        };

        // `NewPostPage`로 기존 게시글 정보 전달
        Get.toNamed('/community/new_post', arguments: postInfo);
      },
      onDelete: () {
        Navigator.of(context).pop();
        controller.deletePost();
      },
      onReport: () => ScaffoldMessenger.of(context)
          .showSnackBar(const SnackBar(content: Text('게시글 신고 기능 실행'))),
    );
  }
}
