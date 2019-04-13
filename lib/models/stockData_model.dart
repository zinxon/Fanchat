class StockData {
  String interval;
  String symbol;
  String timeSeries_1min;
  StockData(this.interval, this.symbol, this.timeSeries_1min);

  StockData.fromJson(Map<String, dynamic> json)
      : symbol = json["Meta Data"]['2. Symbol'],
        interval = json["Meta Data"]['4. Interval'],
        timeSeries_1min = json["Time Series (1min)"];

  // factory StockData.fromJson(Map<String, dynamic> json) =>
  //     _$StockDataFromJson(json);

  // Map<String, dynamic> toJson() => _$StockDataToJson(this);
}
