import 'dart:async';
import 'package:rxdart/rxdart.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../resources/repository.dart';
import '../models/user_model.dart';
import '../models/stockData_model.dart';

class UserBloc {
  SharedPreferences prefs;
  final _repository = Repository();

  final BehaviorSubject<UserModel> _$userModel = BehaviorSubject<UserModel>();

  Future<void> getUserModel() async {
    prefs = await SharedPreferences.getInstance();
    String uid = prefs.getString('uid');
    UserModel userModel = await _repository.getUserModel(uid);
    _$userModel.sink.add(userModel);
  }

  Future<StockData> getStockData(String stockCode) async {
    return await _repository.getStockData(stockCode);
  }

  Future<void> addStock(String stockCode) async {
    prefs = await SharedPreferences.getInstance();
    String uid = prefs.getString('uid');
    return _repository.addStock(uid, stockCode);
  }

  Future<void> delStock(UserModel userModel, int index) async {
    return _repository.delStock(userModel, index);
  }

  void dispose() async {
    await _$userModel.drain();
    _$userModel.close();
  }

  BehaviorSubject<UserModel> get userModel => _$userModel;
}
