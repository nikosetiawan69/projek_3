import 'package:flutter/material.dart';

class SecuritySettingsPage extends StatefulWidget {
  const SecuritySettingsPage({super.key});

  @override
  State<SecuritySettingsPage> createState() => _SecuritySettingsPageState();
}

class _SecuritySettingsPageState extends State<SecuritySettingsPage> {
  bool twoFactorAuth = false;
  bool loginNotifications = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5FAFF), // biru muda lembut
      appBar: AppBar(
        title: const Text("Security Settings"),
        backgroundColor: const Color(0xFF4A90E2), // biru utama
        elevation: 0,
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          // Change Password
          Card(
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
            child: ListTile(
              leading: const Icon(Icons.lock, color: Color(0xFF4A90E2)),
              title: const Text("Change Password"),
              subtitle: const Text("Update your account password"),
              trailing: const Icon(Icons.arrow_forward_ios, size: 18),
              onTap: () {
                _showChangePasswordDialog(context);
              },
            ),
          ),
          const SizedBox(height: 12),

          // Two Factor Authentication
          Card(
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
            child: SwitchListTile(
              secondary: const Icon(Icons.verified_user, color: Color(0xFF4A90E2)),
              title: const Text("Enable Two-Factor Authentication"),
              subtitle: const Text("Extra security for your account"),
              value: twoFactorAuth,
              onChanged: (value) {
                setState(() {
                  twoFactorAuth = value;
                });
              },
            ),
          ),
          const SizedBox(height: 12),

          // Login Notifications
          Card(
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
            child: SwitchListTile(
              secondary: const Icon(Icons.notifications_active, color: Color(0xFF4A90E2)),
              title: const Text("Login Notifications"),
              subtitle: const Text("Get notified when your account is accessed"),
              value: loginNotifications,
              onChanged: (value) {
                setState(() {
                  loginNotifications = value;
                });
              },
            ),
          ),
        ],
      ),
    );
  }

  void _showChangePasswordDialog(BuildContext context) {
    String oldPassword = "";
    String newPassword = "";
    bool showOldPassword = false;
    bool showNewPassword = false;

    showDialog(
      context: context,
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setState) {
            return AlertDialog(
              title: const Text("Change Password"),
              content: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  // Old Password
                  TextField(
                    obscureText: !showOldPassword,
                    decoration: InputDecoration(
                      labelText: "Old Password",
                      suffixIcon: IconButton(
                        icon: Icon(
                          showOldPassword ? Icons.visibility_off : Icons.visibility,
                          color: Colors.grey,
                        ),
                        onPressed: () {
                          setState(() {
                            showOldPassword = !showOldPassword;
                          });
                        },
                      ),
                    ),
                    onChanged: (value) => oldPassword = value,
                  ),
                  const SizedBox(height: 10),
                  // New Password
                  TextField(
                    obscureText: !showNewPassword,
                    decoration: InputDecoration(
                      labelText: "New Password",
                      suffixIcon: IconButton(
                        icon: Icon(
                          showNewPassword ? Icons.visibility_off : Icons.visibility,
                          color: Colors.grey,
                        ),
                        onPressed: () {
                          setState(() {
                            showNewPassword = !showNewPassword;
                          });
                        },
                      ),
                    ),
                    onChanged: (value) => newPassword = value,
                  ),
                ],
              ),
              actions: [
                TextButton(
                  onPressed: () => Navigator.pop(context),
                  child: const Text("Cancel"),
                ),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(backgroundColor: const Color(0xFF4A90E2)),
                  onPressed: () {
                    // Logika simpan password baru bisa ditaruh di sini
                    Navigator.pop(context);
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text("Password changed successfully")),
                    );
                  },
                  child: const Text("Save"),
                ),
              ],
            );
          },
        );
      },
    );
  }
}
