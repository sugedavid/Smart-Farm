import 'package:flutter_test/flutter_test.dart';
import 'package:smart_farm/core/utils/assets.dart';

void main() {
  test('AppAssets constants are defined correctly', () {
    const expectedLogoImg = 'assets/icons/launcher.png';
    const expectedSuccessImg = 'assets/images/sucess.png';
    const expectedEmailVerificationImg = 'assets/images/email_verification.png';
    const expectedLeafScanAnim = 'assets/anim/leaf_scan.json';
    const expectedImageScanAnim = 'assets/anim/image_scan.json';

    expect(AppAssets.logoImg, expectedLogoImg);
    expect(AppAssets.successImg, expectedSuccessImg);
    expect(AppAssets.emailVerificationImg, expectedEmailVerificationImg);
    expect(AppAssets.leafScanAnim, expectedLeafScanAnim);
    expect(AppAssets.imageScanAnim, expectedImageScanAnim);
  });
}
