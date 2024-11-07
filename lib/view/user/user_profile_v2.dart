import 'package:amity_sdk/amity_sdk.dart';
import 'package:amity_uikit_beta_service/components/custom_user_avatar.dart';
import 'package:amity_uikit_beta_service/view/UIKit/social/create_post_screenV2.dart';
import 'package:amity_uikit_beta_service/view/social/global_feed.dart';
import 'package:amity_uikit_beta_service/view/social/user_follow_screen.dart';
import 'package:amity_uikit_beta_service/view/user/medie_component.dart';
import 'user_setting.dart';
import 'package:amity_uikit_beta_service/viewmodel/follower_following_viewmodel.dart';
import 'package:animation_wrappers/animations/fade_animation.dart';
import 'package:animation_wrappers/animations/faded_scale_animation.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_sticky_header/flutter_sticky_header.dart';
import 'package:provider/provider.dart';

import '../../viewmodel/amity_viewmodel.dart';
import '../../viewmodel/configuration_viewmodel.dart';
import '../../viewmodel/user_feed_viewmodel.dart';

// ignore: must_be_immutable
class UserProfileScreen extends StatefulWidget {
  final AmityUser? amityUser;
  final String amityUserId;
  bool? isEnableAppbar = true;
  Widget? customActions = Container();

  UserProfileScreen({
    super.key,
    this.amityUser,
    this.isEnableAppbar,
    this.customActions,
    required this.amityUserId,
  });

  @override
  UserProfileScreenState createState() => UserProfileScreenState();
}

class UserProfileScreenState extends State<UserProfileScreen>
    with SingleTickerProviderStateMixin {
  @override
  void initState() {
    super.initState();

    if (widget.amityUser != null) {
      Provider.of<UserFeedVM>(context, listen: false).initUserFeed(
          amityUser: widget.amityUser, userId: widget.amityUser!.userId!);
      Provider.of<UserFeedVM>(context, listen: false).userFeedTabController =
          TabController(
        length: 2,
        vsync: this,
      );
    } else {
      Provider.of<UserFeedVM>(context, listen: false)
          .initUserFeed(userId: widget.amityUserId);

      Provider.of<UserFeedVM>(context, listen: false).userFeedTabController =
          TabController(
        length: 2,
        vsync: this,
      );
    }
  }

  String getFollowingStatusString(AmityFollowStatus amityFollowStatus) {
    switch (amityFollowStatus) {
      case AmityFollowStatus.NONE:
        return "follow.follow".tr();
      case AmityFollowStatus.PENDING:
        return "follow.pending".tr();
      case AmityFollowStatus.ACCEPTED:
        return "follow.followed".tr();
      case AmityFollowStatus.BLOCKED:
        return "follow.blocked".tr();
      default:
        return "follow.miss_type".tr();
    }
  }

  Color getFollowingStatusColor(AmityFollowStatus amityFollowStatus) {
    if (amityFollowStatus == AmityFollowStatus.NONE) {
      return Provider.of<AmityUIConfiguration>(context).primaryColor;
    } else if (amityFollowStatus == AmityFollowStatus.PENDING) {
      return Colors.grey;
    } else if (amityFollowStatus == AmityFollowStatus.ACCEPTED) {
      return Colors.white;
    } else {
      return Colors.white;
    }
  }

  Color getFollowingStatusTextColor(AmityFollowStatus amityFollowStatus) {
    if (amityFollowStatus == AmityFollowStatus.NONE) {
      return Colors.white;
    } else if (amityFollowStatus == AmityFollowStatus.PENDING) {
      return Colors.white;
    } else if (amityFollowStatus == AmityFollowStatus.ACCEPTED) {
      return Provider.of<AmityUIConfiguration>(context).primaryColor;
    } else {
      return Colors.red;
    }
  }

  AmityUser getAmityUser() {
    if (Provider.of<UserFeedVM>(context).amityUser!.userId ==
        AmityCoreClient.getCurrentUser().userId) {
      return Provider.of<AmityVM>(context).currentAmityUser!;
    } else {
      return Provider.of<UserFeedVM>(context).amityUser!;
    }
  }

  @override
  Widget build(BuildContext context) {
    var isCurrentUser =
        AmityCoreClient.getCurrentUser().userId == widget.amityUserId;
    final theme = Theme.of(context);
    final mediaQuery = MediaQuery.of(context);
    final myAppBar = AppBar(
      backgroundColor: Colors.transparent,
      leading: IconButton(
        color: Provider.of<AmityUIConfiguration>(context).primaryColor,
        onPressed: () {
          Navigator.of(context).pop();
        },
        icon: Icon(
          Icons.chevron_left,
          color: Provider.of<AmityUIConfiguration>(context).appColors.base,
          size: 24,
        ),
      ),
      elevation: 0,
    );
    final bheight = mediaQuery.size.height -
        mediaQuery.padding.top -
        myAppBar.preferredSize.height;
    if (Provider.of<UserFeedVM>(context).amityUser != null) {
      return AppScaffold(
        title: '',
        slivers: [
          Consumer<UserFeedVM>(builder: (context, vm, _) {
            return _StickyHeaderList(
              index: 0,
              profileSectionWidget: Column(
                children: [
                  Container(
                    color: Provider.of<AmityUIConfiguration>(context)
                        .appColors
                        .baseBackground,
                    padding:
                        const EdgeInsetsDirectional.only(start: 16, end: 16),
                    child: Column(
                      children: [
                        FadedScaleAnimation(
                          child: getAvatarImage(
                              isCurrentUser
                                  ? Provider.of<AmityVM>(
                                      context,
                                    ).currentAmityUser?.avatarUrl
                                  : Provider.of<UserFeedVM>(context)
                                      .amityUser!
                                      .avatarUrl,
                              radius: 64),
                        ),
                        const SizedBox(height: 10),
                        Text(
                          getAmityUser().displayName ?? "",
                          style: const TextStyle(
                            color: Color(0xff4B5563),
                            fontSize: 20,
                            fontWeight: FontWeight.w700,
                            letterSpacing: -0.4,
                          ),
                        ),

                        // Text(vm.amityMyFollowInfo.status
                        //     .toString()),
                        vm.amityMyFollowInfo.id == null
                            ? const SizedBox()
                            : StreamBuilder<AmityUserFollowInfo>(
                                stream: vm.amityMyFollowInfo.listen.stream,
                                initialData: vm.amityMyFollowInfo,
                                builder: (context, snapshot) {
                                  return Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      // Text('${  vm.amityMyFollowInfo.followerCount
                                      //     .toString()} Posts  '),
                                      GestureDetector(
                                        onTap: () {
                                          Navigator.of(context).push(
                                            MaterialPageRoute(
                                              builder: (context) =>
                                                  ChangeNotifierProvider(
                                                create: (context) =>
                                                    FollowerVM(),
                                                child: FollowScreen(
                                                    followScreenType:
                                                        FollowScreenType
                                                            .following,
                                                    key: UniqueKey(),
                                                    userId: widget.amityUserId,
                                                    displayName: getAmityUser()
                                                        .displayName),
                                              ),
                                            ),
                                          );
                                        },
                                        child: Text(
                                            "community.member".plural(
                                              snapshot.data!.followingCount!
                                                  .toInt(),
                                              format: NumberFormat.compact(
                                                  locale: context.locale
                                                      .toString()),
                                            ), //following
                                            style: const TextStyle(
                                                fontWeight: FontWeight.w500,
                                                fontSize: 13,
                                                color: Color(0xff4B5563))),
                                      ),
                                      const SizedBox(width: 12),
                                      GestureDetector(
                                        onTap: () {
                                          Navigator.of(context).push(
                                            MaterialPageRoute(
                                              builder: (context) =>
                                                  ChangeNotifierProvider(
                                                create: (context) =>
                                                    FollowerVM(),
                                                child: FollowScreen(
                                                    followScreenType:
                                                        FollowScreenType
                                                            .follower,
                                                    key: UniqueKey(),
                                                    userId: widget.amityUserId,
                                                    displayName: getAmityUser()
                                                        .displayName),
                                              ),
                                            ),
                                          );
                                        },
                                        child: Text(
                                          "community.follower".plural(
                                            snapshot.data!.followerCount!,
                                            format: NumberFormat.compact(
                                                locale:
                                                    context.locale.toString()),
                                          ),
                                          //followers
                                          style: const TextStyle(
                                              fontWeight: FontWeight.w500,
                                              fontSize: 13,
                                              color: Color(0xff4B5563)),
                                        ),
                                      ),
                                    ],
                                  );
                                }),

                        const SizedBox(height: 12),
                        Align(
                          alignment: AlignmentDirectional.centerStart,
                          child: Wrap(
                            alignment: WrapAlignment.start,
                            children: [
                              Text(
                                getAmityUser().description ?? "",
                                style: TextStyle(
                                    fontSize: 16,
                                    color: Provider.of<AmityUIConfiguration>(
                                            context)
                                        .appColors
                                        .base),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(height: 12),
                        AmityCoreClient.getCurrentUser().userId ==
                                Provider.of<UserFeedVM>(context)
                                    .amityUser!
                                    .userId
                            ? Row(
                                children: [
                                  Expanded(
                                    child: GestureDetector(
                                      onTap: () async {
                                        await Navigator.of(context).pushNamed(
                                          "/my-account/profile",
                                          arguments: {"fromSettings": false},
                                        );
                                        // await Navigator.of(context).push(
                                        //     MaterialPageRoute(
                                        //         builder: (context) =>
                                        //             ProfileScreen(
                                        //                 user: vm.amityUser!)));
                                      },
                                      child: Container(
                                        decoration: BoxDecoration(
                                          border: Border.all(
                                              color: const Color(0xffDDDDDD),
                                              style: BorderStyle.solid,
                                              width: 1),
                                          borderRadius:
                                              BorderRadius.circular(50),
                                          color:
                                              Provider.of<AmityUIConfiguration>(
                                                      context)
                                                  .appColors
                                                  .baseBackground,
                                        ),
                                        padding: const EdgeInsetsDirectional
                                            .fromSTEB(10, 10, 10, 10),
                                        child: Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          children: [
                                            Text(
                                              "external.edit"
                                                  .tr(), //Edit Profile
                                              style: theme.textTheme.titleSmall!
                                                  .copyWith(
                                                color: const Color(0xff4B5563),
                                                fontSize: 15,
                                              ),
                                              textAlign: TextAlign.center,
                                            ),
                                            const Icon(
                                              Icons.edit_outlined,
                                              color: Color(0xff4B5563),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              )
                            : Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  // GestureDetector(
                                  //   onTap: () {},
                                  //   child: Container(
                                  //     width: constraints.maxWidth * 0.35,
                                  //     decoration: BoxDecoration(
                                  //         border: Border.all(
                                  //             color: Provider.of<
                                  //                         AmityUIConfiguration>(
                                  //                     context)
                                  //                 .primaryColor,
                                  //             style: BorderStyle.solid,
                                  //             width: 1),
                                  //         borderRadius:
                                  //             BorderRadius.circular(10),
                                  //         color: Colors.white),
                                  //     padding: const EdgeInsetsDirectional.fromSTEB(
                                  //         10, 10, 10, 10),
                                  //     child: Text(
                                  //       "Messages",
                                  //       style: theme.textTheme.subtitle2!
                                  //           .copyWith(
                                  //         color: Provider.of<
                                  //                     AmityUIConfiguration>(
                                  //                 context)
                                  //             .primaryColor,
                                  //         fontSize: 12,
                                  //       ),
                                  //       textAlign: TextAlign.center,
                                  //     ),
                                  //   ),
                                  // ),

                                  Expanded(
                                    child: Padding(
                                      padding:
                                          const EdgeInsetsDirectional.only(),
                                      child: vm.amityMyFollowInfo.id == null
                                          ? Container(
                                              decoration: BoxDecoration(
                                                border: Border.all(
                                                    color: Provider.of<
                                                                AmityUIConfiguration>(
                                                            context)
                                                        .primaryColor,
                                                    style: BorderStyle.solid,
                                                    width: 1),
                                                borderRadius:
                                                    BorderRadius.circular(10),
                                              ),
                                              padding:
                                                  const EdgeInsetsDirectional
                                                      .fromSTEB(10, 10, 10, 10),
                                              child: Text(
                                                "",
                                                textAlign: TextAlign.center,
                                                style: theme
                                                    .textTheme.titleSmall!
                                                    .copyWith(
                                                  fontSize: 12,
                                                ),
                                              ),
                                            )
                                          : StreamBuilder<AmityUserFollowInfo>(
                                              stream: vm.amityMyFollowInfo
                                                  .listen.stream,
                                              initialData: vm.amityMyFollowInfo,
                                              builder: (context, snapshot) {
                                                return FadeAnimation(
                                                  child:
                                                      snapshot.data!.status ==
                                                              AmityFollowStatus
                                                                  .ACCEPTED
                                                          ? const SizedBox()
                                                          : GestureDetector(
                                                              onTap: () {
                                                                vm.followButtonAction(
                                                                    vm
                                                                        .amityUser!,
                                                                    snapshot
                                                                        .data!
                                                                        .status);
                                                              },
                                                              child: Container(
                                                                decoration: BoxDecoration(
                                                                    border: Border.all(
                                                                        color: getFollowingStatusTextColor(snapshot
                                                                            .data!
                                                                            .status),
                                                                        style: BorderStyle
                                                                            .solid,
                                                                        width:
                                                                            1),
                                                                    borderRadius:
                                                                        BorderRadius
                                                                            .circular(
                                                                                4),
                                                                    color: getFollowingStatusColor(
                                                                        snapshot
                                                                            .data!
                                                                            .status)),
                                                                padding:
                                                                    const EdgeInsetsDirectional
                                                                        .fromSTEB(
                                                                        10,
                                                                        10,
                                                                        10,
                                                                        10),
                                                                child: Row(
                                                                  mainAxisAlignment:
                                                                      MainAxisAlignment
                                                                          .center,
                                                                  children: [
                                                                    Icon(
                                                                      Icons.add,
                                                                      size: 16,
                                                                      color: Provider.of<AmityUIConfiguration>(
                                                                              context)
                                                                          .appColors
                                                                          .userProfileBGColor,
                                                                      weight: 4,
                                                                    ),
                                                                    const SizedBox(
                                                                      width: 2,
                                                                    ),
                                                                    Text(
                                                                      getFollowingStatusString(snapshot
                                                                          .data!
                                                                          .status),
                                                                      textAlign:
                                                                          TextAlign
                                                                              .center,
                                                                      style: theme
                                                                          .textTheme
                                                                          .titleSmall!
                                                                          .copyWith(
                                                                        fontWeight:
                                                                            FontWeight.w700,
                                                                        color: getFollowingStatusTextColor(snapshot
                                                                            .data!
                                                                            .status),
                                                                        fontSize:
                                                                            15,
                                                                      ),
                                                                    ),
                                                                  ],
                                                                ),
                                                              ),
                                                            ),
                                                );
                                              },
                                            ),
                                    ),
                                  ),
                                ],
                              )
                      ],
                    ),
                  ),
                  const SizedBox(height: 0),
                ],
              ),
              theme: theme,
              bheight: bheight,
            );
          }),
          _StickyHeaderList(
            index: 1,
            theme: theme,
            bheight: bheight,
          ),
        ],
        amityUser: Provider.of<UserFeedVM>(context).amityUser!,
        amityUserId: widget.amityUserId,
      );
    } else {
      return Scaffold(
        backgroundColor:
            Provider.of<AmityUIConfiguration>(context).appColors.baseBackground,
      );
    }
  }
}

class _Item extends StatelessWidget {
  const _Item({
    super.key,
    required this.text,
    required this.builder,
  });

  final String text;
  final WidgetBuilder builder;

  @override
  Widget build(BuildContext context) {
    return Card(
      color: Colors.blue,
      child: InkWell(
        onTap: () =>
            Navigator.push(context, MaterialPageRoute(builder: builder)),
        child: Container(
          padding: const EdgeInsetsDirectional.all(16),
          child: Text(
            text,
            style: const TextStyle(
                color: Colors.white, fontWeight: FontWeight.bold, fontSize: 20),
          ),
        ),
      ),
    );
  }
}

class _StickyHeaderList extends StatelessWidget {
  const _StickyHeaderList({
    super.key,
    this.index,
    this.profileSectionWidget,
    required this.theme,
    required this.bheight,
  });

  final int? index;
  final Widget? profileSectionWidget;
  final ThemeData theme;
  final double bheight;

  @override
  Widget build(BuildContext context) {
    return SliverStickyHeader(
      header: Header(
        // index: 0,
        index: index,
      ),
      sliver: SliverList(
        delegate: SliverChildBuilderDelegate(
          (context, i) {
            if (index == 0) {
              return profileSectionWidget;
            } else {
              return Consumer<UserFeedVM>(
                builder: (context, vm, _) {
                  Widget buildPrivateAccountWidget(double bheight) {
                    return SingleChildScrollView(
                      child: Container(
                        color: Provider.of<AmityUIConfiguration>(context)
                            .appColors
                            .baseShade4,
                        width: MediaQuery.of(context).size.width,
                        height: bheight,
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            const SizedBox(
                              height: 150,
                            ),
                            Image.asset(
                              "assets/images/privateIcon.png",
                              package: "amity_uikit_beta_service",
                            ),
                            const SizedBox(height: 12),
                            Text(
                              "user.private".tr(), //This account is private
                              style: const TextStyle(
                                  fontSize: 17,
                                  fontWeight: FontWeight.w600,
                                  color: Color(0xff292B32)),
                            ),
                            Text(
                              "user.follow_post".tr(),
                              //Follow this user to see all posts
                              style: const TextStyle(
                                  fontSize: 15,
                                  fontWeight: FontWeight.w400,
                                  color: Color(0xffA5A9B5)),
                            ),
                          ],
                        ),
                      ),
                    );
                  }

                  Widget buildNoPostsWidget(
                      double bheight, BuildContext context) {
                    return SingleChildScrollView(
                      child: Container(
                        color: Provider.of<AmityUIConfiguration>(context)
                            .appColors
                            .baseShade4,
                        width: MediaQuery.of(context).size.width,
                        height: bheight,
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            const SizedBox(
                              height: 150,
                            ),
                            Image.asset(
                              "assets/images/noPostYet.png",
                              package: "amity_uikit_beta_service",
                            ),
                            const SizedBox(height: 12),
                            Text(
                              "external.empty".tr(), //No post yet
                              style: const TextStyle(
                                  fontSize: 17,
                                  fontWeight: FontWeight.w600,
                                  color: Color(0xffA5A9B5)),
                            ),
                          ],
                        ),
                      ),
                    );
                  }

                  Widget buildContent(BuildContext context, double bheight) {
                    if (vm.amityMyFollowInfo.status !=
                            AmityFollowStatus.ACCEPTED &&
                        vm.amityUser!.userId != AmityCoreClient.getUserId()) {
                      return buildPrivateAccountWidget(bheight);
                    }
                    // else {
                    //   return SizedBox.shrink();
                    // }
                    else if (vm.amityPosts.isEmpty) {
                      return buildNoPostsWidget(bheight, context);
                    } else {
                      return Container(
                        color: Provider.of<AmityUIConfiguration>(context)
                            .appColors
                            .baseShade4,
                        child: ListView.builder(
                          padding: EdgeInsetsDirectional.zero,
                          physics: const NeverScrollableScrollPhysics(),
                          shrinkWrap: true,
                          itemCount: Provider.of<UserFeedVM>(context)
                              .amityPosts
                              .length,
                          itemBuilder: (context, index) {
                            return StreamBuilder<AmityPost>(
                              stream: vm.amityPosts[index].listen.stream,
                              initialData: vm.amityPosts[index],
                              builder: (context, snapshot) {
                                return PostWidget(
                                  isPostDetail: false,
                                  feedType: FeedType.user,
                                  showCommunity: false,
                                  showLatestComment: false,
                                  isFromFeed: true,
                                  post: snapshot.data!,
                                  theme: theme,
                                  postIndex: index,
                                );
                              },
                            );
                          },
                        ),
                      );
                    }
                  }

                  if (vm.userFeedTabController!.index == 0) {
                    return buildContent(context, bheight);
                  } else {
                    return MediaGalleryPage(
                      galleryFeed: GalleryFeed.user,
                      onRefresh: () {},
                    );
                  }
                },
              );
            }
          },
          childCount: 1,
        ),
      ),
    );
  }
}

class AppScaffold extends StatelessWidget {
  const AppScaffold({
    super.key,
    required this.title,
    required this.slivers,
    this.reverse = false,
    required this.amityUser,
    required this.amityUserId,
  });

  final String title;
  final List<Widget> slivers;
  final bool reverse;
  final AmityUser amityUser;
  final String amityUserId;

  @override
  Widget build(BuildContext context) {
    return DefaultStickyHeaderController(
      child: Scaffold(
        floatingActionButton:
            amityUserId != AmityCoreClient.getCurrentUser().userId
                ? null
                : FloatingActionButton(
                    shape: const CircleBorder(),
                    onPressed: () async {
                      await showModalBottomSheet(
                        context: context,
                        isScrollControlled: true,
                        shape: const RoundedRectangleBorder(
                          borderRadius: BorderRadius.vertical(
                            top: Radius.circular(12),
                          ),
                        ),
                        clipBehavior: Clip.hardEdge,
                        builder: (context) => const FractionallySizedBox(
                          heightFactor: 0.8,
                          child: AmityCreatePostV2Screen(),
                        ),
                      );
                      Provider.of<UserFeedVM>(context, listen: false)
                          .initUserFeed(userId: amityUserId);
                    },
                    backgroundColor:
                        Provider.of<AmityUIConfiguration>(context).primaryColor,
                    child: Provider.of<AmityUIConfiguration>(context)
                        .iconConfig
                        .postIcon(iconSize: 28, color: Colors.white),
                  ),
        appBar: AppBar(
          scrolledUnderElevation: 0,
          backgroundColor: Provider.of<AmityUIConfiguration>(context)
              .appColors
              .baseBackground,
          title: Text(title),
          leading: IconButton(
            icon: Icon(
              Icons.chevron_left,
              color: Provider.of<AmityUIConfiguration>(context).appColors.base,
              size: 30,
            ),
            onPressed: () => Navigator.of(context).pop(),
          ),
          // actions: [
          //   Provider.of<UserFeedVM>(context).amityMyFollowInfo.id == null
          //       ? const SizedBox()
          //       : StreamBuilder<AmityUserFollowInfo>(
          //           stream: Provider.of<UserFeedVM>(context)
          //               .amityMyFollowInfo
          //               .listen
          //               .stream,
          //           initialData:
          //               Provider.of<UserFeedVM>(context).amityMyFollowInfo,
          //           builder: (context, snapshot) {
          //             return IconButton(
          //               icon: Icon(Icons.more_horiz,
          //                   color: Provider.of<AmityUIConfiguration>(context)
          //                       .appColors
          //                       .base),
          //               onPressed: () {
          //                 Navigator.of(context).push(MaterialPageRoute(
          //                     builder: (_) => UserSettingPage(
          //                           amityMyFollowInfo: snapshot.data!,
          //                           amityUser: Provider.of<UserFeedVM>(context)
          //                               .amityUser!,
          //                         )));
          //               },
          //             );
          //           }),
          // ],
        ),
        body: RefreshIndicator(
          color: Provider.of<AmityUIConfiguration>(context).primaryColor,
          onRefresh: () async {
            await Provider.of<UserFeedVM>(context, listen: false)
                .initUserFeed(amityUser: amityUser, userId: amityUser.userId!);
          },
          child: CustomScrollView(
            physics: const AlwaysScrollableScrollPhysics(),
            controller: Provider.of<UserFeedVM>(context).scrollcontroller,
            slivers: slivers,
            reverse: reverse,
          ),
        ),
      ),
    );
  }
}

class Header extends StatelessWidget {
  const Header({
    super.key,
    this.index,
    this.title,
    this.color = Colors.lightBlue,
  });

  final String? title;
  final int? index;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Consumer<UserFeedVM>(
      builder: (context, vm, _) {
        return index == 0
            ? const SizedBox()
            : Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Expanded(
                    child: GestureDetector(
                      onTap: () {},
                      child: Container(
                        color: Provider.of<AmityUIConfiguration>(context)
                            .appColors
                            .baseBackground,
                        child: TabBar(
                          onTap: ((value) {
                            vm.changeTab();
                          }),
                          dividerColor:
                              Provider.of<AmityUIConfiguration>(context)
                                  .appColors
                                  .baseBackground,
                          tabAlignment: TabAlignment.start,
                          controller: vm.userFeedTabController,
                          isScrollable: true,
                          labelColor: Provider.of<AmityUIConfiguration>(context)
                              .appColors
                              .primary,
                          indicatorColor:
                              Provider.of<AmityUIConfiguration>(context)
                                  .appColors
                                  .primary,
                          // labelStyle: const TextStyle(
                          //   fontSize: 17,
                          //   fontWeight: FontWeight.w600,
                          //   fontFamily: 'SF Pro Text',
                          // ),
                          tabs: [
                            Tab(text: "user.timeline".tr()), //Timeline
                            Tab(text: "user.gallery".tr()), //Gallery
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              );
      },
    );
  }
}
