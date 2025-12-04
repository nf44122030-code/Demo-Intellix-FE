import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/auth_provider.dart';
import '../providers/theme_provider.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  bool _isEditing = false;
  late TextEditingController _nameController;
  late TextEditingController _emailController;
  late TextEditingController _phoneController;
  late TextEditingController _locationController;
  late TextEditingController _bioController;

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController(text: 'Noor Fayyad');
    _emailController = TextEditingController(text: 'noor.fayyad@email.com');
    _phoneController = TextEditingController(text: '+1 (555) 123-4567');
    _locationController = TextEditingController(text: 'New York, USA');
    _bioController = TextEditingController(
      text: 'Business intelligence enthusiast and data-driven decision maker.',
    );
  }

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _phoneController.dispose();
    _locationController.dispose();
    _bioController.dispose();
    super.dispose();
  }

  void _handleSave() {
    setState(() {
      _isEditing = false;
    });
    // Here you would typically save to backend/database
  }

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);
    final isDarkMode = themeProvider.isDarkMode;

    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: isDarkMode
              ? const LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [Color(0xFF0A1929), Color(0xFF0A1929)],
                )
              : const LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [Color(0xFFF0F9FF), Color(0xFFE0F2FE), Color(0xFFBAE6FD)],
                ),
        ),
        child: Stack(
          children: [
            Column(
              children: [
                // Curved Header
                Container(
                  decoration: BoxDecoration(
                    gradient: isDarkMode
                        ? const LinearGradient(
                            begin: Alignment.centerLeft,
                            end: Alignment.centerRight,
                            colors: [Color(0xFF0369A1), Color(0xFF0EA5E9)],
                          )
                        : const LinearGradient(
                            begin: Alignment.centerLeft,
                            end: Alignment.centerRight,
                            colors: [Color(0xFF0284C7), Color(0xFF0EA5E9), Color(0xFF06B6D4)],
                          ),
                    borderRadius: const BorderRadius.only(
                      bottomLeft: Radius.circular(40),
                      bottomRight: Radius.circular(40),
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.1),
                        blurRadius: 10,
                        offset: const Offset(0, 5),
                      ),
                    ],
                  ),
                  padding: const EdgeInsets.only(top: 40, bottom: 96, left: 24, right: 24),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      IconButton(
                        icon: const Icon(Icons.arrow_back, color: Colors.white, size: 24),
                        onPressed: () => Navigator.pop(context),
                      ),
                      const Text(
                        'PROFILE',
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                          letterSpacing: 6,
                        ),
                      ),
                      IconButton(
                        icon: Icon(
                          _isEditing ? Icons.save : Icons.edit,
                          color: Colors.white,
                          size: 24,
                        ),
                        onPressed: () {
                          if (_isEditing) {
                            _handleSave();
                          } else {
                            setState(() => _isEditing = true);
                          }
                        },
                      ),
                    ],
                  ),
                ),

                // Main Content
                Expanded(
                  child: SingleChildScrollView(
                    padding: const EdgeInsets.fromLTRB(24, 80, 24, 24),
                    child: Column(
                      children: [
                        // Name Section
                        _isEditing
                            ? TextField(
                                controller: _nameController,
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                  fontSize: 24,
                                  fontWeight: FontWeight.bold,
                                  color: isDarkMode ? Colors.white : const Color(0xFF1F2937),
                                ),
                                decoration: InputDecoration(
                                  contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(12),
                                    borderSide: BorderSide(
                                      color: isDarkMode
                                          ? const Color(0xFF1E4976)
                                          : const Color(0xFFBAE6FD),
                                    ),
                                  ),
                                  focusedBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(12),
                                    borderSide: const BorderSide(
                                      color: Color(0xFF0EA5E9),
                                      width: 2,
                                    ),
                                  ),
                                  filled: true,
                                  fillColor: isDarkMode
                                      ? const Color(0xFF132F4C)
                                      : Colors.white,
                                ),
                              )
                            : Text(
                                _nameController.text,
                                style: TextStyle(
                                  fontSize: 24,
                                  fontWeight: FontWeight.bold,
                                  color: isDarkMode ? Colors.white : const Color(0xFF1F2937),
                                ),
                              ),
                        const SizedBox(height: 8),
                        Text(
                          'Member since January 2024',
                          style: TextStyle(
                            fontSize: 14,
                            color: isDarkMode ? const Color(0xFF9CA3AF) : const Color(0xFF6B7280),
                          ),
                        ),
                        const SizedBox(height: 24),

                        // Bio Section
                        _buildSectionCard(
                          title: 'Bio',
                          isDarkMode: isDarkMode,
                          child: _isEditing
                              ? TextField(
                                  controller: _bioController,
                                  maxLines: 3,
                                  style: TextStyle(
                                    color: isDarkMode
                                        ? const Color(0xFFD1D5DB)
                                        : const Color(0xFF4B5563),
                                  ),
                                  decoration: InputDecoration(
                                    contentPadding: const EdgeInsets.all(12),
                                    border: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(12),
                                      borderSide: BorderSide(
                                        color: isDarkMode
                                            ? const Color(0xFF1E4976)
                                            : const Color(0xFFBAE6FD),
                                      ),
                                    ),
                                    focusedBorder: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(12),
                                      borderSide: const BorderSide(
                                        color: Color(0xFF0EA5E9),
                                        width: 2,
                                      ),
                                    ),
                                    filled: true,
                                    fillColor: isDarkMode
                                        ? const Color(0xFF0A1929)
                                        : const Color(0xFFF0F9FF),
                                  ),
                                )
                              : Text(
                                  _bioController.text,
                                  style: TextStyle(
                                    color: isDarkMode
                                        ? const Color(0xFFD1D5DB)
                                        : const Color(0xFF4B5563),
                                  ),
                                ),
                        ),
                        const SizedBox(height: 16),

                        // Contact Information
                        _buildSectionCard(
                          title: 'Contact Information',
                          isDarkMode: isDarkMode,
                          child: Column(
                            children: [
                              _buildProfileField(
                                icon: Icons.email,
                                label: 'Email',
                                controller: _emailController,
                                isEditing: _isEditing,
                                isDarkMode: isDarkMode,
                                inputType: TextInputType.emailAddress,
                              ),
                              const SizedBox(height: 12),
                              _buildProfileField(
                                icon: Icons.phone,
                                label: 'Phone',
                                controller: _phoneController,
                                isEditing: _isEditing,
                                isDarkMode: isDarkMode,
                                inputType: TextInputType.phone,
                              ),
                              const SizedBox(height: 12),
                              _buildProfileField(
                                icon: Icons.location_on,
                                label: 'Location',
                                controller: _locationController,
                                isEditing: _isEditing,
                                isDarkMode: isDarkMode,
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(height: 16),

                        // Account Stats
                        Row(
                          children: [
                            Expanded(
                              child: _buildStatCard(
                                label: 'Sessions',
                                value: '24',
                                isDarkMode: isDarkMode,
                              ),
                            ),
                            const SizedBox(width: 16),
                            Expanded(
                              child: _buildStatCard(
                                label: 'Queries',
                                value: '156',
                                isDarkMode: isDarkMode,
                              ),
                            ),
                            const SizedBox(width: 16),
                            Expanded(
                              child: _buildStatCard(
                                label: 'Reports',
                                value: '12',
                                isDarkMode: isDarkMode,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 24),

                        // Action Buttons (only show when editing)
                        if (_isEditing)
                          Row(
                            children: [
                              Expanded(
                                child: ElevatedButton(
                                  onPressed: _handleSave,
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: Colors.transparent,
                                    shadowColor: Colors.transparent,
                                    padding: const EdgeInsets.symmetric(vertical: 16),
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(28),
                                    ),
                                  ),
                                  child: Ink(
                                    decoration: BoxDecoration(
                                      gradient: isDarkMode
                                          ? const LinearGradient(
                                              colors: [Color(0xFF0369A1), Color(0xFF0EA5E9)],
                                            )
                                          : const LinearGradient(
                                              colors: [Color(0xFF0284C7), Color(0xFF06B6D4)],
                                            ),
                                      borderRadius: BorderRadius.circular(28),
                                    ),
                                    child: Container(
                                      alignment: Alignment.center,
                                      child: const Text(
                                        'Save Changes',
                                        style: TextStyle(
                                          color: Colors.white,
                                          fontSize: 16,
                                          fontWeight: FontWeight.w600,
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                              const SizedBox(width: 12),
                              Expanded(
                                child: ElevatedButton(
                                  onPressed: () => setState(() => _isEditing = false),
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: isDarkMode
                                        ? const Color(0xFF1E4976)
                                        : const Color(0xFFE0F2FE),
                                    padding: const EdgeInsets.symmetric(vertical: 16),
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(28),
                                    ),
                                  ),
                                  child: Text(
                                    'Cancel',
                                    style: TextStyle(
                                      color: isDarkMode
                                          ? const Color(0xFFD1D5DB)
                                          : const Color(0xFF0369A1),
                                      fontSize: 16,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                      ],
                    ),
                  ),
                ),
              ],
            ),

            // Floating Profile Image
            Positioned(
              top: 120,
              left: 0,
              right: 0,
              child: Center(
                child: Stack(
                  children: [
                    Container(
                      width: 128,
                      height: 128,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        shape: BoxShape.circle,
                        border: Border.all(color: Colors.white, width: 4),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.2),
                            blurRadius: 20,
                            offset: const Offset(0, 10),
                          ),
                        ],
                      ),
                      child: Icon(
                        Icons.person,
                        size: 64,
                        color: isDarkMode ? const Color(0xFF0EA5E9) : const Color(0xFF0284C7),
                      ),
                    ),
                    if (_isEditing)
                      Positioned(
                        bottom: 0,
                        right: 0,
                        child: Container(
                          width: 40,
                          height: 40,
                          decoration: BoxDecoration(
                            gradient: isDarkMode
                                ? const LinearGradient(
                                    colors: [Color(0xFF0369A1), Color(0xFF0EA5E9)],
                                  )
                                : const LinearGradient(
                                    colors: [Color(0xFF0284C7), Color(0xFF06B6D4)],
                                  ),
                            shape: BoxShape.circle,
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withOpacity(0.2),
                                blurRadius: 8,
                                offset: const Offset(0, 4),
                              ),
                            ],
                          ),
                          child: const Icon(
                            Icons.camera_alt,
                            color: Colors.white,
                            size: 20,
                          ),
                        ),
                      ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSectionCard({
    required String title,
    required bool isDarkMode,
    required Widget child,
  }) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: isDarkMode ? const Color(0xFF132F4C) : Colors.white,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: isDarkMode ? const Color(0xFF1E4976) : const Color(0xFFBAE6FD),
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.03),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w600,
              color: isDarkMode ? const Color(0xFF0EA5E9) : const Color(0xFF0284C7),
            ),
          ),
          const SizedBox(height: 12),
          child,
        ],
      ),
    );
  }

  Widget _buildProfileField({
    required IconData icon,
    required String label,
    required TextEditingController controller,
    required bool isEditing,
    required bool isDarkMode,
    TextInputType? inputType,
  }) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Icon(
          icon,
          size: 20,
          color: isDarkMode ? const Color(0xFF0EA5E9) : const Color(0xFF0284C7),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                label,
                style: TextStyle(
                  fontSize: 12,
                  color: isDarkMode ? const Color(0xFF9CA3AF) : const Color(0xFF6B7280),
                ),
              ),
              const SizedBox(height: 4),
              isEditing
                  ? TextField(
                      controller: controller,
                      keyboardType: inputType,
                      style: TextStyle(
                        color: isDarkMode
                            ? const Color(0xFFD1D5DB)
                            : const Color(0xFF1F2937),
                      ),
                      decoration: InputDecoration(
                        isDense: true,
                        contentPadding: const EdgeInsets.symmetric(
                          horizontal: 12,
                          vertical: 8,
                        ),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8),
                          borderSide: BorderSide(
                            color: isDarkMode
                                ? const Color(0xFF1E4976)
                                : const Color(0xFFBAE6FD),
                          ),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8),
                          borderSide: const BorderSide(
                            color: Color(0xFF0EA5E9),
                            width: 2,
                          ),
                        ),
                        filled: true,
                        fillColor: isDarkMode
                            ? const Color(0xFF0A1929)
                            : const Color(0xFFF0F9FF),
                      ),
                    )
                  : Text(
                      controller.text,
                      style: TextStyle(
                        fontSize: 15,
                        color: isDarkMode
                            ? const Color(0xFFD1D5DB)
                            : const Color(0xFF1F2937),
                      ),
                    ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildStatCard({
    required String label,
    required String value,
    required bool isDarkMode,
  }) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: isDarkMode ? const Color(0xFF132F4C) : Colors.white,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: isDarkMode ? const Color(0xFF1E4976) : const Color(0xFFBAE6FD),
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.03),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        children: [
          Text(
            value,
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: isDarkMode ? const Color(0xFF0EA5E9) : const Color(0xFF0284C7),
            ),
          ),
          const SizedBox(height: 4),
          Text(
            label,
            style: TextStyle(
              fontSize: 12,
              color: isDarkMode ? const Color(0xFF9CA3AF) : const Color(0xFF6B7280),
            ),
          ),
        ],
      ),
    );
  }
}
