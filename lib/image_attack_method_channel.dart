import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';

import 'image_attack_platform_interface.dart';

/// An implementation of [ImageAttackPlatform] that uses method channels.
class MethodChannelImageAttack extends ImageAttackPlatform {
  /// The method channel used to interact with the native platform.
  @visibleForTesting
  final methodChannel = const MethodChannel('image_attack');

  @override
  Future<String?> getPlatformVersion() async {
    final version = await methodChannel.invokeMethod<String>('getPlatformVersion');
    return version;
  }
}
