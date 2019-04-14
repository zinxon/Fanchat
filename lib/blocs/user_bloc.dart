import 'dart:async';
import 'package:rxdart/rxdart.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../resources/repository.dart';
import '../models/user_model.dart';

class UserBloc {
  SharedPreferences prefs;
  final _repository = Repository();

  final BehaviorSubject<UserModel> _$userModel = BehaviorSubject<UserModel>();

  Future<void> getUserModel() async {
    prefs = await SharedPreferences.getInstance();
    print("--------------> In UserBloc");
    print("--------------> uid: ${prefs.getString('uid')}");
    UserModel userModel =
        await _repository.getUserModel(prefs.getString('uid'));
    _$userModel.sink.add(userModel);
  }

  dispose() {
    _$userModel.close();
  }

  BehaviorSubject<UserModel> get userModel => _$userModel;
}
