import 'package:flutter/material.dart';

import 'package:bloc/bloc.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:timer/generated/i18n.dart';
import 'package:timer/src/timer/bloc.dart';


class TimerPage extends StatelessWidget {
  static const TextStyle timerTextStyle = TextStyle(
    fontSize: 60,
    fontWeight: FontWeight.bold,
  );

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(S.of(context).title)),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          Padding(
            padding: EdgeInsets.symmetric(vertical: 100.0),
            child: Center(
              child: clockCounter(context),
            ),
          ),
        ],
      ),
    );
  }

  Widget clockCounter(BuildContext context){
    return BlocBuilder<TimerBloc, TimerState>(
      builder: (context, state) {
        final String minutesStr = ((state.duration / 60) % 60)
            .floor()
            .toString()
            .padLeft(2, '0');
        final String secondsStr =
        (state.duration % 60).floor().toString().padLeft(2, '0');
        return Text(
          '$minutesStr:$secondsStr',
          style: TimerPage.timerTextStyle,
        );
      },
    );
  }
}
