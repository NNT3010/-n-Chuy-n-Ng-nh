import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/child_model.dart';

class ChildService {
  final CollectionReference _childrenCollection =
  FirebaseFirestore.instance.collection('children');

  // Lấy danh sách bé của một gia đình (dựa trên family_id)
  Stream<List<ChildModel>> getChildrenByFamily(String familyId) {
    return _childrenCollection
        .where('family_id', isEqualTo: familyId)
        .snapshots()
        .map((snapshot) {
      return snapshot.docs
          .map((doc) => ChildModel.fromFirestore(
          doc as DocumentSnapshot<Map<String, dynamic>>))
          .toList();
    });
  }

  // Thêm bé mới
  Future<void> addChild(Map<String, dynamic> data) async {
    await FirebaseFirestore.instance.collection("children").add(data);
  }


  // === BỔ SUNG: Cập nhật thông tin của bé ===
  Future<void> updateChild(String childId, ChildModel updatedChild) {
    return _childrenCollection.doc(childId).update(updatedChild.toMap());
  }

  // === BỔ SUNG: Xóa một bé ===
  Future<void> deleteChild(String childId) {
    return _childrenCollection.doc(childId).delete();
  }

  // Lấy 1 bé theo ID
  Future<ChildModel?> getById(String childId) async {
    final doc = await _childrenCollection.doc(childId).get();
    if (!doc.exists) return null;

    return ChildModel.fromFirestore(
      doc as DocumentSnapshot<Map<String, dynamic>>,
    );
  }

  Future<ChildModel?> getChildById(String childId) async {
    final doc = await _childrenCollection.doc(childId).get();
    if (!doc.exists) return null;
    return ChildModel.fromFirestore(doc as DocumentSnapshot<Map<String, dynamic>>);
  }
}
