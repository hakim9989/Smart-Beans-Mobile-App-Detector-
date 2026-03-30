import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../utils/theme_provider.dart';
import '../utils/app_theme.dart';
import '../services/firebase_auth_service.dart';
import '../services/notice_service.dart';
import 'about_screen.dart';
import 'admin_panel_screen.dart';
import 'login_screen.dart';

/// Settings screen for app customization
class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  Future<void> _handleLogout(BuildContext context) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Logout'),
        content: const Text('Are you sure you want to logout?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context, true),
            style: TextButton.styleFrom(
              foregroundColor: Colors.red,
            ),
            child: const Text('Logout'),
          ),
        ],
      ),
    );

    if (confirmed == true && context.mounted) {
      await FirebaseAuthService().logout();
      if (context.mounted) {
        Navigator.of(context).pushAndRemoveUntil(
          MaterialPageRoute(builder: (_) => const LoginScreen()),
          (route) => false,
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final themeProvider = Provider.of<ThemeProvider>(context);

    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              theme.colorScheme.primary.withValues(alpha: 0.1),
              Colors.white,
            ],
          ),
        ),
        child: CustomScrollView(
          slivers: [
            // App bar
            SliverAppBar(
              expandedHeight: 200,
              floating: false,
              pinned: true,
              backgroundColor: theme.colorScheme.primary,
              flexibleSpace: FlexibleSpaceBar(
                title: const Text(
                  'Settings',
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                background: Container(
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                      colors: [
                        theme.colorScheme.primary,
                        theme.colorScheme.secondary,
                      ],
                    ),
                  ),
                  child: const Center(
                    child: Icon(
                      Icons.settings,
                      size: 80,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
            ),

            // Content
            SliverPadding(
              padding: const EdgeInsets.all(16),
              sliver: SliverList(
                delegate: SliverChildListDelegate([
                  // Appearance section
                  _buildSectionTitle('Appearance', Icons.palette),
                  const SizedBox(height: 12),

                  // Dark mode toggle
                  Card(
                    child: SwitchListTile(
                      title: const Text(
                        'Dark Mode',
                        style: TextStyle(fontWeight: FontWeight.w600),
                      ),
                      subtitle: const Text('Switch between light and dark theme'),
                      secondary: Icon(
                        themeProvider.isDarkMode ? Icons.dark_mode : Icons.light_mode,
                        color: theme.colorScheme.primary,
                      ),
                      value: themeProvider.isDarkMode,
                      onChanged: (_) => themeProvider.toggleDarkMode(),
                    ),
                  ),
                  const SizedBox(height: 24),

                  // Theme color section
                  _buildSectionTitle('Theme Color', Icons.color_lens),
                  const SizedBox(height: 12),

                  Card(
                    child: Padding(
                      padding: const EdgeInsets.all(20),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            'Choose your preferred color theme',
                            style: TextStyle(
                              fontSize: 14,
                              color: Colors.grey,
                            ),
                          ),
                          const SizedBox(height: 20),
                          Wrap(
                            spacing: 16,
                            runSpacing: 16,
                            children: AppTheme.themeColors.entries.map((entry) {
                              final isSelected = themeProvider.themeColor == entry.key;
                              return _buildColorOption(
                                context,
                                entry.key,
                                entry.value,
                                isSelected,
                                themeProvider,
                              );
                            }).toList(),
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 24),

                  // About section
                  _buildSectionTitle('About', Icons.info_outline),
                  const SizedBox(height: 12),

                  Card(
                    child: Column(
                      children: [
                        // Admin Panel (only for admins)
                        if (NoticeService.isAdmin(FirebaseAuthService().getCurrentUserEmail())) ...[
                          ListTile(
                            leading: Icon(Icons.admin_panel_settings, color: Colors.orange),
                            title: const Text('Admin Panel'),
                            subtitle: const Text('Post notices to all users'),
                            trailing: Container(
                              padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                              decoration: BoxDecoration(
                                color: Colors.orange.shade100,
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: Text(
                                'ADMIN',
                                style: TextStyle(
                                  fontSize: 10,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.orange.shade700,
                                ),
                              ),
                            ),
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (_) => const AdminPanelScreen(),
                                ),
                              );
                            },
                          ),
                          const Divider(height: 1),
                        ],
                        ListTile(
                          leading: Icon(Icons.group, color: theme.colorScheme.primary),
                          title: const Text('Team & Project Info'),
                          subtitle: const Text('View team members and system details'),
                          trailing: const Icon(Icons.arrow_forward_ios, size: 16),
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (_) => const AboutScreen(),
                              ),
                            );
                          },
                        ),
                        const Divider(height: 1),
                        ListTile(
                          leading: Icon(Icons.info, color: theme.colorScheme.primary),
                          title: const Text('Version'),
                          subtitle: const Text('1.0.0'),
                        ),
                        const Divider(height: 1),
                        ListTile(
                          leading: Icon(Icons.code, color: theme.colorScheme.primary),
                          title: const Text('Built with'),
                          subtitle: const Text('Flutter & TensorFlow Lite'),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 24),

                  // Account section
                  _buildSectionTitle('Account', Icons.person_outline),
                  const SizedBox(height: 12),

                  Card(
                    child: ListTile(
                      leading: Icon(Icons.logout, color: Colors.red.shade700),
                      title: Text(
                        'Logout',
                        style: TextStyle(
                          color: Colors.red.shade700,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      subtitle: const Text('Sign out of your account'),
                      onTap: () => _handleLogout(context),
                    ),
                  ),
                  const SizedBox(height: 24),

                  // Old About section removed
                  const SizedBox(height: 32),
                ]),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSectionTitle(String title, IconData icon) {
    return Row(
      children: [
        Icon(icon, size: 20, color: Colors.grey.shade600),
        const SizedBox(width: 8),
        Text(
          title,
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
            color: Colors.grey.shade700,
          ),
        ),
      ],
    );
  }

  Widget _buildColorOption(
    BuildContext context,
    String colorName,
    Color color,
    bool isSelected,
    ThemeProvider themeProvider,
  ) {
    return GestureDetector(
      onTap: () => themeProvider.setThemeColor(colorName),
      child: Column(
        children: [
          Container(
            width: 60,
            height: 60,
            decoration: BoxDecoration(
              color: color,
              shape: BoxShape.circle,
              border: Border.all(
                color: isSelected ? color : Colors.grey.shade300,
                width: isSelected ? 4 : 2,
              ),
              boxShadow: isSelected
                  ? [
                      BoxShadow(
                        color: color.withValues(alpha: 0.4),
                        blurRadius: 12,
                        offset: const Offset(0, 4),
                      ),
                    ]
                  : null,
            ),
            child: isSelected
                ? const Icon(
                    Icons.check,
                    color: Colors.white,
                    size: 32,
                  )
                : null,
          ),
          const SizedBox(height: 8),
          Text(
            colorName[0].toUpperCase() + colorName.substring(1),
            style: TextStyle(
              fontSize: 12,
              fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
              color: isSelected ? color : Colors.grey.shade600,
            ),
          ),
        ],
      ),
    );
  }
}
