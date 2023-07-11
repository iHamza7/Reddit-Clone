import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/providers/stroage_repository_provider.dart';
import '../repository/post_repository.dart';

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
}
