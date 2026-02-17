import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:mebecare/admin/pages/growth_list_page.dart';
import 'package:mebecare/admin/pages/vaccination_list_page.dart';
import 'dart:io';

// ========== USER PAGES ==========
import 'package:mebecare/pages/login_page.dart';
import 'package:mebecare/pages/register_page.dart';
import 'package:mebecare/pages/book_appointment.dart';
import 'package:mebecare/pages/doctor_detail_page.dart';
import 'package:mebecare/pages/doctor_list_page.dart';

// ========== ADMIN PAGES ==========
import 'admin/admin_dashboard.dart';
import 'admin/pages/users_page.dart';
import 'admin/pages/doctors_page.dart';
import 'admin/pages/experts_page.dart';
import 'admin/pages/medical_service_page.dart';
import 'admin/pages/admin_articles_page.dart';


// Nếu có file firebase_options.dart thì mở dòng này
// import 'firebase_options.dart';
import 'package:flutter/material.dart';


void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  HttpOverrides.global = MyHttpOverrides();

  try {
    // Nếu có firebase_options.dart dùng dòng này
    // await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);

    await Firebase.initializeApp();   // ⬅ Tạm dùng cách này nếu chưa tạo firebase_options.dart
    debugPrint('🔥 Firebase connected successfully!');
  } catch (e) {
    debugPrint('❌ Firebase init error: $e');
  }

  runApp(const MeBeCareApp());
}

class MeBeCareApp extends StatelessWidget {
  const MeBeCareApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'MeBeCare',

      // 🔥 Route mặc định (khởi chạy login)
      home: const SplashToLogin(),

      // ============ APP ROUTES ============
      routes: {

        // ==== USER SIDE ====
        '/login': (context) => const LoginPage(),
        '/register': (context) => const RegisterPage(),
        '/doctors': (context) => DoctorListPage(),
        '/doctorDetail': (context) => DoctorDetailPage(),
        '/bookAppointment': (context) => BookAppointmentPage(),

        // ==== ADMIN SIDE ====
        '/admin'         : (context) => AdminDashboard(),
        '/admin/users'   : (context) => UsersPage(),
        '/admin/doctors' : (context) => DoctorsPage(),
        '/admin/experts' : (context) => ExpertsPage(),
        '/admin/growth'  : (context) => GrowthListPage(),
        '/admin/vaccinations' : (context) => VaccinationListPage(),
        '/admin/services': (context) => const MedicalServicePage(),
        '/admin/articles': (context) => const AdminArticlesPage(),
      },

      // ============ UI THEME ============
      theme: ThemeData(
        primaryColor: const Color(0xFFFF6F91),
        scaffoldBackgroundColor: const Color(0xFFFFF3F6),
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color(0xFFFF6F91),
          primary: const Color(0xFFFF6F91),
          secondary: const Color(0xFFFF8FB1),
        ),
        inputDecorationTheme: InputDecorationTheme(
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
          focusedBorder: OutlineInputBorder(
            borderSide: const BorderSide(color: Color(0xFFFF6F91), width: 2),
            borderRadius: BorderRadius.circular(10),
          ),
          labelStyle: const TextStyle(color: Colors.pink),
        ),
      ),

      // ============ NGÔN NGỮ ============
      supportedLocales: const [ Locale('vi', 'VN'), Locale('en', 'US') ],
      localizationsDelegates: const [
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
    );
  }
}

class SplashToLogin extends StatefulWidget {
  const SplashToLogin({super.key});
  @override
  State<SplashToLogin> createState() => _SplashToLoginState();
}

class _SplashToLoginState extends State<SplashToLogin> {
  bool _initialized = false;
  bool _error = false;

  @override
  void initState() {
    super.initState();
    _load();
  }

  Future<void> _load() async {
    try {
      await Future.delayed(const Duration(milliseconds: 800));
      setState(() => _initialized = true);
    } catch (e) {
      setState(() => _error = true);
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_error) {
      return const Scaffold(body: Center(child: Text("❌ Firebase load lỗi!")));
    }

    if (!_initialized) {
      return const Scaffold(
        backgroundColor: Color(0xFFFFF3F6),
        body: Center(child: CircularProgressIndicator(color: Color(0xFFFF6F91))),
      );
    }

    return const LoginPage();
  }
}

class MyHttpOverrides extends HttpOverrides {
  @override
  HttpClient createHttpClient(SecurityContext? context) {
    return super.createHttpClient(context)
      ..badCertificateCallback = (X509Certificate cert, String host, int port) => true;
  }
}

