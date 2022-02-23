import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:very_good_slide_puzzle/theme/bloc/theme_bloc.dart';

class SkyLicenseWidget extends StatelessWidget {
  const SkyLicenseWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final theme = context.select((ThemeBloc bloc) => bloc.state.theme);

    return Text(
      'Landscape Vectors by Vecteezy',
      style: TextStyle(
        color: theme.licenseTextColor,
        fontSize: 12,
      ),
    );
  }
}
