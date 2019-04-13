import 'dart:async';
import 'package:rxdart/rxdart.dart';
import 'package:firebase_auth/firebase_auth.dart';

import '../utils/strings.dart';
import '../resources/repository.dart';

class LoginBloc {
  final _repository = Repository();
  final _email = BehaviorSubject<String>();
  final _password = BehaviorSubject<String>();

  Observable<String> get email => _email.stream.transform(_validateEmail);

  Observable<String> get password =>
      _password.stream.transform(_validatePassword);

  String get emailAddress => _email.value;

  // Change data
  Function(String) get changeEmail => _email.sink.add;

  Function(String) get changePassword => _password.sink.add;

  final _validateEmail =
      StreamTransformer<String, String>.fromHandlers(handleData: (email, sink) {
    if (email.contains('@')) {
      sink.add(email);
    } else {
      sink.addError(StringConstant.emailValidateMessage);
    }
  });

  final _validatePassword = StreamTransformer<String, String>.fromHandlers(
      handleData: (password, sink) {
    if (password.length > 3) {
      sink.add(password);
    } else {
      sink.addError(StringConstant.passwordValidateMessage);
    }
  });

  Future<int> submit() {
    return _repository.signInWithEmailAndPassword(
        _email.value, _password.value);
  }

  Future<int> signUp() {
    return _repository.signUp(_email.value, _password.value);
  }

  Future<void> signInWithEmailAndPassword() {
    return _repository.signInWithEmailAndPassword(
        _email.value, _password.value);
  }

  Future<FirebaseUser> signInWithGoogle() {
    return _repository.signInWithGoogle();
  }

  void dispose() async {
    await _email.drain();
    _email.close();
    await _password.drain();
    _password.close();
  }

  bool validateFields() {
    if (_email.value != null &&
        _email.value.isNotEmpty &&
        _password.value != null &&
        _password.value.isNotEmpty &&
        _email.value.contains('@') &&
        _password.value.length > 3) {
      return true;
    } else {
      return false;
    }
  }
}