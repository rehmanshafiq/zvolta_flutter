import 'package:flutter/material.dart';
import 'package:zvolta_flutter/core/constants/app_colors.dart';
import 'package:zvolta_flutter/presentation/widgets/profile/profile_header.dart';
import 'package:zvolta_flutter/presentation/widgets/profile/profile_settings_tab_content.dart';
import 'package:zvolta_flutter/presentation/widgets/profile/profile_tab_content.dart';
import 'package:zvolta_flutter/presentation/widgets/profile/profile_vehicles_tab_content.dart';

/// Profile tab — user info, vehicles, and settings.
class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  ProfileSectionTab _selectedTab = ProfileSectionTab.profile;

  void _onTabChanged(ProfileSectionTab tab) {
    if (_selectedTab == tab) return;
    setState(() => _selectedTab = tab);
  }

  void _onLogoutTap() {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Logout coming soon')),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.homeBackground,
      body: SafeArea(
        bottom: false,
        child: CustomScrollView(
          physics: const AlwaysScrollableScrollPhysics(),
          slivers: [
            SliverToBoxAdapter(
              child: ProfileHeader(
                username: 'driver-2',
                email: 'friver2@gmail.com',
                memberSince: 'Member since',
                selectedTab: _selectedTab,
                onTabChanged: _onTabChanged,
              ),
            ),
            SliverPadding(
              padding: const EdgeInsets.fromLTRB(16, 16, 16, 24),
              sliver: SliverToBoxAdapter(
                child: _buildTabContent(),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTabContent() {
    return switch (_selectedTab) {
      ProfileSectionTab.profile => const ProfileTabContent(),
      ProfileSectionTab.vehicles => const ProfileVehiclesTabContent(),
      ProfileSectionTab.settings => ProfileSettingsTabContent(
          onLogoutTap: _onLogoutTap,
        ),
    };
  }
}
