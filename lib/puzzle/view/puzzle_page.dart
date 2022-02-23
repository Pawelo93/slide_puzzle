import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gap/gap.dart';
import 'package:very_good_slide_puzzle/audio_control/audio_control.dart';
import 'package:very_good_slide_puzzle/dashatar/dashatar.dart';
import 'package:very_good_slide_puzzle/helpers.dart';
import 'package:very_good_slide_puzzle/l10n/l10n.dart';
import 'package:very_good_slide_puzzle/layout/layout.dart';
import 'package:very_good_slide_puzzle/models/models.dart';
import 'package:very_good_slide_puzzle/puzzle/puzzle.dart';
import 'package:very_good_slide_puzzle/simple/simple.dart';
import 'package:very_good_slide_puzzle/sky/clouds_bloc.dart';
import 'package:very_good_slide_puzzle/sky/clouds_widget.dart';
import 'package:very_good_slide_puzzle/sky/resource_bundle.dart';
import 'package:very_good_slide_puzzle/sky/sky_theme.dart';
import 'package:very_good_slide_puzzle/theme/theme.dart';
import 'package:very_good_slide_puzzle/timer/timer.dart';
import 'package:very_good_slide_puzzle/typography/typography.dart';
import 'dart:ui' as ui;

/// {@template puzzle_page}
/// The root page of the puzzle UI.
///
/// Builds the puzzle based on the current [PuzzleTheme]
/// from [ThemeBloc].
/// {@endtemplate}
class PuzzlePage extends StatelessWidget {
  /// {@macro puzzle_page}
  const PuzzlePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<ui.Image>>(
      future: Future.wait([
        loadImage('assets/sky/background_details.png'),
        loadImage('assets/sky/foreground_details.png'),
        loadImage('assets/sky/static_background.png'),
        loadImage('assets/sky/static_foreground.png'),
        loadImage('assets/sky/cloud1.png'),
        loadImage('assets/sky/cloud2.png'),
        loadImage('assets/sky/cloud3.png'),
        loadImage('assets/sky/cloud4.png'),
        loadImage('assets/sky/cloud5.png'),
        loadImage('assets/sky/cloud6.png'),
        loadImage('assets/sky/river.png'),
      ]),
      builder: (context, data) {
        // print('DATA $data');
        if (data.hasData) {
          final backgroundDetails = data.data![0];
          final foregroundDetails = data.data![1];
          final staticBackground = data.data![2];
          final staticForeground = data.data![3];
          final cloud1 = data.data![4];
          final cloud2 = data.data![5];
          final cloud3 = data.data![6];
          final cloud4 = data.data![7];
          final cloud5 = data.data![8];
          final cloud6 = data.data![9];
          final river = data.data![10];
          final resourceBundle = ResourceBundle(
            backgroundDetails,
            foregroundDetails,
            staticBackground,
            staticForeground,
            [cloud1, cloud2, cloud3, cloud4, cloud5, cloud6],
            river,
          );
          return MultiBlocProvider(
            providers: [
              BlocProvider(
                create: (_) => DashatarPuzzleBloc(
                  secondsToBegin: 3,
                  ticker: const Ticker(),
                ),
              ),
              BlocProvider(
                create: (context) => ThemeBloc(
                  initTheme: SkyTheme(resourceBundle),
                  initialThemes: [
                    SkyTheme(resourceBundle),
                  ],
                ),
              ),
              BlocProvider(
                create: (_) => TimerBloc(
                  ticker: const Ticker(),
                ),
              ),
              BlocProvider(
                create: (_) => AudioControlBloc(),
              ),
            ],
            child: PuzzleView(resourceBundle: resourceBundle),
          );
        } else {
          return const PuzzleView(resourceBundle: null);
        }
      },
    );
  }
}

/// {@template puzzle_view}
/// Displays the content for the [PuzzlePage].
/// {@endtemplate}
class PuzzleView extends StatelessWidget {
  /// {@macro puzzle_view}
  const PuzzleView({Key? key, this.resourceBundle}) : super(key: key);

  final ResourceBundle? resourceBundle;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: AnimatedContainer(
        duration: PuzzleThemeAnimationDuration.backgroundColorChange,
        decoration: const BoxDecoration(
          gradient: RadialGradient(
            radius: 1,
            colors: [
              // Color(0xffbd8b9b),
              // Color(0xc4894d80),

              Color(0x41b35f7f),
              Color(0xb46b4264),

              // Color(0xAAb35f7f),
              // Color(0xAA6b4264),
            ],
          ),
          // color: theme.backgroundColor,
        ),
        child: resourceBundle != null ? MultiBlocProvider(
          providers: [
            BlocProvider(
              create: (context) => TimerBloc(
                ticker: const Ticker(),
              ),
            ),
            BlocProvider(
              create: (context) => PuzzleBloc(4)
                ..add(
                  PuzzleInitialized(
                    shufflePuzzle: false,
                  ),
                ),
            ),
            BlocProvider(
              create: (_) => CloudsBloc()..init(),
            )
          ],
          child: _Puzzle(
            key: Key('puzzle_view_puzzle'),
            resourceBundle: resourceBundle!,
          ),
        ) : Center(child: const CircularProgressIndicator()),
      ),
    );
  }
}

class _Puzzle extends StatelessWidget {
  const _Puzzle({Key? key, required this.resourceBundle}) : super(key: key);

  final ResourceBundle resourceBundle;

  @override
  Widget build(BuildContext context) {
    final theme = context.select((ThemeBloc bloc) => bloc.state.theme);
    final state = context.select((PuzzleBloc bloc) => bloc.state);

    return LayoutBuilder(
      builder: (context, constraints) {
        return Stack(
          children: [
            if (theme is SimpleTheme)
              theme.layoutDelegate.backgroundBuilder(state),
            SingleChildScrollView(
              child: ConstrainedBox(
                constraints: BoxConstraints(
                  minHeight: constraints.maxHeight,
                ),
                child: Column(
                  children: [
                    PuzzleHeader(resourceBundle: resourceBundle),
                    PuzzleSections(resourceBundle: resourceBundle),
                  ],
                ),
              ),
            ),
            if (theme is! SimpleTheme)
              theme.layoutDelegate.backgroundBuilder(state),
          ],
        );
      },
    );
  }
}

/// {@template puzzle_header}
/// Displays the header of the puzzle.
/// {@endtemplate}
@visibleForTesting
class PuzzleHeader extends StatelessWidget {
  /// {@macro puzzle_header}
  const PuzzleHeader({Key? key, required this.resourceBundle})
      : super(key: key);

  final ResourceBundle resourceBundle;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 96,
      child: ResponsiveLayoutBuilder(
        small: (context, child) => Stack(
          children: [
            Align(
              child: PuzzleLogo(resourceBundle: resourceBundle),
            ),
            Align(
              alignment: Alignment.centerRight,
              child: Padding(
                padding: const EdgeInsets.only(right: 34),
                child: AudioControl(key: audioControlKey),
              ),
            ),
          ],
        ),
        medium: (context, child) => Padding(
          padding: const EdgeInsets.symmetric(
            horizontal: 50,
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              PuzzleLogo(resourceBundle: resourceBundle),
              PuzzleMenu(),
            ],
          ),
        ),
        large: (context, child) => Padding(
          padding: const EdgeInsets.symmetric(
            horizontal: 50,
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              PuzzleLogo(resourceBundle: resourceBundle),
              PuzzleMenu(),
            ],
          ),
        ),
      ),
    );
  }
}

/// {@template puzzle_logo}
/// Displays the logo of the puzzle.
/// {@endtemplate}
@visibleForTesting
class PuzzleLogo extends StatelessWidget {
  /// {@macro puzzle_logo}
  const PuzzleLogo({Key? key, required this.resourceBundle}) : super(key: key);

  final ResourceBundle resourceBundle;

  @override
  Widget build(BuildContext context) {
    final theme = context.select((ThemeBloc bloc) => bloc.state.theme);

    return AppFlutterLogo(
      key: puzzleLogoKey,
      isColored: theme.isLogoColored,
    );
  }
}

/// {@template puzzle_sections}
/// Displays start and end sections of the puzzle.
/// {@endtemplate}
class PuzzleSections extends StatelessWidget {
  /// {@macro puzzle_sections}
  const PuzzleSections({Key? key, required this.resourceBundle})
      : super(key: key);

  final ResourceBundle resourceBundle;

  @override
  Widget build(BuildContext context) {
    final theme = context.select((ThemeBloc bloc) => bloc.state.theme);
    final state = context.select((PuzzleBloc bloc) => bloc.state);

    return ResponsiveLayoutBuilder(
      small: (context, child) => Column(
        children: [
          theme.layoutDelegate.startSectionBuilder(state),
          const PuzzleMenu(),
          PuzzleBoard(resourceBundle: resourceBundle),
          theme.layoutDelegate.endSectionBuilder(state),
        ],
      ),
      medium: (context, child) => Column(
        children: [
          theme.layoutDelegate.startSectionBuilder(state),
          PuzzleBoard(resourceBundle: resourceBundle),
          theme.layoutDelegate.endSectionBuilder(state),
        ],
      ),
      large: (context, child) => Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: theme.layoutDelegate.startSectionBuilder(state),
          ),
          PuzzleBoard(resourceBundle: resourceBundle),
          Expanded(
            child: theme.layoutDelegate.endSectionBuilder(state),
          ),
        ],
      ),
    );
  }
}

/// {@template puzzle_board}
/// Displays the board of the puzzle.
/// {@endtemplate}
@visibleForTesting
class PuzzleBoard extends StatelessWidget {
  /// {@macro puzzle_board}
  PuzzleBoard({
    Key? key,
    required this.resourceBundle,
  }) : super(key: key);

  final GlobalKey cloudsScreenKey = GlobalKey(debugLabel: 'cloudsScreen');
  final ResourceBundle resourceBundle;

  @override
  Widget build(BuildContext context) {
    final theme = context.select((ThemeBloc bloc) => bloc.state.theme);
    final puzzle = context.select((PuzzleBloc bloc) => bloc.state.puzzle);

    final size = puzzle.getDimension();
    if (size == 0) return const CircularProgressIndicator();

    return PuzzleKeyboardHandler(
      child: BlocListener<PuzzleBloc, PuzzleState>(
        listener: (context, state) {
          if (theme.hasTimer && state.puzzleStatus == PuzzleStatus.complete) {
            context.read<TimerBloc>().add(const TimerStopped());
          }
        },
        child: Stack(
          children: [
            theme.layoutDelegate.boardBuilder(
              size,
              puzzle.tiles
                  .map(
                    (tile) => _PuzzleTile(
                      key: Key('puzzle_tile_${tile.value.toString()}'),
                      tile: tile,
                    ),
                  )
                  .toList(),
            ),
            Positioned.fill(
              key: cloudsScreenKey,
              child: ClipRect(
                child: Opacity(
                  opacity: 1.0,
                  child: IgnorePointer(
                    child: BlocBuilder<CloudsBloc, CloudsState>(
                      builder: (context, state) {
                        return CloudsWidget(
                          resourceBundle: resourceBundle,
                          clouds: state.clouds,
                          cloudsScreenKey: cloudsScreenKey,
                          child: Container(),
                        );
                      },
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _PuzzleTile extends StatelessWidget {
  _PuzzleTile({
    Key? key,
    required this.tile,
  }) : super(key: key);

  /// The tile to be displayed.
  final Tile tile;

  @override
  Widget build(BuildContext context) {
    final theme = context.select((ThemeBloc bloc) => bloc.state.theme);
    final state = context.select((PuzzleBloc bloc) => bloc.state);

    return tile.isWhitespace
        ? theme.layoutDelegate.whitespaceTileBuilder()
        : theme.layoutDelegate.tileBuilder(
            tile,
            state,
          );
  }
}

/// {@template puzzle_menu}
/// Displays the menu of the puzzle.
/// {@endtemplate}
@visibleForTesting
class PuzzleMenu extends StatelessWidget {
  /// {@macro puzzle_menu}
  const PuzzleMenu({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        ResponsiveLayoutBuilder(
          small: (_, child) => const SizedBox(),
          medium: (_, child) => child!,
          large: (_, child) => child!,
          child: (currentSize) {
            return Row(
              children: [
                const Gap(44),
                AudioControl(
                  key: audioControlKey,
                )
              ],
            );
          },
        ),
      ],
    );
  }
}

/// {@template puzzle_menu_item}
/// Displays the menu item of the [PuzzleMenu].
/// {@endtemplate}
@visibleForTesting
class PuzzleMenuItem extends StatelessWidget {
  /// {@macro puzzle_menu_item}
  const PuzzleMenuItem({
    Key? key,
    required this.theme,
    required this.themeIndex,
  }) : super(key: key);

  /// The theme corresponding to this menu item.
  final PuzzleTheme theme;

  /// The index of [theme] in [ThemeState.themes].
  final int themeIndex;

  @override
  Widget build(BuildContext context) {
    final currentTheme = context.select((ThemeBloc bloc) => bloc.state.theme);
    final isCurrentTheme = theme == currentTheme;

    return ResponsiveLayoutBuilder(
      small: (_, child) => Column(
        children: [
          Container(
            width: 100,
            height: 40,
            decoration: isCurrentTheme
                ? BoxDecoration(
                    border: Border(
                      bottom: BorderSide(
                        width: 2,
                        color: currentTheme.menuUnderlineColor,
                      ),
                    ),
                  )
                : null,
            child: child,
          ),
        ],
      ),
      medium: (_, child) => child!,
      large: (_, child) => child!,
      child: (currentSize) {
        final leftPadding =
            themeIndex > 0 && currentSize != ResponsiveLayoutSize.small
                ? 40.0
                : 0.0;

        return Padding(
          padding: EdgeInsets.only(left: leftPadding),
          child: Tooltip(
            message:
                theme != currentTheme ? context.l10n.puzzleChangeTooltip : '',
            child: TextButton(
              style: TextButton.styleFrom(
                padding: EdgeInsets.zero,
              ).copyWith(
                overlayColor: MaterialStateProperty.all(Colors.transparent),
              ),
              onPressed: () {
                // Ignore if this theme is already selected.
                if (theme == currentTheme) {
                  return;
                }

                // Update the currently selected theme.
                context
                    .read<ThemeBloc>()
                    .add(ThemeChanged(themeIndex: themeIndex));

                // Reset the timer of the currently running puzzle.
                context.read<TimerBloc>().add(const TimerReset());

                // Stop the Dashatar countdown if it has been started.
                context.read<DashatarPuzzleBloc>().add(
                      const DashatarCountdownStopped(),
                    );

                // Initialize the puzzle board for the newly selected theme.
                context.read<PuzzleBloc>().add(
                      PuzzleInitialized(
                        shufflePuzzle: theme is SimpleTheme,
                      ),
                    );
              },
              child: AnimatedDefaultTextStyle(
                duration: PuzzleThemeAnimationDuration.textStyle,
                style: PuzzleTextStyle.headline5.copyWith(
                  color: isCurrentTheme
                      ? currentTheme.menuActiveColor
                      : currentTheme.menuInactiveColor,
                ),
                child: Text(theme.name),
              ),
            ),
          ),
        );
      },
    );
  }
}

/// The global key of [PuzzleLogo].
///
/// Used to animate the transition of [PuzzleLogo] when changing a theme.
final puzzleLogoKey = GlobalKey(debugLabel: 'puzzle_logo');

/// The global key of [PuzzleName].
///
/// Used to animate the transition of [PuzzleName] when changing a theme.
final puzzleNameKey = GlobalKey(debugLabel: 'puzzle_name');

/// The global key of [PuzzleTitle].
///
/// Used to animate the transition of [PuzzleTitle] when changing a theme.
final puzzleTitleKey = GlobalKey(debugLabel: 'puzzle_title');

/// The global key of [NumberOfMovesAndTilesLeft].
///
/// Used to animate the transition of [NumberOfMovesAndTilesLeft]
/// when changing a theme.
final numberOfMovesAndTilesLeftKey =
    GlobalKey(debugLabel: 'number_of_moves_and_tiles_left');

/// The global key of [AudioControl].
///
/// Used to animate the transition of [AudioControl]
/// when changing a theme.
final audioControlKey = GlobalKey(debugLabel: 'audio_control');
