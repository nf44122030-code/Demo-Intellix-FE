import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/theme_provider.dart';

// FAQ Data Model
class FAQCategory {
  final String category;
  final List<FAQItem> questions;

  FAQCategory({required this.category, required this.questions});
}

class FAQItem {
  final String question;
  final String answer;

  FAQItem({required this.question, required this.answer});
}

// FAQ Data
final List<FAQCategory> faqData = [
  FAQCategory(
    category: 'Getting Started',
    questions: [
      FAQItem(
        question: 'How do I create an account?',
        answer: 'Tap on "Sign Up" from the login screen and fill in your details. Verify your email to complete registration.',
      ),
      FAQItem(
        question: 'How do I reset my password?',
        answer: 'Click "Forgot Password" on the login screen and follow the instructions sent to your email.',
      ),
      FAQItem(
        question: 'What is Intellix?',
        answer: 'Intellix is an AI-powered business intelligence platform that helps you analyze trends, gain insights, and make data-driven decisions.',
      ),
    ],
  ),
  FAQCategory(
    category: 'AI Assistant',
    questions: [
      FAQItem(
        question: 'How do I use the AI Assistant?',
        answer: 'Navigate to the AI Chat tab and type your question. The AI will provide intelligent responses based on your business data.',
      ),
      FAQItem(
        question: 'What can I ask the AI?',
        answer: 'You can ask about business metrics, trends, forecasts, data analysis, and get recommendations for improving your business.',
      ),
      FAQItem(
        question: 'Is my data secure with AI?',
        answer: 'Yes, all conversations are encrypted and your data is processed securely. We never share your information with third parties.',
      ),
    ],
  ),
  FAQCategory(
    category: 'Features',
    questions: [
      FAQItem(
        question: 'How do I view trends?',
        answer: 'Navigate to the Trends page from the home screen or sidebar. You can filter by timeframe (week, month, year) to see different data views.',
      ),
      FAQItem(
        question: 'Can I export my data?',
        answer: 'Yes, you can export reports and data from the Settings page under Data Management.',
      ),
      FAQItem(
        question: 'How do I customize my dashboard?',
        answer: 'Go to Settings > Preferences to customize your dashboard layout and widgets.',
      ),
    ],
  ),
  FAQCategory(
    category: 'Account & Privacy',
    questions: [
      FAQItem(
        question: 'How do I delete my account?',
        answer: 'Go to Settings > Danger Zone > Delete Account. Note that this action is permanent and cannot be undone.',
      ),
      FAQItem(
        question: 'How is my data protected?',
        answer: 'We use industry-standard encryption and security measures to protect your data. Read our Privacy Policy for more details.',
      ),
      FAQItem(
        question: 'Can I change my email address?',
        answer: 'Yes, go to Settings > Account > Change Email and follow the verification process.',
      ),
    ],
  ),
];

// Quick Help Topics Data
class QuickHelpTopic {
  final IconData icon;
  final String title;
  final String subtitle;

  QuickHelpTopic({
    required this.icon,
    required this.title,
    required this.subtitle,
  });
}

final List<QuickHelpTopic> quickHelpTopics = [
  QuickHelpTopic(
    icon: Icons.book,
    title: 'User Guide',
    subtitle: 'Complete documentation',
  ),
  QuickHelpTopic(
    icon: Icons.video_library,
    title: 'Video Tutorials',
    subtitle: 'Step-by-step guides',
  ),
  QuickHelpTopic(
    icon: Icons.chat_bubble_outline,
    title: 'Live Chat',
    subtitle: 'Chat with support',
  ),
  QuickHelpTopic(
    icon: Icons.description,
    title: 'Release Notes',
    subtitle: "What's new",
  ),
];

class HelpPage extends StatefulWidget {
  const HelpPage({super.key});

  @override
  State<HelpPage> createState() => _HelpPageState();
}

class _HelpPageState extends State<HelpPage> {
  final TextEditingController _searchController = TextEditingController();
  String _searchQuery = '';
  String? _expandedQuestion;

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  List<FAQCategory> get filteredFAQs {
    if (_searchQuery.isEmpty) return faqData;

    return faqData.map((category) {
      final filteredQuestions = category.questions.where((q) {
        return q.question.toLowerCase().contains(_searchQuery.toLowerCase()) ||
            q.answer.toLowerCase().contains(_searchQuery.toLowerCase());
      }).toList();

      return FAQCategory(
        category: category.category,
        questions: filteredQuestions,
      );
    }).where((category) => category.questions.isNotEmpty).toList();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<ThemeProvider>(
      builder: (context, themeProvider, _) {
        final isDarkMode = themeProvider.isDarkMode;
        final iconColor = isDarkMode ? const Color(0xFF0EA5E9) : const Color(0xFF0284C7);

        return Scaffold(
          backgroundColor: isDarkMode
              ? const Color(0xFF0A1929)
              : const Color(0xFFF0F9FF),
          body: Stack(
            children: [
              Column(
                children: [
                  // ===== CURVED APP BAR =====
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
                              colors: [
                                Color(0xFF0284C7),
                                Color(0xFF0EA5E9),
                                Color(0xFF06B6D4),
                              ],
                            ),
                      borderRadius: const BorderRadius.only(
                        bottomLeft: Radius.circular(40),
                        bottomRight: Radius.circular(40),
                      ),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.1),
                          blurRadius: 10,
                          offset: const Offset(0, 4),
                        ),
                      ],
                    ),
                    padding: const EdgeInsets.only(
                      top: 40,
                      bottom: 96,
                      left: 24,
                      right: 24,
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        IconButton(
                          icon: const Icon(Icons.arrow_back, color: Colors.white),
                          onPressed: () => Navigator.pop(context),
                        ),
                        const Text(
                          'HELP CENTER',
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                            letterSpacing: 4.8,
                          ),
                        ),
                        const SizedBox(width: 48),
                      ],
                    ),
                  ),

                  // ===== SCROLLABLE CONTENT =====
                  Expanded(
                    child: SingleChildScrollView(
                      padding: const EdgeInsets.only(
                        top: 80,
                        left: 24,
                        right: 24,
                        bottom: 24,
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // ===== SEARCH BAR =====
                          Container(
                            decoration: BoxDecoration(
                              color: isDarkMode
                                  ? const Color(0xFF132F4C)
                                  : Colors.white,
                              borderRadius: BorderRadius.circular(16),
                              border: Border.all(
                                color: isDarkMode
                                    ? const Color(0xFF1E4976)
                                    : const Color(0xFFE5E7EB),
                              ),
                            ),
                            child: TextField(
                              controller: _searchController,
                              onChanged: (value) {
                                setState(() => _searchQuery = value);
                              },
                              style: TextStyle(
                                color: isDarkMode ? Colors.white : const Color(0xFF1F2937),
                              ),
                              decoration: InputDecoration(
                                hintText: 'Search for help...',
                                hintStyle: TextStyle(
                                  color: isDarkMode
                                      ? const Color(0xFF6B7280)
                                      : const Color(0xFF9CA3AF),
                                ),
                                prefixIcon: Icon(
                                  Icons.search,
                                  color: isDarkMode
                                      ? const Color(0xFF6B7280)
                                      : const Color(0xFF9CA3AF),
                                ),
                                border: InputBorder.none,
                                contentPadding: const EdgeInsets.all(12),
                              ),
                            ),
                          ),
                          const SizedBox(height: 24),

                          // ===== QUICK ACCESS =====
                          _buildSectionHeader('QUICK ACCESS', isDarkMode),
                          const SizedBox(height: 12),
                          GridView.builder(
                            shrinkWrap: true,
                            physics: const NeverScrollableScrollPhysics(),
                            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                              crossAxisCount: 2,
                              crossAxisSpacing: 12,
                              mainAxisSpacing: 12,
                              childAspectRatio: 1.4,
                            ),
                            itemCount: quickHelpTopics.length,
                            itemBuilder: (context, index) {
                              final topic = quickHelpTopics[index];
                              return _buildQuickHelpCard(
                                topic: topic,
                                iconColor: iconColor,
                                isDarkMode: isDarkMode,
                              );
                            },
                          ),
                          const SizedBox(height: 24),

                          // ===== FREQUENTLY ASKED QUESTIONS =====
                          _buildSectionHeader('FREQUENTLY ASKED QUESTIONS', isDarkMode),
                          const SizedBox(height: 12),
                          
                          if (filteredFAQs.isEmpty && _searchQuery.isNotEmpty)
                            _buildNoResults(isDarkMode)
                          else
                            ...filteredFAQs.map((category) {
                              if (category.questions.isEmpty) return const SizedBox.shrink();
                              
                              return Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Padding(
                                    padding: const EdgeInsets.only(left: 8, bottom: 8),
                                    child: Text(
                                      category.category,
                                      style: TextStyle(
                                        fontSize: 14,
                                        fontWeight: FontWeight.w600,
                                        color: isDarkMode
                                            ? const Color(0xFFD1D5DB)
                                            : const Color(0xFF374151),
                                      ),
                                    ),
                                  ),
                                  Container(
                                    decoration: BoxDecoration(
                                      color: isDarkMode
                                          ? const Color(0xFF132F4C)
                                          : Colors.white,
                                      borderRadius: BorderRadius.circular(16),
                                      border: Border.all(
                                        color: isDarkMode
                                            ? const Color(0xFF1E4976)
                                            : const Color(0xFFE5E7EB),
                                      ),
                                    ),
                                    child: Column(
                                      children: category.questions.asMap().entries.map((entry) {
                                        final index = entry.key;
                                        final item = entry.value;
                                        final questionId = '${category.category}-$index';
                                        final isExpanded = _expandedQuestion == questionId;
                                        final isLast = index == category.questions.length - 1;

                                        return _buildFAQItem(
                                          question: item.question,
                                          answer: item.answer,
                                          isExpanded: isExpanded,
                                          onTap: () {
                                            setState(() {
                                              _expandedQuestion = isExpanded ? null : questionId;
                                            });
                                          },
                                          showBorder: !isLast,
                                          isDarkMode: isDarkMode,
                                        );
                                      }).toList(),
                                    ),
                                  ),
                                  const SizedBox(height: 16),
                                ],
                              );
                            }).toList(),

                          const SizedBox(height: 8),

                          // ===== CONTACT SUPPORT =====
                          _buildSectionHeader('CONTACT SUPPORT', isDarkMode),
                          const SizedBox(height: 12),
                          Container(
                            decoration: BoxDecoration(
                              color: isDarkMode
                                  ? const Color(0xFF132F4C)
                                  : Colors.white,
                              borderRadius: BorderRadius.circular(16),
                              border: Border.all(
                                color: isDarkMode
                                    ? const Color(0xFF1E4976)
                                    : const Color(0xFFBAE6FD),
                              ),
                            ),
                            child: Column(
                              children: [
                                _buildContactItem(
                                  icon: Icons.chat_bubble_outline,
                                  title: 'Live Chat',
                                  subtitle: 'Available 24/7',
                                  iconColor: iconColor,
                                  isDarkMode: isDarkMode,
                                  showBorder: true,
                                ),
                                _buildContactItem(
                                  icon: Icons.email,
                                  title: 'Email Support',
                                  subtitle: 'support@intellix.com',
                                  iconColor: iconColor,
                                  isDarkMode: isDarkMode,
                                  showBorder: true,
                                ),
                                _buildContactItem(
                                  icon: Icons.phone,
                                  title: 'Phone Support',
                                  subtitle: '+1 (800) 123-4567',
                                  iconColor: iconColor,
                                  isDarkMode: isDarkMode,
                                  showBorder: false,
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(height: 24),

                          // ===== STILL NEED HELP CARD =====
                          Container(
                            padding: const EdgeInsets.all(24),
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
                                      colors: [Color(0xFF0284C7), Color(0xFF06B6D4)],
                                    ),
                              borderRadius: BorderRadius.circular(16),
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const Icon(
                                  Icons.check_circle,
                                  size: 40,
                                  color: Colors.white,
                                ),
                                const SizedBox(height: 12),
                                const Text(
                                  'Still need help?',
                                  style: TextStyle(
                                    fontSize: 20,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.white,
                                  ),
                                ),
                                const SizedBox(height: 8),
                                Text(
                                  'Our support team is ready to assist you with any questions or issues.',
                                  style: TextStyle(
                                    fontSize: 14,
                                    color: Colors.white.withOpacity(0.9),
                                  ),
                                ),
                                const SizedBox(height: 16),
                                ElevatedButton(
                                  onPressed: () {},
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: Colors.white,
                                    foregroundColor: isDarkMode
                                        ? const Color(0xFF0369A1)
                                        : const Color(0xFF0284C7),
                                    padding: const EdgeInsets.symmetric(
                                      horizontal: 24,
                                      vertical: 12,
                                    ),
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(24),
                                    ),
                                  ),
                                  child: const Text(
                                    'Contact Us',
                                    style: TextStyle(fontWeight: FontWeight.w600),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(height: 24),

                          // ===== APP INFO FOOTER =====
                          Center(
                            child: Column(
                              children: [
                                Text(
                                  'Intellix v1.0.0',
                                  style: TextStyle(
                                    fontSize: 14,
                                    color: isDarkMode
                                        ? const Color(0xFF6B7280)
                                        : const Color(0xFF9CA3AF),
                                  ),
                                ),
                                const SizedBox(height: 4),
                                Text(
                                  'Last updated: December 2025',
                                  style: TextStyle(
                                    fontSize: 12,
                                    color: isDarkMode
                                        ? const Color(0xFF6B7280)
                                        : const Color(0xFF9CA3AF),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),

              // ===== ICON OVERLAY =====
              Positioned(
                top: 120,
                left: MediaQuery.of(context).size.width / 2 - 64,
                child: Container(
                  width: 128,
                  height: 128,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    shape: BoxShape.circle,
                    border: Border.all(color: Colors.white, width: 4),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.15),
                        blurRadius: 20,
                        offset: const Offset(0, 8),
                      ),
                    ],
                  ),
                  child: Icon(
                    Icons.help_outline,
                    size: 64,
                    color: iconColor,
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildSectionHeader(String title, bool isDarkMode) {
    return Padding(
      padding: const EdgeInsets.only(left: 8),
      child: Text(
        title,
        style: TextStyle(
          fontSize: 12,
          fontWeight: FontWeight.w600,
          color: const Color(0xFF6B7280),
          letterSpacing: 1.2,
        ),
      ),
    );
  }

  Widget _buildQuickHelpCard({
    required QuickHelpTopic topic,
    required Color iconColor,
    required bool isDarkMode,
  }) {
    return InkWell(
      onTap: () {},
      borderRadius: BorderRadius.circular(16),
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: isDarkMode ? const Color(0xFF132F4C) : Colors.white,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: isDarkMode
                ? const Color(0xFF1E4976)
                : const Color(0xFFE5E7EB),
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.05),
              blurRadius: 4,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              topic.icon,
              size: 20,
              color: iconColor,
            ),
            const SizedBox(height: 8),
            Text(
              topic.title,
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w600,
                color: isDarkMode ? Colors.white : const Color(0xFF1F2937),
              ),
            ),
            const SizedBox(height: 4),
            Text(
              topic.subtitle,
              style: const TextStyle(
                fontSize: 12,
                color: Color(0xFF6B7280),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildFAQItem({
    required String question,
    required String answer,
    required bool isExpanded,
    required VoidCallback onTap,
    required bool showBorder,
    required bool isDarkMode,
  }) {
    return Container(
      decoration: BoxDecoration(
        border: showBorder
            ? Border(
                bottom: BorderSide(
                  color: isDarkMode
                      ? const Color(0xFF1E4976)
                      : const Color(0xFFE5E7EB),
                ),
              )
            : null,
      ),
      child: Column(
        children: [
          InkWell(
            onTap: onTap,
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Row(
                children: [
                  Expanded(
                    child: Text(
                      question,
                      style: TextStyle(
                        fontSize: 16,
                        color: isDarkMode
                            ? const Color(0xFFD1D5DB)
                            : const Color(0xFF374151),
                      ),
                    ),
                  ),
                  AnimatedRotation(
                    turns: isExpanded ? 0.25 : 0,
                    duration: const Duration(milliseconds: 200),
                    child: Icon(
                      Icons.chevron_right,
                      size: 20,
                      color: const Color(0xFF9CA3AF),
                    ),
                  ),
                ],
              ),
            ),
          ),
          if (isExpanded)
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
              child: Text(
                answer,
                style: TextStyle(
                  fontSize: 14,
                  height: 1.5,
                  color: isDarkMode
                      ? const Color(0xFF9CA3AF)
                      : const Color(0xFF6B7280),
                ),
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildContactItem({
    required IconData icon,
    required String title,
    required String subtitle,
    required Color iconColor,
    required bool isDarkMode,
    required bool showBorder,
  }) {
    return InkWell(
      onTap: () {},
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          border: showBorder
              ? Border(
                  bottom: BorderSide(
                    color: isDarkMode
                        ? const Color(0xFF1E4976)
                        : const Color(0xFFE5E7EB),
                  ),
                )
              : null,
        ),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: isDarkMode
                    ? const Color(0xFF0A1929)
                    : const Color(0xFFF3F4F6),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Icon(
                icon,
                size: 20,
                color: iconColor,
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      color: isDarkMode ? Colors.white : const Color(0xFF1F2937),
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    subtitle,
                    style: const TextStyle(
                      fontSize: 14,
                      color: Color(0xFF6B7280),
                    ),
                  ),
                ],
              ),
            ),
            Icon(
              Icons.chevron_right,
              size: 20,
              color: isDarkMode
                  ? const Color(0xFF6B7280)
                  : const Color(0xFF9CA3AF),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildNoResults(bool isDarkMode) {
    return Container(
      padding: const EdgeInsets.all(32),
      decoration: BoxDecoration(
        color: isDarkMode ? const Color(0xFF132F4C) : Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: isDarkMode
              ? const Color(0xFF1E4976)
              : const Color(0xFFE5E7EB),
        ),
      ),
      child: Column(
        children: [
          Icon(
            Icons.search,
            size: 48,
            color: isDarkMode
                ? const Color(0xFF4B5563)
                : const Color(0xFFD1D5DB),
          ),
          const SizedBox(height: 12),
          Text(
            'No results found',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w600,
              color: isDarkMode
                  ? const Color(0xFF9CA3AF)
                  : const Color(0xFF6B7280),
            ),
          ),
          const SizedBox(height: 4),
          Text(
            'Try different keywords or contact support',
            style: TextStyle(
              fontSize: 14,
              color: isDarkMode
                  ? const Color(0xFF6B7280)
                  : const Color(0xFF9CA3AF),
            ),
          ),
        ],
      ),
    );
  }
}
