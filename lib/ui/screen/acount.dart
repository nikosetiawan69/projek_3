import 'package:flutter/material.dart';
import 'package:flutter_samples/supabase/service/auth_service.dart';
import 'package:flutter_samples/ui/navigation/home_tab_view.dart';
import 'package:flutter_samples/ui/screen/contact.dart';
import 'package:flutter_samples/ui/screen/general_settings.dart';
import 'package:flutter_samples/ui/screen/login.dart';
import 'package:flutter_samples/ui/screen/security.dart';
import 'package:flutter_samples/ui/theme.dart';
// import halaman utama
import 'package:flutter_samples/ui/getstart.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class AcountPage extends StatefulWidget {
  const AcountPage({super.key});

  static const Color tileColor = Color(0xFFAECFFF);

  @override
  State<AcountPage> createState() => _AcountPageState();

  static Widget _buildTile(
    String title,
    IconData leadingIcon,
    Color color,
    VoidCallback onTap,
  ) {
    return InkWell(
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.only(bottom: 15),
        decoration: BoxDecoration(
          color: color,
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
            Icon(leadingIcon, size: 26, color: Colors.black),
            const SizedBox(width: 16),
            Expanded(
              child: Text(
                title,
                style: const TextStyle(
                  fontFamily: "Inter",
                  fontSize: 25,
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                ),
              ),
            ),
            const Icon(
              Icons.arrow_forward_ios,
              size: 20,
              color: Colors.black54,
            ),
          ],
        ),
      ),
    );
  }
}

class _AcountPageState extends State<AcountPage> {
  @override
  Widget build(BuildContext context) {
    final user = Supabase.instance.client.auth.currentUser;
    return Container(
      color: RiveAppTheme.background2,
      child: Center(
        child: Container(
          decoration: BoxDecoration(
            color: RiveAppTheme.background,
            borderRadius: BorderRadius.circular(30),
          ),
          clipBehavior: Clip.hardEdge,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 50),
                const Text(
                  'Acount',
                  style: TextStyle(
                    fontSize: 34,
                    fontFamily: "Poppins",
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 20),
                const Center(
                  child: Icon(
                    Icons.account_circle,
                    size: 100,
                    color: Colors.black,
                  ),
                ),
                Center(
                  child: StreamBuilder<List<Map<String, dynamic>>>(
                    stream: Supabase.instance.client
                        .from('profiles')
                        .stream(primaryKey: ['id'])
                        .eq('id', user!.id),
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return const Text("Loading...");
                      }
                      if (snapshot.hasError ||
                          !snapshot.hasData ||
                          snapshot.data!.isEmpty) {
                        // Fallback ke email jika display_name tidak ada
                        return Text(
                          user.userMetadata?['full_name'] ??
                              user.email ??
                              "No Name",
                          style: const TextStyle(
                            color: Colors.black,
                            fontSize: 17,
                          ),
                        );
                      }

                      final data = snapshot.data!.first;
                      return Text(
                        data['display_name'] ?? user.email ?? "None",
                        style: const TextStyle(
                          color: Colors.black,
                          fontSize: 17,
                          fontFamily: "Inter",
                        ),
                      );
                    },
                  ),
                ),
                const SizedBox(height: 20),
                Expanded(
                  child: ListView(
                    children: [
                      AcountPage._buildTile(
                        "AboutApp",
                        Icons.settings,
                        AcountPage.tileColor,
                        () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => const GeneralSettingsPage(),
                            ),
                          );
                        },
                      ),

                      AcountPage._buildTile(
                        "Security",
                        Icons.lock,
                        AcountPage.tileColor,
                        () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => const ChangePasswordPage(),
                            ),
                          );
                        },
                      ),

                      AcountPage._buildTile(
                        "Contact Us",
                        Icons.contact_mail,
                        AcountPage.tileColor,
                        () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => const ContactUsPage(),
                            ),
                          );
                        },
                      ),
                      AcountPage._buildTile(
                        "Log Out",
                        Icons.logout,
                        AcountPage.tileColor,
                        () async {
                          await AuthService().signOut();
                          if (!mounted) return;
                          Navigator.of(context).pushAndRemoveUntil(
                            MaterialPageRoute(
                              builder: (_) => const LoginPage(),
                            ),
                            (route) => false,
                          );
                        },
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
