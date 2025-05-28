import 'dart:async';
import 'package:flutter/material.dart';

class Throttle {
  final Duration? duration;
  VoidCallback? _action;
  bool _isThrottled = false;
  Throttle({this.duration});

  void call(VoidCallback action) {
    if (_isThrottled) return;
    _action = action;
    _isThrottled = true;
    Future.delayed(duration ?? const Duration(seconds: 1), execute);
  }

  Future<void> execute()async{
    _isThrottled = false;
    if (_action != null) {
      _action!();
      _action = null;
    }
  }

  void cancel() {
    _isThrottled = false;
    _action = null;
  }
}

