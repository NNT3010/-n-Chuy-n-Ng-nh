import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class EditUserPage extends StatefulWidget {
  final String userId;
  final Map<String, dynamic> userData;

  const EditUserPage({super.key, required this.userId, required this.userData});

  @override
  _EditUserPageState createState() => _EditUserPageState();
}

class _EditUserPageState extends State<EditUserPage> {
  late TextEditingController first;
  late TextEditingController last;
  late TextEditingController phone;
  late TextEditingController address;
  String role = "Mother";

  @override
  void initState() {
    first = TextEditingController(text: widget.userData['first_name']);
    last = TextEditingController(text: widget.userData['last_name']);
    phone = TextEditingController(text: widget.userData['phone']);
    address = TextEditingController(text: widget.userData['address']);
    role = widget.userData['role'] ?? "Mother";
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("✏ Chỉnh sửa người dùng")),
      body: Padding(
        padding: const EdgeInsets.all(14),
        child: Column(
          children: [
            field("Họ", first),
            field("Tên", last),
            field("Số điện thoại", phone),
            field("Địa chỉ", address),

            DropdownButtonFormField(
              value: role,
              items: ["Mother","Father","Doctor","Expert","admin"]
                  .map((e)=> DropdownMenuItem(value:e, child: Text(e))).toList(),
              decoration: const InputDecoration(labelText: "Vai trò"),
              onChanged: (v)=> setState(()=> role = v!),
            ),

            const SizedBox(height: 20),
            ElevatedButton(onPressed: updateUser, child: const Text("💾 Lưu thay đổi"))
          ],
        ),
      ),
    );
  }

  Widget field(String label, TextEditingController c){
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: TextField(
        controller:c,
        decoration: InputDecoration(labelText: label,border:OutlineInputBorder()),
      ),
    );
  }

  Future<void> updateUser() async {
    await FirebaseFirestore.instance.collection("Users").doc(widget.userId).update({
      'first_name': first.text,
      'last_name': last.text,
      'phone': phone.text,
      'address': address.text,
      'role': role,
    });

    Navigator.pop(context);
  }
}
