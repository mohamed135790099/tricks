import 'dart:async';
import 'package:flutter/material.dart';

// A simple debounce utility class that allows you to delay the execution of a function
// until a specified duration has passed since the last call.
class Debounce{
  final Duration duration;
  VoidCallback? _action;
  Timer? _timer;

  Debounce({required this.duration});

  void call(VoidCallback action) {
    _action = action;
    _timer?.cancel();
    _timer = Timer(duration, _execute);
  }

  void _execute() {
    if (_action != null) {
      _action!();
      _action = null;
    }
  }

  void cancel() {
    _timer?.cancel();
    _action = null;
  }
}

