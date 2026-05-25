import 'package:flutter/material.dart';

/// Brand logo used on the splash screen.
class ZvoltaLogo extends StatelessWidget {
  const ZvoltaLogo({
    super.key,
    this.width = 220,
  });

  final double width;

  static const _assetPath = 'assets/images/zvolta_logo.png';

  @override
  Widget build(BuildContext context) {
    return Image.asset(
      _assetPath,
      width: width,
      fit: BoxFit.contain,
      filterQuality: FilterQuality.high,
    );
  }
}
