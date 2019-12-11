import 'package:flutter/material.dart';

import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:timer/src/timer/bloc.dart';

/// Widget с кнопками управления
/// меняет кнопки в зависимости от текущего состояния TimerBloc счетчика
class Actions extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: _mapStateToActionButtons(
        context: context,
        timerBloc: BlocProvider.of<TimerBloc>(context),
      ),
    );
  }

  List<Widget> _mapStateToActionButtons({
    BuildContext context,
    TimerBloc timerBloc,
  }) {
    final TimerState currentState = timerBloc.state;
    if (currentState is Ready) {
      return [
        FloatingActionButton(
          child: Icon(Icons.play_arrow),
          onPressed: () =>
              timerBloc.add(Start(context, duration: currentState.duration)),
        ),
      ];
    }
    if (currentState is Running) {
      return [
        _btnPause(context),
        _btnReset(context),
      ];
    }
    if (currentState is Paused) {
      return [
        _btnResume(context),
        _btnReset(context),
      ];
    }
    if (currentState is Finished) {
      return [
        _btnReset(context),
      ];
    }
    return [];
  }

  FloatingActionButton _btnPause(BuildContext context) {
    return FloatingActionButton(
      child: Icon(Icons.pause),
      onPressed: () => BlocProvider.of<TimerBloc>(context).add(Pause(context)),
    );
  }

  FloatingActionButton _btnReset(BuildContext context) {
    return FloatingActionButton(
      child: Icon(Icons.replay),
      onPressed: () => BlocProvider.of<TimerBloc>(context).add(Reset(context)),
    );
  }

  FloatingActionButton _btnResume(BuildContext context) {
    return FloatingActionButton(
      child: Icon(Icons.play_arrow),
      onPressed: () => BlocProvider.of<TimerBloc>(context).add(Resume(context)),
    );
  }
}
