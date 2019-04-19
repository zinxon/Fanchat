class StockDataList {
  List<StockData> _stockDataList = [];
  StockDataList(this._stockDataList);

  List<StockData> get stockDataList => _stockDataList;
}

class StockData {
  List<TimeSeriesSale> _stockData = [];
  StockData(this._stockData);

  List<TimeSeriesSale> get stockData => _stockData;
}

class TimeSeriesSale {
  final DateTime time;
  final double sales;

  TimeSeriesSale(this.time, this.sales);

  // double get sales => _sales;
  // DateTime get time => _time;
}
