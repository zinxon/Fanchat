import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import '../widgets/sparkline_widget.dart';
import '../models/stockData_model.dart';
import '../resources/repository.dart';

Widget myHiddenContainer(BuildContext context) {
  return Container(
    height: MediaQuery.of(context).size.height,
    color: Colors.orange,
    child: Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: <Widget>[
        Align(
          alignment: Alignment.centerLeft,
          child: IconButton(
            icon: Icon(FontAwesomeIcons.solidTrashAlt),
            color: Colors.white,
            onPressed: () {},
          ),
        ),
      ],
    ),
  );
}

Widget myListContainer(String stockName, String stockCode) {
  return Padding(
    padding: const EdgeInsets.all(8.0),
    child: Container(
      height: 140.0,
      child: Material(
        color: Colors.white,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(20.0)),
        ),
        elevation: 14.0,
        shadowColor: Color(0x802196F3),
        child: Container(
          child: Row(
            children: <Widget>[
              Container(
                height: 100.0,
                width: 10.0,
                color: Colors.orange,
              ),
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: <Widget>[
                      Row(
                        children: <Widget>[
                          Text(stockName,
                              style: TextStyle(
                                  fontSize: 24.0,
                                  color: Colors.black,
                                  fontWeight: FontWeight.bold)),
                          Container(
                            margin: EdgeInsets.only(left: 50),
                            child: Text('($stockCode)',
                                style: TextStyle(
                                    fontSize: 18.0, color: Colors.blueAccent)),
                          )
                        ],
                      ),
                      Container(
                        height: 80,
                        child: SimpleTimeSeriesChart.withSampleData(),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    ),
  );
}
