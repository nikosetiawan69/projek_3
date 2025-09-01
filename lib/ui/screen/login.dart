import 'package:flutter/material.dart';
import 'package:flutter_samples/supabase/service/auth_service.dart';
import 'package:flutter_samples/ui/home.dart';
import 'package:flutter_samples/ui/screen/signup.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final emailRegex = RegExp(r'^[\w\.-]+@([\w-]+\.)+[a-zA-Z]{2,}$');
  final usernameRegex = RegExp(r'^[a-zA-Z0-9._]{3,20}$');
  final authService = AuthService();
  bool obscurePassword = true;

  final _formKey = GlobalKey<FormState>();

  String? validateIdentifier(String value) {
    if (value.isEmpty) return "Wajib diisi";
    if (!emailRegex.hasMatch(value) && !usernameRegex.hasMatch(value)) {
      return "Gunakan email atau username yang valid";
    }
    return null;
  }

  String? validatePassword(String value) {
    if (value.isEmpty) return "Password wajib diisi";
    if (value.length < 8) return "Minimal 8 karakter";
    return null;
  }

  final _identifierController =
      TextEditingController(); // bisa email / username
  final _passwordController = TextEditingController();

  Future<void> login() async {
    final identifier = _identifierController.text.trim();
    final password = _passwordController.text;

    try {
      // 1. Ambil email dari username jika perlu
      // final usernameInput =
      //     identifier.startsWith('@') ? identifier : '@$identifier';
      final usernameInput = identifier;
      final email =
          emailRegex.hasMatch(usernameInput)
              ? usernameInput
              : await authService.getEmailByUsername(usernameInput);

      // 2. Login pakai email
      await authService.signInWithEmailPassword(email, password);

      // 3. Navigasi ke home
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (_) => const RiveAppHome()),
      );
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text("Error: $e")));
        debugPrint('error: $e');
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    const bgImage = AssetImage('assets/samples/images/bgawal.png');
    const gradientBtn = LinearGradient(
      colors: [Color(0xFF4B5EAA), Color(0xFF8A4AF3)],
      begin: Alignment.topCenter,
      end: Alignment.bottomCenter,
    );

    return Scaffold(
      body: Container(
        width: double.infinity,
        decoration: const BoxDecoration(
          image: DecorationImage(image: bgImage, fit: BoxFit.cover),
        ),
        child: Center(
          child: SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                SizedBox(
                  width: 150,
                  height: 150,
                  child: Image.asset('assets/samples/images/topi.png'),
                ),
                const Text(
                  'SkillUp!',
                  style: TextStyle(
                    fontSize: 50,
                    fontFamily: "Poppins",
                    fontWeight: FontWeight.bold,
                    color: Colors.black,
                  ),
                ),
                const SizedBox(height: 20),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 40),
                  child: Form(
                    key: _formKey,
                    child: Column(
                      children: [
                        _input(
                          'Gmail / Username',
                          _identifierController,
                          validator: validateIdentifier,
                        ),
                        const SizedBox(height: 10),
                        _input(
                          'Password',
                          _passwordController,
                          isPassword: true,
                          validator: validatePassword,
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 20),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 40),
                  child: Row(
                    children: [
                      Expanded(
                        child: GestureDetector(
                          onTap:
                              () => Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (_) => const SignUpPage(),
                                ),
                              ),
                          child: Container(
                            decoration: BoxDecoration(
                              gradient: gradientBtn,
                              borderRadius: BorderRadius.circular(30),
                            ),
                            alignment: Alignment.center,
                            padding: const EdgeInsets.symmetric(vertical: 15),
                            child: const Text(
                              'Sign Up',
                              style: TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                                fontFamily: "Inter",
                                color: Colors.white,
                              ),
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(width: 20),
                      Expanded(
                        child: ElevatedButton(
                          onPressed: login,
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.transparent,
                            shadowColor: Colors.transparent,
                            padding: EdgeInsets.zero,
                          ),
                          child: Container(
                            decoration: BoxDecoration(
                              gradient: gradientBtn,
                              borderRadius: BorderRadius.circular(30),
                            ),
                            alignment: Alignment.center,
                            padding: const EdgeInsets.symmetric(vertical: 15),
                            child: const Text(
                              'Login',
                              style: TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                                fontFamily: "Inter",
                                color: Colors.white,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 30),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _input(
    String hint,
    TextEditingController controller, {
    bool isPassword = false,
    String? Function(String value)? validator,
  }) {
    return TextFormField(
      controller: controller,
      obscureText: isPassword ? obscurePassword : false,
      validator: (val) => validator != null ? validator(val ?? '') : null,
      decoration: InputDecoration(
        filled: true,
        fillColor: const Color(0xFFD3D3D3),
        hintText: hint,
        hintStyle: const TextStyle(color: Colors.black54),
        contentPadding: const EdgeInsets.symmetric(
          vertical: 23,
          horizontal: 16,
        ),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: BorderSide.none,
        ),
        suffixIcon:
            isPassword
                ? GestureDetector(
                  onTap:
                      () => setState(() => obscurePassword = !obscurePassword),
                  child: Icon(
                    obscurePassword
                        ? Icons.visibility_outlined
                        : Icons.visibility_off_outlined,
                    color: Colors.black,
                    size: 22,
                  ),
                )
                : null,
      ),
    );
  }
}
