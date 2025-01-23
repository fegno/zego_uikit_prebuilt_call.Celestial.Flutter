// Flutter imports:
import 'package:celestial/imports_bindings.dart';

// Package imports:

// Project imports:
import 'package:zego_uikit_prebuilt_call/src/invitation/internal/internal.dart';
import 'package:zego_uikit_prebuilt_call/src/invitation/pages/calling/page/common.dart';
import 'package:zego_uikit_prebuilt_call/src/invitation/pages/calling/toolbar/inviter_bottom_toolbar.dart';
import 'package:zego_uikit_prebuilt_call/src/invitation/pages/page_manager.dart';

/// @nodoc
class ZegoCallingInviterView extends StatelessWidget {
  const ZegoCallingInviterView({
    Key? key,
    required this.pageManager,
    required this.callInvitationData,
    required this.inviter,
    required this.invitees,
    required this.invitationType,
    required this.customData,
    this.avatarBuilder,
    this.foregroundBuilder,
    this.backgroundBuilder,
  }) : super(key: key);

  final ZegoCallInvitationPageManager pageManager;
  final ZegoUIKitPrebuiltCallInvitationData callInvitationData;

  final ZegoUIKitUser inviter;
  final List<ZegoUIKitUser> invitees;
  final ZegoCallInvitationType invitationType;
  final String customData;
  final ZegoAvatarBuilder? avatarBuilder;
  final ZegoCallingForegroundBuilder? foregroundBuilder;
  final ZegoCallingBackgroundBuilder? backgroundBuilder;

  ZegoCallInvitationInviterUIConfig get config => callInvitationData.uiConfig.inviter;
  ZegoCallInvitationInnerText get innerText => callInvitationData.innerText;

  @override
  Widget build(BuildContext context) {
    StatusBarTheme.setDarkStatusBarColor(
      statusBarColor: context.theme.scaffoldBackgroundColor,
    );
    return Scaffold(
      appBar: AppBar(
        backgroundColor: context.theme.scaffoldBackgroundColor,
        elevation: 0,
        // leading: IconButton(
        //   icon: const Icon(Icons.arrow_back),
        //   onPressed: () {},
        // ),
        leading: const SizedBox.shrink(),
      ),
      body: ZegoScreenUtilInit(
        designSize: const Size(750, 1334),
        minTextAdapt: true,
        splitScreenMode: true,
        builder: (context, child) {
          return Stack(
            children: [
              backgroundView(context),
              surface(context),
              foreground(context),
            ],
          );
        },
      ),
    );
  }

  Widget backgroundView(BuildContext context) {
    if (ZegoCallInvitationType.videoCall == invitationType) {
      return ZegoAudioVideoView(user: inviter);
    }

    return LayoutBuilder(builder: (context, constraints) {
      return Container(
        width: constraints.maxWidth,
        height: constraints.maxHeight,
        color: context.theme.scaffoldBackgroundColor,
      );
      // return backgroundBuilder?.call(
      //       context,
      //       Size(constraints.maxWidth, constraints.maxHeight),
      //       ZegoCallingBuilderInfo(
      //         inviter: inviter,
      //         invitees: invitees,
      //         callType: invitationType,
      //         customData: customData,
      //       ),
      //     ) ??
      //     backgroundImage();
    });
  }

  Widget surface(BuildContext context) {
    final isVideo = ZegoCallInvitationType.videoCall == invitationType;
    final firstInvitee = invitees.isNotEmpty ? invitees.first : ZegoUIKitUser.empty();
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        // if (isVideo) const ZegoInviterCallingVideoTopToolBar() else Container(),
        // if (isVideo) SizedBox(height: 140.zH) else SizedBox(height: 228.zH),
        SizedBox(height: 14.zR),
        config.showCentralName
            ? centralName((isVideo
                    ? (invitees.length > 1 ? innerText.outgoingGroupVideoCallPageTitle : innerText.outgoingVideoCallPageTitle)
                    : (invitees.length > 1 ? innerText.outgoingGroupVoiceCallPageTitle : innerText.outgoingVoiceCallPageTitle))
                .replaceFirst(param_1, firstInvitee.name))
            : SizedBox(height: 59.zH),
        SizedBox(height: 24.zR),
        config.showCallingText
            ? callingText(isVideo
                ? (invitees.length > 1 ? innerText.outgoingGroupVideoCallPageMessage : innerText.outgoingVideoCallPageMessage)
                : (invitees.length > 1 ? innerText.outgoingGroupVoiceCallPageMessage : innerText.outgoingVoiceCallPageMessage))
            : SizedBox(height: 32.0.zR),
        SizedBox(height: 120.zR),
        SizedBox.square(
          dimension: 200.zR,
          child: Stack(
            alignment: Alignment.center,
            fit: StackFit.expand,
            children: [
              CustomPaint(
                size: Size.square(200.zR),
                painter: DashedCirclesPainter(
                  1,
                ),
              ),
              config.showAvatar
                  ? ValueListenableBuilder(
                      valueListenable: ZegoUIKitUserPropertiesNotifier(firstInvitee),
                      builder: (context, _, __) {
                        return avatarBuilder?.call(
                              context,
                              Size(200.zR, 200.zR),
                              firstInvitee,
                              {},
                            ) ??
                            circleAvatar(firstInvitee.name);
                      },
                    )
                  : Container()
            ],
          ),
        ),
        const Spacer(),
        ZegoInviterCallingBottomToolBar(
          pageManager: pageManager,
          networkLoadingConfig: callInvitationData.config.networkLoading,
          cancelButtonConfig: config.cancelButton,
          invitees: invitees,
        ),
        SizedBox(height: 105.zR),
      ],
    );
  }

  Widget foreground(BuildContext context) {
    return LayoutBuilder(builder: (context, constraints) {
      return foregroundBuilder?.call(
            context,
            Size(constraints.maxWidth, constraints.maxHeight),
            ZegoCallingBuilderInfo(
              inviter: inviter,
              invitees: invitees,
              callType: invitationType,
              customData: customData,
            ),
          ) ??
          Container();
    });
  }
}
