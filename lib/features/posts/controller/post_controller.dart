import 'dart:io';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter/material.dart';
import 'package:routemaster/routemaster.dart';

import '../../../core/enums/enums.dart';
import '../../../core/providers/stroage_repository_provider.dart';
import '../../../core/utlis.dart';
import '../../../models/comments_model.dart';
import '../../../models/community_models.dart';
import '../../../models/post_model.dart';
import '../../auth/controllers/auth_controller.dart';
import '../../user_profile/controller/user_profile_controller.dart';
import '../repository/post_repository.dart';
import 'package:uuid/uuid.dart';

final postControllerProvider =
    StateNotifierProvider<PostController, bool>((ref) {
  final postRepository = ref.watch(postRepositoryProvider);
  final storageRepository = ref.watch(storagaRepositoryProvider);

  return PostController(
      postRepository: postRepository,
      ref: ref,
      storageRepository: storageRepository);
});

final userPostProvider =
    StreamProvider.family((ref, List<Community> communities) {
  final postController = ref.watch(postControllerProvider.notifier);
  return postController.fetchUserPosts(communities);
});
final guestPostProvider = StreamProvider((ref) {
  final postController = ref.watch(postControllerProvider.notifier);
  return postController.fetchGuestPosts();
});

final getUserByIdProvider = StreamProvider.family((ref, String postId) {
  final postController = ref.watch(postControllerProvider.notifier);
  return postController.getPostById(postId);
});
final getPostCommentsProvider = StreamProvider.family((ref, String postId) {
  final postController = ref.watch(postControllerProvider.notifier);
  return postController.fetchPostComments(postId);
});

class PostController extends StateNotifier<bool> {
  final PostRepository _postRepository;
  final Ref _ref;
  final StorageRepository _storageRepository;
  PostController(
      {required PostRepository postRepository,
      required Ref ref,
      required StorageRepository storageRepository})
      : _postRepository = postRepository,
        _ref = ref,
        _storageRepository = storageRepository,
        super(false);

  void shareTextPost({
    required BuildContext context,
    required String title,
    required Community selectedCommnunity,
    required String description,
  }) async {
    state = true;
    String postId = const Uuid().v1();
    final user = _ref.watch(userProvider)!;

    final Post post = Post(
        id: postId,
        title: title,
        communityName: selectedCommnunity.name,
        communityProfilePic: selectedCommnunity.avatar,
        upvotes: [],
        downvotes: [],
        commentCount: 0,
        username: user.name,
        uid: user.uid,
        type: 'text',
        createdAt: DateTime.now(),
        awards: [],
        description: description);

    final res = await _postRepository.addPost(post);
    _ref
        .read(userProfileControllerProvider.notifier)
        .updateUserKarma(UserKarma.textPost);
    state = false;
    res.fold((l) => showSnackBar(context, l.message), (r) {
      showSnackBar(context, 'Posted Succesfully');
      Routemaster.of(context).pop();
    });
  }

  void shareLinkPost({
    required BuildContext context,
    required String title,
    required Community selectedCommnunity,
    required String link,
  }) async {
    state = true;
    String postId = const Uuid().v1();
    final user = _ref.watch(userProvider)!;

    final Post post = Post(
        id: postId,
        title: title,
        communityName: selectedCommnunity.name,
        communityProfilePic: selectedCommnunity.avatar,
        upvotes: [],
        downvotes: [],
        commentCount: 0,
        username: user.name,
        uid: user.uid,
        type: 'link',
        createdAt: DateTime.now(),
        awards: [],
        link: link);

    final res = await _postRepository.addPost(post);
    _ref
        .read(userProfileControllerProvider.notifier)
        .updateUserKarma(UserKarma.linkPost);
    state = false;
    res.fold((l) => showSnackBar(context, l.message), (r) {
      showSnackBar(context, 'Posted Succesfully');
      Routemaster.of(context).pop();
    });
  }

  void shareImagePost({
    required BuildContext context,
    required String title,
    required Community selectedCommnunity,
    required File? file,
  }) async {
    state = true;
    String postId = const Uuid().v1();
    final user = _ref.watch(userProvider)!;
    final imageRes = await _storageRepository.storeFile(
      path: 'posts/${selectedCommnunity.name}',
      id: postId,
      file: file,
    );

    imageRes.fold((l) => showSnackBar(context, l.message), (r) async {
      final Post post = Post(
          id: postId,
          title: title,
          communityName: selectedCommnunity.name,
          communityProfilePic: selectedCommnunity.avatar,
          upvotes: [],
          downvotes: [],
          commentCount: 0,
          username: user.name,
          uid: user.uid,
          type: 'image',
          createdAt: DateTime.now(),
          awards: [],
          link: r);

      final res = await _postRepository.addPost(post);
      _ref
          .read(userProfileControllerProvider.notifier)
          .updateUserKarma(UserKarma.imagePost);
      state = false;
      res.fold((l) => showSnackBar(context, l.message), (r) {
        showSnackBar(context, 'Posted Succesfully');
        Routemaster.of(context).pop();
      });
    });
  }

  Stream<List<Post>> fetchUserPosts(List<Community> communities) {
    if (communities.isNotEmpty) {
      return _postRepository.fetchUserPosts(communities);
    }
    return Stream.value([]);
  }

  Stream<List<Post>> fetchGuestPosts() {
    return _postRepository.fetchGuestPosts();
  }

  void deletePost(Post post, BuildContext context) async {
    final res = await _postRepository.deletePost(post);
    _ref
        .read(userProfileControllerProvider.notifier)
        .updateUserKarma(UserKarma.deletePost);
    res.fold(
        (l) => null, (r) => showSnackBar(context, 'Post Deleted Successfully'));
  }

  void upvote(Post post) async {
    final uid = _ref.read(userProvider)!.uid;
    _postRepository.upvote(post, uid);
  }

  void downvote(Post post) async {
    final uid = _ref.read(userProvider)!.uid;
    _postRepository.downvote(post, uid);
  }

  void addComment({
    required BuildContext context,
    required String text,
    required Post post,
  }) async {
    final user = _ref.read(userProvider)!;
    final commentId = const Uuid().v1();
    Comment comment = Comment(
      id: commentId,
      text: text,
      createdAt: DateTime.now(),
      postId: post.id,
      username: user.name,
      profilePic: user.profilePic,
    );
    final res = await _postRepository.addComment(comment);
    _ref
        .read(userProfileControllerProvider.notifier)
        .updateUserKarma(UserKarma.comment);
    res.fold((l) => showSnackBar(context, l.message), (r) => null);
  }

  void awardPost({
    required Post post,
    required String award,
    required BuildContext context,
  }) async {
    final user = _ref.read(userProvider)!;
    final res = await _postRepository.awardPost(post, award, user.uid);

    res.fold((l) => showSnackBar(context, l.message), (r) {
      _ref
          .read(userProfileControllerProvider.notifier)
          .updateUserKarma(UserKarma.awardPost);
      _ref.read(userProvider.notifier).update((state) {
        state?.awards.remove(award);
        return state;
      });
      Routemaster.of(context).pop();
    });
  }

  Stream<Post> getPostById(String postId) {
    return _postRepository.getPostById(postId);
  }

  Stream<List<Comment>> fetchPostComments(String postId) {
    return _postRepository.getCommentsOfPost(postId);
  }
}
