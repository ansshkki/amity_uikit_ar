import 'package:amity_sdk/amity_sdk.dart';
import 'package:amity_uikit_beta_service/v4/utils/skeleton.dart';
import 'package:amity_uikit_beta_service/viewmodel/configuration_viewmodel.dart';
import 'package:amity_uikit_beta_service/viewmodel/my_community_viewmodel.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../v4/utils/Shimmer.dart';

class PostToPage extends StatefulWidget {
  const PostToPage({super.key});

  @override
  State<PostToPage> createState() => _PostToPageState();
}

class _PostToPageState extends State<PostToPage> {
  @override
  void initState() {
    Future.delayed(Duration.zero, () {
      Provider.of<MyCommunityVM>(context, listen: false).initMyCommunity();
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor:
          Provider.of<AmityUIConfiguration>(context).appColors.baseBackground,
      appBar: AppBar(
        scrolledUnderElevation: 0,
        elevation: 0.0, // Add this line to remove the shadow
        leading: IconButton(
          icon: Icon(
            Icons.close,
            color: Provider.of<AmityUIConfiguration>(context).appColors.base,
          ),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(
          "النشر إلى", //Post to
          style: Provider.of<AmityUIConfiguration>(context)
              .titleTextStyle
              .copyWith(
                  color: Provider.of<AmityUIConfiguration>(context)
                      .appColors
                      .base),
        ),
        backgroundColor: Colors.transparent,
        iconTheme: const IconThemeData(color: Colors.black),
      ),
      body: Consumer<MyCommunityVM>(
        builder: (context, viewModel, child) {
          return SingleChildScrollView(
            controller: viewModel.scrollcontroller,
            child: ListView(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              children: [
                // ListTile(
                //   leading: (AmityCoreClient.getCurrentUser().avatarUrl != null)
                //       ? CircleAvatar(
                //           backgroundColor: Colors.transparent,
                //           backgroundImage: NetworkImage(
                //               AmityCoreClient.getCurrentUser().avatarUrl!),
                //         )
                //       : Container(
                //           height: 40,
                //           width: 40,
                //           decoration: BoxDecoration(
                //               color: Provider.of<AmityUIConfiguration>(context)
                //                   .appColors
                //                   .primaryShade3,
                //               shape: BoxShape.circle),
                //           child: Icon(
                //             Icons.person,
                //             color: Provider.of<AmityUIConfiguration>(context)
                //                 .appColors
                //                 .userProfileTextColor,
                //           ),
                //         ),
                //   title: Text(
                //     "صفحتي الشخصية", //My Timeline
                //     style: TextStyle(
                //         fontSize: 15,
                //         fontWeight: FontWeight.w600,
                //         color: Provider.of<AmityUIConfiguration>(context)
                //             .appColors
                //             .base),
                //     // Adjust as needed),
                //   ),
                //   onTap: () {
                //     // Navigate or perform action based on 'Newsfeed' tap
                //     // Navigator.of(context).push(MaterialPageRoute(
                //     //   builder: (context) => const AmityCreatePostV2Screen(
                //     //     isFromPostToPage: true,
                //     //   ),
                //     // ));
                //     Navigator.pop(context);
                //   },
                // ),
                Padding(
                  padding: const EdgeInsetsDirectional.all(16.0),
                  child: Text(
                    "مجتمعاتي", //My community
                    style: TextStyle(
                        fontSize: 15,
                        color: Provider.of<AmityUIConfiguration>(context)
                            .appColors
                            .userProfileTextColor),
                  ),
                ),
                if (viewModel.amityCommunities.isEmpty) ...[
                  for (int i = 0; i < 10; i++) buildLoader(context),
                ],
                // if (viewModel.isEmpty)
                //   const SizedBox(
                //     height: 300,
                //     width: double.infinity,
                //     child: Center(
                //       child: Text("لست منضماً إلى أي مجتمع"),
                //     ),
                //   ),
                ...viewModel.amityCommunities.map((community) {
                  return StreamBuilder<AmityCommunity>(
                      stream: community.listen.stream,
                      builder: (context, snapshot) {
                        var communityStream = snapshot.data ?? community;
                        return ListTile(
                          leading: (communityStream.avatarFileId != null)
                              ? CircleAvatar(
                                  backgroundColor: Colors.transparent,
                                  backgroundImage: NetworkImage(
                                      communityStream.avatarImage!.fileUrl!),
                                )
                              : Container(
                                  height: 40,
                                  width: 40,
                                  decoration: BoxDecoration(
                                      color: Provider.of<AmityUIConfiguration>(
                                              context)
                                          .appColors
                                          .primaryShade3,
                                      shape: BoxShape.circle),
                                  child: const Icon(
                                    Icons.group,
                                    color: Colors.white,
                                  ),
                                ),
                          title: Row(
                            children: [
                              !community.isPublic!
                                  ? Padding(
                                      padding: const EdgeInsetsDirectional.only(start: 7.0),
                                      child: Icon(
                                        Icons.lock,
                                        color:
                                            Provider.of<AmityUIConfiguration>(
                                                    context)
                                                .appColors
                                                .base,
                                        size: 17,
                                      ))
                                  : const SizedBox(),
                              const SizedBox(
                                width: 5,
                              ),
                              Text(
                                community.displayName ?? '',
                                style: TextStyle(
                                    fontSize: 15,
                                    fontWeight: FontWeight.w600,
                                    color: Provider.of<AmityUIConfiguration>(
                                            context)
                                        .appColors
                                        .base),
                              ),
                              community.isOfficial!
                                  ? Padding(
                                      padding: const EdgeInsetsDirectional.only(start: 7.0),
                                      child: Provider.of<AmityUIConfiguration>(
                                              context)
                                          .iconConfig
                                          .officialIcon(
                                              iconSize: 17,
                                              color: Provider.of<
                                                          AmityUIConfiguration>(
                                                      context)
                                                  .primaryColor),
                                    )
                                  : const SizedBox(),
                            ],
                          ),
                          onTap: () {
                            // Navigate or perform action based on 'Newsfeed' tap
                            // Navigator.of(context).push(MaterialPageRoute(
                            //   builder: (context) => AmityCreatePostV2Screen(
                            //     community: community,
                            //     isFromPostToPage: true,
                            //     feedType: FeedType.community,
                            //   ),
                            // ));
                            Navigator.pop(context, community);
                          },
                        );
                      });
                }).toList(),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget buildLoader(BuildContext context) {
    return Shimmer(
      linearGradient: LinearGradient(
        colors: [
          Color(0xFFEBEBF4),
          Color(0xFFF4F4F4),
          Color(0xFFEBEBF4),
        ],
        stops: [
          0.1,
          0.3,
          0.4,
        ],
        begin: Alignment(-1.0, -0.3),
        end: Alignment(1.0, 0.3),
        tileMode: TileMode.clamp,
      ),
      child: ShimmerLoading(
        isLoading: true,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 19),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Container(
                    width: 48,
                    height: 60,
                    padding: const EdgeInsetsDirectional.only(
                        top: 12, start: 0, end: 8, bottom: 8),
                    child: const SkeletonImage(
                      height: 40,
                      width: 40,
                      borderRadius: 40,
                    ),
                  ),
                  const Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        SizedBox(height: 6.0),
                        SkeletonText(width: 120),
                        SizedBox(height: 12.0),
                        SkeletonText(width: 88),
                      ]),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
