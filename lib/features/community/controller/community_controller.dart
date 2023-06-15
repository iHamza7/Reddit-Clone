import 'package:flutter/material.dart';

import '../../../core/constants/constants.dart';
import '../../../models/community_models.dart';
import '../../auth/controllers/auth_controller.dart';
import '../repository/community_repository.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class CommunityController {
  final CommunityRepository _communityRepository;
  final Ref _ref;
  CommunityController(
      {required CommunityRepository communityRepository, required Ref ref})
      : _communityRepository = communityRepository,
        _ref = ref;

  void createCommunity(BuildContext context, String name) async {
    final uid = _ref.watch(userProvider)?.uid ?? '';
    Community community = Community(
      id: name,
      name: name,
      banner: Constants.bannerDefault,
      avatar: Constants.avatarDefault,
      members: [uid],
      mods: [uid],
    );
    final res = await _communityRepository.createCommunity(community);
  }
}
