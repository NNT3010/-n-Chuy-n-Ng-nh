import 'package:cloud_firestore/cloud_firestore.dart';

/// FirestoreService: lớp trung gian giữa Firestore và Model
class FirestoreService {
  final FirebaseFirestore _db = FirebaseFirestore.instance;

  /// 🩷 Thêm 1 document (auto hoặc custom ID)
  Future<void> addDocument({
    required String collectionPath,
    required Map<String, dynamic> data,
    String? docId,
  }) async {
    try {
      final collection = _db.collection(collectionPath);
      if (docId != null) {
        await collection.doc(docId).set(_convertDates(data));
      } else {
        await collection.add(_convertDates(data));
      }
    } catch (e) {
      print('❌ [FirestoreService] Lỗi khi thêm document vào $collectionPath: $e');
      rethrow;
    }
  }

  /// 🩷 Cập nhật document
  Future<void> updateDocument({
    required String collectionPath,
    required String docId,
    required Map<String, dynamic> data,
  }) async {
    try {
      await _db.collection(collectionPath).doc(docId).update(_convertDates(data));
    } catch (e) {
      print('❌ [FirestoreService] Lỗi khi cập nhật $collectionPath/$docId: $e');
      rethrow;
    }
  }

  /// 🩷 Xóa document
  Future<void> deleteDocument({
    required String collectionPath,
    required String docId,
  }) async {
    try {
      await _db.collection(collectionPath).doc(docId).delete();
    } catch (e) {
      print('❌ [FirestoreService] Lỗi khi xóa $collectionPath/$docId: $e');
      rethrow;
    }
  }

  /// 🩷 Lấy document theo ID
  Future<Map<String, dynamic>?> getDocument({
    required String collectionPath,
    required String docId,
  }) async {
    try {
      final doc = await _db.collection(collectionPath).doc(docId).get();
      if (doc.exists) return _convertTimestamps(doc.data()!);
      return null;
    } catch (e) {
      print('❌ [FirestoreService] Lỗi khi lấy $collectionPath/$docId: $e');
      rethrow;
    }
  }

  /// 🩷 Lấy tất cả document trong 1 collection
  Future<List<Map<String, dynamic>>> getAllDocuments(String collectionPath) async {
    try {
      final snapshot = await _db.collection(collectionPath).get();
      return snapshot.docs
          .map((doc) => {'id': doc.id, ..._convertTimestamps(doc.data())})
          .toList();
    } catch (e) {
      print('❌ [FirestoreService] Lỗi khi lấy danh sách $collectionPath: $e');
      rethrow;
    }
  }

  /// 🩷 Lấy document theo điều kiện (query)
  Future<List<Map<String, dynamic>>> queryDocuments({
    required String collectionPath,
    required String field,
    required dynamic value,
  }) async {
    try {
      final snapshot =
      await _db.collection(collectionPath).where(field, isEqualTo: value).get();
      return snapshot.docs
          .map((doc) => {'id': doc.id, ..._convertTimestamps(doc.data())})
          .toList();
    } catch (e) {
      print('❌ [FirestoreService] Lỗi query $collectionPath.$field=$value: $e');
      rethrow;
    }
  }

  /// 🩷 Stream realtime collection
  Stream<List<Map<String, dynamic>>> streamCollection(String collectionPath) {
    return _db.collection(collectionPath).snapshots().map((snapshot) {
      return snapshot.docs
          .map((doc) => {'id': doc.id, ..._convertTimestamps(doc.data())})
          .toList();
    });
  }

  // -----------------------------
  // 🔄 Xử lý DateTime ↔ Timestamp
  // -----------------------------
  Map<String, dynamic> _convertDates(Map<String, dynamic> data) {
    final converted = <String, dynamic>{};
    data.forEach((key, value) {
      if (value is DateTime) {
        converted[key] = Timestamp.fromDate(value);
      } else {
        converted[key] = value;
      }
    });
    return converted;
  }

  Map<String, dynamic> _convertTimestamps(Map<String, dynamic> data) {
    final converted = <String, dynamic>{};
    data.forEach((key, value) {
      if (value is Timestamp) {
        converted[key] = value.toDate();
      } else {
        converted[key] = value;
      }
    });
    return converted;
  }
}
