import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:dotted_border/dotted_border.dart';

import '../../../core/common/error.dart';
import '../../../core/common/loader.dart';
import '../../../core/constants/constants.dart';
import '../../../theme/pallete.dart';
import '../controller/community_controller.dart';

class EditCommunityScreen extends ConsumerStatefulWidget {
  final String name;
  const EditCommunityScreen({super.key, required this.name});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() =>
      _EditCommunityScreenState();
}

class _EditCommunityScreenState extends ConsumerState<EditCommunityScreen> {
  @override
  Widget build(BuildContext context) {
    return ref.watch(getCommunityByNameProvider(widget.name)).when(
          data: (community) => Scaffold(
            appBar: AppBar(
              title: const Text('Edit Community'),
              actions: [
                TextButton(
                  onPressed: () {},
                  child: const Text(
                    'Save',
                    style: TextStyle(fontSize: 16),
                  ),
                ),
              ],
            ),
            body: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                children: [
                  Stack(
                    children: [
                      DottedBorder(
                        borderType: BorderType.RRect,
                        radius: const Radius.circular(10),
                        dashPattern: const [10, 4],
                        strokeCap: StrokeCap.round,
                        color: Pallete
                            .darkModeAppTheme.textTheme.bodyMedium!.color!,
                        child: Container(
                          width: double.infinity,
                          height: 150,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(15),
                          ),
                          child: community.banner.isEmpty ||
                                  community.banner == Constants.bannerDefault
                              ? const Center(
                                  child: Icon(
                                    Icons.camera_alt_outlined,
                                    size: 40,
                                  ),
                                )
                              : Image.network(community.banner),
                        ),
                      ),
                    ],
                  )
                ],
              ),
            ),
          ),
          error: (error, stackTrace) => ErrorText(text: error.toString()),
          loading: () => const Loader(),
        );
  }
}
