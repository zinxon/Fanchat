import 'stockData_model.dart';

class Stock {
  String _stockCode;
  String _stockName;
  String _discribe;
  String _employees;
  String _industry;
  String _sector;
  String _website;
  StockData _stockData;

  Stock.fromFirebase(Map<dynamic, dynamic> parsedJson) {
    _stockCode = parsedJson['stockCode'];
    _stockName = parsedJson['name'];
    _discribe = parsedJson['discribe'];
    _employees = parsedJson['employees'];
    _industry = parsedJson['industry'];
    _sector = parsedJson['sector'];
    _website = parsedJson['website'];
  }

  set setStockData(StockData stockData) {
    _stockData = stockData;
  }

  Map<String, dynamic> toMap() {
    return {
      "stockCode": _stockCode,
      "name": _stockName,
      "discribe": _discribe,
      "employees": _employees,
      "industry": _industry,
      "sector": _sector,
      "website": _website,
    };
  }

  String get stockCode => _stockCode;
  String get stockName => _stockName;
  String get discribe => _discribe;
  String get employees => _employees;
  String get industry => _industry;
  String get sector => _sector;
  String get website => _website;
  StockData get stockData => _stockData;
}
