enum RequestableFeatures {
  camera,
  microphone,
  storage,
}

/// To create specific snackbars
extension RequestableFeaturesExtension on RequestableFeatures {
  String get featureName {
    switch (this) {
      case RequestableFeatures.camera:
        return 'camera';

      case RequestableFeatures.microphone:
        return 'microphone';
      case RequestableFeatures.storage:
        return 'storage';

      default:
        return 'camera';
    }
  }
}
