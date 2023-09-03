import 'dart:collection';

class VMeetingOptions {
  VMeetingOptions({
    required this.room,
    required this.serverURL,
  });

  final String room;
  final String serverURL;

  String? subject;
  String? token;
  bool? audioMuted;
  bool? audioOnly;
  bool? videoMuted;
  String? userDisplayName;
  String? userEmail;
  String? iosAppBarRGBAColor;
  String? userAvatarURL;

  Map<String, dynamic>? webOptions; // options for web

  Map<String, dynamic> config = HashMap(); //

  Map<String, dynamic> featureFlags = HashMap();

  /// Get feature flags Map with keys as String instead of Enum
  /// Useful as an argument sent to the Kotlin/Swift code

  Map<String?, dynamic> getconfig() {
    Map<String?, dynamic> configWithStrings = HashMap();

    config.forEach((key, value) {
      configWithStrings[key] = value;
    });

    return configWithStrings;
  }

  @override
  String toString() {
    return 'vMeetingOptions{room: $room,'
        'subject: $subject, token: $token, audioMuted: $audioMuted, '
        'audioOnly: $audioOnly, videoMuted: $videoMuted, serverURL: $serverURL '
        'userDisplayName: $userDisplayName, userEmail: $userEmail, '
        'iosAppBarRGBAColor :$iosAppBarRGBAColor, featureFlags: $featureFlags,'
        ' config: $config , userAvatarURL: $userAvatarURL}';
  }

/* Not used yet, needs more research
  Bundle colorScheme;
  String userAvatarURL;
*/

}
