import 'package:economic_fe/data/models/community/comment.dart';
import 'package:economic_fe/data/services/remote_data_source.dart';
import 'package:flutter/widgets.dart';
import 'package:get/get.dart';

class DetailController extends GetxController {
  final RemoteDataSource remoteDataSource = RemoteDataSource(); // 인스턴스 생성

  // 공통 상태
  RxInt currentPostId = (-1).obs;
  RxBool isLoading = true.obs;
  RxBool isSyncing = false.obs;
  int _lastReqId = 0;

  RxMap<String, dynamic> postDetail = <String, dynamic>{}.obs;
  RxList<Comment> comments = RxList<Comment>();

  RxBool isAuthor = false.obs;
  RxBool isLikedPost = false.obs;
  RxBool isScrappedPost = false.obs;

  RxList<int> myPostIds = <int>[].obs; // 내가 작성한 게시물 id
  RxList<int> likedPostIds = <int>[].obs; // 내가 좋아요 한 게시물 id
  RxList<int> scrappedPostIds = <int>[].obs; // 내가 스크랩 한 게시물 id
  // RxMap<int, bool> likedCommentMap = <int, bool>{}.obs; // 각 댓글별 좋아요 상태

  final TextEditingController messageController = TextEditingController();
  var messageText = ''.obs;
  RxBool isModalVisible = false.obs;

  // 단일 새로고침
  Future<void> reload() async {
    final postId = currentPostId.value;
    if (postId <= 0) return;

    final int reqId = ++_lastReqId;
    isSyncing(true);
    try {
      final postData = await remoteDataSource.getPostDetail(postId);
      if (reqId != _lastReqId) return;

      if (postData != null) {
        postData["id"] = postId;
        postDetail.value = postData;
        isAuthor.value = postData['isAuthor'] ?? false;
        isLikedPost.value = postData['isLiked'] ?? false;
        isScrappedPost.value = postData['isScraped'] ?? false;
        comments.value = _parseComments(postData['commentList'] ?? []);
      }
    } catch (e) {
      debugPrint('reload 중 오류: $e');
    } finally {
      if (reqId == _lastReqId) isSyncing(false);
    }
  }

  // 액션 후 항상 새로고침: 낙관적 업데이트 + 실패 시 롤백
  Future<void> _mutateAndRefresh({
    required Future<bool> Function() action,
    VoidCallback? optimistic,
    VoidCallback? rollback,
  }) async {
    optimistic?.call();
    bool ok = false;
    try {
      ok = await action();
    } catch (e) {
      debugPrint('mutate error: $e');
      ok = false;
    }
    if (!ok) {
      rollback?.call();
      Get.snackbar("오류", "요청 처리에 실패했습니다.");
      return;
    }
    await reload();
  }

  @override
  void onReady() {
    super.onReady();
    final args = Get.arguments;
    final int? postId =
        (args is int) ? args : (args is Map ? args['postId'] as int? : null);

    if (postId != null) {
      isLoading.value = true;
      currentPostId.value = postId;
      reload().whenComplete(() {
        isLoading.value = false;
      });
    } else {
      isLoading.value = false;
    }
  }

  /// 게시글 상세 조회
  Future<void> fetchPostDetail(int postId) async {
    currentPostId.value = postId;
    await reload();
  }

  /// 댓글 파싱 (서버 데이터 → Comment 모델)
  List<Comment> _parseComments(List<dynamic> list) {
    return list
        .map<Comment>((raw) {
          final int? id = int.tryParse(raw['id'].toString());
          return Comment(
            id: id ?? -1,
            content: raw['isDeleted'] == true
                ? "삭제된 댓글입니다."
                : (raw['content'] ?? ''),
            author: raw['commenterName'] ?? '익명',
            date: raw['createdDate'] ?? '방금 전',
            likes: raw['likeCount'] ?? 0,
            isLiked: raw['isLiked'] ?? false,
            isAuthor: raw['isAuthor'] ?? false,
            replies:
                raw['children'] != null ? _parseComments(raw['children']) : [],
            isDeleted: raw['isDeleted'] ?? false,
            commenterId: raw['commenterId'],
            commenterProfileImageUrl: raw['commenterProfileImageUrl'],
          );
        })
        .where((c) => c.id != -1)
        .toList();
  }

  // 답글을 작성 중인 댓글 ID
  RxInt replyingToCommentId = (-1).obs;
  RxString replyToAuthor = RxString("");

  /// 댓글 입력값 변경 감지
  void updateMessage(String value) {
    messageText.value = value;
  }

  final FocusNode inputFocusNode = FocusNode();

  /// 답글 작성 모드 활성화
  void activateReplyMode(int commentId, String author) {
    replyingToCommentId.value = commentId;
    replyToAuthor.value = author;
    messageController.clear();
    messageText.value = '';
    // 프레임 끝난 뒤 포커스
    WidgetsBinding.instance.addPostFrameCallback((_) {
      inputFocusNode.requestFocus();
    });
  }

  /// 답글 작성 모드 해제 (일반 댓글 작성 모드)
  void disableReplyMode() {
    replyingToCommentId.value = -1;
    replyToAuthor.value = "";
  }

  // 댓글/답글 작성
  Future<void> sendMessage() async {
    final msg = messageController.text.trim();
    if (msg.isEmpty) return;

    final isReply = replyingToCommentId.value != -1;
    final parentId = replyingToCommentId.value;

    // (옵션) 낙관적: 화면 즉시 반영
    List<Comment> snapshot = comments.map((e) => e.copyWith()).toList();

    await _mutateAndRefresh(
      action: () async {
        if (!isReply) {
          return await remoteDataSource.addComment(currentPostId.value, msg);
        } else {
          return await remoteDataSource.addReply(
              currentPostId.value, parentId, msg);
        }
      },
      optimistic: () {
        messageController.clear();
        messageText.value = '';
        if (isReply) {
          // 부모 댓글 찾아 임시 reply push
          final idx = comments.indexWhere((c) => c.id == parentId);
          if (idx != -1) {
            comments[idx].replies.add(Comment(
                  id: DateTime.now().millisecondsSinceEpoch * -1, // 임시 음수 ID
                  content: msg,
                  author: '나',
                  date: '방금 전',
                  likes: 0,
                  isLiked: false,
                  isAuthor: true,
                  replies: [],
                  isDeleted: false,
                  commenterId: null,
                  commenterProfileImageUrl: null,
                ));
            comments.refresh();
          }
        } else {
          // 최상위로 임시 댓글 push
          comments.insert(
              0,
              Comment(
                id: DateTime.now().millisecondsSinceEpoch * -1,
                content: msg,
                author: '나',
                date: '방금 전',
                likes: 0,
                isLiked: false,
                isAuthor: true,
                replies: [],
                isDeleted: false,
                commenterId: null,
                commenterProfileImageUrl: null,
              ));
          comments.refresh();
        }
        replyingToCommentId.value = -1;
      },
      rollback: () {
        comments.value = snapshot;
        comments.refresh();
      },
    );
  }

  /// 게시글 좋아요 토글
  void likePostToggle() {
    if (currentPostId.value == -1) {
      Get.snackbar("오류", "게시글 정보가 아직 준비되지 않았습니다.");
      return;
    }

    final before = isLikedPost.value;
    _mutateAndRefresh(
      action: () async {
        return before
            ? await remoteDataSource.deleteLikedPost(currentPostId.value)
            : await remoteDataSource.likePost(currentPostId.value);
      },
      optimistic: () => isLikedPost.value = !before,
      rollback: () => isLikedPost.value = before,
    );
  }

  /// 게시글 스크랩 토글
  void scrapPostToggle() {
    final before = isScrappedPost.value;
    _mutateAndRefresh(
      action: () async {
        return before
            ? await remoteDataSource.deletePostScrap(currentPostId.value)
            : await remoteDataSource.scrapPost(currentPostId.value);
      },
      optimistic: () => isScrappedPost.value = !before,
      rollback: () => isScrappedPost.value = before,
    );
  }

  /// 댓글 좋아요 토글
  void likeCommentToggle(int commentId) {
    // 대상 찾기
    Comment? target;
    for (final c in comments) {
      if (c.id == commentId) {
        target = c;
        break;
      }
      for (final r in c.replies) {
        if (r.id == commentId) {
          target = r;
          break;
        }
      }
      if (target != null) break;
    }
    if (target == null || target.isDeleted) return;
    setCommentLike(commentId, !target.isLiked);
  }

  Future<void> setCommentLike(int commentId, bool like) async {
    // 대상 찾기
    Comment? target;
    for (final c in comments) {
      if (c.id == commentId) {
        target = c;
        break;
      }
      for (final r in c.replies) {
        if (r.id == commentId) {
          target = r;
          break;
        }
      }
      if (target != null) break;
    }
    if (target == null) return;
    if (target.isDeleted == true) return; // 삭제 댓글 비활성

    final beforeLiked = target.isLiked;
    final beforeLikes = target.likes;
    if (beforeLiked == like) {
      // 이미 원하는 상태면 아무 것도 안 해도 됨
      return;
    }

    // 낙관적 변경
    optimisticFn() {
      target!.isLiked = like;
      target.likes = like ? (beforeLikes + 1) : (beforeLikes - 1);
      comments.refresh();
    }

    // 롤백
    rollbackFn() {
      target!.isLiked = beforeLiked;
      target.likes = beforeLikes;
      comments.refresh();
    }

    await _mutateAndRefresh(
      action: () async {
        final postId = currentPostId.value;
        return like
            ? await remoteDataSource.likeComment(postId, commentId)
            : await remoteDataSource.deleteLikedComment(postId, commentId);
      },
      optimistic: optimisticFn,
      rollback: rollbackFn,
    );
  }

// 기존 함수는 이렇게 얇은 래퍼로 유지 (호출처 호환성 유지)
  Future<void> likeComment(int commentId) async {
    await setCommentLike(commentId, true);
  }

  Future<void> deleteLikedComment(int commentId) async {
    await setCommentLike(commentId, false);
  }

  // 댓글 수정 상태 변수
  RxBool isEditingComment = false.obs;
  RxInt editingCommentId = (-1).obs;
  RxString editingCommentText = "".obs;

  // 대댓글 수정 상태 변수
  RxBool isEditingReply = false.obs;
  RxInt editingReplyId = (-1).obs;
  RxString editingReplyText = "".obs;

  /// 댓글 수정 모드 활성화
  void activateEditMode(int commentId, String content) {
    isEditingComment.value = true;
    editingCommentId.value = commentId;
    editingCommentText.value = content;
    messageController.text = content;
  }

  /// 대댓글 수정 모드 활성화
  void activateReplyEditMode(int replyId, String content) {
    isEditingReply.value = true;
    editingReplyId.value = replyId;
    editingReplyText.value = content;
    messageController.text = content;
  }

  /// 댓글 수정 모드 해제
  void disableEditMode() {
    isEditingComment.value = false;
    editingCommentId.value = -1;
    editingCommentText.value = "";
    messageController.clear();
  }

  /// 대댓글 수정 모드 해제
  void disableReplyEditMode() {
    isEditingReply.value = false;
    editingReplyId.value = -1;
    editingReplyText.value = "";
    messageController.clear();
  }

  /// 댓글 수정 API 호출
  Future<void> editComment() async {
    final text = messageController.text.trim();
    if (text.isEmpty) return;

    final commentId = editingCommentId.value;
    final snapshot = comments.map((e) => e.copyWith()).toList();

    await _mutateAndRefresh(
      action: () async {
        return await remoteDataSource.editComment(
            currentPostId.value, commentId, text);
      },
      optimistic: () {
        // 로컬 즉시 반영
        final idx = comments.indexWhere((c) => c.id == commentId);
        if (idx != -1) {
          comments[idx] = comments[idx].copyWith(content: text);
          comments.refresh();
        }
      },
      rollback: () {
        comments.value = snapshot;
        comments.refresh();
      },
    );

    disableEditMode();
  }

  /// 대댓글 수정 API 호출
  Future<void> editReply() async {
    final text = messageController.text.trim();
    if (text.isEmpty) return;

    final replyId = editingReplyId.value;
    final snapshot = comments.map((e) => e.copyWith()).toList();

    await _mutateAndRefresh(
      action: () async {
        return await remoteDataSource.editComment(
            currentPostId.value, replyId, text);
      },
      optimistic: () {
        for (final c in comments) {
          final i = c.replies.indexWhere((r) => r.id == replyId);
          if (i != -1) {
            c.replies[i] = c.replies[i].copyWith(content: text);
            comments.refresh();
            break;
          }
        }
      },
      rollback: () {
        comments.value = snapshot;
        comments.refresh();
      },
    );

    disableReplyEditMode();
  }

  /// 게시물 삭제 기능
  Future<void> deletePost() async {
    int postId = currentPostId.value; // 현재 게시글 ID 가져오기
    bool success = await remoteDataSource.deletePost(postId);

    if (success) {
      Get.snackbar("삭제 성공", "게시물이 성공적으로 삭제되었습니다.");
      Get.offNamed('/community'); // 삭제 후 커뮤니티 화면으로 이동
    } else {
      Get.snackbar("삭제 실패", "게시물 삭제에 실패했습니다.");
    }
  }

  /// 댓글 또는 대댓글 삭제
  Future<void> deleteComment(int commentId) async {
    // 낙관적: 현재 트리에 반영 후 실패 시 롤백
    final snapshot = comments.map((e) => e.copyWith()).toList();

    await _mutateAndRefresh(
      action: () async {
        return await remoteDataSource.deleteComment(
            currentPostId.value, commentId);
      },
      optimistic: () {
        _removeCommentOrReply(commentId);
      },
      rollback: () {
        comments.value = snapshot;
        comments.refresh();
      },
    );
  }

  /// 댓글 또는 대댓글을 UI에서 즉시 제거하는 함수
  void _removeCommentOrReply(int commentId) {
    for (var comment in comments) {
      int replyIndex =
          comment.replies.indexWhere((reply) => reply.id == commentId);

      // 대댓글 삭제
      if (replyIndex != -1) {
        comment.replies.removeAt(replyIndex);
        debugPrint("대댓글 삭제됨: $commentId");

        // 모든 대댓글이 삭제되었고 댓글도 삭제 상태라면, 댓글도 삭제
        if (comment.replies.isEmpty && comment.isDeleted == true) {
          debugPrint("모든 대댓글 삭제됨, 댓글도 제거: ${comment.id}");
          comments.removeWhere((c) => c.id == comment.id);
        }

        comments.refresh();
        return;
      }
    }

    // 일반 댓글 삭제
    int commentIndex =
        comments.indexWhere((comment) => comment.id == commentId);
    if (commentIndex != -1) {
      comments.removeAt(commentIndex);
      debugPrint("일반 댓글 삭제됨: $commentId");
    }

    comments.refresh();
  }

  /// 뒤로 가기
  void goBack() {
    Get.back();
  }

  /// 커뮤니티 화면 이동
  void goToCommunity() {
    Get.until((route) => Get.currentRoute == '/community');
  }

  /// 옵션 모달 토글
  void toggleModal() {
    isModalVisible.value = !isModalVisible.value;
  }

  /// 챗봇 화면 이동
  void toChatPage() {
    Get.toNamed('/chatbot');
  }

  /// 글쓰기 화면 이동
  void toNewPost() {
    Get.toNamed('/community/new_post');
  }
}
