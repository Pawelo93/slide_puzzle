import 'package:flutter/material.dart';
import 'package:very_good_slide_puzzle/extensions.dart';
import 'package:very_good_slide_puzzle/sky/clouds_bloc.dart';
import 'package:very_good_slide_puzzle/sky/resource_bundle.dart';

class CloudsWidget extends StatelessWidget {
  const CloudsWidget({
    Key? key,
    required this.resourceBundle,
    required this.clouds,
    required this.cloudsScreenKey,
    required this.child,
  }) : super(key: key);

  final ResourceBundle resourceBundle;
  final List<Cloud> clouds;
  final GlobalKey cloudsScreenKey;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return CustomPaint(
      painter: CloudsPainter(
        resourceBundle: resourceBundle,
        clouds: clouds,
        cloudsScreenKey: cloudsScreenKey,
      ),
      child: child,
    );
  }
}

class CloudsPainter extends CustomPainter {
  CloudsPainter({
    required this.resourceBundle,
    required this.clouds,
    required this.cloudsScreenKey,
  });

  final Paint _paint = Paint();
  final List<Cloud> clouds;
  final ResourceBundle resourceBundle;
  final GlobalKey cloudsScreenKey;

  @override
  void paint(Canvas canvas, Size size) {
    final Rect? bounds = cloudsScreenKey.globalPaintBounds;

    final tileWidth = (bounds?.topRight.dx ?? 0) - (bounds?.topLeft.dx ?? 0);
    final screenWidth = tileWidth * 4 + 3 * 8;
    final ratio = screenWidth / tileWidth;
    final startHeight = (bounds?.bottomLeft.dy ?? 0) - (bounds?.topLeft.dy ?? 0);

    for (final cloud in clouds) {
      final image = resourceBundle.clouds[cloud.id - 1];
      final double cloudWidth = image.width / ratio;
      final double cloudHeight = image.height / ratio;
      double opacity = 0.15;

      final maxOpacity = 0.15;
      final minDistance = 200;
      final maxDistance = screenWidth / 2;

      final bufor = (screenWidth * 0.2).toInt();
      final minScreenWidth = screenWidth - bufor;
      var output = (minScreenWidth - cloud.x) / (minScreenWidth - maxDistance);

      if (cloud.x > minDistance && cloud.x < maxDistance) {
        opacity = maxOpacity;
      } else {
        if (cloud.x > 0 && cloud.x < minDistance) {
          opacity = maxOpacity / (minDistance / cloud.x);
        } else if (cloud.x > maxDistance && cloud.x < minScreenWidth) {
          opacity = maxOpacity * output;
        } else {
          opacity = 0;
        }
      }

      _paint.color = Color.fromRGBO(0, 0, 0, opacity);
      canvas.drawImageRect(
        image,
        Rect.fromLTWH(0, 0, image.width.toDouble(), image.height.toDouble()),
        Rect.fromLTWH(cloud.x / ratio, cloud.y / ratio + startHeight / 6, cloudWidth, cloudHeight),
        _paint,
      );
    }
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    return true;
  }
}
