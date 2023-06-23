import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:routemaster/routemaster.dart';

import '../../../core/common/error.dart';
import '../../../core/common/loader.dart';
import '../../community/controller/community_controller.dart';

class CommunityListDrawer extends ConsumerWidget {
  const CommunityListDrawer({super.key});

  void navigateToCreateCommunity(BuildContext context) {
    Routemaster.of(context).push('/create-community');
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Drawer(
      child: SafeArea(
          child: Column(
        children: [
          ListTile(
            onTap: () => navigateToCreateCommunity(context),
            title: const Text("Create a community"),
            leading: const Icon(
              Icons.add,
              color: Colors.white,
            ),
          ),
          ref.watch(userCommunitiesProvider).when(
              data: (communities) => ListView.builder(
                    itemCount: communities.length,
                    itemBuilder: (BuildContext context, int index) {
                      final community = communities[index];
                      return const ListTile();
                    },
                  ),
              error: (error, stackTrace) => ErrorText(text: error.toString()),
              loading: () => const Loader())
        ],
      )),
    );
  }
}
