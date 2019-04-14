class Stock {
  String _stockCode;
  String _stockName;
  String _discribe;
  String _employees;
  String _industry;
  String _sector;
  String _website;

  Stock.fromFirebase(Map<dynamic, dynamic> parsedJson) {
    _stockCode = parsedJson['stockCode'];
    _stockName = parsedJson['stockName'];
    _discribe = parsedJson['discribe'];
    _employees = parsedJson['employeese'];
    _industry = parsedJson['industry'];
    _sector = parsedJson['sector'];
    _website = parsedJson['website'];
  }

  String get stockCode => _stockCode;
  String get stockName => _stockName;
  String get discribe => _discribe;
  String get employees => _employees;
  String get industry => _industry;
  String get sector => _sector;
  String get website => _website;
}
