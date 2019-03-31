import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/user_model.dart';
import 'package:shared_preferences/shared_preferences.dart';

SharedPreferences preferences;

class FirestoreProvider {
  Firestore _firestore = Firestore.instance;

  Future<DocumentSnapshot> getUserModel() async {
    var preferences = await SharedPreferences.getInstance();
    String _id = preferences.getString('id');
    // final QuerySnapshot result = await _firestore
    //     .collection("users")
    //     .where("id", isEqualTo: _id)
    //     .getDocuments();
    // final List<DocumentSnapshot> docs = result.documents;
    final DocumentSnapshot snapshot =
        await _firestore.collection("users").document(_id).get();

    print(snapshot);
    return snapshot;
  }
}
