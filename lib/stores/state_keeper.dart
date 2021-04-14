import 'package:flutter/material.dart';

class StateKeeper extends ChangeNotifier {
  Map<String, dynamic> data = <String, dynamic>{};
  Map<String, Status> status = {"main": Status.Idle};
  Map<String, String> error = {};

  setStatus(String function, Status _status) {
    this.status[function] = _status;
    notifyListeners();
  }

  setData(String function, dynamic _data) {
    this.data[function] = _data;
    notifyListeners();
  }

  setError(String function, String _error, [Status _status]) {
    if (_error != null) {
      error[function] = _error;
      status[function] = Status.Error;
    } else {
      this.error[function] = null;
      this.status[function] = _status ?? Status.Idle;
    }
    notifyListeners();
  }

  reset(String function) {
    this.data[function] = Status.Idle;
    this.error?.remove(function);
    this.status?.remove(function);
  }

  resetHard() {
    this.data = <String, dynamic>{};
    this.status = {"main": Status.Idle};
    this.error = {};
  }

  notify() {
    notifyListeners();
  }
}

enum Status {
  Idle,
  Loading,
  Done,
  Error,
}
