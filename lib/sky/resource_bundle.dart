import 'dart:ui' as ui;

class ResourceBundle {
  ResourceBundle(
    this.backgroundDetails,
    this.foregroundDetails,
    this.staticBackground,
    this.staticForeground,
    this.clouds,
    this.river,
  );

  final ui.Image backgroundDetails;
  final ui.Image foregroundDetails;
  final ui.Image staticBackground;
  final ui.Image staticForeground;
  final List<ui.Image> clouds;
  final ui.Image river;
}
