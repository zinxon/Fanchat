import 'package:dio/dio.dart';
import '../models/stockData_model.dart';

class StockDataProvider {
  final Dio _dio = Dio();

  Future<StockData> getStockData(String stockCode) async {
    try {
      final String api = "TIR873DLX4ZC9WTV";
      final String url =
          "https://www.alphavantage.co/query?function=TIME_SERIES_DAILY_ADJUSTED&outputsize=compact&symbol=$stockCode&apikey=$api";
      Response response = await _dio.get(url);
      print('url: $url');
      Map dataMap = response.data['Time Series (Daily)'];
      print('------------------------_>\n${dataMap}');
      List<TimeSeriesSale> timeList = [];
      int i = 0;
      for (var time in dataMap.keys) {
        if (i < 10) {
          DateTime dateTime = DateTime.parse(time.toString());
          double close = double.parse(dataMap[time]["4. close"]);
          TimeSeriesSale t = TimeSeriesSale(dateTime, close);
          timeList.add(t);
          print('time: $dateTime - close: $close');
        }
        i++;
      }
      StockData stockData = StockData(timeList);
      return stockData;
    } catch (error, stacktrace) {
      print("Exception occured: $error stackTrace: $stacktrace");
    }
  }
}
