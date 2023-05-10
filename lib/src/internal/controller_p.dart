part of 'package:zego_uikit_prebuilt_call/src/call_controller.dart';

mixin ZegoUIKitPrebuiltCallControllerPrivate {
  final screenSharingViewController = ZegoScreenSharingViewController();
  ZegoUIKitPrebuiltCallConfig? _prebuiltConfig;

  final ValueNotifier<bool> isHangUpRequestingNotifier =
      ValueNotifier<bool>(false);

  ZegoInvitationPageManager? get _pageManager =>
      ZegoCallInvitationInternalInstance.instance.pageManager;

  ZegoCallInvitationConfig? get _callInvitationConfig =>
      ZegoCallInvitationInternalInstance.instance.callInvitationConfig;

  ZegoCallInvitationInnerText? get _innerText =>
      _callInvitationConfig?.innerText;

  ZegoUIKitPrebuiltCallConfig? get prebuiltConfig => _prebuiltConfig;

  Future<bool> _sendInvitation({
    required List<ZegoCallUser> invitees,
    required bool isVideoCall,
    required String callID,
    String customData = '',
    String? resourceID,
    String? notificationTitle,
    String? notificationMessage,
    int timeoutSeconds = 60,
  }) {
    return ZegoUIKit()
        .getSignalingPlugin()
        .sendInvitation(
          inviterName: ZegoUIKit().getLocalUser().name,
          invitees: invitees.map((user) {
            return user.id;
          }).toList(),
          timeout: timeoutSeconds,
          type: ZegoCallTypeExtension(
            isVideoCall ? ZegoCallType.videoCall : ZegoCallType.voiceCall,
          ).value,
          data: InvitationInternalData(
            callID,
            invitees
                .map((invitee) => ZegoUIKitUser(
                      id: invitee.id,
                      name: invitee.name,
                    ))
                .toList(),
            customData,
          ).toJson(),
          zegoNotificationConfig: ZegoNotificationConfig(
            resourceID: resourceID ?? '',
            title: notificationTitle ??
                (isVideoCall
                        ? ((invitees.length > 1
                                ? _innerText?.incomingGroupVideoCallDialogTitle
                                : _innerText?.incomingVideoCallDialogTitle) ??
                            param_1)
                        : ((invitees.length > 1
                                ? _innerText?.incomingGroupVoiceCallDialogTitle
                                : _innerText?.incomingVoiceCallDialogTitle) ??
                            param_1))
                    .replaceFirst(param_1, ZegoUIKit().getLocalUser().name),
            message: notificationMessage ??
                (isVideoCall
                    ? ((invitees.length > 1
                            ? _innerText?.incomingGroupVideoCallDialogMessage
                            : _innerText?.incomingVideoCallDialogMessage) ??
                        'Incoming video call...')
                    : ((invitees.length > 1
                            ? _innerText?.incomingGroupVoiceCallDialogMessage
                            : _innerText?.incomingVoiceCallDialogMessage) ??
                        'Incoming voice call...')),
          ),
        )
        .then((result) {
      _pageManager?.onLocalSendInvitation(
        callID,
        invitees
            .map((invitee) => ZegoUIKitUser(
                  id: invitee.id,
                  name: invitee.name,
                ))
            .toList(),
        isVideoCall ? ZegoCallType.videoCall : ZegoCallType.voiceCall,
        result.error?.code ?? '',
        result.error?.message ?? '',
        result.invitationID,
        result.errorInvitees.keys.toList(),
      );

      return result.error?.code.isNotEmpty ?? true;
    });
  }

  Future<int> _waitUntil(
    bool Function() test, {
    final int maxIterations = 100,
    final Duration step = const Duration(milliseconds: 10),
  }) async {
    var iterations = 0;
    for (; iterations < maxIterations; iterations++) {
      await Future.delayed(step);
      if (test()) {
        break;
      }
    }
    if (iterations >= maxIterations) {
      return iterations;
    }
    return iterations;
  }

  /// DO NOT CALL
  /// Call Inside By Prebuilt
  /// prebuilt assign value to internal variables
  void initByPrebuilt({required ZegoUIKitPrebuiltCallConfig prebuiltConfig}) {
    ZegoLoggerService.logInfo(
      'init by prebuilt',
      tag: 'call',
      subTag: 'controller_p',
    );

    _prebuiltConfig = prebuiltConfig;
  }

  /// DO NOT CALL
  /// Call Inside By Prebuilt
  /// prebuilt assign value to internal variables
  void uninitByPrebuilt() {
    ZegoLoggerService.logInfo(
      'uninit by prebuilt',
      tag: 'call',
      subTag: 'controller_p',
    );

    isHangUpRequestingNotifier.value = false;

    _prebuiltConfig = null;
  }
}
