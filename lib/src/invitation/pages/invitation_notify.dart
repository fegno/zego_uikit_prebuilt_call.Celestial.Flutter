// Flutter imports:
import 'package:celestial/imports_bindings.dart';
import 'package:flutter/material.dart';

// Package imports:
import 'package:zego_uikit/zego_uikit.dart';

// Project imports:
import 'package:zego_uikit_prebuilt_call/src/invitation/config.defines.dart';
import 'package:zego_uikit_prebuilt_call/src/invitation/defines.dart';
import 'package:zego_uikit_prebuilt_call/src/invitation/inner_text.dart';
import 'package:zego_uikit_prebuilt_call/src/invitation/internal/internal.dart';
import 'package:zego_uikit_prebuilt_call/src/invitation/internal/protocols.dart';
import 'package:zego_uikit_prebuilt_call/src/invitation/pages/page_manager.dart';

// Project imports:

/// @nodoc
/// top sheet, popup when invitee receive a invitation
class ZegoCallInvitationNotifyDialog extends StatefulWidget {
  const ZegoCallInvitationNotifyDialog({
    Key? key,
    required this.pageManager,
    required this.callInvitationConfig,
    required this.invitationData,
    required this.declineButtonConfig,
    required this.acceptButtonConfig,
    this.config,
    this.avatarBuilder,
  }) : super(key: key);

  final ZegoCallInvitationPageManager pageManager;
  final ZegoUIKitPrebuiltCallInvitationData callInvitationConfig;
  final ZegoCallInvitationData invitationData;

  final ZegoCallInvitationNotifyPopUpUIConfig? config;
  final ZegoCallButtonUIConfig declineButtonConfig;
  final ZegoCallButtonUIConfig acceptButtonConfig;
  final ZegoAvatarBuilder? avatarBuilder;

  @override
  State<ZegoCallInvitationNotifyDialog> createState() => _ZegoCallInvitationNotifyDialogState();
}

class _ZegoCallInvitationNotifyDialogState extends State<ZegoCallInvitationNotifyDialog> {
  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 24.zW, vertical: 24.zH),
        width: widget.config?.width ?? 718.zW,
        // height: widget.config?.height ?? 160.zH,
        decoration: widget.config?.decoration ??
            BoxDecoration(
              color: AppColors.light,
              borderRadius: BorderRadius.circular(16.0),
            ),
        child: widget.config?.builder?.call(
              widget.invitationData,
            ) ??
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                ValueListenableBuilder(
                  valueListenable: ZegoUIKitUserPropertiesNotifier(
                    widget.invitationData.inviter ?? ZegoUIKitUser.empty(),
                  ),
                  builder: (context, _, __) {
                    return Container(
                      width: 84.zR,
                      height: 84.zR,
                      decoration: const BoxDecoration(color: Color(0xffDBDDE3), shape: BoxShape.circle),
                      child: widget.avatarBuilder?.call(
                            context,
                            Size(84.zR, 84.zR),
                            widget.invitationData.inviter,
                            {},
                          ) ??
                          circleName(widget.invitationData.inviter?.name ?? ''),
                    );
                  },
                ),
                SizedBox(width: 26.zW),
                Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    userName(),
                    SizedBox(height: 7.zH),
                    subtitle(),
                  ],
                ),
                const Expanded(child: SizedBox()),
                ...widget.declineButtonConfig.visible
                    ? [
                        declineButton(),
                        SizedBox(width: 40.zW),
                      ]
                    : [],
                ...widget.acceptButtonConfig.visible ? [acceptButton()] : [],
              ],
            ),
      ),
    );
  }

  Widget circleName(String name) {
    return Center(
      child: Text(
        name.isNotEmpty ? name.characters.first : '',
        style: TextStyle(
          fontSize: 60.0.zR,
          color: const Color(0xff222222),
          decoration: TextDecoration.none,
        ),
      ),
    );
  }

  Widget userName() {
    return SizedBox(
      width: 350.zW,
      child: Text(
        (ZegoCallInvitationType.videoCall == widget.invitationData.type
                ? (widget.invitationData.invitees.length > 1
                    ? widget.callInvitationConfig.innerText.incomingGroupVideoCallDialogTitle
                    : widget.callInvitationConfig.innerText.incomingVideoCallDialogTitle)
                : (widget.invitationData.invitees.length > 1
                    ? widget.callInvitationConfig.innerText.incomingGroupVoiceCallDialogTitle
                    : widget.callInvitationConfig.innerText.incomingVoiceCallDialogTitle))
            .replaceFirst(param_1, widget.invitationData.inviter?.name ?? ''),
        overflow: TextOverflow.ellipsis,
        textAlign: TextAlign.left,
        style: AppStyles.text14Px.w500.dark,
      ),
    );
  }

  Widget subtitle() {
    return SizedBox(
      width: 360.zW,
      child: Text(
        invitationTypeString(
          widget.invitationData.type,
          widget.invitationData.invitees,
        ),
        maxLines: 1,
        overflow: TextOverflow.ellipsis,
        style: AppStyles.text12Px.w400.dark,
      ),
    );
  }

  Widget declineButton() {
    return AbsorbPointer(
      absorbing: false,
      child: ZegoRefuseInvitationButton(
        inviterID: widget.invitationData.inviter?.id ?? '',
        targetInvitationID: widget.invitationData.invitationID,
        // customization is not supported
        data: ZegoCallInvitationRejectRequestProtocol(
          reason: ZegoCallInvitationProtocolKey.refuseByDecline,
        ).toJson(),
        textStyle: widget.declineButtonConfig.textStyle,
        icon: ButtonIcon(
          icon: widget.declineButtonConfig.icon ??
              Image(
                image: ZegoCallImage.asset(InvitationStyleIconUrls.inviteReject).image,
                fit: BoxFit.fill,
              ),
        ),
        iconSize: widget.declineButtonConfig.iconSize ?? Size(74.zR, 74.zR),
        buttonSize: widget.declineButtonConfig.size ?? Size(74.zR, 74.zR),
        onPressed: (ZegoRefuseInvitationButtonResult result) {
          widget.pageManager.hideInvitationTopSheet();
          widget.pageManager.onLocalRefuseInvitation(
            widget.invitationData.invitationID,
            result.code,
            result.message,
          );
        },
        networkLoadingConfig: widget.callInvitationConfig.config.networkLoading ??
            ZegoNetworkLoadingConfig(
              enabled: true,
              progressColor: Colors.white,
            ),
      ),
    );
  }

  Widget acceptButton() {
    return AbsorbPointer(
      absorbing: false,
      child: ZegoAcceptInvitationButton(
        inviterID: widget.invitationData.inviter?.id ?? '',
        targetInvitationID: widget.invitationData.invitationID,
        customData: ZegoCallInvitationAcceptRequestProtocol().toJson(),
        textStyle: widget.acceptButtonConfig.textStyle,
        icon: ButtonIcon(
          icon: widget.acceptButtonConfig.icon ??
              Image(
                image: ZegoCallImage.asset(
                  imageURLByInvitationType(widget.invitationData.type),
                ).image,
                fit: BoxFit.fill,
              ),
        ),
        iconSize: widget.acceptButtonConfig.iconSize ?? Size(74.zR, 74.zR),
        buttonSize: widget.acceptButtonConfig.size ?? Size(74.zR, 74.zR),
        onPressed: (ZegoAcceptInvitationButtonResult result) {
          widget.pageManager.hideInvitationTopSheet();
          widget.pageManager.onLocalAcceptInvitation(
            widget.invitationData.invitationID,
            result.code,
            result.message,
          );
        },
        networkLoadingConfig: widget.callInvitationConfig.config.networkLoading ??
            ZegoNetworkLoadingConfig(
              enabled: true,
              progressColor: Colors.white,
            ),
      ),
    );
  }

  String imageURLByInvitationType(ZegoCallInvitationType invitationType) {
    switch (invitationType) {
      case ZegoCallInvitationType.voiceCall:
        return InvitationStyleIconUrls.inviteVoice;
      case ZegoCallInvitationType.videoCall:
        return InvitationStyleIconUrls.inviteVideo;
    }
  }

  String invitationTypeString(ZegoCallInvitationType invitationType, List<ZegoUIKitUser> invitees) {
    switch (invitationType) {
      case ZegoCallInvitationType.voiceCall:
        return invitees.length > 1 ? (widget.callInvitationConfig.innerText.incomingGroupVoiceCallDialogMessage) : (widget.callInvitationConfig.innerText.incomingVoiceCallDialogMessage);
      case ZegoCallInvitationType.videoCall:
        return invitees.length > 1 ? (widget.callInvitationConfig.innerText.incomingGroupVideoCallDialogMessage) : (widget.callInvitationConfig.innerText.incomingVideoCallDialogMessage);
    }
  }
}
