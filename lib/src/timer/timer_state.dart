import 'package:flutter/material.dart';

import 'package:equatable/equatable.dart';
import 'package:timer/generated/i18n.dart';


/// в Таймер всегда должен знать время [duration]
/// [context] нужен для перевода
abstract class TimerState extends Equatable {
  final int duration;
  final BuildContext context;

  const TimerState(this.context, this.duration);

  @override
  List<Object> get props  => [duration];
}

/// Ready — таймер готов начать отсчет указанного времени.
/// (пользователь может запустить таймер)
class Ready extends TimerState {
  Ready(BuildContext context, int duration) : super(context, duration);

  @override
  String toString() => S.of(context).ready(duration.toString());
}

/// Paused — приостановлено.
/// (пользователь сможет возобновить таймер и сбросить таймер)
class Paused extends TimerState {
  Paused(BuildContext context, int duration) : super(context, duration);

  @override
  String toString() => S.of(context).paused(duration.toString());
}

/// Running — идет отсчет.
/// (пользователь сможет приостановить и сбросить таймер, а также
/// увидеть оставшуюся продолжительность)
class Running extends TimerState {
  Running(BuildContext context, int duration) : super(context, duration);

  @override
  String toString() => S.of(context).running(duration.toString());
}

/// Отсчет завершен, таймер обнулен
/// (пользователь сможет сбросить таймер)
class Finished extends TimerState{
  Finished(BuildContext context) : super(context, 0);
}
