import 'package:amity_sdk/amity_sdk.dart';
import 'package:amity_uikit_beta_service/components/alert_dialog.dart';
import 'package:amity_uikit_beta_service/view/UIKit/social/community_setting/posts/post_cpmponent.dart';
import 'package:amity_uikit_beta_service/view/UIKit/social/post_target_page.dart';
import 'package:amity_uikit_beta_service/viewmodel/configuration_viewmodel.dart';
import 'package:amity_uikit_beta_service/viewmodel/create_postV2_viewmodel.dart';

// import 'package:amity_uikit_beta_service/viewmodel/create_post_viewmodel.dart';
// import 'package:amity_uikit_beta_service/viewmodel/media_viewmodel.dart';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../viewmodel/community_feed_viewmodel.dart';
import '../../../viewmodel/community_member_viewmodel.dart';
import '../../social/comments.dart';
import '../../social/global_feed.dart';

class AmityCreatePostV2Screen extends StatefulWidget {
  final AmityCommunity? community;

  // final AmityUser? amityUser;
  final bool isFromPostToPage;
  final FeedType? feedType;

  AmityCreatePostV2Screen({
    super.key,
    this.community,
    // this.amityUser,
    this.isFromPostToPage = false,
    this.feedType,
  });

  @override
  State<AmityCreatePostV2Screen> createState() =>
      _AmityCreatePostV2ScreenState();
}

class _AmityCreatePostV2ScreenState extends State<AmityCreatePostV2Screen> {
  AmityCommunity? community;
  final textFocusNode = FocusNode();
  bool loading = false;

  @override
  void initState() {
    community = widget.community;
    Provider.of<CreatePostVMV2>(context, listen: false).inits();

    super.initState();
  }

  @override
  void dispose() {
    textFocusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Consumer<CreatePostVMV2>(builder: (consumerContext, vm, _) {
      return Scaffold(
        backgroundColor:
        Provider
            .of<AmityUIConfiguration>(context)
            .appColors
            .baseBackground,
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          elevation: 0,
          centerTitle: false,
          title: Text(
            "منشور جديد", //My Feed
            style: Provider
                .of<AmityUIConfiguration>(context)
                .titleTextStyle
                .copyWith(
                color: Provider
                    .of<AmityUIConfiguration>(context)
                    .appColors
                    .base),
          ),
          automaticallyImplyLeading: false,
          actions: [
            // TextButton(
            //   onPressed: hasContent
            //       ? () async {
            //           if (vm.isUploadComplete) {
            //             if (widget.community == null) {
            //               //creat post in user Timeline
            //               await vm.createPost(context,
            //                   callback: (isSuccess, error) {
            //                 if (isSuccess) {
            //                   Navigator.of(context).pop();
            //                   if (widget.isFromPostToPage) {
            //                     Navigator.of(context).pop();
            //                   }
            //                 } else {}
            //               });
            //             } else {
            //               //create post in Community
            //               await vm.createPost(context,
            //                   communityId: widget.community?.communityId!,
            //                   callback: (isSuccess, error) async {
            //                 if (isSuccess) {
            //                   var roleVM = Provider.of<MemberManagementVM>(
            //                       context,
            //                       listen: false);
            //                   roleVM.checkCurrentUserRole(
            //                       widget.community!.communityId!);
            //
            //                   if (widget.community!.isPostReviewEnabled!) {
            //                     if (!widget.community!.hasPermission(
            //                         AmityPermission.REVIEW_COMMUNITY_POST)) {
            //                       await AmityDialog().showAlertErrorDialog(
            //                           title: "تم تسجيل المنشور", //Post submitted
            //                           message:
            //                               "لقد تم إرسال منشورك إلى قائمة الانتظار. سيتم مراجعتها بواسطة مشرف المجتمع"); //Your post has been submitted to the pending list. It will be reviewed by community moderator
            //                     }
            //                   }
            //                   Navigator.of(context).pop();
            //                   if (widget.isFromPostToPage) {
            //                     Navigator.of(context).pop();
            //                   }
            //                   if (widget.community!.isPostReviewEnabled!) {
            //                     Provider.of<CommuFeedVM>(context, listen: false)
            //                         .initAmityPendingCommunityFeed(
            //                             widget.community!.communityId!,
            //                             AmityFeedType.REVIEWING);
            //                   }
            //
            //                   // Navigator.of(context).push(MaterialPageRoute(
            //                   //     builder: (context) => ChangeNotifierProvider(
            //                   //           create: (context) => CommuFeedVM(),
            //                   //           child: CommunityScreen(
            //                   //             isFromFeed: true,
            //                   //             community: widget.community!,
            //                   //           ),
            //                   //         )));
            //                 }
            //               });
            //             }
            //           }
            //         }
            //       : null,
            //   child: Text("نشر", //Post
            //       style: TextStyle(
            //           color: vm.isPostValid
            //               ? Provider.of<AmityUIConfiguration>(context)
            //                   .primaryColor
            //               : Colors.grey)),
            // ),
            IconButton(
              icon: Icon(Icons.close,
                  color: Provider
                      .of<AmityUIConfiguration>(context)
                      .appColors
                      .base),
              onPressed: () {
                if (vm.isPostValid) {
                  ConfirmationDialog().show(
                    context: context,
                    title: 'تجاهل المنشور؟',
                    //Discard Post?
                    detailText: 'هل تريد تجاهل منشورك؟',
                    //Do you want to discard your post?
                    leftButtonText: 'إلغاء',
                    //Cancel
                    rightButtonText: 'تجاهل',
                    //Discard
                    onConfirm: () {
                      Navigator.of(context).pop();
                    },
                  );
                } else {
                  Navigator.of(context).pop();
                }
              },
            ),
          ],
        ),
        body: SafeArea(
          child: Column(
            children: [
              Expanded(
                child: GestureDetector(
                  onTap: () {
                    textFocusNode.requestFocus();
                  },
                  child: SingleChildScrollView(
                    keyboardDismissBehavior:
                    ScrollViewKeyboardDismissBehavior.onDrag,
                    child: Padding(
                      padding: const EdgeInsetsDirectional.all(16.0),
                      child: Column(
                        children: [
                          TextField(
                            style: TextStyle(
                                color:
                                Provider
                                    .of<AmityUIConfiguration>(context)
                                    .appColors
                                    .base),
                            focusNode: textFocusNode,
                            onChanged: (value) => vm.updatePostValidity(),
                            controller: vm.textEditingController,
                            scrollPhysics: const NeverScrollableScrollPhysics(),
                            maxLines: null,
                            decoration: InputDecoration(
                              border: InputBorder.none,
                              hintText: "اكتب شيئاً لنشره",
                              //Write something to post
                              hintStyle: TextStyle(
                                  color:
                                  Provider
                                      .of<AmityUIConfiguration>(context)
                                      .appColors
                                      .userProfileTextColor),
                            ),
                            // style: t/1heme.textTheme.bodyText1.copyWith(color: Colors.grey),
                          ),
                          Consumer<CreatePostVMV2>(
                            builder: (context, vm, _) =>
                                PostMedia(files: vm.files),
                          )
                        ],
                      ),
                    ),
                  ),
                ),
              ),
              const Divider(),
              InkWell(
                onTap: () async {
                  final community = await showModalBottomSheet(
                    context: context,
                    isScrollControlled: true,
                    shape: const RoundedRectangleBorder(
                      borderRadius: BorderRadius.vertical(
                        top: Radius.circular(12),
                      ),
                    ),
                    clipBehavior: Clip.hardEdge,
                    builder: (context) =>
                        FractionallySizedBox(
                          heightFactor: 0.8,
                          child: PostToPage(),
                        ),
                  );
                  if (community is AmityCommunity?) {
                    setState(() {
                      this.community = community;
                    });
                  }
                },
                child: Padding(
                  padding:
                  const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8),
                  child: Row(
                    children: [
                      Expanded(
                        child: Text(
                          "النشر إلى: ${community?.displayName ??
                              "صفحتي الشخصية"}",
                          style:
                          Theme
                              .of(context)
                              .textTheme
                              .bodyMedium
                              ?.copyWith(
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      const Icon(Icons.keyboard_arrow_down),
                    ],
                  ),
                ),
              ),
              const Divider(),
              Padding(
                padding: const EdgeInsetsDirectional.symmetric(
                    horizontal: 16, vertical: 8),
                child: Row(
                  children: [
                    _iconButton(
                      Icons.camera_alt_outlined,
                      isEnable:
                      vm.availableFileSelectionOptions()[MyFileType.image]!,
                      label: "كاميرا",
                      //Photo
                      // debugingText:
                      //     "${vm2.isNotSelectVideoYet()}&& ${vm2.isNotSelectedFileYet()}",
                      onTap: () {
                        _handleCameraTap(context);
                      },
                    ),
                    _iconButton(
                      Icons.image_outlined,
                      label: "صورة", //Image
                      isEnable:
                      vm.availableFileSelectionOptions()[MyFileType.image]!,
                      onTap: () async {
                        _handleImageTap(context);
                      },
                    ),
                    _iconButton(
                      Icons.play_circle_outline,
                      label: "فيديو", //Video
                      isEnable:
                      vm.availableFileSelectionOptions()[MyFileType.video]!,
                      onTap: () async {
                        _handleVideoTap(context);
                      },
                    ),
                    _iconButton(
                      Icons.attach_file_outlined,
                      label: "ملف", //File
                      isEnable:
                      vm.availableFileSelectionOptions()[MyFileType.file]!,
                      onTap: () async {
                        _handleFileTap(context);
                      },
                    ),
                    // _iconButton(
                    //   Icons.more_horiz,
                    //   isEnable: true,
                    //   label: "المزيد", //More
                    //   onTap: () {
                    //     // TODO: Implement more options logic
                    //     _showMoreOptions(context);
                    //   },
                    // ),
                    const Spacer(),
                    loading
                        ? const CircularProgressIndicator()
                        : ElevatedButton(
                      onPressed: vm.isPostValid
                          ? () async {
                        setState(() => loading = true);
                        if (vm.isUploadComplete) {
                          if (community == null) {
                            //creat post in user Timeline
                            await vm.createPost(context,
                                callback: (isSuccess, error, post) {
                                  setState(() => loading = false);
                                  if (isSuccess) {
                                    Navigator.of(context).pop(true);
                                    if (widget.isFromPostToPage) {
                                      Navigator.of(context).pop(true);
                                    }
                                  } else {}
                                });
                          } else {
                            //create post in Community
                            await vm.createPost(context,
                                communityId:
                                community?.communityId!,
                                callback:
                                    (isSuccess, error, post) async {
                                  setState(() => loading = false);
                                  if (isSuccess) {
                                    var roleVM =
                                    Provider.of<MemberManagementVM>(
                                        context,
                                        listen: false);
                                    roleVM.checkCurrentUserRole(
                                        community!.communityId!);

                                    if (community!
                                        .isPostReviewEnabled!) {
                                      if (!community!.hasPermission(
                                          AmityPermission
                                              .REVIEW_COMMUNITY_POST)) {
                                        await AmityDialog()
                                            .showAlertErrorDialog(
                                            title:
                                            "تم تسجيل المنشور",
                                            //Post submitted
                                            message:
                                            "لقد تم إرسال منشورك إلى قائمة الانتظار. سيتم مراجعتها بواسطة مشرف المجتمع"); //Your post has been submitted to the pending list. It will be reviewed by community moderator
                                      }
                                    }
                                    Navigator.of(context).pop(true);
                                    if (widget.isFromPostToPage) {
                                      Navigator.of(context).pop(true);
                                    }
                                    if (community!
                                        .isPostReviewEnabled!) {
                                      Provider.of<CommuFeedVM>(context,
                                          listen: false)
                                          .initAmityPendingCommunityFeed(
                                          community!.communityId!,
                                          AmityFeedType.REVIEWING);
                                    }

                                    if (post != null) {
                                      Navigator.of(context).push(
                                          MaterialPageRoute(
                                              builder: (context) =>
                                                  CommentScreen(
                                                    amityPost: post,
                                                    theme: Theme.of(
                                                        context),
                                                    isFromFeed: false,
                                                    feedType: FeedType
                                                        .community,
                                                  )));
                                    }

                                    // Navigator.of(context).push(MaterialPageRoute(
                                    //     builder: (context) => ChangeNotifierProvider(
                                    //           create: (context) => CommuFeedVM(),
                                    //           child: CommunityScreen(
                                    //             isFromFeed: true,
                                    //             community: community!,
                                    //           ),
                                    //         )));
                                  }
                                });
                          }
                        }
                      }
                          : null,
                      style: ElevatedButton.styleFrom(
                        padding:
                        const EdgeInsets.symmetric(horizontal: 40),
                      ),
                      child: const Text("نشر"),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      );
    });
  }

  Widget _iconButton(IconData icon,
      {required String label,
        required VoidCallback onTap,
        required bool isEnable,
        String? debugingText}) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        debugingText == null ? const SizedBox() : Text(debugingText),
        IconButton(
          icon: Icon(
            icon,
            color:
            Provider
                .of<AmityUIConfiguration>(context)
                .appColors
                .baseShade1,
          ),
          onPressed: isEnable ? onTap : null,
        ),
      ],
    );
  }

  void _showMoreOptions(BuildContext context) {
    showModalBottomSheet(
      backgroundColor: Colors.transparent,
      context: context,
      builder: (BuildContext context) {
        return Consumer<CreatePostVMV2>(builder: (consumerContext, vm, _) {
          return Container(
            decoration: const BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(15.0),
                topRight: Radius.circular(15.0),
              ),
            ),
            child: SafeArea(
              child: Padding(
                padding: const EdgeInsetsDirectional.only(top: 16.0),
                // Space at the top
                child: Wrap(
                  children: <Widget>[
                    ListTile(
                      leading: _iconButton(Icons.camera_alt_outlined,
                          isEnable: vm.availableFileSelectionOptions()[
                          MyFileType.image]!,
                          label: "كاميرا", //Camera
                          onTap: () {}),
                      title: Text(
                        'كاميرا', //Camera
                        style: TextStyle(
                            color: vm.availableFileSelectionOptions()[
                            MyFileType.image]!
                                ? Colors.black
                                : Colors.grey),
                      ),
                      onTap: () {
                        if (vm.availableFileSelectionOptions()[
                        MyFileType.image]!) {
                          _handleImageTap(context);
                          Navigator.pop(context);
                        }
                      },
                    ),
                    ListTile(
                      leading: _iconButton(Icons.image_outlined,
                          isEnable: vm.availableFileSelectionOptions()[
                          MyFileType.image]!,
                          label: "صورة", //Photo
                          onTap: () {}),
                      title: Text(
                        'صورة', //Photo
                        style: TextStyle(
                            color: vm.availableFileSelectionOptions()[
                            MyFileType.image]!
                                ? Colors.black
                                : Colors.grey),
                      ),
                      onTap: () {
                        if (vm.availableFileSelectionOptions()[
                        MyFileType.image]!) {
                          _handleImageTap(context);
                          Navigator.pop(context);
                        }
                      },
                    ),
                    ListTile(
                      leading: _iconButton(Icons.attach_file_rounded,
                          isEnable: vm.availableFileSelectionOptions()[
                          MyFileType.file]!,
                          label: "ملحق", //Attachment
                          onTap: () {}),
                      title: Text(
                        'ملحق', //Attachment
                        style: TextStyle(
                            color: vm.availableFileSelectionOptions()[
                            MyFileType.file]!
                                ? Colors.black
                                : Colors.grey),
                      ),
                      onTap: () {
                        if (vm.availableFileSelectionOptions()[
                        MyFileType.file]!) {
                          _handleFileTap(context);
                          Navigator.pop(context);
                        }
                      },
                    ),
                    ListTile(
                      leading: _iconButton(
                        Icons.play_circle_outline_outlined,
                        isEnable: vm
                            .availableFileSelectionOptions()[MyFileType.video]!,
                        label: "فيديو", //Video
                        onTap: () {},
                      ),
                      title: Text(
                        'فيديو', //Video
                        style: TextStyle(
                            color: vm.availableFileSelectionOptions()[
                            MyFileType.video]!
                                ? Colors.black
                                : Colors.grey),
                      ),
                      onTap: () {
                        if (vm.availableFileSelectionOptions()[
                        MyFileType.video]!) {
                          _handleVideoTap(context);
                          Navigator.pop(context);
                        }
                      },
                    ),
                  ],
                ),
              ),
            ),
          );
        });
      },
    );
  }

  void _showDiscardDialog() {
    showDialog(
      context: context,
      builder: (context) =>
          AlertDialog(
            title: const Text('تجاهل المنشور؟'),
            //Discard Post?
            content: const Text('هل تود تجاهل منشورك؟'),
            //Do you want to discard your post?
            actions: [
              TextButton(
                onPressed: () => Navigator.of(context).pop(false),
                child: const Text('إلغاء'), //Cancel
              ),
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop(true);
                  Navigator.of(context).pop();
                },
                child: const Text('تجاهل'), //Discard
              ),
            ],
          ),
    );
  }

  Future<void> _handleCameraTap(BuildContext context) async {
    await _pickMedia(context, PickerAction.cameraImage);
  }

  Future<void> _handleImageTap(BuildContext context) async {
    await _pickMedia(context, PickerAction.galleryImage);
  }

  Future<void> _handleVideoTap(BuildContext context) async {
    await _pickMedia(context, PickerAction.galleryVideo);
  }

  Future<void> _handleFileTap(BuildContext context) async {
    await _pickMedia(context, PickerAction.filePicker);
  }

  Future<void> _pickMedia(BuildContext context, PickerAction action) async {
    var createPostVM = Provider.of<CreatePostVMV2>(context, listen: false);
    await createPostVM.pickFile(action);
  }
}
