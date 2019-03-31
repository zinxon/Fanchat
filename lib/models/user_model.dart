class UserModel {
  static final UserModel _userModel = UserModel._internal();

  UserModel._internal();

  static UserModel get instance => _userModel;

  String _id;
  String _username;
  String _email;
  String _profilePicture;
  // List<_Stock> _stocklist;
  List<String> _stockList;
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
  List<String> get stockList => _stockList;
  // List<_Stock> get stocklist => _stocklist;

  factory UserModel.fromFirebase(Map<dynamic, dynamic> parsedJson) {
    _userModel._id = parsedJson['id'];
    _userModel._username = parsedJson['username'];
    _userModel._email = parsedJson['email'];
    _userModel._profilePicture = parsedJson['profilePicture'];
    _userModel._investorType = parsedJson['investorType'];
    _userModel._resultUrl = parsedJson['resultUrl'];
    _userModel._didQuiz = parsedJson['didQuiz'];
    List<String> temp = [];
    for (int i = 0; i < parsedJson['stockList'].length; i++) {
      print(parsedJson['stockList'][i].toString());
      temp.add(parsedJson['stockList'][i].toString());
    }
    _userModel._stockList = temp;
    // List<_Stock> temp = [];
    // for (int i = 0; i < parsedJson['stocklist'].length; i++) {
    //   _Stock stock = _Stock(parsedJson['stocklist'][i]);
    //   temp.add(stock);
    // }
    // _stocklist = temp;
    return _userModel;
  }
}
