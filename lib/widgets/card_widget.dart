import 'package:flutter/material.dart';
import '../models/stock_model.dart';
import '../page/webview_page.dart';
import '../style/theme.dart' show AppColors;

Widget cardWidget(BuildContext context, Stock stock) {
  return Card(
    color: AppColors.greyColor2,
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.all(Radius.circular(10.0)),
    ),
    child: Column(
      mainAxisSize: MainAxisSize.min,
      children: <Widget>[
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            ListTile(
              // leading: Icon(Icons.album),
              title: Text('${stock.stockName} (${stock.stockCode})'),
              subtitle: Text(
                  '界別: ${stock.sector}\n行業: ${stock.industry}\n全職員工: ${stock.employees}\n描述: ${stock.discribe}'),
            ),
            GestureDetector(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => WebViewPage(
                            url: stock.website,
                            isBack: true,
                            title: stock.stockName,
                          )),
                );
              },
              child: Container(
                margin: const EdgeInsets.only(left: 16.0),
                child: Text.rich(TextSpan(
                  children: [
                    TextSpan(text: '公司網頁: '),
                    TextSpan(
                        text: '${stock.website}',
                        style: TextStyle(
                          color: Colors.blueAccent,
                          decoration: TextDecoration.underline,
                        ))
                  ],
                )),
              ),
            ),
            ButtonTheme.bar(
              child: ButtonBar(
                alignment: MainAxisAlignment.center,
                children: <Widget>[
                  RaisedButton(
                    child: const Text('財務報表'),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.all(Radius.circular(20.0)),
                    ),
                    textColor: Colors.white,
                    color: Colors.orange,
                    padding: const EdgeInsets.all(8.0),
                    onPressed: () {
                      goToWeb(context, stock, "financials");
                    },
                  ),
                  RaisedButton(
                    child: const Text('持股人'),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.all(Radius.circular(20.0)),
                    ),
                    textColor: Colors.white,
                    color: Colors.orange,
                    padding: const EdgeInsets.all(8.0),
                    onPressed: () {
                      goToWeb(context, stock, "news");
                    },
                  ),
                  RaisedButton(
                    child: const Text('統計資料'),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.all(Radius.circular(20.0)),
                    ),
                    textColor: Colors.white,
                    color: Colors.orange,
                    padding: const EdgeInsets.all(8.0),
                    onPressed: () {
                      goToWeb(context, stock, "key-statistics");
                    },
                  ),
                  RaisedButton(
                    child: const Text('新聞'),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.all(Radius.circular(20.0)),
                    ),
                    textColor: Colors.white,
                    color: Colors.orange,
                    padding: const EdgeInsets.all(8.0),
                    onPressed: () {
                      goToWeb(context, stock, "news");
                    },
                  ),
                ],
              ),
            )
          ],
        ),
      ],
    ),
  );
}

void goToWeb(BuildContext context, Stock stock, String type) {
  Navigator.push(
    context,
    MaterialPageRoute(
        builder: (context) => WebViewPage(
              url:
                  "https://hk.finance.yahoo.com/quote/${stock.stockCode}/$type?p=${stock.stockCode}",
              isBack: true,
              title: stock.stockName,
            )),
  );
}
// .replaceFirstMapped('http', (m) {
//                               return 'https';
//                             })
