import 'package:amity_sdk/amity_sdk.dart';
import 'package:amity_uikit_beta_service/viewmodel/chat_room_viewmodel.dart';
import 'package:amity_uikit_beta_service/viewmodel/configuration_viewmodel.dart';
import 'package:animation_wrappers/animations/faded_slide_animation.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';

class ChatRoomPage extends StatefulWidget {
  final String channelId;

  const ChatRoomPage({
    super.key,
    required this.channelId,
  });

  @override
  State<ChatRoomPage> createState() => _ChatRoomPageState();
}

class _ChatRoomPageState extends State<ChatRoomPage> {
  @override
  void initState() {
    Provider.of<ChatRoomVM>(context, listen: false)
        .initSingleChannel(widget.channelId);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final myAppBar = AppBar(
      automaticallyImplyLeading: false,
      elevation: 0,
      backgroundColor: Provider.of<AmityUIConfiguration>(context)
          .messageRoomConfig
          .backgroundColor,
      leadingWidth: 0,
      title: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          GestureDetector(
              onTap: () {
                Navigator.of(context).pop();
              },
              child: Icon(Icons.chevron_left,
                  color:
                      Provider.of<AmityUIConfiguration>(context).primaryColor,
                  size: 30)),
          Container(
            height: 45,
            margin: const EdgeInsetsDirectional.symmetric(vertical: 4),
            decoration: const BoxDecoration(shape: BoxShape.circle),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Text(
              Provider.of<ChatRoomVM>(context).channel == null
                  ? ""
                  : Provider.of<ChatRoomVM>(context).channel!.displayName!,
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ],
      ),
    );

    final mediaQuery = MediaQuery.of(context);
    final bHeight = mediaQuery.size.height -
        mediaQuery.padding.top -
        myAppBar.preferredSize.height;
    const textFieldHeight = 60.0;
    final theme = Theme.of(context);
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: myAppBar,
      body: SafeArea(
        child: Stack(
          children: [
            FadedSlideAnimation(
              beginOffset: const Offset(0, 0.3),
              endOffset: const Offset(0, 0),
              slideCurve: Curves.linearToEaseOut,
              child: Provider.of<ChatRoomVM>(context).channel == null
                  ? const SizedBox()
                  : SingleChildScrollView(
                      reverse: true,
                      controller:
                          Provider.of<ChatRoomVM>(context).scrollController,
                      child: MessageComponent(
                        bheight: bHeight - textFieldHeight,
                        theme: theme,
                        mediaQuery: mediaQuery,
                        channelId: Provider.of<ChatRoomVM>(context)
                            .channel!
                            .channelId!,
                        channel: Provider.of<ChatRoomVM>(context).channel!,
                      ),
                    ),
            ),
            Column(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                ChatTextFieldComponent(
                    theme: theme,
                    textFieldHeight: textFieldHeight,
                    mediaQuery: mediaQuery),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class ChatTextFieldComponent extends StatelessWidget {
  const ChatTextFieldComponent({
    super.key,
    required this.theme,
    required this.textFieldHeight,
    required this.mediaQuery,
  });

  final ThemeData theme;
  final double textFieldHeight;
  final MediaQueryData mediaQuery;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
          color: theme.canvasColor,
          border: Border(top: BorderSide(color: theme.highlightColor))),
      height: textFieldHeight,
      width: mediaQuery.size.width,
      padding: const EdgeInsetsDirectional.fromSTEB(10, 0, 10, 0),
      child: Row(
        children: [
          // SizedBox(
          //   width: 5,
          // ),
          // Icon(
          //   Icons.emoji_emotions_outlined,
          //   color: theme.primaryIconTheme.color,
          //   size: 22,
          // ),
          const SizedBox(width: 10),
          SizedBox(
            width: mediaQuery.size.width * 0.7,
            child: TextField(
              controller: Provider.of<ChatRoomVM>(context, listen: false)
                  .textEditingController,
              decoration: InputDecoration(
                hintText: "messages.write".tr(), //Write your message
                hintStyle: const TextStyle(fontSize: 14),
                border: InputBorder.none,
              ),
            ),
          ),
          const Spacer(),
          GestureDetector(
            onTap: () {
              HapticFeedback.heavyImpact();
              Provider.of<ChatRoomVM>(context, listen: false).sendMessage();
            },
            child: Icon(
              Icons.send,
              color: Provider.of<AmityUIConfiguration>(context).primaryColor,
              size: 22,
            ),
          ),
          const SizedBox(
            width: 5,
          ),
        ],
      ),
    );
  }
}

class MessageComponent extends StatelessWidget {
  const MessageComponent({
    super.key,
    required this.theme,
    required this.mediaQuery,
    required this.channelId,
    required this.bheight,
    required this.channel,
  });

  final String channelId;
  final AmityChannel channel;

  final ThemeData theme;

  final MediaQueryData mediaQuery;

  final double bheight;

  String getTimeStamp(AmityMessage msg) {
    if (msg.editedAt == null) {
      return '';
    }
    String hour = msg.editedAt!.hour.toString();
    String minute = "";
    if (msg.editedAt!.minute > 9) {
      minute = msg.editedAt!.minute.toString();
    } else {
      minute = "0${msg.editedAt!.minute}";
    }
    return "$hour:$minute";
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<ChatRoomVM>(
      builder: (context, vm, _) {
        return Container(
          padding: const EdgeInsetsDirectional.fromSTEB(10, 10, 10, 0),
          child: ListView.builder(
            physics: const NeverScrollableScrollPhysics(),
            shrinkWrap: true,
            itemCount: vm.amityMessage.length,
            itemBuilder: (context, index) {
              var data = vm.amityMessage[index].data;

              bool isSendbyCurrentUser = vm.amityMessage[index].userId !=
                  AmityCoreClient.getCurrentUser().userId;
              return Column(
                crossAxisAlignment: isSendbyCurrentUser
                    ? CrossAxisAlignment.start
                    : CrossAxisAlignment.end,
                children: [
                  Row(
                    mainAxisAlignment: isSendbyCurrentUser
                        ? MainAxisAlignment.start
                        : MainAxisAlignment.end,
                    children: [
                      if (!isSendbyCurrentUser)
                        Text(
                          getTimeStamp(vm.amityMessage[index]),
                          style:
                              const TextStyle(color: Colors.grey, fontSize: 8),
                        ),
                      vm.amityMessage[index].type != AmityMessageDataType.TEXT
                          ? Container(
                              margin: const EdgeInsetsDirectional.fromSTEB(
                                  10, 4, 10, 4),
                              padding: const EdgeInsetsDirectional.fromSTEB(
                                  10, 5, 10, 5),
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(10),
                                  color: Colors.red),
                              child: Text(
                                "messages.upSupport".tr(),
                                style: const TextStyle(color: Colors.white),
                              ),
                            )
                          : Flexible(
                              child: Container(
                                constraints: BoxConstraints(
                                    maxWidth: mediaQuery.size.width * 0.7),
                                margin: const EdgeInsetsDirectional.fromSTEB(
                                    10, 4, 10, 4),
                                padding: const EdgeInsetsDirectional.fromSTEB(
                                    10, 5, 10, 5),
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(10),
                                  color: isSendbyCurrentUser
                                      ? const Color(0xfff1f1f1)
                                      : Provider.of<AmityUIConfiguration>(
                                              context)
                                          .primaryColor,
                                ),
                                child: Text(
                                  (vm.amityMessage[index].data!
                                              as MessageTextData)
                                          .text ??
                                      "",
                                  style: theme.textTheme.bodyLarge!.copyWith(
                                      fontSize: 14.7,
                                      color: isSendbyCurrentUser
                                          ? Colors.black
                                          : Colors.white),
                                ),
                              ),
                            ),
                      if (isSendbyCurrentUser)
                        Text(
                          getTimeStamp(vm.amityMessage[index]),
                          style:
                              TextStyle(color: Colors.grey[500], fontSize: 8),
                        ),
                    ],
                  ),
                  if (index + 1 == vm.amityMessage.length)
                    const SizedBox(
                      height: 90,
                    )
                ],
              );
            },
          ),
        );
      },
    );
  }
}
