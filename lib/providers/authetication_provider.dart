import 'package:firebase_auth/firebase_auth.dart';
import 'package:gameslati/providers/base_provider.dart';

class AutheticationProvider extends BaseProvider {
  FirebaseAuth firebaseAuth = FirebaseAuth.instance;

  bool loading = false;

  Future<bool> login(String email, String password) async {
    setBusy(true);
    UserCredential userCred = await firebaseAuth.signInWithEmailAndPassword(
        email: email, password: password);
    if (userCred.user != null) {
      setBusy(false);
      return true;
    } else {
      setBusy(false);
      return true;
    }
  }

  Future<bool> createAccount(String email, String password) async {
    UserCredential usercred = await firebaseAuth.createUserWithEmailAndPassword(
        email: email, password: password);
    if (usercred.user != null) {
      return true;
    } else {
      return false;
    }
  }

  Future<bool> logout() async {
    firebaseAuth.signOut();
    return true;
  }
}
