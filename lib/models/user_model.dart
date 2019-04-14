import 'stock_model.dart';

class UserModel {
  static final UserModel _userModel = UserModel._internal();

  UserModel._internal();

  static UserModel get instance => _userModel;

  String _id;
  String _username;
  String _email;
  String _profilePicture;
  List<Stock> _stockList = [];
  String _investorType;
  String _resultUrl;
  bool _didQuiz;

  String get id => _id;
  String get username => _username;
  String get email => _email;
  String get profilePicture => _profilePicture;
  String get investorType => _investorType;
  String get resultUrl => _resultUrl;
  bool get didQuiz => _didQuiz;
  List<Stock> get stockList => _stockList;

  factory UserModel.fromFirebase(Map<dynamic, dynamic> parsedJson) {
    _userModel._id = parsedJson['id'];
    _userModel._username = parsedJson['username'];
    _userModel._email = parsedJson['email'];
    _userModel._profilePicture = parsedJson['profilePicture'];
    _userModel._investorType = parsedJson['investorType'];
    _userModel._resultUrl = parsedJson['resultUrl'];
    _userModel._didQuiz = parsedJson['didQuiz'];
    List<Stock> temp = [];
    for (int i = 0; i < parsedJson['stockList'].length; i++) {
      Stock stock = Stock.fromFirebase(parsedJson['stockList'][i]);
      temp.add(stock);
    }
    _userModel._stockList = temp;
    return _userModel;
  }
}
