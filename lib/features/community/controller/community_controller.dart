import 'package:flutter/material.dart';

import '../repository/community_repository.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class CommunityController {
  final CommunityRepository _communityRepository;
  final Ref _ref;
  CommunityController(
      {required CommunityRepository communityRepository, required Ref ref})
      : _communityRepository = communityRepository,
        _ref = ref;

  void createCommunity(BuildContext context, String name) {}
}
