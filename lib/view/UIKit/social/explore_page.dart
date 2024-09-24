import 'dart:developer';

import 'package:amity_sdk/amity_sdk.dart';
import 'package:amity_uikit_beta_service/components/custom_user_avatar.dart';
import 'package:amity_uikit_beta_service/view/UIKit/social/search_communities.dart'
    hide CommunityIconList;
import 'package:amity_uikit_beta_service/view/social/community_feedV2.dart';
import 'package:amity_uikit_beta_service/view/social/global_feed.dart';
import 'package:amity_uikit_beta_service/viewmodel/configuration_viewmodel.dart';
import 'package:amity_uikit_beta_service/viewmodel/explore_page_viewmodel.dart';
import 'package:amity_uikit_beta_service/viewmodel/feed_viewmodel.dart';
import 'package:amity_uikit_beta_service/viewmodel/my_community_viewmodel.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:provider/provider.dart';

import '../../../components/search_field.dart';
import '../../../viewmodel/amity_viewmodel.dart';
import '../../../viewmodel/community_feed_viewmodel.dart';
import '../../../viewmodel/user_feed_viewmodel.dart';
import '../../notification/notification_page.dart';
import '../../user/user_profile_v2.dart';
import 'create_group_button_sheet.dart';
import 'create_post_screenV2.dart';
import 'my_community_feed.dart';

// enum CategoryListState { loading, success, empty, error }

class CommunityPage extends StatefulWidget {
  final bool isShowMyCommunity;

  const CommunityPage({super.key, this.isShowMyCommunity = true});

  @override
  State<CommunityPage> createState() => _CommunityPageState();
}

class _CommunityPageState extends State<CommunityPage> {
  @override
  void initState() {
    super.initState();

    var explorePageVM = Provider.of<ExplorePageVM>(context, listen: false);

    explorePageVM.getRecommendedCommunities();
    explorePageVM.getTrendingCommunities();
    explorePageVM.queryCommunityCategories(
        sortOption: AmityCommunityCategorySortOption.FIRST_CREATED);

    var globalFeedProvider = Provider.of<FeedVM>(context, listen: false);
    var myCommunityList = Provider.of<MyCommunityVM>(context, listen: false);

    myCommunityList.initMyCommunityFeed();

    globalFeedProvider.initAmityGlobalfeed();
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 3,
      child: Scaffold(
        backgroundColor:
            Provider.of<AmityUIConfiguration>(context).appColors.baseShade4,
        floatingActionButton: Padding(
          padding:
              EdgeInsets.only(bottom: MediaQuery.paddingOf(context).bottom),
          child: FloatingActionButton(
            shape: const CircleBorder(),
            onPressed: () async {
              final posted = await showModalBottomSheet(
                context: context,
                isScrollControlled: true,
                shape: const RoundedRectangleBorder(
                  borderRadius: BorderRadius.vertical(
                    top: Radius.circular(12),
                  ),
                ),
                clipBehavior: Clip.hardEdge,
                builder: (context) => FractionallySizedBox(
                  heightFactor: 0.8,
                  child: AmityCreatePostV2Screen(),
                ),
              );
              if ((posted ?? false) && context.mounted) {
                Provider.of<FeedVM>(context, listen: false)
                    .initAmityGlobalfeed();
              }
            },
            backgroundColor:
                Provider.of<AmityUIConfiguration>(context).primaryColor,
            child: Provider.of<AmityUIConfiguration>(context)
                .iconConfig
                .postIcon(iconSize: 28, color: Colors.white),
          ),
        ),
        appBar: AppBar(
          elevation: 0.05,
          // Add this line to remove the shadow
          backgroundColor: Provider.of<AmityUIConfiguration>(context)
              .appColors
              .baseBackground,

          // leading: IconButton(
          //   icon: Icon(
          //     Icons.close,
          //     color: Provider.of<AmityUIConfiguration>(context).appColors.base,
          //   ),
          //   onPressed: () => Navigator.of(context).pop(),
          // ),
          // centerTitle: false,
          automaticallyImplyLeading: false,
          leading: Provider.of<AmityVM>(context).currentamityUser == null
              ? null
              : IconButton(
                  onPressed: () {
                    final user = Provider.of<AmityVM>(context, listen: false)
                        .currentamityUser;
                    Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (context) => ChangeNotifierProvider(
                          create: (context) => UserFeedVM(),
                          child: UserProfileScreen(
                            amityUser: user!,
                            amityUserId: user.userId!,
                          ),
                        ),
                      ),
                    );
                  },
                  icon: getAvatarImage(Provider.of<AmityVM>(context)
                      .currentamityUser
                      ?.avatarUrl),
                ),
          actions: [
            IconButton(
              icon: SvgPicture.asset(
                "assets/Icons/notifications.svg",
                package: "amity_uikit_beta_service",
              ),
              onPressed: () {
                Navigator.of(context).push(MaterialPageRoute(
                    builder: (context) => const NotificationPage()));
              },
            ),
            IconButton(
              icon: SvgPicture.asset(
                "assets/Icons/search.svg",
                package: "amity_uikit_beta_service",
              ),
              onPressed: () {
                // Implement search functionality
                Navigator.of(context).push(MaterialPageRoute(
                    builder: (context) => const SearchCommunitiesScreen()));
              },
            ),
          ],
          bottom: TabBar(
            // controller: tabController,
            // tabAlignment: TabAlignment.start,
            // isScrollable: true,
            // Ensure that the TabBar is scrollable
            dividerColor: Provider.of<AmityUIConfiguration>(context)
                .appColors
                .baseBackground,
            labelColor:
                Provider.of<AmityUIConfiguration>(context).appColors.primary,
            unselectedLabelColor: Colors.grey,
            indicatorColor:
                Provider.of<AmityUIConfiguration>(context).appColors.primary,
            // labelStyle: const TextStyle(
            //   fontSize: 17,
            //   fontWeight: FontWeight.w600,
            //   fontFamily: 'SF Pro Text',
            // ),
            tabs: const [
              Tab(text: "صفحتي"), //Newsfeed
              Tab(text: "استكشفي"), //Explore
              Tab(text: "المجموعات"),
            ],
          ),
        ),
        body: TabBarView(
          // controller: tabController,
          children: [
            Scaffold(
              // floatingActionButton: FloatingActionButton(
              //   shape: const CircleBorder(),
              //   onPressed: () {
              //     // Navigate or perform action based on 'Newsfeed' tap
              //     Navigator.of(context).push(MaterialPageRoute(
              //       builder: (context) => const Scaffold(body: PostToPage()),
              //     ));
              //   },
              //   backgroundColor:
              //       Provider.of<AmityUIConfiguration>(context).appColors.primary,
              //   child: Provider.of<AmityUIConfiguration>(context)
              //       .iconConfig
              //       .postIcon(iconSize: 28, color: Colors.white),
              // ),
              body: GlobalFeedScreen(
                isShowMyCommunity: widget.isShowMyCommunity,
                canCreateCommunity: false,
              ),
            ),
            RefreshIndicator(
                onRefresh: () async {
                  var explorePageVM =
                      Provider.of<ExplorePageVM>(context, listen: false);

                  explorePageVM.getRecommendedCommunities();
                  explorePageVM.getTrendingCommunities();
                  explorePageVM.queryCommunityCategories(
                      sortOption:
                          AmityCommunityCategorySortOption.FIRST_CREATED);
                },
                child: const ExplorePage()),
            const GroupsSectionsPage(),
          ],
        ),
      ),
    );
  }
}

class ExplorePage extends StatelessWidget {
  const ExplorePage({super.key});

  @override
  Widget build(BuildContext context) {
    // return ListView(
    //   children: [
    //     // RecommendationSection(),
    //     // TrendingSection(),
    //     const CategorySection(),
    //   ],
    // );

    final theme = Theme.of(context);
    return Consumer<FeedVM>(
      builder: (context, vm, _) {
        if (vm.getAmityPosts.isEmpty) {
          return SingleChildScrollView(
            padding: EdgeInsets.only(
              top: 0,
              bottom: MediaQuery.paddingOf(context).bottom + 24,
            ),
            child: const CategorySection(max: 16),
          );
        }

        return ListView.builder(
          controller: vm.scrollcontroller,
          padding: EdgeInsets.only(
            top: 0,
            bottom: MediaQuery.paddingOf(context).bottom + 24,
          ),
          physics: const AlwaysScrollableScrollPhysics(),
          itemCount: vm.getAmityPosts.length,
          itemBuilder: (context, index) {
            return StreamBuilder<AmityPost>(
              key: Key(vm.getAmityPosts[index].postId!),
              stream: vm.getAmityPosts[index].listen.stream,
              initialData: vm.getAmityPosts[index],
              builder: (context, snapshot) {
                return Column(
                  children: [
                    index != 0 ? const SizedBox() : const CategorySection(),
                    PostWidget(
                      isPostDetail: false,
                      feedType: FeedType.global,
                      showCommunity: true,
                      showlatestComment: false,
                      post: snapshot.data!,
                      theme: theme,
                      postIndex: index,
                      isFromFeed: true,
                    ),
                  ],
                );
              },
            );
          },
        );
      },
    );
  }
}

class RecommendationSection extends StatelessWidget {
  const RecommendationSection({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Consumer<ExplorePageVM>(
      builder: (context, vm, _) {
        if (vm.recommendedCommunities.isEmpty) {
          return SizedBox();
        }

        return Container(
          padding: const EdgeInsetsDirectional.only(bottom: 16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsetsDirectional.only(start: 16),
                child: Text(
                  'المجموعات التي قد تعجبك', //Recommended for you
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.bold,
                    color: Provider.of<AmityUIConfiguration>(context)
                        .appColors
                        .baseShade1,
                  ),
                ),
              ),
              const SizedBox(height: 8),
              SizedBox(
                height: 194,
                child: PageView.builder(
                  controller: PageController(viewportFraction: 0.9),
                  itemCount: vm.recommendedCommunities.length,
                  itemBuilder: (context, index) {
                    final community = vm.recommendedCommunities[index];
                    return Card(
                      shape: RoundedRectangleBorder(
                        borderRadius:
                            BorderRadius.circular(12), // No border radius
                      ),
                      margin: EdgeInsets.symmetric(horizontal: 8),
                      child: Stack(
                        children: [
                          if (community.avatarImage?.fileUrl != null)
                            Positioned.fill(
                              child: Image.network(
                                community.avatarImage!
                                    .getUrl(AmityImageSize.MEDIUM),
                                fit: BoxFit.cover,
                              ),
                            ),
                          Positioned.fill(
                            child: Container(
                              decoration: BoxDecoration(
                                gradient: LinearGradient(
                                  colors: [
                                    Colors.black.withOpacity(0.0),
                                    Colors.black.withOpacity(0.6),
                                  ],
                                  begin: Alignment.topCenter,
                                  end: Alignment.bottomCenter,
                                ),
                              ),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.all(12.0),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.end,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  community.displayName ?? "",
                                  style: TextStyle(
                                    fontSize: 14,
                                    color: Colors.white,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                                Text(
                                  community.description ?? "",
                                  maxLines: 2,
                                  style: TextStyle(
                                    fontSize: 12,
                                    color: Colors.white,
                                  ),
                                ),
                                Text.rich(TextSpan(
                                  children: [
                                    TextSpan(
                                        text: community.postsCount?.toString()),
                                    TextSpan(text: " منشور - "),
                                    TextSpan(
                                        text:
                                            community.membersCount?.toString()),
                                    TextSpan(text: " عضو"),
                                  ],
                                  style: TextStyle(
                                    fontSize: 10,
                                    color: Colors.white70,
                                  ),
                                )),
                              ],
                            ),
                          ),
                          Material(
                            color: Colors.transparent,
                            child: InkWell(
                              onTap: () {
                                Navigator.of(context).push(MaterialPageRoute(
                                    builder: (context) =>
                                        CommunityScreen(community: community)));
                              },
                            ),
                          ),
                        ],
                      ),
                    );
                  },
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}

class TrendingSection extends StatelessWidget {
  const TrendingSection({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Consumer<ExplorePageVM>(
      builder: (context, vm, _) {
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsetsDirectional.only(start: 16, top: 20),
              child: Text(
                "المجموعات المقترحة", //Today\'s Trending
                style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w500,
                    color: Provider.of<AmityUIConfiguration>(context)
                        .appColors
                        .baseShade1),
              ),
            ),
            ListView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              padding: EdgeInsets.only(
                top: 8,
                bottom: MediaQuery.paddingOf(context).bottom + 75,
              ),
              itemCount: vm.trendingCommunities.length,
              // itemExtent: 60.0,
              // <-- Set this to your desired height
              itemBuilder: (context, index) {
                final community = vm.trendingCommunities[index];

                return Card(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  margin: EdgeInsets.symmetric(horizontal: 16, vertical: 6),
                  child: InkWell(
                    onTap: () {
                      Navigator.of(context).push(MaterialPageRoute(
                          builder: (context) => ChangeNotifierProvider(
                                create: (context) => CommuFeedVM(),
                                child: CommunityScreen(
                                  isFromFeed: true,
                                  community: community,
                                ),
                              )));
                    },
                    child: Row(
                      children: [
                        SizedBox(
                          width: 75,
                          height: 75,
                          child: Image.network(
                            community.avatarImage!.fileUrl!,
                            fit: BoxFit.cover,
                          ),
                        ),
                        SizedBox(width: 12),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                community.displayName ?? "",
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                                style: TextStyle(
                                  fontSize: 14,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                              Text.rich(TextSpan(
                                children: [
                                  TextSpan(
                                      text: community.postsCount?.toString()),
                                  TextSpan(text: " منشور - "),
                                  TextSpan(
                                      text: community.membersCount?.toString()),
                                  TextSpan(text: " عضو"),
                                ],
                                style: TextStyle(
                                  fontSize: 10,
                                ),
                              )),
                            ],
                          ),
                        ),
                        TextButton(
                          onPressed: community.isJoined ?? false
                              ? null
                              : () {
                                  if (community.isJoined != null) {
                                    if (community.isJoined!) {
                                      AmitySocialClient.newCommunityRepository()
                                          .leaveCommunity(
                                              community.communityId!)
                                          .then((value) {
                                        // setState(() {
                                        community.isJoined =
                                            !(community.isJoined!);
                                        var explorePageVM =
                                            Provider.of<ExplorePageVM>(context,
                                                listen: false);
                                        explorePageVM
                                            .getRecommendedCommunities();
                                        explorePageVM.getTrendingCommunities();
                                        // });
                                      }).onError((error, stackTrace) {
                                        //handle error
                                        log(error.toString());
                                      });
                                    } else {
                                      AmitySocialClient.newCommunityRepository()
                                          .joinCommunity(community.communityId!)
                                          .then((value) {
                                        // setState(() {
                                        community.isJoined =
                                            !(community.isJoined!);
                                        var explorePageVM =
                                            Provider.of<ExplorePageVM>(context,
                                                listen: false);
                                        explorePageVM
                                            .getRecommendedCommunities();
                                        explorePageVM.getTrendingCommunities();
                                        print(">>>>>>>>>>>>>>>callback");

                                        var myCommunityList =
                                            Provider.of<MyCommunityVM>(context,
                                                listen: false);
                                        myCommunityList.initMyCommunity();

                                        for (var i in myCommunityList
                                            .amityCommunities) {
                                          print(
                                              ">>>>>>>>>>>>>>>${i.displayName}");
                                        }
                                        print(myCommunityList.amityCommunities);
                                        // });
                                      }).onError((error, stackTrace) {
                                        log(error.toString());
                                      });
                                    }
                                  }
                                },
                          child: Text(
                              community.isJoined ?? false ? "منضم" : "انضم"),
                        ),
                      ],
                    ),
                  ),
                );

                // return ListTile(
                //   onTap: () {
                //     Navigator.of(context).push(MaterialPageRoute(
                //         builder: (context) => ChangeNotifierProvider(
                //               create: (context) => CommuFeedVM(),
                //               child: CommunityScreen(
                //                 isFromFeed: true,
                //                 community: community,
                //               ),
                //             )));
                //   },
                //   leading: Row(
                //     mainAxisSize: MainAxisSize.min,
                //     children: [
                //       Container(
                //         height: 40,
                //         width: 40,
                //         decoration: BoxDecoration(
                //           color: Provider.of<AmityUIConfiguration>(context)
                //               .appColors
                //               .primaryShade3,
                //           shape: BoxShape.circle,
                //         ),
                //         child: community.avatarImage != null
                //             ? CircleAvatar(
                //                 backgroundImage: NetworkImage(
                //                     community.avatarImage?.fileUrl ?? ''),
                //               )
                //             : const Icon(Icons.people, color: Colors.white),
                //       ),
                //       const SizedBox(width: 15),
                //       Text("${index + 1}",
                //           style: TextStyle(
                //               fontSize: 20,
                //               color:
                //                   Provider.of<AmityUIConfiguration>(context)
                //                       .appColors
                //                       .primary,
                //               fontWeight: FontWeight.bold)), // Ranking number
                //       // Spacing between rank and avatar
                //     ],
                //   ),
                //   title: Row(
                //     mainAxisSize: MainAxisSize.min,
                //     children: [
                //       Flexible(
                //         child: Text(
                //           "${community.displayName}  ",
                //           style: TextStyle(
                //             fontWeight: FontWeight.bold,
                //             color: Provider.of<AmityUIConfiguration>(context)
                //                 .appColors
                //                 .base,
                //             fontSize: 15,
                //           ),
                //           overflow:
                //               TextOverflow.ellipsis, // Handle text overflow
                //         ),
                //       ),
                //       community.isOfficial!
                //           ? Provider.of<AmityUIConfiguration>(context)
                //               .iconConfig
                //               .officialIcon(
                //                 iconSize: 17,
                //                 color:
                //                     Provider.of<AmityUIConfiguration>(context)
                //                         .primaryColor,
                //               )
                //           : const SizedBox(),
                //     ],
                //   ),
                //   subtitle: community.categories!.isEmpty
                //       ? Text(
                //           'ما من تصنيف • ${community.membersCount} ${community.membersCount == 1 ? "عضو" : "أعضاء"}',
                //           //no category //member //members
                //           style: const TextStyle(
                //               fontSize: 13, color: Color(0xff636878)),
                //         )
                //       : Text(
                //           '${community.categories?[0]?.name ?? ""} • ${community.membersCount} ${community.membersCount == 1 ? "عضو" : "أعضاء"}', //member //members
                //           style: const TextStyle(
                //               fontSize: 13, color: Color(0xff636878)),
                //         ),
                // );
              },
            )
          ],
        );
      },
    );
  }
}

class CategorySection extends StatelessWidget {
  final int max;

  const CategorySection({super.key, this.max = 8});

  @override
  Widget build(BuildContext context) {
    return Consumer<ExplorePageVM>(
      builder: (context, vm, _) {
        return Container(
          padding: const EdgeInsetsDirectional.all(16),
          // color: Provider.of<AmityUIConfiguration>(context)
          //     .appColors
          //     .baseBackground,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'الفئات', //Categories
                      style: Provider.of<AmityUIConfiguration>(context)
                          .titleTextStyle
                          .copyWith(
                              color: Provider.of<AmityUIConfiguration>(context)
                                  .appColors
                                  .base),
                    ),
                    IconButton(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => const CategoryListPage()),
                        );
                      },
                      style: IconButton.styleFrom(
                        foregroundColor:
                            Provider.of<AmityUIConfiguration>(context)
                                .appColors
                                .primary,
                      ),
                      icon: const Icon(Icons.chevron_right),
                    ),
                  ],
                ),
              ),
              GridView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  mainAxisExtent: 56,
                  mainAxisSpacing: 8,
                  crossAxisSpacing: 8,
                ),
                padding: EdgeInsets.zero,
                itemCount: vm.amityCategories.length > max
                    ? max
                    : vm.amityCategories.length,
                // Limit to maximum 8 items (2x4 grid)
                itemBuilder: (context, index) {
                  final category = vm.amityCategories[index];
                  return Card(
                    margin: EdgeInsets.zero,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    color: Provider.of<AmityUIConfiguration>(context)
                        .appColors
                        .baseBackground,
                    child: InkWell(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => CommunityListPage(
                                    category: category,
                                  )),
                        );
                      },
                      child: SizedBox(
                        child: Row(
                          children: [
                            Container(
                              height: 40,
                              width: 40,
                              margin: const EdgeInsets.symmetric(
                                  horizontal: 16, vertical: 8),
                              decoration: BoxDecoration(
                                  color:
                                      Provider.of<AmityUIConfiguration>(context)
                                          .appColors
                                          .primaryShade3,
                                  shape: BoxShape.circle),
                              child: category.avatar != null
                                  ? CircleAvatar(
                                      backgroundImage: NetworkImage(
                                          category.avatar!.fileUrl!),
                                    )
                                  : const Icon(
                                      Icons.category,
                                      color: Colors.white,
                                    ),
                            ),
                            Expanded(
                              child: Text(
                                category.name ?? '',
                                overflow: TextOverflow.ellipsis,
                                style: TextStyle(
                                  color:
                                      Provider.of<AmityUIConfiguration>(context)
                                          .appColors
                                          .base,
                                  fontSize: 14,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ),
                            const SizedBox(width: 2),
                          ],
                        ),
                      ),
                    ),
                  );
                },
              ),
              const SizedBox(height: 14),
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 16,
                ),
                decoration: BoxDecoration(
                  color: Provider.of<AmityUIConfiguration>(context)
                      .appColors
                      .primaryShade1,
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    CircleAvatar(
                      radius: 56 / 2,
                      backgroundColor:
                          Provider.of<AmityUIConfiguration>(context)
                              .appColors
                              .baseBackground,
                      child: SvgPicture.asset(
                        "assets/icons/community.svg",
                        color: Provider.of<AmityUIConfiguration>(context)
                            .appColors
                            .primary,
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                              "ألا ترى ما تريد؟ أطلب مجموعة و سنضعها في الاعتبار, و سنخبرك بمجرد إنشائها"),
                          const SizedBox(height: 8),
                          TextButton(
                            style: ButtonStyle(
                                backgroundColor: WidgetStatePropertyAll(
                              Provider.of<AmityUIConfiguration>(context)
                                  .appColors
                                  .primary,
                            )),
                            onPressed: () {
                              showModalBottomSheet(
                                enableDrag: false,
                                isScrollControlled: true,
                                context: context,
                                builder: (context) => CreateGroupButtonSheet(),
                              );
                            },
                            child: Text(
                              "اطلب مجموعة",
                              style: TextStyle(
                                color:
                                    Provider.of<AmityUIConfiguration>(context)
                                        .appColors
                                        .baseBackground,
                              ),
                            ),
                          )
                        ],
                      ),
                    )
                  ],
                ),
              )
            ],
          ),
        );
      },
    );
  }
}

class CategoryListPage extends StatefulWidget {
  const CategoryListPage({super.key});

  @override
  State<CategoryListPage> createState() => _CategoryListPageState();
}

class _CategoryListPageState extends State<CategoryListPage> {
  @override
  void initState() {
    Future.delayed(Duration.zero, () {
      var explorePageVM = Provider.of<ExplorePageVM>(
        context,
        listen: false,
      );

      explorePageVM.queryCommunityCategories(
          sortOption: AmityCommunityCategorySortOption.NAME,
          enablenotifylistener: true);
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor:
          Provider.of<AmityUIConfiguration>(context).appColors.baseBackground,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0.0, // Remove shadow
        title: Text(
          "التصنيفات", //Category
          style: Provider.of<AmityUIConfiguration>(context).titleTextStyle,
        ),
        iconTheme: const IconThemeData(color: Colors.black),
      ),
      body: Consumer<ExplorePageVM>(
        builder: (context, vm, widget) {
          switch (vm.categoryState) {
            case CategoryListState.loading:
              return const Center(child: CircularProgressIndicator());
            case CategoryListState.error:
              return Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Icon(Icons.error, color: Colors.red, size: 48),
                    const SizedBox(height: 16),
                    Text(
                      'Failed to load categories. Please try again.',
                      style: Theme.of(context).textTheme.titleSmall,
                    ),
                    const SizedBox(height: 16),
                    ElevatedButton(
                      onPressed: () {
                        var explorePageVM = Provider.of<ExplorePageVM>(
                          context,
                          listen: false,
                        );
                        explorePageVM.queryCommunityCategories(
                          sortOption: AmityCommunityCategorySortOption.NAME,
                          enablenotifylistener: true,
                        );
                      },
                      child: const Text('Retry'),
                    ),
                  ],
                ),
              );
            default:
              return ListView.builder(
                itemCount: vm.amityCategories.length,
                controller: vm.categoryScrollcontroller,
                physics: const AlwaysScrollableScrollPhysics(),
                itemBuilder: (context, index) {
                  final category = vm.amityCategories[index];
                  return ListTile(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => CommunityListPage(
                                  category: category,
                                )),
                      );
                    },
                    leading: Container(
                      height: 40,
                      width: 40,
                      decoration: BoxDecoration(
                        color: Provider.of<AmityUIConfiguration>(context)
                            .appColors
                            .primaryShade3,
                        shape: BoxShape.circle,
                      ),
                      child: category.avatar != null
                          ? CircleAvatar(
                              backgroundColor:
                                  Provider.of<AmityUIConfiguration>(context)
                                      .appColors
                                      .primaryShade3,
                              backgroundImage:
                                  NetworkImage(category.avatar?.fileUrl ?? ''),
                            )
                          : const Icon(
                              Icons.people,
                              color: Colors.white,
                            ),
                    ),
                    title: Text(category.name ?? ''),
                  );
                },
              );
          }
        },
      ),
    );
  }
}

class CommunityListPage extends StatefulWidget {
  final AmityCommunityCategory category;

  const CommunityListPage({required this.category, Key? key}) : super(key: key);

  @override
  _CommunityListPageState createState() => _CommunityListPageState();
}

class _CommunityListPageState extends State<CommunityListPage> {
  late final ExplorePageVM _viewModel;
  String searchQuery = "";

  @override
  void initState() {
    super.initState();
    Future.delayed(Duration.zero, () {
      _viewModel = Provider.of<ExplorePageVM>(context, listen: false);
      _viewModel.getCommunitiesInCategory(
          categoryId: widget.category.categoryId!, enableNotifyListener: true);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor:
          Provider.of<AmityUIConfiguration>(context).appColors.baseBackground,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0.0, // Remove shadow

        title: Text(
          widget.category.name ?? "مجتمع", //Community
          style: Provider.of<AmityUIConfiguration>(context).titleTextStyle,
        ),
        iconTheme: const IconThemeData(color: Colors.black),
      ),
      body: Consumer<ExplorePageVM>(
        builder: (context, vm, _) {
          final communities = vm.amityCommunities
              .where(
                (element) =>
                    element.displayName?.contains(searchQuery) ?? false,
              )
              .toList();
          return Column(
            children: [
              SearchField(
                onChanged: (query) {
                  setState(() {
                    searchQuery = query;
                  });
                },
              ),
              Expanded(
                child: ListView.builder(
                  padding: EdgeInsetsDirectional.zero,
                  itemCount: communities.length,
                  controller: vm.communityScrollcontroller,
                  itemBuilder: (context, index) {
                    final community = communities[index];

                    return Card(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      margin: EdgeInsets.symmetric(horizontal: 16, vertical: 6),
                      child: InkWell(
                        onTap: () {
                          Navigator.of(context).push(MaterialPageRoute(
                              builder: (context) => ChangeNotifierProvider(
                                    create: (context) => CommuFeedVM(),
                                    child: CommunityScreen(
                                      isFromFeed: true,
                                      community: community,
                                    ),
                                  )));
                        },
                        child: Row(
                          children: [
                            SizedBox(
                              width: 75,
                              height: 75,
                              child: Image.network(
                                community.avatarImage!.fileUrl!,
                                fit: BoxFit.cover,
                              ),
                            ),
                            SizedBox(width: 12),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    community.displayName ?? "",
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                    style: TextStyle(
                                      fontSize: 14,
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                  Text.rich(TextSpan(
                                    children: [
                                      TextSpan(
                                          text:
                                              community.postsCount?.toString()),
                                      TextSpan(text: " منشور - "),
                                      TextSpan(
                                          text: community.membersCount
                                              ?.toString()),
                                      TextSpan(text: " عضو"),
                                    ],
                                    style: TextStyle(
                                      fontSize: 10,
                                    ),
                                  )),
                                ],
                              ),
                            ),
                            TextButton(
                              onPressed: community.isJoined ?? false
                                  ? null
                                  : () {
                                      if (community.isJoined != null) {
                                        if (community.isJoined!) {
                                          AmitySocialClient
                                                  .newCommunityRepository()
                                              .leaveCommunity(
                                                  community.communityId!)
                                              .then((value) {
                                            // setState(() {
                                            community.isJoined =
                                                !(community.isJoined!);
                                            var explorePageVM =
                                                Provider.of<ExplorePageVM>(
                                                    context,
                                                    listen: false);
                                            explorePageVM
                                                .getRecommendedCommunities();
                                            explorePageVM
                                                .getTrendingCommunities();
                                            // });
                                          }).onError((error, stackTrace) {
                                            //handle error
                                            log(error.toString());
                                          });
                                        } else {
                                          AmitySocialClient.newCommunityRepository()
                                              .joinCommunity(
                                                  community.communityId!)
                                              .then((value) {
                                            // setState(() {
                                            community.isJoined =
                                                !(community.isJoined!);
                                            var explorePageVM =
                                                Provider.of<ExplorePageVM>(
                                                    context,
                                                    listen: false);
                                            explorePageVM
                                                .getRecommendedCommunities();
                                            explorePageVM
                                                .getTrendingCommunities();
                                            print(">>>>>>>>>>>>>>>callback");

                                            var myCommunityList =
                                                Provider.of<MyCommunityVM>(
                                                    context,
                                                    listen: false);
                                            myCommunityList.initMyCommunity();

                                            for (var i in myCommunityList
                                                .amityCommunities) {
                                              print(
                                                  ">>>>>>>>>>>>>>>${i.displayName}");
                                            }
                                            print(myCommunityList
                                                .amityCommunities);
                                            // });
                                          }).onError((error, stackTrace) {
                                            log(error.toString());
                                          });
                                        }
                                      }
                                    },
                              child: Text(community.isJoined ?? false
                                  ? "منضم"
                                  : "انضم"),
                            ),
                          ],
                        ),
                      ),
                    );

                    // return ListTile(
                    //   onTap: () {
                    //     Navigator.of(context).push(MaterialPageRoute(
                    //         builder: (context) =>
                    //             CommunityScreen(community: community)));
                    //   },
                    //   leading: Container(
                    //     height: 40,
                    //     width: 40,
                    //     decoration: BoxDecoration(
                    //       color: Provider.of<AmityUIConfiguration>(context)
                    //           .appColors
                    //           .primaryShade3,
                    //       shape: BoxShape.circle,
                    //     ),
                    //     child: community.avatarImage != null
                    //         ? CircleAvatar(
                    //             backgroundImage: NetworkImage(
                    //                 community.avatarImage?.fileUrl ?? ''),
                    //           )
                    //         : const Icon(
                    //             Icons.people,
                    //             color: Colors.white,
                    //           ),
                    //   ),
                    //   title: Text(community.displayName ?? ''),
                    // );
                  },
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}

class GroupsSectionsPage extends StatelessWidget {
  const GroupsSectionsPage({super.key});

  @override
  Widget build(BuildContext context) {
    final myCommunities =
        Provider.of<MyCommunityVM>(context).amityCommunitiesForFeed;
    return ListView(
      children: [
        if (myCommunities.isNotEmpty)
          CommunityIconList(
            amityCommunites: myCommunities,
            canCreateCommunity: false,
          ),
        if (myCommunities.isEmpty) const SizedBox(height: 16),
        const RecommendationSection(),
        const TrendingSection(),
      ],
    );
  }
}
