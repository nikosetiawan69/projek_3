import 'package:flutter/material.dart';

class ChangePasswordPage extends StatefulWidget {
  const ChangePasswordPage({super.key});

  @override
  State<ChangePasswordPage> createState() => _ChangePasswordPageState();
}

class _ChangePasswordPageState extends State<ChangePasswordPage> {
  final _formKey = GlobalKey<FormState>();

  bool showOldPassword = false;
  bool showNewPassword = false;
  bool showConfirmPassword = false;

  String oldPassword = "";
  String newPassword = "";
  String confirmPassword = "";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF4F7FC),
      appBar: AppBar(
        title: const Text(
          "Change Password",
          style: TextStyle(
            fontWeight: FontWeight.w600,
            fontSize: 20,
            fontFamily: "Poppins",
          ),
        ),
        backgroundColor: const Color(0xFF4A90E2),
        elevation: 0,
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Card(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          elevation: 5,
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    "Update your password securely 🔒",
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w500,
                      fontFamily: "Poppins",
                    ),
                  ),
                  const SizedBox(height: 20),

                  // Old Password
                  _buildPasswordField(
                    label: "Old Password",
                    obscureText: !showOldPassword,
                    onChanged: (value) => oldPassword = value,
                    toggle: () {
                      setState(() => showOldPassword = !showOldPassword);
                    },
                    isVisible: showOldPassword,
                  ),
                  const SizedBox(height: 16),

                  // New Password
                  _buildPasswordField(
                    label: "New Password",
                    obscureText: !showNewPassword,
                    onChanged: (value) => newPassword = value,
                    toggle: () {
                      setState(() => showNewPassword = !showNewPassword);
                    },
                    isVisible: showNewPassword,
                  ),
                  const SizedBox(height: 16),

                  // Confirm Password
                  _buildPasswordField(
                    label: "Confirm Password",
                    obscureText: !showConfirmPassword,
                    onChanged: (value) => confirmPassword = value,
                    toggle: () {
                      setState(() => showConfirmPassword = !showConfirmPassword);
                    },
                    isVisible: showConfirmPassword,
                  ),

                  const SizedBox(height: 30),

                  // Save Button
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF4A90E2),
                        padding: const EdgeInsets.symmetric(vertical: 14),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(14),
                        ),
                      ),
                      onPressed: () {
                        if (_formKey.currentState!.validate()) {
                          if (newPassword != confirmPassword) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                content: Text(
                                  "New password and confirm password do not match ❌",
                                  style: TextStyle(fontFamily: "Poppins"),
                                ),
                              ),
                            );
                            return;
                          }

                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              backgroundColor: Colors.green,
                              content: Text(
                                "Password updated successfully ✅",
                                style: TextStyle(fontFamily: "Poppins"),
                              ),
                            ),
                          );
                        }
                      },
                      child: const Text(
                        "Save Password",
                        style: TextStyle(
                          fontFamily: "Poppins",
                          fontWeight: FontWeight.w600,
                          fontSize: 16,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  )
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  // Custom password field widget
  Widget _buildPasswordField({
    required String label,
    required bool obscureText,
    required Function(String) onChanged,
    required VoidCallback toggle,
    required bool isVisible,
  }) {
    return TextFormField(
      obscureText: obscureText,
      decoration: InputDecoration(
        labelText: label,
        labelStyle: const TextStyle(fontFamily: "Poppins"),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
        ),
        suffixIcon: IconButton(
          icon: Icon(
            isVisible ? Icons.visibility_off_outlined : Icons.visibility_outlined,
            color: Colors.grey,
          ),
          onPressed: toggle,
        ),
      ),
      onChanged: onChanged,
      validator: (value) {
        if (value == null || value.isEmpty) {
          return "$label cannot be empty";
        }
        if (label == "New Password" && value.length < 6) {
          return "Password must be at least 6 characters";
        }
        return null;
      },
    );
  }
}
