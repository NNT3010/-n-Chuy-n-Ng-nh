import 'package:flutter/material.dart';

class LienHePage extends StatefulWidget {
  const LienHePage({Key? key}) : super(key: key);

  @override
  State<LienHePage> createState() => _LienHePageState();
}

class _LienHePageState extends State<LienHePage> {
  final _formKey = GlobalKey<FormState>();

  final _fullNameController = TextEditingController();
  final _emailController = TextEditingController();
  final _phoneController = TextEditingController();
  final _messageController = TextEditingController();

  String? _selectedSubject;
  String? _selectedChildAge;

  @override
  Widget build(BuildContext context) {
    final Color primaryColor = const Color(0xFFFF6699);
    final Color lightPink = const Color(0xFFFCE8F1);

    return Scaffold(
      backgroundColor: const Color(0xFFFCF5F9),
      appBar: AppBar(
        backgroundColor: primaryColor,
        title: const Text('Liên hệ với chúng tôi'),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            // Header
            Column(
              children: [
                Image.network(
                  'https://insacmau.com/wp-content/uploads/2024/12/logo-me-be-8.jpg',
                  width: 120,
                ),
                const SizedBox(height: 12),
                Text(
                  "Liên Hệ Với Chúng Tôi",
                  style: TextStyle(
                    fontSize: 26,
                    fontWeight: FontWeight.bold,
                    color: primaryColor,
                  ),
                ),
                const SizedBox(height: 8),
                const Text(
                  "Chúng tôi luôn sẵn sàng lắng nghe và hỗ trợ bạn mọi lúc mọi nơi",
                  textAlign: TextAlign.center,
                  style: TextStyle(color: Colors.grey),
                ),
                const SizedBox(height: 25),
              ],
            ),

            // Thông tin liên hệ
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: lightPink,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Column(
                children: [
                  _buildContactItem(
                    icon: Icons.location_on,
                    title: 'Địa chỉ',
                    text: 'Số 12 đường Cây Keo, Tam Phú, TP.Thủ Đức, TPHCM',
                  ),
                  const SizedBox(height: 12),
                  _buildContactItem(
                    icon: Icons.email,
                    title: 'Email',
                    text: 'nguyen2662004@gmail.com',
                    isLink: true,
                    linkAction: () {},
                  ),
                  const SizedBox(height: 12),
                  _buildContactItem(
                    icon: Icons.phone,
                    title: 'Đường dây nóng',
                    text: '0909965841',
                    isLink: true,
                    linkAction: () {},
                  ),
                ],
              ),
            ),

            const SizedBox(height: 25),

            // Form liên hệ
            Form(
              key: _formKey,
              child: Column(
                children: [
                  _buildTextField(
                    controller: _fullNameController,
                    label: 'Họ và tên',
                    icon: Icons.person,
                    validator: (v) =>
                    v == null || v.isEmpty ? 'Vui lòng nhập họ tên' : null,
                  ),
                  const SizedBox(height: 16),
                  _buildTextField(
                    controller: _emailController,
                    label: 'Email',
                    icon: Icons.email,
                    validator: (v) => v == null || !v.contains('@')
                        ? 'Email không hợp lệ'
                        : null,
                  ),
                  const SizedBox(height: 16),
                  _buildTextField(
                    controller: _phoneController,
                    label: 'Số điện thoại',
                    icon: Icons.phone,
                    validator: (v) => v != null && v.isNotEmpty
                        ? (RegExp(r'^[0-9]{10,11}$').hasMatch(v)
                        ? null
                        : 'Số điện thoại không hợp lệ')
                        : null,
                  ),
                  const SizedBox(height: 16),

                  // Chủ đề liên hệ
                  _buildDropdown(
                    label: "Chủ đề liên hệ",
                    icon: Icons.topic,
                    value: _selectedSubject,
                    items: const [
                      'Câu hỏi về sản phẩm',
                      'Dịch vụ chăm sóc',
                      'Khiếu nại',
                      'Đại lý/Bán buôn',
                      'Tư vấn dinh dưỡng & sức khỏe',
                      'Vấn đề khác',
                    ],
                    onChanged: (value) =>
                        setState(() => _selectedSubject = value),
                  ),
                  const SizedBox(height: 16),

                  // Độ tuổi bé
                  _buildDropdown(
                    label: "Độ tuổi của bé",
                    icon: Icons.child_care,
                    value: _selectedChildAge,
                    items: const [
                      'Đang mang thai',
                      'Sơ sinh (0-3 tháng)',
                      'Trẻ nhỏ (4-12 tháng)',
                      'Trẻ tập đi (1-3 tuổi)',
                      'Mẫu giáo (3-5 tuổi)',
                      'Trẻ đến trường (6+ tuổi)',
                      'Nhiều con ở các độ tuổi khác nhau',
                    ],
                    onChanged: (value) =>
                        setState(() => _selectedChildAge = value),
                  ),
                  const SizedBox(height: 16),

                  // Nội dung tin nhắn
                  TextFormField(
                    controller: _messageController,
                    decoration: InputDecoration(
                      labelText: 'Nội dung liên hệ',
                      alignLabelWithHint: true,
                      prefixIcon: const Icon(Icons.message, color: Colors.pink),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                    minLines: 4,
                    maxLines: 6,
                    validator: (v) => v == null || v.isEmpty
                        ? 'Vui lòng nhập nội dung liên hệ'
                        : null,
                  ),

                  const SizedBox(height: 25),

                  ElevatedButton.icon(
                    onPressed: () {
                      if (_formKey.currentState!.validate()) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text(
                                '✅ Tin nhắn đã được gửi! Cảm ơn bạn đã liên hệ.'),
                            backgroundColor: Colors.green,
                          ),
                        );
                        _formKey.currentState!.reset();
                      }
                    },
                    icon: const Icon(Icons.send),
                    label: const Text("Gửi tin nhắn"),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: primaryColor,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(30),
                      ),
                      padding: const EdgeInsets.symmetric(
                          horizontal: 32, vertical: 14),
                    ),
                  ),

                  const SizedBox(height: 15),
                  const Text(
                    "Chúng tôi sẽ phản hồi trong vòng 24 giờ làm việc.",
                    style: TextStyle(color: Colors.grey),
                  ),

                  const SizedBox(height: 25),

                  // Quay lại
                  TextButton.icon(
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    icon: const Icon(Icons.arrow_back),
                    label: const Text("Quay lại trang chủ"),
                    style: TextButton.styleFrom(
                      foregroundColor: primaryColor,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Widget con: ô nhập liệu
  Widget _buildTextField({
    required TextEditingController controller,
    required String label,
    required IconData icon,
    String? Function(String?)? validator,
  }) {
    return TextFormField(
      controller: controller,
      validator: validator,
      decoration: InputDecoration(
        prefixIcon: Icon(icon, color: Colors.pink),
        labelText: label,
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
      ),
    );
  }

  // Widget con: dropdown chọn
  Widget _buildDropdown({
    required String label,
    required IconData icon,
    required List<String> items,
    required String? value,
    required ValueChanged<String?> onChanged,
  }) {
    return DropdownButtonFormField<String>(
      value: value,
      decoration: InputDecoration(
        labelText: label,
        prefixIcon: Icon(icon, color: Colors.pink),
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
      ),
      items: items
          .map((e) => DropdownMenuItem(value: e, child: Text(e)))
          .toList(),
      onChanged: onChanged,
      validator: (v) => v == null ? 'Vui lòng chọn $label' : null,
    );
  }

  // Widget con: thông tin liên hệ
  Widget _buildContactItem({
    required IconData icon,
    required String title,
    required String text,
    bool isLink = false,
    VoidCallback? linkAction,
  }) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        CircleAvatar(
          backgroundColor: Colors.pinkAccent,
          child: Icon(icon, color: Colors.white),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(title,
                  style: const TextStyle(
                      fontWeight: FontWeight.bold, fontSize: 15)),
              const SizedBox(height: 2),
              GestureDetector(
                onTap: isLink ? linkAction : null,
                child: Text(
                  text,
                  style: TextStyle(
                    color: isLink ? Colors.pinkAccent : Colors.grey[700],
                    decoration:
                    isLink ? TextDecoration.underline : TextDecoration.none,
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
