import 'package:flutter/material.dart';
import 'package:very_good_slide_puzzle/layout/layout.dart';
import 'package:very_good_slide_puzzle/models/models.dart';
import 'package:very_good_slide_puzzle/puzzle/puzzle.dart';
import 'package:very_good_slide_puzzle/sky/resource_bundle.dart';
import 'package:very_good_slide_puzzle/sky/sky_countdown.dart';
import 'package:very_good_slide_puzzle/sky/sky_license_widget.dart';
import 'package:very_good_slide_puzzle/sky/sky_puzzle_action_button.dart';
import 'package:very_good_slide_puzzle/sky/sky_puzzle_board.dart';
import 'package:very_good_slide_puzzle/sky/sky_puzzle_tile.dart';
import 'package:very_good_slide_puzzle/sky/sky_start_section.dart';
import 'package:very_good_slide_puzzle/sky/sky_timer.dart';
import 'package:very_good_slide_puzzle/theme/bloc/theme_bloc.dart';
import 'package:very_good_slide_puzzle/theme/themes/puzzle_theme.dart';

/// {@template dashatar_puzzle_layout_delegate}
/// A delegate for computing the layout of the puzzle UI
/// that uses a [SkyTheme].
/// {@endtemplate}
class SkyPuzzleLayoutDelegate extends PuzzleLayoutDelegate {
  /// {@macro dashatar_puzzle_layout_delegate}
  const SkyPuzzleLayoutDelegate(this.resourceBundle);

  final ResourceBundle resourceBundle;

  @override
  Widget startSectionBuilder(PuzzleState state) {
    return ResponsiveLayoutBuilder(
      small: (_, child) => child!,
      medium: (_, child) => child!,
      large: (_, child) => Padding(
        padding: const EdgeInsets.only(left: 50, right: 32),
        child: child,
      ),
      child: (_) => SkyStartSection(state: state),
    );
  }

  @override
  Widget endSectionBuilder(PuzzleState state) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        const ResponsiveGap(
          small: 23,
          medium: 32,
        ),
        ResponsiveLayoutBuilder(
          small: (_, child) => const SkyPuzzleActionButton(),
          medium: (_, child) => const SkyPuzzleActionButton(),
          large: (_, __) => const SizedBox(),
        ),
        const ResponsiveGap(
          small: 32,
          medium: 54,
        ),
        const ResponsiveGap(
          large: 130,
        ),
        const SkyCountdown(),
      ],
    );
  }

  @override
  Widget backgroundBuilder(PuzzleState state) {
    return Positioned(
      bottom: 16,
      right: 16,
      child: ResponsiveLayoutBuilder(
        small: (_, child) => child!,
        medium: (_, child) => child!,
        large: (_, child) => child!,
        child: (_) => const SkyLicenseWidget(),
      ),
    );
  }

  @override
  Widget boardBuilder(int size, List<Widget> tiles) {
    return Stack(
      children: [
        Positioned(
          top: 24,
          left: 0,
          right: 0,
          child: ResponsiveLayoutBuilder(
            small: (_, child) => const SizedBox(),
            medium: (_, child) => const SizedBox(),
            large: (_, child) => const SkyTimer(),
          ),
        ),
        Column(
          children: [
            const ResponsiveGap(
              small: 21,
              medium: 34,
              large: 96,
            ),
            SkyPuzzleBoard(tiles: tiles),
            const ResponsiveGap(
              large: 96,
            ),
          ],
        ),
      ],
    );
  }

  @override
  Widget tileBuilder(Tile tile, PuzzleState state) {
    return SkyPuzzleTile(
      tile: tile,
      state: state,
      resourceBundle: resourceBundle,
    );
  }

  @override
  Widget whitespaceTileBuilder() {
    return const SizedBox();
  }

  @override
  List<Object?> get props => [];
}
