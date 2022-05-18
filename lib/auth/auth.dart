import 'package:firebase_auth/firebase_auth.dart';

class AuthService {
  static Future signInAnon() async {
    try {
      await FirebaseAuth.instance.signInAnonymously();

      return true;
    } on FirebaseAuthException catch (e) {
      switch (e.code) {
        case "operation-not-allowed":
          return false;
        default:
          return false;
      }
    }
  }
}
