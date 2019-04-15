import 'firestore_provider.dart';
import '../models/stockData_model.dart';
import '../models/user_model.dart';
import '../api/stock_api.dart';

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

  Future<UserModel> getUserModel(String uid) =>
      _firestoreProvider.getUserModel(uid);

  Future<void> addStock(String uid, String stockCode) =>
      _firestoreProvider.addStock(uid, stockCode);

  Future<void> delStock(UserModel userModel, int index) =>
      _firestoreProvider.delStock(userModel, index);
}
