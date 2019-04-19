import 'package:dio/dio.dart';
import '../models/stockData_model.dart';
import '../models/user_model.dart';

class StockDataProvider {
  final Dio _dio = Dio();

  Future<StockData> getStockData(String stockCode, String api) async {
    try {
      final String url =
          "https://www.alphavantage.co/query?function=TIME_SERIES_DAILY_ADJUSTED&outputsize=compact&symbol=$stockCode&apikey=$api";
      Response response = await _dio.get(url);
      print('url: $url\nresponse code: ${response.statusCode}');

      Map dataMap = response.data['Time Series (Daily)'];
      print('------------------------>\n${dataMap}');
      if (dataMap == null) {
        print(response.data);
        // getStockData(stockCode, api);
      }
      List<TimeSeriesSale> timeList = [];
      int i = 0;
      for (var time in dataMap.keys) {
        if (i < 10) {
          DateTime dateTime = DateTime.parse(time.toString());
          double close = double.parse(dataMap[time]["4. close"]);
          TimeSeriesSale t = TimeSeriesSale(dateTime, close);
          timeList.add(t);
          print('[$i] time: $dateTime - close: $close');
        }
        i++;
      }
      // dataMap.keys.forEach((item) async {
      //   // if (i < 10) {
      //   DateTime dateTime = await DateTime.parse(item.toString());
      //   double close = await double.parse(dataMap[item]["4. close"]);
      //   TimeSeriesSale t = TimeSeriesSale(dateTime, close);
      //   timeList.add(t);
      //   print('[$i] time: $dateTime - close: $close');
      //   // }
      //   i++;
      // });
      StockData stockData = StockData(timeList);
      return stockData;
    } catch (error, stacktrace) {
      print("Exception occured: $error stackTrace: $stacktrace");
    }
  }

  Future<UserModel> updateStockDataList(UserModel userModel) async {
    List<String> apiList = ['TIR873DLX4ZC9WTV', '4DUZ3TRQ9N8UUSXO'];
    for (int i = 0; i < userModel.stockList.length; i++) {
      StockData stockData =
          await getStockData(userModel.stockList[i].stockCode, apiList[i % 2]);
      userModel.stockList[i].setStockData = stockData;
    }
    // for (var item in userModel.stockList) {
    //   StockData stockData = await getStockData(item.stockCode, apiList[0]);
    //   item.setStockData = stockData;
    // }
    // userModel.stockList.forEach((item) async {
    //   StockData stockData = await getStockData(item.stockCode);
    //   item.setStockData = stockData;
    // });
    return userModel;
  }
}
