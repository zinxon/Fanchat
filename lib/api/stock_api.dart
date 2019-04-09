import 'package:dio/dio.dart';

getStockPrice(String stockCode) async {
  var dio = Dio();
  String api = "TIR873DLX4ZC9WTV";
  String url =
      "https://www.alphavantage.co/query?function=TIME_SERIES_INTRADAY&outputsize=compact&symbol=$stockCode&interval=1min&apikey=$api";
  print(url);
  Response response = await dio.get(url);
  print(response.data);
}
