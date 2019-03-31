class _Stock {
  String _stockCode;
  String _stockName;
  String _discribe;
  String _employees;
  String _industry;
  String _sector;
  String _website;

  _Stock(stock) {
    _stockCode = stock['stockCode'];
    _stockName = stock['name'];
    _discribe = stock['discribe'];
    _employees = stock['employeese'];
    _industry = stock['industry'];
    _sector = stock['sector'];
    _website = stock['website'];
  }

  String get stockCode => _stockCode;
  String get stockName => _stockName;
  String get discribe => _discribe;
  String get employees => _employees;
  String get industry => _industry;
  String get sector => _sector;
  String get website => _website;
}
