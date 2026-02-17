import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../models/user_model.dart';

class AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _db = FirebaseFirestore.instance;

  Future<String?> registerUser(UserModel user, String password) async {
    try {
      final result = await _auth.createUserWithEmailAndPassword(
          email: user.email!, password: password);

      user.id = result.user!.uid;
      await _db.collection('Users').doc(user.id).set(user.toMap());
      return null; // success
    } on FirebaseAuthException catch (e) {
      return e.message;
    }
  }

  Future<String?> login(String email, String password) async {
    try {
      await _auth.signInWithEmailAndPassword(email: email, password: password);
      return null; // success
    } on FirebaseAuthException catch (e) {
      return e.message;
    }
  }

  Future<void> logout() async {
    await _auth.signOut();
  }

  Future<String?> getUserRole() async {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) return null;

    final doc = await FirebaseFirestore.instance.collection("Users").doc(user.uid).get();
    return doc.data()?["role"]; // trả về admin/user/doctor/expert
  }

  Future<String?> sendPasswordResetEmail(String email) async {
    try {
      await _auth.sendPasswordResetEmail(email: email);
      return null; // Thành công
    } on FirebaseAuthException catch (e) {
      if (e.code == 'user-not-found') {
        return 'Email này chưa được đăng ký.';
      } else if (e.code == 'invalid-email') {
        return 'Địa chỉ email không hợp lệ.';
      }
      return e.message; // Các lỗi khác
    }
  }

  Stream<User?> get userChanges => _auth.userChanges();
}
