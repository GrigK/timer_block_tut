import 'package:flutter/material.dart';

import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:timer/generated/i18n.dart';
import 'package:timer/src/theme_block.dart';
import 'package:timer/src/timer/bloc.dart';
import 'package:timer/src/widgets/actions.dart' as myAction;
import 'package:timer/src/widgets/background.dart';

class TimerPage extends StatelessWidget {
  static const TextStyle timerTextStyle = TextStyle(
    fontSize: 60,
    fontWeight: FontWeight.bold,
  );

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(S.of(context).title),
        actions: <Widget>[
          IconButton(
              icon: Icon(Icons.brightness_medium),
              onPressed: () {
                // Используем глобальный BLoC (смена темы)
                BlocProvider.of<ThemeBloc>(context).add(ThemeEvent.toggle);
              }),
          SizedBox(
            width: 16.0,
          )
        ],
      ),
      body: Stack(
        children: <Widget>[
          Background(),
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              Padding(
                padding: EdgeInsets.symmetric(vertical: 100.0),
                child: Center(
                  child: _clockCounter(context),
                ),
              ),
              _actionButtons(context)
            ],
          ),
        ],
      ),
    );
  }

  Widget _clockCounter(BuildContext context) {
    return BlocBuilder<TimerBloc, TimerState>(
      builder: (context, state) {
        final String minutesStr =
            ((state.duration / 60) % 60).floor().toString().padLeft(2, '0');
        final String secondsStr =
            (state.duration % 60).floor().toString().padLeft(2, '0');
        return Text(
          '$minutesStr:$secondsStr',
          style: TimerPage.timerTextStyle,
        );
      },
    );
  }

  Widget _actionButtons(BuildContext context) {
    return BlocBuilder<TimerBloc, TimerState>(
      /// виджет будет перестроен только при изменении state
      /// т.е. если  previousState != state будет вызван компоновщик builder
      condition: (previousState, state) =>
          state.runtimeType != previousState.runtimeType,
      builder: (context, state) => myAction.Actions(),
    );
  }
}
