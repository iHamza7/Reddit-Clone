import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/common/error.dart';
import '../../../core/common/loader.dart';
import '../controller/post_controller.dart';

class CommentsSceen extends ConsumerStatefulWidget {
  final String postId;
  const CommentsSceen({super.key, required this.postId});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _CommentsSceenState();
}

class _CommentsSceenState extends ConsumerState<CommentsSceen> {
  final commentsController = TextEditingController();

  @override
  void dispose() {
    super.dispose();
    commentsController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ref.watch(getUserByIdProvider(widget.postId)).when(
            data: (data) {
              return null;
            },
            error: (error, stackTrace) => ErrorText(text: error.toString()),
            loading: () => const Loader(),
          ),
    );
  }
}
