import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import '../models/user_model.dart';
import '../models/stock_model.dart';
import '../page/webview_page.dart';
import '../style/theme.dart' show AppColors;

UserModel _userModel = UserModel.instance;

Widget cardWidget(BuildContext context, Stock stock, bool canAdd) {
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
              title: Text('${stock.stockName} (${stock.stockCode})'),
              subtitle: Text(
                  '界別: ${stock.sector}\n行業: ${stock.industry}\n全職員工: ${stock.employees}\n描述: ${stock.discribe}'),
              trailing: canAdd
                  ? RaisedButton(
                      child: Text("加到我的關注"),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.all(Radius.circular(20.0)),
                      ),
                      textColor: Colors.white,
                      color: Colors.orange,
                      padding: const EdgeInsets.all(8.0),
                      onPressed: () {
                        try {
                          if (_userModel != null) {
                            Firestore.instance
                                .collection("users")
                                .document(_userModel.id)
                                .updateData({
                              "stockCodeList":
                                  FieldValue.arrayUnion([stock.stockCode]),
                            });
                            Fluttertoast.showToast(
                                msg: "${stock.stockCode} 已關注",
                                toastLength: Toast.LENGTH_SHORT,
                                gravity: ToastGravity.CENTER,
                                timeInSecForIos: 1,
                                backgroundColor: Colors.blueGrey,
                                textColor: Colors.white,
                                fontSize: 14.0);
                          }
                        } catch (e) {
                          print(e);
                        }
                      },
                    )
                  : null,
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
                  _raisedButton(context, stock, {'財務報表': 'financials'}),
                  _raisedButton(context, stock, {'持股人': 'holders'}),
                  _raisedButton(context, stock, {'統計資料': 'key-statistics'}),
                  _raisedButton(context, stock, {'新聞': 'news'})
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

Widget _raisedButton(
    BuildContext context, Stock stock, Map<String, String> map) {
  return RaisedButton(
    child: Text(map.keys.toList()[0]),
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.all(Radius.circular(20.0)),
    ),
    textColor: Colors.white,
    color: Colors.orange,
    padding: const EdgeInsets.all(8.0),
    onPressed: () {
      goToWeb(context, stock, map.values.toList()[0]);
    },
  );
}
