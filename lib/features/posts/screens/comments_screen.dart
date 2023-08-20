import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class CommentsSceen extends ConsumerStatefulWidget {
  const CommentsSceen({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _CommentsSceenState();
}

class _CommentsSceenState extends ConsumerState<CommentsSceen> {
  final commentsController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return const Scaffold();
  }
}
