import 'package:dio/dio.dart';

getStockNew(String stockCode) async {
  var dio = Dio();
  String url =
      "https://hk.finance.yahoo.com/quote/$stockCode/profile?p=$stockCode";
  print(url);
  Response response = await dio.get(url);
  print(response.data);
}
