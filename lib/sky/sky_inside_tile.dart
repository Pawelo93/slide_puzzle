import 'package:flutter/material.dart';
import 'dart:ui' as ui;

import 'package:very_good_slide_puzzle/extensions.dart';
import 'package:very_good_slide_puzzle/models/position.dart';
import 'package:very_good_slide_puzzle/sky/resource_bundle.dart';

class SkyInsideTile extends StatelessWidget {
  SkyInsideTile({
    Key? key,
    required this.globalKey,
    required this.resourceBundle,
    required this.mainContainerKey,
    required this.correctPosition,
    required this.brightness,
    this.child,
  }) : super(key: key);

  final ResourceBundle resourceBundle;
  final GlobalKey globalKey;
  final GlobalKey mainContainerKey;
  final Position correctPosition;
  final double brightness;
  final Widget? child;

  @override
  Widget build(BuildContext context) {
    return CustomPaint(
      painter: ShapePainter(
        resourceBundle: resourceBundle,
        characterX: 0,
        characterY: 0,
        globalKey: globalKey,
        mainContainerKey: mainContainerKey,
        correctPosition: correctPosition,
        brightness: brightness,
      ),
      child: child,
    );
  }
}

class ShapePainter extends CustomPainter {
  ShapePainter({
    required this.resourceBundle,
    required this.characterX,
    required this.characterY,
    required this.globalKey,
    required this.mainContainerKey,
    required this.correctPosition,
    required this.brightness,
  });

  final Paint _paint = Paint();
  final Paint _riverPaint = Paint();
  final ResourceBundle resourceBundle;

  final double characterX;
  final double characterY;
  final GlobalKey globalKey;
  final GlobalKey mainContainerKey;
  final Position correctPosition;
  final double brightness;

  @override
  void paint(Canvas canvas, Size size) {
    final Rect? bounds = globalKey.globalPaintBounds;

    _riverPaint.color = Color.fromARGB((brightness * 255).toInt(), 255, 255, 255);

    final topRight = mainContainerKey.globalPaintBounds?.topRight.dx ?? 0;
    final topDx = mainContainerKey.globalPaintBounds?.topLeft.dx ?? 0;
    final topDy = mainContainerKey.globalPaintBounds?.topLeft.dy ?? 0;

    final tileWidth = size.width;
    final double spacing = ((topRight - topDx) - (4 * tileWidth)) / 3;

    var maskSize = 1200 / 4 - (spacing * 3);

    final dx = (bounds?.topLeft.dx ?? 0) - topDx;
    double maskX;
    if (dx != 0) {
      maskX = (dx / tileWidth) * maskSize;
    } else {
      maskX = 0;
    }

    final dy = (bounds?.topLeft.dy ?? 0) - topDy;
    double maskY;
    if (dy != 0) {
      maskY = (dy / tileWidth) * maskSize;
    } else {
      maskY = 0;
    }

    canvas.mask(
      resourceBundle.staticBackground,
      x: 0,
      y: 0,
      width: size.width,
      height: size.height,
      maskX: maskX,
      maskY: maskY,
      maskWidth: maskSize,
      maskHeight: maskSize,
      paint: _paint,
    );

    canvas.mask(
      resourceBundle.backgroundDetails,
      x: 0,
      y: 0,
      width: size.width,
      height: size.height,
      maskX: (correctPosition.x - 1) * maskSize,
      maskY: (correctPosition.y - 1) * maskSize,
      maskWidth: maskSize,
      maskHeight: maskSize,
      paint: _paint,
    );

    canvas.mask(
      resourceBundle.staticForeground,
      x: 0,
      y: 0,
      width: size.width,
      height: size.height,
      maskX: maskX,
      maskY: maskY,
      maskWidth: maskSize,
      maskHeight: maskSize,
      paint: _paint,
    );

    canvas.mask(
      resourceBundle.foregroundDetails,
      x: 0,
      y: 0,
      width: size.width,
      height: size.height,
      maskX: (correctPosition.x - 1) * maskSize,
      maskY: (correctPosition.y - 1) * maskSize + 4 * spacing,
      maskWidth: maskSize ,
      maskHeight: maskSize + 4 * spacing,
      paint: _paint,
    );

    canvas.mask(
      resourceBundle.river,
      x: 0,
      y: 0,
      width: size.width,
      height: size.height,
      maskX: maskX,
      maskY: maskY,
      maskWidth: maskSize,
      maskHeight: maskSize,
      paint: _riverPaint,
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
