import 'package:amity_sdk/amity_sdk.dart';
import 'package:amity_uikit_beta_service/view/social/global_feed.dart';
import 'package:amity_uikit_beta_service/viewmodel/configuration_viewmodel.dart';
import 'package:amity_uikit_beta_service/viewmodel/post_viewmodel.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';

class ReactionWidget extends StatelessWidget {
  final AmityPost post;
  final FeedType feedType;
  final double feedReactionCountSize;

  const ReactionWidget({
    super.key,
    required this.post,
    required this.feedType,
    required this.feedReactionCountSize,
  });

  @override
  Widget build(BuildContext context) {
    var buttonStyle = ButtonStyle(
      padding: WidgetStateProperty.all<EdgeInsets>(
          const EdgeInsets.only(top: 6, bottom: 6, left: 6, right: 6)),
      minimumSize: WidgetStateProperty.all<Size>(Size.zero),
      tapTargetSize: MaterialTapTargetSize.shrinkWrap,
    );
    return GestureDetector(
      onTap: () {
        if (post.myReactions!.contains("like")) {
          print(post.myReactions);
          HapticFeedback.heavyImpact();
          Provider.of<PostVM>(context, listen: false).removePostReaction(post);
        } else {
          print(post.myReactions);
          HapticFeedback.heavyImpact();
          Provider.of<PostVM>(context, listen: false).addPostReaction(post);
        }
      },
      child: Container(
        padding: const EdgeInsetsDirectional.only(bottom: 6, top: 4, end: 8),
        color: Colors.transparent,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                post.myReactions!.contains("like")
                    ? TextButton(
                        onPressed: () {
                          print(post.myReactions);
                          HapticFeedback.heavyImpact();
                          Provider.of<PostVM>(context, listen: false)
                              .removePostReaction(post);
                        },
                        style: buttonStyle,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Provider.of<AmityUIConfiguration>(context)
                                .iconConfig
                                .likedIcon(
                                  color:
                                      Provider.of<AmityUIConfiguration>(context)
                                          .primaryColor,
                                ),
                            const SizedBox(width: 4),
                            Text(
                              "post.useful".tr(),
                              style: TextStyle(
                                color:
                                    Provider.of<AmityUIConfiguration>(context)
                                        .primaryColor,
                                fontSize: feedReactionCountSize,
                              ),
                            ),
                          ],
                        ),
                      )
                    : TextButton(
                        onPressed: () {
                          print(post.myReactions);
                          HapticFeedback.heavyImpact();
                          Provider.of<PostVM>(context, listen: false)
                              .addPostReaction(post);
                        },
                        style: buttonStyle,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Provider.of<AmityUIConfiguration>(context)
                                .iconConfig
                                .likeIcon(
                                  color: feedType == FeedType.user
                                      ? Provider.of<AmityUIConfiguration>(
                                              context)
                                          .appColors
                                          .userProfileTextColor
                                      : Colors.grey,
                                ),
                            const SizedBox(width: 4),
                            Text(
                              "post.useful".tr(),
                              style: TextStyle(
                                color: feedType == FeedType.user
                                    ? Provider.of<AmityUIConfiguration>(context)
                                        .appColors
                                        .userProfileTextColor
                                    : Colors.grey,
                                fontSize: feedReactionCountSize,
                              ),
                            ),
                          ],
                        ),
                      ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
