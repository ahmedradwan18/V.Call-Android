/// Class holding the callback functions for conference events
class VMeetingListener {
  ///
  final Function(Map<dynamic, dynamic> message)? onConferenceWillJoin;

  ///
  final Function(Map<dynamic, dynamic> message)? onScreenShareToggled;

  ///
  final Function(Map<dynamic, dynamic> message)? onConferenceJoined;

  ///
  final Function(Map<dynamic, dynamic> message)? onConferenceTerminated;

  ///
  final Function(Map<dynamic, dynamic> message)? onPictureInPictureWillEnter;

  ///
  final Function(Map<dynamic, dynamic> message)? onPictureInPictureTerminated;

  ///
  final Function(dynamic error)? onError;

  /// Generic listeners List for allowed listeners on web
  /// (may be for mobile too)
  final List<VGenericListener>? genericListeners;

  VMeetingListener(
      {this.onConferenceWillJoin,
      this.onConferenceJoined,
      this.onConferenceTerminated,
      this.onPictureInPictureTerminated,
      this.onPictureInPictureWillEnter,
      this.onScreenShareToggled,
      this.onError,
      this.genericListeners});
}

/// Generic listener
class VGenericListener {
  final String eventName;
  final Function(dynamic message) callback;

  VGenericListener({required this.eventName, required this.callback});
}
