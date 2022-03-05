import 'package:flutter/material.dart';
import 'package:very_good_slide_puzzle/colors/colors.dart';
import 'package:very_good_slide_puzzle/layout/puzzle_layout_delegate.dart';
import 'package:very_good_slide_puzzle/sky/resource_bundle.dart';
import 'package:very_good_slide_puzzle/sky/sky_puzzle_layout_delegate.dart';
import 'package:very_good_slide_puzzle/theme/themes/puzzle_theme.dart';

// ignore: public_member_api_docs
class SkyTheme extends PuzzleTheme {
  /// {@macro simple_theme}
  SkyTheme(this.resourceBundle) : super();

  final ResourceBundle resourceBundle;

  @override
  String get name => 'Sky';

  @override
  bool get hasTimer => true;

  @override
  Color get nameColor => PuzzleColors.grey1;

  @override
  Color get titleColor => PuzzleColors.white;

  @override
  Color get backgroundColor => Colors.white;

  @override
  Color get defaultColor => PuzzleColors.primary5;

  @override
  Color get buttonColor => PuzzleColors.primary6;

  @override
  Color get hoverColor => PuzzleColors.primary3;

  @override
  Color get pressedColor => PuzzleColors.primary7;

  @override
  bool get isLogoColored => false;

  @override
  Color get menuActiveColor => PuzzleColors.grey1;

  @override
  Color get menuUnderlineColor => PuzzleColors.primary6;

  @override
  Color get menuInactiveColor => PuzzleColors.grey2;

  @override
  String get audioControlOnAsset => 'assets/images/audio_control/simple_on.png';

  @override
  String get audioControlOffAsset =>
      'assets/images/audio_control/simple_off.png';

  @override
  PuzzleLayoutDelegate get layoutDelegate => SkyPuzzleLayoutDelegate(resourceBundle);

  @override
  List<Object?> get props => [
    name,
    audioControlOnAsset,
    audioControlOffAsset,
    hasTimer,
    nameColor,
    titleColor,
    backgroundColor,
    defaultColor,
    buttonColor,
    hoverColor,
    pressedColor,
    isLogoColored,
    menuActiveColor,
    menuUnderlineColor,
    menuInactiveColor,
    layoutDelegate,
  ];

  @override
  Color get countdownColor => PuzzleColors.primary2;

  @override
  Color get licenseTextColor => const Color(0x88FFFFFF);
}
