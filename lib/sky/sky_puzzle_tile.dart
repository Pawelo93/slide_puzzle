import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:just_audio/just_audio.dart';
import 'package:very_good_slide_puzzle/audio_control/audio_control.dart';
import 'package:very_good_slide_puzzle/dashatar/dashatar.dart';
import 'package:very_good_slide_puzzle/helpers/helpers.dart';
import 'package:very_good_slide_puzzle/l10n/l10n.dart';
import 'package:very_good_slide_puzzle/layout/layout.dart';
import 'package:very_good_slide_puzzle/models/models.dart';
import 'package:very_good_slide_puzzle/puzzle/puzzle.dart';
import 'package:very_good_slide_puzzle/sky/clouds_bloc.dart';
import 'package:very_good_slide_puzzle/sky/resource_bundle.dart';
import 'package:very_good_slide_puzzle/sky/sky_inside_tile.dart';
import 'package:very_good_slide_puzzle/theme/themes/themes.dart';

abstract class _TileSize {
  static double small = 77;
  static double medium = 104;
  static double large = 116;
}

/// {@template dashatar_puzzle_tile}
/// Displays the puzzle tile associated with [tile]
/// based on the puzzle [state].
/// {@endtemplate}
class SkyPuzzleTile extends StatefulWidget {
  /// {@macro dashatar_puzzle_tile}
  const SkyPuzzleTile({
    Key? key,
    required this.tile,
    required this.state,
    required this.resourceBundle,
    AudioPlayerFactory? audioPlayer,
  })  : _audioPlayerFactory = audioPlayer ?? getAudioPlayer,
        super(key: key);

  /// The tile to be displayed.
  final Tile tile;

  /// The state of the puzzle.
  final PuzzleState state;

  final AudioPlayerFactory _audioPlayerFactory;
  final ResourceBundle resourceBundle;

  @override
  State<SkyPuzzleTile> createState() => SkyPuzzleTileState();
}

/// The state of [SkyPuzzleTile].
@visibleForTesting
class SkyPuzzleTileState extends State<SkyPuzzleTile>
    with SingleTickerProviderStateMixin {
  AudioPlayer? _audioPlayer;
  late final Timer _timer;

  /// The controller that drives [_scale] animation.
  late AnimationController _controller;
  late Animation<double> _scale;
  final GlobalKey containerKey = GlobalKey();
  final GlobalKey mainContainerKey = GlobalKey();

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(
      vsync: this,
      duration: PuzzleThemeAnimationDuration.puzzleTileScale,
    );

    _scale = Tween<double>(begin: 1, end: 0.96).animate(
      CurvedAnimation(
        parent: _controller,
        curve: const Interval(0, 1, curve: Curves.easeInOut),
      ),
    );

    // Delay the initialization of the audio player for performance reasons,
    // to avoid dropping frames when the theme is changed.
    _timer = Timer(const Duration(seconds: 1), () {
      _audioPlayer = widget._audioPlayerFactory()
        ..setAsset('assets/audio/tile_move.mp3');
    });
  }

  @override
  void dispose() {
    _timer.cancel();
    _audioPlayer?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final size = widget.state.puzzle.getDimension();
    final status =
        context.select((DashatarPuzzleBloc bloc) => bloc.state.status);
    final hasStarted = status == DashatarPuzzleStatus.started;
    final puzzleIncomplete =
        context.select((PuzzleBloc bloc) => bloc.state.puzzleStatus) ==
            PuzzleStatus.incomplete;

    final movementDuration = status == DashatarPuzzleStatus.loading
        ? const Duration(milliseconds: 700)
        : const Duration(milliseconds: 500);

    final canPress = hasStarted && puzzleIncomplete;

    return Container(
      key: mainContainerKey,
      child: AudioControlListener(
        audioPlayer: _audioPlayer,
        child: AnimatedAlign(
          key: Key('dashatar_puzzle_tile_align_${widget.tile.value}'),
          alignment: FractionalOffset(
            (widget.tile.currentPosition.x - 1) / (size - 1),
            (widget.tile.currentPosition.y - 1) / (size - 1),
          ),
          duration: movementDuration,
          curve: Curves.easeInOutCubic,
          child: ResponsiveLayoutBuilder(
            small: (_, child) => SizedBox.square(
              key: Key('dashatar_puzzle_tile_small_${widget.tile.value}'),
              dimension: _TileSize.small,
              child: child,
            ),
            medium: (_, child) => SizedBox.square(
              key: Key('dashatar_puzzle_tile_medium_${widget.tile.value}'),
              dimension: _TileSize.medium,
              child: child,
            ),
            large: (_, child) => SizedBox.square(
              key: Key('dashatar_puzzle_tile_large_${widget.tile.value}'),
              dimension: _TileSize.large,
              child: child,
            ),
            child: (currentSize) => MouseRegion(
              onEnter: (_) {
                if (canPress) {
                  _controller.forward();
                }
              },
              onExit: (_) {
                if (canPress) {
                  _controller.reverse();
                }
              },
              child: ScaleTransition(
                key: Key('dashatar_puzzle_tile_scale_${widget.tile.value}'),
                scale: _scale,
                child: IconButton(
                  padding: EdgeInsets.zero,
                  onPressed: canPress
                      ? () {
                          context
                              .read<PuzzleBloc>()
                              .add(TileTapped(widget.tile));
                          unawaited(_audioPlayer?.replay());
                        }
                      : null,
                  icon: Container(
                    key: containerKey,
                    padding: const EdgeInsets.all(2),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(8),
                      child: BlocBuilder<CloudsBloc, CloudsState>(
                        builder: (context, state) => SkyInsideTile(
                          globalKey: containerKey,
                          mainContainerKey: mainContainerKey,
                          resourceBundle: widget.resourceBundle,
                          correctPosition: widget.tile.correctPosition,
                          brightness: state.brightness,
                          child: Center(
                            child: Text(
                              widget.tile.value.toString(),
                              semanticsLabel: context.l10n.puzzleTileLabelText(
                                widget.tile.value.toString(),
                                widget.tile.currentPosition.x.toString(),
                                widget.tile.currentPosition.y.toString(),
                              ),
                              style: const TextStyle(
                                color: Color(0x57DFDFE2),
                                fontSize: 28,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  double getSize(ResponsiveLayoutSize size) {
    switch (size) {
      case ResponsiveLayoutSize.small:
        return _TileSize.small;
      case ResponsiveLayoutSize.medium:
        return _TileSize.medium;
      case ResponsiveLayoutSize.large:
        return _TileSize.large;
    }
  }
}
