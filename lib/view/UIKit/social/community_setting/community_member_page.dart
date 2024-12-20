import 'dart:developer';

import 'package:amity_sdk/amity_sdk.dart';
import 'package:amity_uikit_beta_service/components/alert_dialog.dart';
import 'package:amity_uikit_beta_service/view/social/select_user_page.dart';
import 'package:amity_uikit_beta_service/view/user/user_profile_v2.dart';
import 'package:amity_uikit_beta_service/viewmodel/community_member_viewmodel.dart';
import 'package:amity_uikit_beta_service/viewmodel/community_viewmodel.dart';
import 'package:amity_uikit_beta_service/viewmodel/configuration_viewmodel.dart';
import 'package:amity_uikit_beta_service/viewmodel/user_feed_viewmodel.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class MemberManagementPage extends StatefulWidget {
  final String communityId;

  const MemberManagementPage({
    super.key,
    required this.communityId,
  });

  @override
  State<MemberManagementPage> createState() => _MemberManagementPageState();
}

class _MemberManagementPageState extends State<MemberManagementPage> {
  @override
  void initState() {
    Future.delayed(Duration.zero, () {
      final amityReactions = <AmityReaction>[];
      late PagingController<AmityReaction> reactionController;

      void queryPostReaction(String postId) {
        reactionController = PagingController(
          pageFuture: (token) => AmitySocialClient.newPostRepository()
              .getReaction(postId: postId)
              //Optional to query specific reaction, eg. "like"
              .reactionName('like')
              .getPagingData(token: token, limit: 20),
          pageSize: 20,
        )..addListener(
            () {
              if (reactionController.error == null) {
                //handle results, we suggest to clear the previous items
                //and add with the latest _controller.loadedItems
                amityReactions.clear();
                amityReactions.addAll(reactionController.loadedItems);
                //update widgets
              } else {
                //error on pagination controller
                //update widgets
              }
            },
          );
      }

      Provider.of<MemberManagementVM>(context, listen: false).initMember(
        communityId: widget.communityId,
      );
      Provider.of<MemberManagementVM>(context, listen: false).initModerators(
        communityId: widget.communityId,
      );
      Provider.of<MemberManagementVM>(context, listen: false)
          .checkCurrentUserRole(widget.communityId);
    });

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        backgroundColor:
            Provider.of<AmityUIConfiguration>(context).appColors.baseBackground,
        appBar: AppBar(
          actions: [
            !Provider.of<MemberManagementVM>(context)
                    .currentUserRoles
                    .contains('community-moderator')
                ? const SizedBox()
                : IconButton(
                    icon: Icon(
                      Icons.add,
                      color: Provider.of<AmityUIConfiguration>(context)
                          .appColors
                          .base,
                    ),
                    onPressed: () async {
                      var userList = Provider.of<MemberManagementVM>(context,
                              listen: false)
                          .userList;
                      List<AmityUser> userIdList =
                          userList.map((user) => user.user!).toList();
                      Navigator.of(context).push<List<AmityUser>>(
                        MaterialPageRoute(
                          builder: (context) => UserListPage(
                            preSelectMember: userIdList,
                            onDonePressed: (users) async {
                              List<String> userIds =
                                  users.map((user) => user.userId!).toList();
                              if (users.isNotEmpty) {
                                await Provider.of<CommunityVM>(context,
                                        listen: false)
                                    .addMembers(widget.communityId, userIds);
                                await Provider.of<MemberManagementVM>(context,
                                        listen: false)
                                    .initMember(
                                  communityId: widget.communityId,
                                );
                                await Provider.of<MemberManagementVM>(context,
                                        listen: false)
                                    .initModerators(
                                  communityId: widget.communityId,
                                );
                                Navigator.of(context).pop();
                              } else {
                                log('Failed to add members');
                              }
                            },
                          ),
                        ),
                      );
                    },
                  ),
          ],
          elevation: 0.0,
          iconTheme: const IconThemeData(color: Colors.black),
          backgroundColor: Provider.of<AmityUIConfiguration>(context)
              .appColors
              .baseBackground,
          leading: IconButton(
            onPressed: () => Navigator.of(context).pop(),
            icon: Icon(Icons.chevron_left,
                color:
                    Provider.of<AmityUIConfiguration>(context).appColors.base,
                size: 30),
          ),
          title: Text("community.community".tr(), //Community
              style: Provider.of<AmityUIConfiguration>(context)
                  .titleTextStyle
                  .copyWith(
                    color: Provider.of<AmityUIConfiguration>(context)
                        .appColors
                        .base,
                  )),
          bottom: PreferredSize(
            preferredSize: const Size.fromHeight(
                48.0), // Provide a height for the AppBar's bottom
            child: Row(
              children: [
                TabBar(
                  tabAlignment: TabAlignment.start,
                  isScrollable: true,
                  // Ensure that the TabBar is scrollable
                  dividerColor: Provider.of<AmityUIConfiguration>(context)
                      .appColors
                      .baseBackground,
                  labelColor: Provider.of<AmityUIConfiguration>(context)
                      .appColors
                      .primary,

                  indicatorColor: Provider.of<AmityUIConfiguration>(context)
                      .appColors
                      .primary,
                  // labelStyle: const TextStyle(
                  //   fontSize: 17,
                  //   fontWeight: FontWeight.w600,
                  //   fontFamily: 'SF Pro Text',
                  // ),

                  tabs: [
                    Tab(text: "community.members".tr()), //Members
                    Tab(text: "community.moderators".tr()), //Moderators
                  ],
                ),
              ],
            ),
          ),
        ),
        body: const TabBarView(
          children: [
            MemberList(), // You need to create a MemberList widget
            ModeratorList(), // You need to create a ModeratorList widget
          ],
        ),
      ),
    );
  }
}
// Import statements remain the same

class MemberList extends StatelessWidget {
  const MemberList({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<MemberManagementVM>(
      builder: (context, viewModel, child) {
        return ListView.builder(
          controller: viewModel.scrollController,
          itemCount: viewModel.userList.length,
          itemBuilder: (context, index) {
            return ListTile(
              onTap: () {
                Navigator.of(context).push(MaterialPageRoute(
                    builder: (context) => ChangeNotifierProvider(
                        create: (context) => UserFeedVM(),
                        child: UserProfileScreen(
                          amityUser: viewModel.userList[index].user!,
                          amityUserId: viewModel.userList[index].user!.userId!,
                        ))));
              },
              leading: CircleAvatar(
                backgroundColor: Provider.of<AmityUIConfiguration>(context)
                    .appColors
                    .primaryShade3,
                backgroundImage: viewModel.userList[index].user?.avatarUrl ==
                        null
                    ? null
                    : NetworkImage(viewModel.userList[index].user!.avatarUrl!),
                child: viewModel.userList[index].user?.avatarUrl != null
                    ? null
                    : const Icon(Icons.person, size: 20, color: Colors.white),
              ),
              title: Text(
                viewModel.userList[index].user?.displayName ?? '',
                style: TextStyle(
                    fontWeight: FontWeight.w500,
                    fontSize: 15,
                    color: Provider.of<AmityUIConfiguration>(context)
                        .appColors
                        .base),
              ),
              trailing: IconButton(
                icon: Icon(Icons.more_horiz_rounded,
                    color: Provider.of<AmityUIConfiguration>(context)
                        .appColors
                        .base),
                onPressed: () {
                  _showOptionsBottomSheet(
                      context, viewModel.userList[index], viewModel,
                      showDemoteButton: false);
                },
              ),
            );
          },
        );
      },
    );
  }
}

class ModeratorList extends StatelessWidget {
  const ModeratorList({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<MemberManagementVM>(
      builder: (context, viewModel, child) {
        return ListView.builder(
          itemCount: viewModel.moderatorList.length,
          controller: viewModel.scrollControllerForModerator,
          itemBuilder: (context, index) {
            return ListTile(
              onTap: () {
                Navigator.of(context).push(MaterialPageRoute(
                    builder: (context) => ChangeNotifierProvider(
                        create: (context) => UserFeedVM(),
                        child: UserProfileScreen(
                          amityUser: viewModel.moderatorList[index].user!,
                          amityUserId: viewModel.userList[index].user!.userId!,
                        ))));
              },
              leading: CircleAvatar(
                backgroundColor: Provider.of<AmityUIConfiguration>(context)
                    .appColors
                    .primaryShade3,
                backgroundImage:
                    viewModel.moderatorList[index].user?.avatarUrl == null
                        ? null
                        : NetworkImage(
                            viewModel.moderatorList[index].user!.avatarUrl!),
                child: viewModel.moderatorList[index].user?.avatarUrl != null
                    ? null
                    : const Icon(Icons.person,
                        size: 20,
                        color: Colors
                            .white), // Adjust to use the correct attribute for avatar URL
              ),
              title: Text(
                viewModel.moderatorList[index].user?.displayName ?? '',
                style:
                    const TextStyle(fontWeight: FontWeight.w500, fontSize: 15),
              ),
              trailing: IconButton(
                icon: const Icon(
                  Icons.more_horiz,
                  color: Colors.black,
                ),
                onPressed: () {
                  _showOptionsBottomSheet(
                      context, viewModel.moderatorList[index], viewModel);
                },
              ),
            );
          },
        );
      },
    );
  }
}

void _showOptionsBottomSheet(BuildContext context, AmityCommunityMember member,
    MemberManagementVM viewModel,
    {bool showDemoteButton = true}) {
  bool isModerator = viewModel.currentUserRoles.contains('community-moderator');

  showModalBottomSheet(
      backgroundColor: Colors.transparent,
      context: context,
      builder: (BuildContext bc) {
        return Container(
          padding: const EdgeInsetsDirectional.only(top: 20, bottom: 20),
          decoration: const BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(20.0),
              topRight: Radius.circular(20.0),
            ),
          ),
          child: Wrap(
            children: isModerator
                ? [
                    member.roles!.contains('community-moderator') &
                            !showDemoteButton
                        ? const SizedBox()
                        : ListTile(
                            title: Text(
                              member.roles!.contains('community-moderator')
                                  ? "community.dismiss_moderator"
                                      .tr() //Dismiss moderator
                                  : "community.promote_user_to_moderator".tr(),
                              //Promote to moderator
                              style:
                                  const TextStyle(fontWeight: FontWeight.w500),
                            ),
                            onTap: () async {
                              Navigator.pop(context);
                              if (member.roles!
                                  .contains('community-moderator')) {
                                await viewModel.demoteFromModerator(
                                    viewModel.communityId, [member.userId!]);
                              } else {
                                await viewModel.promoteToModerator(
                                    viewModel.communityId, [member.userId!]);
                              }
                              await viewModel.initModerators(
                                  communityId: viewModel.communityId);
                              await viewModel.initMember(
                                communityId: viewModel.communityId,
                              );
                            },
                          ),
                    ListTile(
                      title: Text(
                        member.user!.isFlaggedByMe
                            ? "report.unReport_user".tr()
                            : "report.report_user"
                                .tr(), //Undo Report //Report
                        style: const TextStyle(fontWeight: FontWeight.w500),
                      ),
                      onTap: () async {
                        if (member.user!.isFlaggedByMe) {
                          await viewModel.undoReportUser(member.user!);
                        } else {
                          await viewModel.reportUser(member.user!);
                        }
                        await viewModel.initModerators(
                            communityId: viewModel.communityId);
                        await viewModel.initMember(
                          communityId: viewModel.communityId,
                        );
                        Navigator.pop(context);
                      },
                    ),
                    // ListTile(
                    //   title: const Text(
                    //     'حظر المستخدم', //Block User
                    //     style: TextStyle(fontWeight: FontWeight.w500),
                    //   ),
                    //   onTap: () {
                    //     viewModel.blockUser(member.user!);
                    //     Navigator.pop(context);
                    //   },
                    // ),
                    ListTile(
                      title: Text(
                        "community.remove".tr(), //Remove from community
                        style: const TextStyle(
                            color: Colors.red, fontWeight: FontWeight.w500),
                      ),
                      onTap: () async {
                        Navigator.pop(context);
                        await ConfirmationDialog().show(
                          context: context,
                          title: "messages.remove.title".tr(),
                          //Remove user from Community?
                          detailText: "messages.remove.content".tr(),
                          //This user won't no longer be able to search, post and interact in this community
                          onConfirm: () => viewModel.removeMembers(
                              viewModel.communityId, [member.userId!]),
                        );
                        await viewModel.initModerators(
                            communityId: viewModel.communityId);
                        await viewModel.initMember(
                          communityId: viewModel.communityId,
                        );
                      },
                    ),
                  ]
                : [
                    // ListTile(
                    //   title: const Text(
                    //     'حظر المستخدم', //Block User
                    //     style: TextStyle(fontWeight: FontWeight.w500),
                    //   ),
                    //   onTap: () {
                    //     viewModel.blockUser(member.user!);
                    //     Navigator.pop(context);
                    //   },
                    // ),
                    ListTile(
                      title: Text(
                        member.user!.isFlaggedByMe
                            ? "report.unReport_user".tr()
                            : "report.report_user".tr(), //Report
                        style: const TextStyle(fontWeight: FontWeight.w500),
                      ),
                      onTap: () async {
                        Navigator.pop(context);
                        if (member.user!.isFlaggedByMe) {
                          await viewModel.undoReportUser(member.user!);
                        } else {
                          await viewModel.reportUser(member.user!);
                        }
                        viewModel.initModerators(
                            communityId: viewModel.communityId);
                        viewModel.initMember(
                          communityId: viewModel.communityId,
                        );
                      },
                    ),
                  ],
          ),
        );
      });
}
