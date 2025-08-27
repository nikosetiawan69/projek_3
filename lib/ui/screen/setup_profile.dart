import 'package:flutter/material.dart';
import 'package:flutter_samples/ui/screen/login.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class SetupProfilePage extends StatefulWidget {
  final String email;
  final String userId;
  const SetupProfilePage({
    required this.email,
    required this.userId,
    super.key,
  });

  @override
  State<SetupProfilePage> createState() => _SetupProfilePageState();
}

class _SetupProfilePageState extends State<SetupProfilePage> {
  final _usernameController = TextEditingController();
  final _firstNameController = TextEditingController();
  final _lastNameController = TextEditingController();

  Future<void> submitProfile() async {
    final username = _usernameController.text.trim();
    final firstName = _firstNameController.text.trim();
    final lastName = _lastNameController.text.trim();

    try {
      await Supabase.instance.client.from('profiles').insert({
        'id': widget.userId,
        'username': username,
        'display_name':
            '${firstName[0].toUpperCase() + firstName.substring(1).toLowerCase()} ${lastName[0].toUpperCase() + lastName.substring(1).toLowerCase()}',
        'email': widget.email,
      });

      Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(builder: (_) => LoginPage()),
        (route) => false,
      );
    } catch (e) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Error: $e')));
    }
  }

  @override
  Widget build(BuildContext context) {
    const backgroundImage = AssetImage('assets/samples/images/bgawal.png');
    const gradientBtn = LinearGradient(
      colors: [Color(0xFF4B5EAA), Color(0xFF8A4AF3)],
      begin: Alignment.topCenter,
      end: Alignment.bottomCenter,
    );

    return Scaffold(
      body: Container(
        width: double.infinity,
        decoration: const BoxDecoration(
          image: DecorationImage(image: backgroundImage, fit: BoxFit.cover),
        ),
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 40),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const SizedBox(height: 60),
                const Text(
                  'Setup Profile',
                  style: TextStyle(
                    fontSize: 34,
                    fontFamily: "Poppins",
                    fontWeight: FontWeight.bold,
                    color: Colors.black,
                  ),
                ),
                const SizedBox(height: 30),
                _inputField('Username', _usernameController),
                const SizedBox(height: 15),
                _inputField('First Name', _firstNameController),
                const SizedBox(height: 15),
                _inputField('Last Name', _lastNameController),
                const SizedBox(height: 30),
                ElevatedButton(
                  onPressed: submitProfile,
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
                    padding: const EdgeInsets.symmetric(
                      horizontal: 40,
                      vertical: 15,
                    ),
                    child: const Text(
                      'Save Profile',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        fontFamily: "Inter",
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 40),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _inputField(String label, TextEditingController controller) {
    return TextField(
      controller: controller,
      decoration: InputDecoration(
        filled: true,
        fillColor: const Color(0xFFD3D3D3),
        hintText: label,
        hintStyle: const TextStyle(color: Colors.black54),
        contentPadding: const EdgeInsets.symmetric(
          vertical: 23,
          horizontal: 16,
        ),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: BorderSide.none,
        ),
      ),
    );
  }
}
