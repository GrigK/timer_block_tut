import 'package:flutter/material.dart';

import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';

import 'package:timer/generated/i18n.dart';

/// События таймера
/// [context] нужен для перевода
abstract class TimerEvent extends Equatable {
  final BuildContext context;

  const TimerEvent(this.context);

  @override
  List<Object> get props => [];
}

/// событие о начале отсчета
class Start extends TimerEvent {
  final int duration;

  const Start(BuildContext context, {@required this.duration}) : super(context);

  @override
  String toString() => S.of(context).eventStart(duration.toString());
}

/// событие о постановке на паузу
class Pause extends TimerEvent {
  Pause(BuildContext context) : super(context);
}

/// событие о возобновлении отсчета
class Resume extends TimerEvent {
  Resume(BuildContext context) : super(context);
}

/// событие о сбросе счетчика
class Reset extends TimerEvent {
  Reset(BuildContext context) : super(context);
}

/// событие о том, что пришел Tic и надо обновить состояние TimerBloc
class Tick extends TimerEvent {
  final int duration;

  Tick(BuildContext context, {@required this.duration}) : super(context);

  @override
  List<Object> get props => [duration];

  @override
  String toString() => S.of(context).eventTick(duration.toString());
}
