import 'package:plugin_platform_interface/plugin_platform_interface.dart';

import 'image_attack_method_channel.dart';

abstract class ImageAttackPlatform extends PlatformInterface {
  /// Constructs a ImageAttackPlatform.
  ImageAttackPlatform() : super(token: _token);

  static final Object _token = Object();

  static ImageAttackPlatform _instance = MethodChannelImageAttack();

  /// The default instance of [ImageAttackPlatform] to use.
  ///
  /// Defaults to [MethodChannelImageAttack].
  static ImageAttackPlatform get instance => _instance;
  
  /// Platform-specific implementations should set this with their own
  /// platform-specific class that extends [ImageAttackPlatform] when
  /// they register themselves.
  static set instance(ImageAttackPlatform instance) {
    PlatformInterface.verifyToken(instance, _token);
    _instance = instance;
  }

  Future<String?> getPlatformVersion() {
    throw UnimplementedError('platformVersion() has not been implemented.');
  }
}
