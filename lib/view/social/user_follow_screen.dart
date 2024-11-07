import 'package:amity_uikit_beta_service/view/social/user_follower_component.dart';
import 'package:amity_uikit_beta_service/view/social/user_following_component.dart';
import 'package:amity_uikit_beta_service/viewmodel/follower_following_viewmodel.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../viewmodel/configuration_viewmodel.dart';

enum FollowScreenType { following, follower }

class FollowScreen extends StatefulWidget {
  final String userId;
  final String? displayName;
  final FollowScreenType followScreenType;

  const FollowScreen({
    super.key,
    required this.userId,
    this.displayName,
    required this.followScreenType,
  });

  @override
  State<FollowScreen> createState() => _FollowScreenState();
}

class _FollowScreenState extends State<FollowScreen> {
  TabController? _tabController;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Scaffold(
      backgroundColor:
          Provider.of<AmityUIConfiguration>(context).appColors.baseBackground,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        title: Text(
          widget.displayName ?? "",
          style: Provider.of<AmityUIConfiguration>(context).titleTextStyle,
        ),
      ),
      body: DefaultTabController(
        initialIndex:
            widget.followScreenType == FollowScreenType.following ? 0 : 1,
        length: 2,
        child: Column(
          children: [
            TabBar(
              tabAlignment: TabAlignment.start,
              controller: _tabController,
              isScrollable: true,
              dividerColor: Provider.of<AmityUIConfiguration>(context)
                  .appColors
                  .baseBackground,
              labelColor: const Color(0xFFFC2C86),
              unselectedLabelColor: const Color(0xff8F9BB3),
              indicatorColor: const Color(0xFFFC2C86),
              // labelStyle: const TextStyle(
              //   fontSize: 17,
              //   fontWeight: FontWeight.w600,
              //   fontFamily: 'SF Pro Text',
              // ),
              tabs: [
                Tab(
                  child: Text(
                    "user.following".tr(), //Following
                  ),
                ),
                Tab(
                  child: Text(
                    "user.followers".tr(), //Followers
                  ),
                ),
              ],
            ),
            Expanded(
              child: Consumer<FollowerVM>(builder: (context, vm, _) {
                return TabBarView(
                  physics: const AlwaysScrollableScrollPhysics(),
                  children: [
                    AmityFollowingScreen(
                      userId: widget.userId,
                    ),
                    AmityFollowerScreen(
                      userId: widget.userId,
                    ),
                  ],
                );
              }),
            ),
          ],
        ),
      ),
    );
  }
}
