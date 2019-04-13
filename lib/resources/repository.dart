import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/stockData_model.dart';
import '../api/stock_api.dart';
import 'firestore_provider.dart';

class Repository {
  StockDataProvider _apiProvider = StockDataProvider();
  final _firestoreProvider = FirestoreProvider();

  Future<StockData> getStockData(String stockCode) {
    return _apiProvider.getStockData(stockCode);
  }

  Future<void> signInWithEmailAndPassword(String email, String password) =>
      _firestoreProvider.signInWithEmailAndPassword(email, password);

  Future<void> signInWithGoogle() => _firestoreProvider.signInWithGoogle();

  Future<int> signUp(String email, String password) =>
      _firestoreProvider.signUp(email, password);

  Future<DocumentSnapshot> getUserModel() => _firestoreProvider.getUserModel();
}
