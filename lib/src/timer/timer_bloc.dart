import 'dart:async';

import 'package:flutter/material.dart';

import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';

import 'package:timer/src/ticker.dart';
import './bloc.dart';

class TimerBloc extends Bloc<TimerEvent, TimerState> {
  final BuildContext _context;
  final Ticker _ticker;

  // стартовая продолжительность таймера - 60 сек
  final int _duration = 60;

  // подписчик на поток тиков
  StreamSubscription<int> _tickerSubscription;

  TimerBloc(this._context, {@required Ticker ticker})
      : assert(ticker != null),
        _ticker = ticker;

  @override
  Future<Function> close() {
    // если подписка была, то ее отменить
    _tickerSubscription?.cancel();
    return super.close();
  }

  @override
  TimerState get initialState => Ready(_context, _duration);

  @override
  Stream<TimerState> mapEventToState(TimerEvent event,) async* {
    /// логика обработки событий
    if (event is Start) {
      yield* _mapStartToState(event);
    } else if (event is Tick) {
      yield* _mapTickToState(event);
    } else if (event is Pause) {
      yield* _mapPauseToState(event);
    } else if (event is Resume) {
      yield* _mapResumeToState(event);
    } else if (event is Reset) {
      yield* _mapResetToState(event);
    }
  }

  /// обработчик события Start
  Stream<TimerState> _mapStartToState(Start start) async* {
    // TimerBlock перевести в состояние Running
    yield Running(_context, start.duration);
    // если была подписка то отменить ее
    _tickerSubscription?.cancel();

    // слушаем поток _ticker.tick
    _tickerSubscription = _ticker
        .tick(ticks: start.duration)
    // и на каждом тике отправляем событие Tick c оставшейся продолжительностью
        .listen((duration) => add(Tick(_context, duration: duration)));
  }

  /// обработчик событий каждого тика
  Stream<TimerState> _mapTickToState(Tick tick) async* {
    yield tick.duration > 0
        // продолжим с новым значением duration
        ? Running(_context, tick.duration)
        // завершить если счетчие закончился
        : Finished(_context);
  }

  /// обработчик паузы
  Stream<TimerState> _mapPauseToState(Pause pause) async* {
    if (state is Running) {
      /// на паузу ставим только если отсчет уже запущен
      _tickerSubscription?.pause();
      yield Paused(_context, state.duration);
    }
  }

  /// восстановление отсчета после паузы
  Stream<TimerState> _mapResumeToState(Resume pause) async* {
    if (state is Paused) {
      _tickerSubscription?.resume();
      yield Running(_context, state.duration);
    }
  }

  /// обработчик события Reset
  Stream<TimerState> _mapResetToState(Reset reset) async* {
    /// отменим текущую подписку
    _tickerSubscription?.cancel();
    /// и отправим событие о готовности с исходной продолжительностью
    yield Ready(_context, _duration);
  }

}
