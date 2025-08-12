import 'package:flutter/material.dart';
import 'package:flutter_samples/ui/theme.dart';

class GeneralSettingsPage extends StatefulWidget {
  const GeneralSettingsPage({super.key});

  @override
  State<GeneralSettingsPage> createState() => _GeneralSettingsPageState();
}

class _GeneralSettingsPageState extends State<GeneralSettingsPage> {
  bool isDarkMode = false;
  bool notificationsEnabled = true;
  String selectedLanguage = "English";

  static const Color tileColor = Color(0xFFAECFFF);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: RiveAppTheme.background2,
      appBar: AppBar(
        title: const Text(
          "General Settings",
          style: TextStyle(
            fontFamily: "Poppins",
            fontWeight: FontWeight.bold,
            color: Colors.black,
          ),
        ),
        backgroundColor: tileColor,
        elevation: 0,
        iconTheme: const IconThemeData(color: Colors.black),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            _buildSwitchTile(
              title: "Dark Mode",
              icon: Icons.dark_mode,
              value: isDarkMode,
              onChanged: (value) {
                setState(() {
                  isDarkMode = value;
                });
              },
            ),
            _buildSwitchTile(
              title: "Enable Notifications",
              icon: Icons.notifications,
              value: notificationsEnabled,
              onChanged: (value) {
                setState(() {
                  notificationsEnabled = value;
                });
              },
            ),
            _buildNavigationTile(
              title: "Language",
              icon: Icons.language,
              subtitle: selectedLanguage,
              onTap: () {
                _showLanguageDialog(context);
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSwitchTile({
    required String title,
    required IconData icon,
    required bool value,
    required ValueChanged<bool> onChanged,
  }) {
    return Container(
      margin: const EdgeInsets.only(bottom: 15),
      decoration: BoxDecoration(
        color: tileColor,
        borderRadius: BorderRadius.circular(15),
        boxShadow: const [
          BoxShadow(
            color: Colors.black12,
            blurRadius: 6,
            offset: Offset(0, 3),
          ),
        ],
      ),
      child: SwitchListTile(
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
        secondary: Icon(icon, color: Colors.black),
        title: Text(
          title,
          style: const TextStyle(
            fontFamily: "Inter",
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: Colors.black,
          ),
        ),
        value: value,
        onChanged: onChanged,
      ),
    );
  }

  Widget _buildNavigationTile({
    required String title,
    required IconData icon,
    String? subtitle,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.only(bottom: 15),
        decoration: BoxDecoration(
          color: tileColor,
          borderRadius: BorderRadius.circular(15),
          boxShadow: const [
            BoxShadow(
              color: Colors.black12,
              blurRadius: 6,
              offset: Offset(0, 3),
            ),
          ],
        ),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 18),
        child: Row(
          children: [
            Icon(icon, color: Colors.black),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: const TextStyle(
                      fontFamily: "Inter",
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Colors.black,
                    ),
                  ),
                  if (subtitle != null)
                    Text(
                      subtitle,
                      style: const TextStyle(
                        fontFamily: "Inter",
                        fontSize: 14,
                        color: Colors.black54,
                      ),
                    ),
                ],
              ),
            ),
            const Icon(Icons.arrow_forward_ios, size: 20, color: Colors.black54),
          ],
        ),
      ),
    );
  }

  void _showLanguageDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text("Select Language"),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              _buildLanguageOption("English"),
              _buildLanguageOption("Bahasa Indonesia"),
              _buildLanguageOption("Spanish"),
            ],
          ),
        );
      },
    );
  }

  Widget _buildLanguageOption(String language) {
    return RadioListTile<String>(
      title: Text(language),
      value: language,
      groupValue: selectedLanguage,
      onChanged: (value) {
        setState(() {
          selectedLanguage = value!;
        });
        Navigator.pop(context);
      },
    );
  }
}
