import 'package:flutter/material.dart';
import 'dart:typed_data';
import 'dart:ui' as ui;

import 'package:flutter/material.dart';
import 'package:flutter/services.dart' show rootBundle;
import 'package:very_good_slide_puzzle/extensions.dart';
import 'package:very_good_slide_puzzle/models/position.dart';

class SkyInsideTile extends StatelessWidget {
  SkyInsideTile({
    Key? key,
    required this.globalKey,
    required this.background,
    this.child,
  }) : super(key: key);

  final ui.Image background;
  final GlobalKey globalKey;
  final Widget? child;
  @override
  Widget build(BuildContext context) {
    return ColoredBox(
      color: Colors.red,
      child: CustomPaint(
        painter: ShapePainter(
          background: background,
          characterX: 0,
          characterY: 0,
          globalKey: globalKey,
        ),
        child: child,
      ),
    );
  }
}

class ShapePainter extends CustomPainter {
  ShapePainter({
    required this.background,
    required this.characterX,
    required this.characterY,
    required this.globalKey,
  });

  final Paint _paint = Paint();
  final ui.Image background;

  final double characterX;
  final double characterY;
  final GlobalKey globalKey;

  Position? oldPosition;

  @override
  void paint(Canvas canvas, Size size) {
    final Rect? bounds = globalKey.globalPaintBounds;

    canvas.mask(
      background,
      x: 0,
      y: 0,
      width: size.width,
      height: size.height,
      maskX: bounds?.topLeft.dx ?? 0,
      maskY: bounds?.topLeft.dy ?? 0,
      maskWidth: size.width,
      maskHeight: size.height,
      paint: _paint,
    );

  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    return true;
  }

  // void drawImage(Canvas canvas, Rect rect) {
  //   canvas.drawImageRect(
  //     character,
  //     Rect.fromLTWH(
  //       0,
  //       0,
  //       character.width.toDouble(),
  //       character.height.toDouble(),
  //     ),
  //     rect,
  //     _paint,
  //   );
  // }
}

extension CanvasExt on Canvas {
  void image(
    ui.Image image, {
    required double x,
    required double y,
    required double width,
    required double height,
    required Paint paint,
  }) {
    drawImageRect(
      image,
      Rect.fromLTWH(0, 0, image.width.toDouble(), image.height.toDouble()),
      Rect.fromLTWH(x, y, width, height),
      paint,
    );
  }

  void mask(
    ui.Image image, {
    required double x,
    required double y,
    required double width,
    required double height,
    required double maskX,
    required double maskY,
    required double maskWidth,
    required double maskHeight,
    required Paint paint,
  }) {
    drawImageRect(
      image,
      Rect.fromLTWH(maskX, maskY, maskWidth, maskHeight),
      Rect.fromLTWH(x, y, width, height),
      paint,
    );
  }
}
