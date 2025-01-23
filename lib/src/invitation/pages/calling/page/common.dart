// Dart imports:

// Flutter imports:
import 'package:celestial/imports_bindings.dart';
import 'package:flutter/material.dart';

// Package imports:
import 'package:zego_uikit/zego_uikit.dart';

// Project imports:
import 'package:zego_uikit_prebuilt_call/src/invitation/internal/internal.dart';

Widget backgroundImage() {
  return Container(
    width: double.infinity,
    height: double.infinity,
    decoration: BoxDecoration(
      image: DecorationImage(
        image: ZegoCallImage.asset(InvitationStyleIconUrls.inviteBackground).image,
        fit: BoxFit.fitHeight,
      ),
    ),
  );
}

Widget centralName(String name) {
  return Text(
    name,
    style: AppStyles.text20Px.w600.kcolor(AppColors.primaryColor),
  );
}

Widget callingText(String text) {
  return Container(
    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
    decoration: BoxDecoration(
      color: AppColors.light,
      borderRadius: BorderRadius.circular(44),
    ),
    child: Text(
      'Calling...',
      style: AppStyles.text12Px.w400.kcolor(AppColors.primaryColor),
    ),
  );
}

Widget circleAvatar(String name) {
  return Container(
    decoration: const BoxDecoration(
      color: Color(0xffDBDDE3),
      shape: BoxShape.circle,
    ),
    child: Center(
      child: Text(
        name.isNotEmpty ? name.characters.first : '',
        style: TextStyle(
          fontSize: 96.0.zR,
          color: const Color(0xff222222),
          decoration: TextDecoration.none,
        ),
      ),
    ),
  );
}
