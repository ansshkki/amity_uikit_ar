import 'package:amity_sdk/amity_sdk.dart';
import 'package:amity_uikit_beta_service/viewmodel/configuration_viewmodel.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

enum ReactPostNotificationSetting { everyone, onlyModerator, off }

enum NewPostNotificationSetting { everyone, onlyModerator, off }

class PostNotificationSettingPage extends StatefulWidget {
  final AmityCommunity community;

  const PostNotificationSettingPage({Key? key, required this.community})
      : super(key: key);

  @override
  _PostNotificationSettingPageState createState() =>
      _PostNotificationSettingPageState();
}

class _PostNotificationSettingPageState
    extends State<PostNotificationSettingPage> {
  ReactPostNotificationSetting _reactPostSetting =
      ReactPostNotificationSetting.everyone;
  NewPostNotificationSetting _newPostSetting =
      NewPostNotificationSetting.everyone;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor:
          Provider.of<AmityUIConfiguration>(context).appColors.baseBackground,
      appBar: AppBar(
        leading: IconButton(
          onPressed: () => Navigator.of(context).pop(),
          icon: Icon(Icons.chevron_left,
              color: Provider.of<AmityUIConfiguration>(context).appColors.base,
              size: 30),
        ),
        title: Text(
          'المنشورات', //Posts
          style: TextStyle(
            color: Provider.of<AmityUIConfiguration>(context).appColors.base,
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
        backgroundColor: Colors.transparent,
        elevation: 0,
        iconTheme: const IconThemeData(color: Colors.black),
      ),
      body: ListView(
        children: [
          // Section 1: React Posts

          Padding(
            padding: const EdgeInsetsDirectional.all(16.0),
            child: Text(
              "التفاعل مع المنشورات", //React Posts
              style: TextStyle(
                fontWeight: FontWeight.w600,
                fontSize: 16,
                color:
                    Provider.of<AmityUIConfiguration>(context).appColors.base,
              ),
            ),
          ),

          const Padding(
            padding: EdgeInsetsDirectional.only(start: 16.0, bottom: 16, end: 16),
            child: Text(
              "تلقي الاشعارات عند تعليق احدهم على منشوراتك في هذا المجتمع", //Receive notifications when someone make a reaction to your posts in this community
              style: TextStyle(
                fontSize: 14,
                color: Color(0xff636878),
              ),
            ),
          ),

          _buildRadioTile<ReactPostNotificationSetting>(
            title: 'أي شخص', //Everyone
            value: ReactPostNotificationSetting.everyone,
            groupValue: _reactPostSetting,
            onChanged: (value) {
              setState(() {
                _reactPostSetting = value!;
              });
            },
          ),
          _buildRadioTile<ReactPostNotificationSetting>(
            title: 'المشرفين فقط', //Only Moderator
            value: ReactPostNotificationSetting.onlyModerator,
            groupValue: _reactPostSetting,
            onChanged: (value) {
              setState(() {
                _reactPostSetting = value!;
              });
            },
          ),
          _buildRadioTile<ReactPostNotificationSetting>(
            title: 'مغلق', //Off
            value: ReactPostNotificationSetting.off,
            groupValue: _reactPostSetting,
            onChanged: (value) {
              setState(() {
                _reactPostSetting = value!;
              });
            },
          ),
          const Padding(
            padding: EdgeInsetsDirectional.only(start: 16, end: 16),
            child: Divider(
              thickness: 1,
            ),
          ),

          // Section 2: New Posts
          const Padding(
            padding: EdgeInsetsDirectional.all(16.0),
            child: Text(
              "التفاعل مع المنشورات", //React Posts
              style: TextStyle(
                fontWeight: FontWeight.w600,
                fontSize: 16,
                color: Color(0xff292B32),
              ),
            ),
          ),
          const Padding(
            padding: EdgeInsetsDirectional.only(start: 16.0, bottom: 16, end: 16),
            child: Text(
              "تلقي الاشعارات عند تعليق احدهم على منشوراتك في هذا المجتمع", //Receive notifications when someone make a reaction to your posts in this community
              style: TextStyle(
                fontSize: 14,
                color: Color(0xff636878),
              ),
            ),
          ),
          _buildRadioTile<NewPostNotificationSetting>(
            title: 'أي شخص', //Everyone
            value: NewPostNotificationSetting.everyone,
            groupValue: _newPostSetting,
            onChanged: (value) {
              setState(() {
                _newPostSetting = value!;
              });
            },
          ),
          _buildRadioTile<NewPostNotificationSetting>(
            title:  'المشرفين فقط', //Only Moderator
            value: NewPostNotificationSetting.onlyModerator,
            groupValue: _newPostSetting,
            onChanged: (value) {
              setState(() {
                _newPostSetting = value!;
              });
            },
          ),
          _buildRadioTile<NewPostNotificationSetting>(
            title: 'مغلق', //Off
            value: NewPostNotificationSetting.off,
            groupValue: _newPostSetting,
            onChanged: (value) {
              setState(() {
                _newPostSetting = value!;
              });
            },
          ),
          const Divider(),
        ],
      ),
    );
  }

  Widget _buildSectionHeader(String text) {
    return Padding(
      padding: const EdgeInsetsDirectional.all(16.0),
      child: Text(
        text,
        style: const TextStyle(
          fontWeight: FontWeight.w600,
          fontSize: 16,
          color: Color(0xff292B32),
        ),
      ),
    );
  }

  Widget _buildRadioTile<T>(
      {required String title,
      required T value,
      required T groupValue,
      required void Function(T?) onChanged}) {
    return ListTile(
      title: Text(
        title,
        style: TextStyle(
          fontSize: 14,
          color: Provider.of<AmityUIConfiguration>(context).appColors.base,
        ),
      ),
      trailing: Radio<T>(
        focusColor: Provider.of<AmityUIConfiguration>(context).primaryColor,
        activeColor: Provider.of<AmityUIConfiguration>(context).primaryColor,
        value: value,
        groupValue: groupValue,
        onChanged: onChanged,
      ),
    );
  }
}
