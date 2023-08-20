import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/common/error.dart';
import '../../../core/common/loader.dart';
import '../../../core/common/post_card.dart';
import '../../../models/post_model.dart';
import '../controller/post_controller.dart';
import '../widgets/comment_card.dart';

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

  void addComments(Post post) {
    ref.read(postControllerProvider.notifier).addComment(
          context: context,
          text: commentsController.text.trim(),
          post: post,
        );
    setState(() {
      commentsController.text = '';
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Comments Section'),
      ),
      body: ref.watch(getUserByIdProvider(widget.postId)).when(
            data: (data) {
              return Column(
                children: [
                  PostCard(post: data),
                  TextField(
                    onSubmitted: (value) => addComments(data),
                    controller: commentsController,
                    decoration: const InputDecoration(
                      hintText: 'Your Thoughts',
                      filled: true,
                      border: InputBorder.none,
                    ),
                  ),
                  ref.watch(getPostCommentsProvider(widget.postId)).when(
                        data: (data) {
                          return ListView.builder(
                            itemCount: data.length,
                            itemBuilder: (BuildContext context, int index) {
                              final comment = data[index];
                              return CommentCard(comment: comment);
                            },
                          );
                        },
                        error: (error, stackTrace) {
                          print(error.toString());
                          return ErrorText(text: error.toString());
                        },
                        loading: () => const Loader(),
                      )
                ],
              );
            },
            error: (error, stackTrace) => ErrorText(text: error.toString()),
            loading: () => const Loader(),
          ),
    );
  }
}
