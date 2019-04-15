import 'dart:async';
import 'package:rxdart/rxdart.dart';
// import 'package:shared_preferences/shared_preferences.dart';

import '../resources/repository.dart';
import '../models/stock_model.dart';
import '../models/stockData_model.dart';

class StockBloc {
  final _repository = Repository();
  final BehaviorSubject<StockDataList> _$stockDataList =
      BehaviorSubject<StockDataList>();

  Future<StockData> getStockData(String stockCode) async {
    return await _repository.getStockData(stockCode);
  }

  void dispose() async {
    await _$stockDataList.drain();
    _$stockDataList.close();
  }

  BehaviorSubject<StockDataList> get stockDataList => _$stockDataList;
}
