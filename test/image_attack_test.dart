import 'package:flutter_test/flutter_test.dart';
import 'package:image_attack/image_attack.dart';
import 'package:image_attack/image_attack_platform_interface.dart';
import 'package:image_attack/image_attack_method_channel.dart';
import 'package:plugin_platform_interface/plugin_platform_interface.dart';

class MockImageAttackPlatform
    with MockPlatformInterfaceMixin
    implements ImageAttackPlatform {
  @override
  Future<String?> getPlatformVersion() => Future.value('42');
}

void main() {
  final ImageAttackPlatform initialPlatform = ImageAttackPlatform.instance;

  test('$MethodChannelImageAttack is the default instance', () {
    expect(initialPlatform, isInstanceOf<MethodChannelImageAttack>());
  });

  test('getPlatformVersion', () async {
    ImageAttack imageAttackPlugin = ImageAttack();
    MockImageAttackPlatform fakePlatform = MockImageAttackPlatform();
    ImageAttackPlatform.instance = fakePlatform;

    // expect(await imageAttackPlugin.getPlatformVersion(), '42');
  });
}
