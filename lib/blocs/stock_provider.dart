import 'package:flutter/material.dart';
import 'stock_bloc.dart';
export 'stock_bloc.dart';

class StockBlocProvider extends InheritedWidget {
  final bloc = StockBloc();

  StockBlocProvider({Key key, Widget child}) : super(key: key, child: child);

  bool updateShouldNotify(_) => true;

  static StockBloc of(BuildContext context) {
    return (context.inheritFromWidgetOfExactType(StockBlocProvider)
            as StockBlocProvider)
        .bloc;
  }
}
