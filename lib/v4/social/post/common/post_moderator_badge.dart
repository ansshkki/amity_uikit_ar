import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

class CommunityModeratorBadge extends StatelessWidget {
  const CommunityModeratorBadge({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 18,
      padding: const EdgeInsetsDirectional.only(start: 4, end: 6),
      clipBehavior: Clip.antiAlias,
      decoration: ShapeDecoration(
        color: const Color(0xFFD9E5FC),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
        ),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Container(
            width: 12,
            height: 12,
            padding: const EdgeInsets.symmetric(vertical: 1.50),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                SizedBox(
                  width: 12,
                  height: 9,
                  child: SvgPicture.asset(
                    'assets/Icons/amity_ic_community_moderator.svg',
                    package: 'amity_uikit_beta_service',
                    width: 16,
                    height: 12,
                  ),
                ),
              ],
            ),
          ),
          Text(
            "community.moderator".tr(),
            textAlign: TextAlign.center,
            style: const TextStyle(
              color: Color(0xFF1054DE),
              fontSize: 10,
              fontWeight: FontWeight.w400,
            ),
          ),
        ],
      ),
    );
  }
}
