import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../models/user_model.dart';
import '../services/auth_service.dart';

class RegisterPage extends StatefulWidget {
  const RegisterPage({super.key});

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  final _formKey = GlobalKey<FormState>();
  final authService = AuthService();

  final firstCtrl = TextEditingController();
  final lastCtrl = TextEditingController();
  final emailCtrl = TextEditingController();
  final phoneCtrl = TextEditingController();
  final passCtrl = TextEditingController();
  final addressCtrl = TextEditingController();

  String role = 'Mother';
  DateTime? dob;
  bool isLoading = false;

  @override
  void dispose() {
    firstCtrl.dispose();
    lastCtrl.dispose();
    emailCtrl.dispose();
    phoneCtrl.dispose();
    passCtrl.dispose();
    addressCtrl.dispose();
    super.dispose();
  }

  Future<void> pickDate() async {
    final now = DateTime.now();
    final initialDate = dob ?? DateTime(now.year - 25, now.month, now.day);

    final picked = await showDatePicker(
      context: context,
      initialDate: initialDate,
      firstDate: DateTime(1950),
      lastDate: now,
      locale: const Locale('vi', 'VN'),
      helpText: 'Chọn ngày sinh',
      cancelText: 'HỦY',
      confirmText: 'CHỌN',
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: const ColorScheme.light(
              primary: Color(0xFFFF6F91),
              onPrimary: Colors.white,
              onSurface: Colors.pink,
            ),
          ),
          child: child!,
        );
      },
    );

    if (picked != null) {
      setState(() => dob = picked);
    }
  }

  Future<void> register() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => isLoading = true);

    final user = UserModel(
      firstName: firstCtrl.text.trim(),
      lastName: lastCtrl.text.trim(),
      email: emailCtrl.text.trim(),
      phone: phoneCtrl.text.trim(),
      address: addressCtrl.text.trim(),
      role: role,
      dateOfBirth: dob,
    );

    final error = await authService.registerUser(user, passCtrl.text.trim());
    setState(() => isLoading = false);

    if (!mounted) return;

    if (error == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('🎉 Đăng ký thành công!'),
          backgroundColor: Colors.green,
        ),
      );
      Navigator.pop(context);
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(error), backgroundColor: Colors.redAccent),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFFF3F6),
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
          child: Column(
            children: [
              const Icon(Icons.favorite_rounded, size: 70, color: Color(0xFFFF6F91)),
              const SizedBox(height: 12),
              const Text(
                "Tạo tài khoản MeBeCare",
                style: TextStyle(
                  fontSize: 26,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFFFF6F91),
                ),
              ),
              const SizedBox(height: 24),

              Container(
                padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 32),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(20),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.pink.shade100.withOpacity(0.4),
                      blurRadius: 10,
                      offset: const Offset(0, 5),
                    ),
                  ],
                ),
                child: Form(
                  key: _formKey,
                  child: Column(
                    children: [
                      buildTextField(firstCtrl, 'Họ', Icons.person_outline),
                      const SizedBox(height: 12),
                      buildTextField(lastCtrl, 'Tên', Icons.badge_outlined),
                      const SizedBox(height: 12),
                      buildTextField(emailCtrl, 'Email', Icons.email_outlined,
                          type: TextInputType.emailAddress),
                      const SizedBox(height: 12),
                      buildTextField(phoneCtrl, 'Số điện thoại', Icons.phone_outlined,
                          type: TextInputType.phone),
                      const SizedBox(height: 12),
                      buildTextField(passCtrl, 'Mật khẩu', Icons.lock_outline,
                          obscure: true),
                      const SizedBox(height: 12),

                      DropdownButtonFormField<String>(
                        value: role,
                        decoration: const InputDecoration(
                          labelText: 'Vai trò',
                          prefixIcon: Icon(Icons.people_outline, color: Colors.pink),
                        ),
                        items: const [
                          DropdownMenuItem(value: 'Mother', child: Text('Mẹ')),
                          DropdownMenuItem(value: 'Father', child: Text('Bố')),
                          DropdownMenuItem(value: 'Doctor', child: Text('Bác sĩ')),
                          DropdownMenuItem(value: 'Expert', child: Text('Chuyên gia')),
                        ],
                        onChanged: (val) => setState(() => role = val!),
                      ),

                      const SizedBox(height: 12),
                      buildTextField(addressCtrl, 'Địa chỉ', Icons.home_outlined),
                      const SizedBox(height: 12),

                      GestureDetector(
                        onTap: pickDate,
                        child: AbsorbPointer(
                          child: TextFormField(
                            decoration: InputDecoration(
                              labelText: 'Ngày sinh',
                              prefixIcon: const Icon(Icons.calendar_today, color: Colors.pink),
                              hintText: dob != null
                                  ? DateFormat('dd/MM/yyyy').format(dob!)
                                  : 'Chọn ngày sinh',
                            ),
                            validator: (_) => dob == null ? 'Chọn ngày sinh của bạn' : null,
                          ),
                        ),
                      ),

                      const SizedBox(height: 24),
                      SizedBox(
                        width: double.infinity,
                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            padding: const EdgeInsets.symmetric(vertical: 14),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                            backgroundColor: const Color(0xFFFF6F91),
                          ),
                          onPressed: isLoading ? null : register,
                          child: isLoading
                              ? const CircularProgressIndicator(color: Colors.white)
                              : const Text(
                            'Đăng ký',
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),

              const SizedBox(height: 16),
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: const Text('Quay lại đăng nhập', style: TextStyle(color: Colors.pink)),
              ),
            ],
          ),
        ),
      ),
    );
  }

  TextFormField buildTextField(
      TextEditingController controller,
      String label,
      IconData icon, {
        TextInputType type = TextInputType.text,
        bool obscure = false,
      }) {
    return TextFormField(
      controller: controller,
      keyboardType: type,
      obscureText: obscure,
      decoration: InputDecoration(
        labelText: label,
        prefixIcon: Icon(icon, color: Colors.pink),
      ),
      validator: (val) =>
      val == null || val.trim().isEmpty ? 'Vui lòng nhập $label' : null,
    );
  }
}
