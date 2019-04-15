class StockDataList {
  List<StockData> _stockDataList = [];
  StockDataList(this._stockDataList);

  List<StockData> get stockDataList => _stockDataList;
}

class StockData {
  List<TimeSeriesSale> _stockdata = [];
  StockData(this._stockdata);

  List<TimeSeriesSale> get stockdata => _stockdata;
}

class TimeSeriesSale {
  final DateTime time;
  final double sales;

  TimeSeriesSale(this.time, this.sales);
}
