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
    String uid = prefs.getString('uid');
    print("--------------> In UserBloc");
    print("--------------> uid: $uid");
    UserModel userModel =
        await _repository.getUserModel(prefs.getString('uid'));
    _$userModel.sink.add(userModel);
  }

  Future<void> addStock(String stockCode) async {
    prefs = await SharedPreferences.getInstance();
    String uid = prefs.getString('uid');
    print("--------------> In UserBloc");
    print("--------------> uid: $uid");
    return _repository.addStock(uid, stockCode);
  }

  dispose() {
    _$userModel.close();
  }

  BehaviorSubject<UserModel> get userModel => _$userModel;
}
