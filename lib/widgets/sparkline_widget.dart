import 'package:charts_flutter/flutter.dart' as charts;
import 'package:flutter/material.dart';

import '../models/stockData_model.dart';

class TimeSeriesChart extends StatefulWidget {
  List<TimeSeriesSale> timeSeries;
  bool animate;

  TimeSeriesChart(this.timeSeries, this.animate);

  @override
  _TimeSeriesChartState createState() =>
      _TimeSeriesChartState(this.timeSeries, this.animate);
}

class _TimeSeriesChartState extends State<TimeSeriesChart> {
  List<TimeSeriesSale> timeSeries;
  bool animate;
  DateTime _time;
  Map<String, num> _measures;

  _TimeSeriesChartState(this.timeSeries, this.animate);

  List<charts.Series<TimeSeriesSale, DateTime>> _createStockData() {
    return [
      new charts.Series<TimeSeriesSale, DateTime>(
        id: 'Price',
        colorFn: (_, __) => charts.MaterialPalette.blue.shadeDefault,
        domainFn: (TimeSeriesSale sales, _) => sales.time,
        measureFn: (TimeSeriesSale sales, _) => sales.sales,
        data: timeSeries,
      )
    ];
  }

  _onSelectionChanged(charts.SelectionModel model) {
    final selectedDatum = model.selectedDatum;

    DateTime time;
    final measures = <String, num>{};

    // We get the model that updated with a list of [SeriesDatum] which is
    // simply a pair of series & datum.
    //
    // Walk the selection updating the measures map, storing off the sales and
    // series name for each selection point.
    if (selectedDatum.isNotEmpty) {
      time = selectedDatum.first.datum.time;
      selectedDatum.forEach((charts.SeriesDatum datumPair) {
        measures[datumPair.series.displayName] = datumPair.datum.sales;
      });
    }

    // Request a build.
    setState(() {
      _time = time;
      _measures = measures;
    });
  }

  @override
  Widget build(BuildContext context) {
    List<num> salesList = [];
    for (var item in timeSeries) {
      salesList.add(item.sales);
    }
    // The children consist of a Chart and Text widgets below to hold the info.
    final children = <Widget>[
      SizedBox(
          height: 80.0,
          child: charts.TimeSeriesChart(
            _createStockData(),
            animate: animate,
            dateTimeFactory: const charts.LocalDateTimeFactory(),
            primaryMeasureAxis: charts.NumericAxisSpec(
                tickProviderSpec: charts.NumericEndPointsTickProviderSpec(),
                viewport: charts.NumericExtents.fromValues(salesList)),
            behaviors: [
              new charts.LinePointHighlighter(
                  showHorizontalFollowLine:
                      charts.LinePointHighlighterFollowLineType.none,
                  showVerticalFollowLine:
                      charts.LinePointHighlighterFollowLineType.nearest),
              new charts.SelectNearest(
                  eventTrigger: charts.SelectionTrigger.tapAndDrag),
              charts.PanAndZoomBehavior(),
              // charts.LinePointHighlighter(
              //     showHorizontalFollowLine:
              //         charts.LinePointHighlighterFollowLineType.none,
              //     showVerticalFollowLine:
              //         charts.LinePointHighlighterFollowLineType.nearest),
              // charts.SelectNearest(
              //     eventTrigger: charts.SelectionTrigger.tapAndDrag)
            ],
            selectionModels: [
              charts.SelectionModelConfig(
                type: charts.SelectionModelType.info,
                changedListener: _onSelectionChanged,
              )
            ],
          )),
    ];

    // If there is a selection, then include the details.
    if (_time != null) {
      children.add(Padding(
          padding: EdgeInsets.only(top: 5.0),
          child: Text(_time.toString().split(' ')[0])));
    }
    _measures?.forEach((String series, num value) {
      children.add(Text(
        '${series}: \$${value}',
        style: TextStyle(fontSize: 15),
      ));
    });

    return Column(children: children);
  }
}
