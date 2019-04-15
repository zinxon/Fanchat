import 'package:dio/dio.dart';
import '../models/stockData_model.dart';

class StockDataProvider {
  final Dio _dio = Dio();

  // getStockPrice(String stockCode) async {
  //   var dio = Dio();
  //   String api = "TIR873DLX4ZC9WTV";
  //   String url =
  //       "https://www.alphavantage.co/query?function=TIME_SERIES_INTRADAY&outputsize=compact&symbol=$stockCode&interval=1min&apikey=$api";
  //   print(url);
  //   Response response = await dio.get(url);
  //   print(response.data);
  // }

  Future<StockData> getStockData(String stockCode) async {
    try {
      final String api = "TIR873DLX4ZC9WTV";
      final String url =
          "https://www.alphavantage.co/query?function=TIME_SERIES_INTRADAY&outputsize=compact&symbol=$stockCode&interval=1min&apikey=$api";
      Response response = await _dio.get(url);
      Map dataMap = response.data['Time Series (1min)'];
      // print('${dataMap}');
      List<TimeSeriesSale> timeList = [];
      for (var time in dataMap.keys) {
        DateTime dateTime = DateTime.parse(time.toString());
        double close = double.parse(dataMap[time]["4. close"]);
        TimeSeriesSale t = TimeSeriesSale(dateTime, close);
        timeList.add(t);
        print('time: $dateTime - close: $close');
      }
      StockData stockData = StockData(timeList);
      print('$stockData is create');
      return stockData;
    } catch (error, stacktrace) {
      print("Exception occured: $error stackTrace: $stacktrace");
    }
  }
}
