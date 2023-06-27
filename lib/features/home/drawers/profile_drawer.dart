import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../auth/controllers/auth_controller.dart';

class ProfileDrawer extends ConsumerWidget {
  const ProfileDrawer({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final user = ref.watch(userProvider)!;
    return Drawer(
      child: SafeArea(
          child: Column(
        children: [
          CircleAvatar(
            backgroundImage: NetworkImage(user.profilePic),
            radius: 70,
          ),
        ],
      )),
    );
  }
}
