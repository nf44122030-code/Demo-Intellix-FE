import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/theme_provider.dart';

class PricingPlan {
  final String id;
  final String name;
  final IconData icon;
  final int price;
  final String period;
  final String description;
  final List<String> features;
  final bool popular;
  final Color gradientFrom;
  final Color gradientTo;

  PricingPlan({
    required this.id,
    required this.name,
    required this.icon,
    required this.price,
    required this.period,
    required this.description,
    required this.features,
    this.popular = false,
    required this.gradientFrom,
    required this.gradientTo,
  });
}

class PricingPage extends StatefulWidget {
  const PricingPage({super.key});

  @override
  State<PricingPage> createState() => _PricingPageState();
}

class _PricingPageState extends State<PricingPage> with SingleTickerProviderStateMixin {
  bool isYearly = false;
  String? selectedPlanId;
  late AnimationController _toggleController;

  final List<PricingPlan> plans = [
    PricingPlan(
      id: 'basic',
      name: 'Basic',
      icon: Icons.auto_awesome,
      price: 0,
      period: 'Forever',
      description: 'Perfect for getting started with Intellix',
      features: [
        'AI Assistant (Limited)',
        '5 Expert Sessions/month',
        'Basic Analytics',
        'Community Access',
        'Mobile App Access',
        'Email Support',
      ],
      gradientFrom: const Color(0xFF9CA3AF),
      gradientTo: const Color(0xFF6B7280),
    ),
    PricingPlan(
      id: 'pro',
      name: 'Pro',
      icon: Icons.flash_on,
      price: 29,
      period: 'per month',
      description: 'For professionals who need more power',
      features: [
        'Unlimited AI Assistant',
        '20 Expert Sessions/month',
        'Advanced Analytics',
        'Priority Support',
        'Custom Reports',
        'Team Collaboration (up to 5)',
        'API Access',
        'Data Export',
      ],
      popular: true,
      gradientFrom: const Color(0xFF5B9FF3),
      gradientTo: const Color(0xFF7DB6F7),
    ),
    PricingPlan(
      id: 'enterprise',
      name: 'Enterprise',
      icon: Icons.workspace_premium,
      price: 99,
      period: 'per month',
      description: 'For teams and organizations',
      features: [
        'Everything in Pro',
        'Unlimited Expert Sessions',
        'Custom AI Training',
        'Dedicated Account Manager',
        'Advanced Security',
        'Unlimited Team Members',
        'Custom Integrations',
        'SLA Guarantee',
        'White-label Options',
        'On-premise Deployment',
      ],
      gradientFrom: const Color(0xFF0284C7),
      gradientTo: const Color(0xFF06B6D4),
    ),
  ];

  final List<Map<String, dynamic>> additionalFeatures = [
    {
      'icon': Icons.security,
      'iconColor': Color(0xFF10B981),
      'title': 'Secure & Private',
      'description': 'Enterprise-grade security for your data',
    },
    {
      'icon': Icons.access_time,
      'iconColor': Color(0xFF3B82F6),
      'title': '24/7 Availability',
      'description': 'Access your AI assistant anytime',
    },
    {
      'icon': Icons.people,
      'iconColor': Color(0xFF06B6D4),
      'title': 'Expert Network',
      'description': 'Connect with industry professionals',
    },
    {
      'icon': Icons.trending_up,
      'iconColor': Color(0xFFF97316),
      'title': 'Growth Analytics',
      'description': 'Track your business insights',
    },
  ];

  @override
  void initState() {
    super.initState();
    _toggleController = AnimationController(
      duration: const Duration(milliseconds: 200),
      vsync: this,
    );
  }

  @override
  void dispose() {
    _toggleController.dispose();
    super.dispose();
  }

  void _handlePlanSelection(String planId) {
    setState(() {
      selectedPlanId = planId;
    });
    Future.delayed(const Duration(seconds: 2), () {
      if (mounted) {
        setState(() {
          selectedPlanId = null;
        });
      }
    });
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
                // App Bar with curved bottom
                Container(
                  decoration: BoxDecoration(
                    gradient: isDarkMode
                        ? const LinearGradient(
                            colors: [Color(0xFF0369A1), Color(0xFF0EA5E9)],
                          )
                        : const LinearGradient(
                            colors: [Color(0xFF0284C7), Color(0xFF0EA5E9), Color(0xFF06B6D4)],
                          ),
                    borderRadius: const BorderRadius.only(
                      bottomLeft: Radius.circular(40),
                      bottomRight: Radius.circular(40),
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: (isDarkMode ? const Color(0xFF0EA5E9) : const Color(0xFF0284C7))
                            .withOpacity(0.3),
                        blurRadius: 20,
                        offset: const Offset(0, 10),
                      ),
                    ],
                  ),
                  padding: const EdgeInsets.only(top: 40, bottom: 96, left: 24, right: 24),
                  child: Row(
                    children: [
                      IconButton(
                        icon: const Icon(Icons.arrow_back, color: Colors.white, size: 24),
                        onPressed: () => Navigator.pop(context),
                      ),
                      const Expanded(
                        child: Center(
                          child: Text(
                            'PRICING',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w500,
                              color: Colors.white,
                              letterSpacing: 4.8,
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(width: 40), // Spacer for centering
                    ],
                  ),
                ),

                // Main Content
                Expanded(
                  child: SingleChildScrollView(
                    padding: const EdgeInsets.fromLTRB(24, 80, 24, 24),
                    child: Column(
                      children: [
                        // Header
                        Text(
                          'Choose Your Plan',
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                            color: isDarkMode ? Colors.white : const Color(0xFF1F2937),
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          'Select the perfect plan for your needs',
                          style: TextStyle(
                            fontSize: 14,
                            color: isDarkMode ? const Color(0xFF9CA3AF) : const Color(0xFF6B7280),
                          ),
                        ),
                        const SizedBox(height: 24),

                        // Billing Toggle
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              'Monthly',
                              style: TextStyle(
                                fontSize: 14,
                                color: !isYearly
                                    ? (isDarkMode ? Colors.white : const Color(0xFF1F2937))
                                    : (isDarkMode
                                        ? const Color(0xFF6B7280)
                                        : const Color(0xFF6B7280)),
                              ),
                            ),
                            const SizedBox(width: 12),
                            GestureDetector(
                              onTap: () {
                                setState(() {
                                  isYearly = !isYearly;
                                  if (isYearly) {
                                    _toggleController.forward();
                                  } else {
                                    _toggleController.reverse();
                                  }
                                });
                              },
                              child: Container(
                                width: 56,
                                height: 28,
                                decoration: BoxDecoration(
                                  color: isYearly
                                      ? (isDarkMode
                                          ? const Color(0xFF7B96F5)
                                          : const Color(0xFF5B9FF3))
                                      : (isDarkMode
                                          ? const Color(0xFF4B5563)
                                          : const Color(0xFFD1D5DB)),
                                  borderRadius: BorderRadius.circular(14),
                                ),
                                child: AnimatedAlign(
                                  duration: const Duration(milliseconds: 200),
                                  curve: Curves.easeInOut,
                                  alignment:
                                      isYearly ? Alignment.centerRight : Alignment.centerLeft,
                                  child: Container(
                                    margin: const EdgeInsets.all(2),
                                    width: 24,
                                    height: 24,
                                    decoration: const BoxDecoration(
                                      color: Colors.white,
                                      shape: BoxShape.circle,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                            const SizedBox(width: 12),
                            Text(
                              'Yearly',
                              style: TextStyle(
                                fontSize: 14,
                                color: isYearly
                                    ? (isDarkMode ? Colors.white : const Color(0xFF1F2937))
                                    : (isDarkMode
                                        ? const Color(0xFF6B7280)
                                        : const Color(0xFF6B7280)),
                              ),
                            ),
                            if (isYearly) ...[
                              const SizedBox(width: 8),
                              Container(
                                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                                decoration: BoxDecoration(
                                  color: isDarkMode
                                      ? const Color(0xFF10B981).withOpacity(0.2)
                                      : const Color(0xFFD1FAE5),
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                child: Text(
                                  'Save 20%',
                                  style: TextStyle(
                                    fontSize: 11,
                                    fontWeight: FontWeight.w600,
                                    color: isDarkMode
                                        ? const Color(0xFF34D399)
                                        : const Color(0xFF059669),
                                  ),
                                ),
                              ),
                            ],
                          ],
                        ),
                        const SizedBox(height: 24),

                        // Pricing Cards
                        ...plans.map((plan) => Padding(
                              padding: const EdgeInsets.only(bottom: 16),
                              child: _buildPricingCard(plan, isDarkMode),
                            )),

                        const SizedBox(height: 24),

                        // All Plans Include
                        Text(
                          'All Plans Include',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                            color: isDarkMode ? Colors.white : const Color(0xFF1F2937),
                          ),
                        ),
                        const SizedBox(height: 16),
                        GridView.builder(
                          shrinkWrap: true,
                          physics: const NeverScrollableScrollPhysics(),
                          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: 2,
                            crossAxisSpacing: 12,
                            mainAxisSpacing: 12,
                            childAspectRatio: 1.1,
                          ),
                          itemCount: additionalFeatures.length,
                          itemBuilder: (context, index) {
                            final feature = additionalFeatures[index];
                            return Container(
                              padding: const EdgeInsets.all(16),
                              decoration: BoxDecoration(
                                color: isDarkMode
                                    ? const Color(0xFF2D2D2D)
                                    : Colors.white,
                                borderRadius: BorderRadius.circular(12),
                                border: Border.all(
                                  color: isDarkMode
                                      ? const Color(0xFF4B5563)
                                      : const Color(0xFFE5E7EB),
                                ),
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.black.withOpacity(0.05),
                                    blurRadius: 10,
                                    offset: const Offset(0, 4),
                                  ),
                                ],
                              ),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Icon(
                                    feature['icon'] as IconData,
                                    size: 20,
                                    color: feature['iconColor'] as Color,
                                  ),
                                  const SizedBox(height: 8),
                                  Text(
                                    feature['title'],
                                    style: TextStyle(
                                      fontSize: 13,
                                      fontWeight: FontWeight.w600,
                                      color: isDarkMode ? Colors.white : const Color(0xFF1F2937),
                                    ),
                                  ),
                                  const SizedBox(height: 4),
                                  Text(
                                    feature['description'],
                                    style: TextStyle(
                                      fontSize: 11,
                                      color: isDarkMode
                                          ? const Color(0xFF6B7280)
                                          : const Color(0xFF6B7280),
                                    ),
                                  ),
                                ],
                              ),
                            );
                          },
                        ),
                        const SizedBox(height: 24),

                        // FAQ Section
                        Text(
                          'Frequently Asked Questions',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                            color: isDarkMode ? Colors.white : const Color(0xFF1F2937),
                          ),
                        ),
                        const SizedBox(height: 16),
                        _buildFAQItem(
                          'Can I change my plan later?',
                          'Yes, you can upgrade or downgrade your plan at any time from your account settings.',
                          isDarkMode,
                        ),
                        const SizedBox(height: 12),
                        _buildFAQItem(
                          'What payment methods do you accept?',
                          'We accept all major credit cards, PayPal, and bank transfers for Enterprise plans.',
                          isDarkMode,
                        ),
                        const SizedBox(height: 12),
                        _buildFAQItem(
                          'Is there a free trial?',
                          'Yes! All paid plans come with a 14-day free trial. No credit card required.',
                          isDarkMode,
                        ),
                        const SizedBox(height: 24),

                        // Contact Card
                        Container(
                          padding: const EdgeInsets.all(24),
                          decoration: BoxDecoration(
                            gradient: isDarkMode
                                ? const LinearGradient(
                                    colors: [Color(0xFF0369A1), Color(0xFF0EA5E9)],
                                  )
                                : const LinearGradient(
                                    colors: [Color(0xFF0284C7), Color(0xFF06B6D4)],
                                  ),
                            borderRadius: BorderRadius.circular(16),
                          ),
                          child: Column(
                            children: [
                              const Text(
                                'Need a Custom Plan?',
                                style: TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white,
                                ),
                              ),
                              const SizedBox(height: 8),
                              Text(
                                'Contact our sales team for custom pricing and features tailored to your organization.',
                                textAlign: TextAlign.center,
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
                                  'Contact Sales',
                                  style: TextStyle(fontWeight: FontWeight.w600),
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

            // Icon Overlay
            Positioned(
              top: 120,
              left: 0,
              right: 0,
              child: Center(
                child: Container(
                  width: 128,
                  height: 128,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    shape: BoxShape.circle,
                    border: Border.all(
                      color: Colors.white,
                      width: 4,
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.1),
                        blurRadius: 20,
                        offset: const Offset(0, 10),
                      ),
                    ],
                  ),
                  child: const Icon(
                    Icons.star,
                    size: 64,
                    color: Color(0xFF5B9FF3),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPricingCard(PricingPlan plan, bool isDarkMode) {
    final yearlyPrice = (plan.price * 12 * 0.8).round();
    final displayPrice = isYearly ? yearlyPrice : plan.price;
    final monthlySavings = isYearly ? ((plan.price * 12 - yearlyPrice) / 12).round() : 0;
    final isSelected = selectedPlanId == plan.id;

    return TweenAnimationBuilder<double>(
      tween: Tween(begin: 1.0, end: isSelected ? 0.95 : 1.0),
      duration: const Duration(milliseconds: 100),
      builder: (context, scale, child) {
        return Transform.scale(
          scale: scale,
          child: child,
        );
      },
      child: Container(
        decoration: BoxDecoration(
          color: isDarkMode
              ? const Color(0xFF132F4C)
              : Colors.white,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: plan.popular
                ? const Color(0xFF0EA5E9)
                : (isDarkMode ? const Color(0xFF1E4976) : const Color(0xFFBAE6FD)),
            width: plan.popular ? 2 : 1,
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.05),
              blurRadius: 10,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Stack(
          children: [
            // Popular Badge
            if (plan.popular)
              Positioned(
                top: 0,
                right: 0,
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
                  decoration: BoxDecoration(
                    gradient: isDarkMode
                        ? const LinearGradient(
                            colors: [Color(0xFF0369A1), Color(0xFF0EA5E9)],
                          )
                        : const LinearGradient(
                            colors: [Color(0xFF0284C7), Color(0xFF06B6D4)],
                          ),
                    borderRadius: const BorderRadius.only(
                      topRight: Radius.circular(14),
                      bottomLeft: Radius.circular(12),
                    ),
                  ),
                  child: const Text(
                    'Most Popular',
                    style: TextStyle(
                      fontSize: 11,
                      fontWeight: FontWeight.w600,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),

            Padding(
              padding: const EdgeInsets.all(24),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Header with Icon
                  Row(
                    children: [
                      Container(
                        width: 48,
                        height: 48,
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            colors: [plan.gradientFrom, plan.gradientTo],
                          ),
                          shape: BoxShape.circle,
                        ),
                        child: Icon(
                          plan.icon,
                          size: 24,
                          color: Colors.white,
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              plan.name,
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                                color: isDarkMode ? Colors.white : const Color(0xFF1F2937),
                              ),
                            ),
                            Text(
                              plan.description,
                              style: TextStyle(
                                fontSize: 11,
                                color: isDarkMode
                                    ? const Color(0xFF6B7280)
                                    : const Color(0xFF6B7280),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),

                  // Price
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        '\$$displayPrice',
                        style: TextStyle(
                          fontSize: 36,
                          fontWeight: FontWeight.bold,
                          color: isDarkMode ? Colors.white : const Color(0xFF1F2937),
                        ),
                      ),
                      if (isYearly && plan.price > 0)
                        Padding(
                          padding: const EdgeInsets.only(left: 8, top: 4),
                          child: Text(
                            '/year',
                            style: TextStyle(
                              fontSize: 13,
                              color: isDarkMode
                                  ? const Color(0xFF6B7280)
                                  : const Color(0xFF6B7280),
                            ),
                          ),
                        ),
                      if (!isYearly && plan.price > 0)
                        Padding(
                          padding: const EdgeInsets.only(left: 8, top: 4),
                          child: Text(
                            '/month',
                            style: TextStyle(
                              fontSize: 13,
                              color: isDarkMode
                                  ? const Color(0xFF6B7280)
                                  : const Color(0xFF6B7280),
                            ),
                          ),
                        ),
                      if (plan.price == 0)
                        Padding(
                          padding: const EdgeInsets.only(left: 8, top: 4),
                          child: Text(
                            'Free',
                            style: TextStyle(
                              fontSize: 13,
                              color: isDarkMode
                                  ? const Color(0xFF6B7280)
                                  : const Color(0xFF6B7280),
                            ),
                          ),
                        ),
                    ],
                  ),
                  if (isYearly && monthlySavings > 0)
                    Padding(
                      padding: const EdgeInsets.only(top: 4),
                      child: Text(
                        'Save \$$monthlySavings/month',
                        style: TextStyle(
                          fontSize: 12,
                          color: isDarkMode
                              ? const Color(0xFF34D399)
                              : const Color(0xFF059669),
                        ),
                      ),
                    ),
                  const SizedBox(height: 16),

                  // Features
                  ...plan.features.map((feature) => Padding(
                        padding: const EdgeInsets.only(bottom: 8),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Icon(
                              Icons.check,
                              size: 16,
                              color: Color(0xFF10B981),
                            ),
                            const SizedBox(width: 8),
                            Expanded(
                              child: Text(
                                feature,
                                style: TextStyle(
                                  fontSize: 13,
                                  color: isDarkMode
                                      ? const Color(0xFF9CA3AF)
                                      : const Color(0xFF6B7280),
                                ),
                              ),
                            ),
                          ],
                        ),
                      )),
                  const SizedBox(height: 16),

                  // CTA Button
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: isSelected ? null : () => _handlePlanSelection(plan.id),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: plan.popular
                            ? Colors.transparent
                            : (isDarkMode
                                ? const Color(0xFF1E4976)
                                : const Color(0xFFE0F2FE)),
                        foregroundColor: plan.popular
                            ? Colors.white
                            : (isDarkMode
                                ? const Color(0xFFD1D5DB)
                                : const Color(0xFF0369A1)),
                        padding: EdgeInsets.zero,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(24),
                        ),
                        elevation: 0,
                        disabledBackgroundColor:
                            isDarkMode ? const Color(0xFF1E4976) : const Color(0xFFE0F2FE),
                      ),
                      child: plan.popular
                          ? Ink(
                              decoration: BoxDecoration(
                                gradient: isDarkMode
                                    ? const LinearGradient(
                                        colors: [Color(0xFF0369A1), Color(0xFF0EA5E9)],
                                      )
                                    : const LinearGradient(
                                        colors: [Color(0xFF0284C7), Color(0xFF06B6D4)],
                                      ),
                                borderRadius: BorderRadius.circular(24),
                              ),
                              child: Container(
                                padding: const EdgeInsets.symmetric(vertical: 12),
                                alignment: Alignment.center,
                                child: Text(
                                  isSelected
                                      ? 'Selected ✓'
                                      : (plan.price == 0 ? 'Get Started' : 'Choose Plan'),
                                  style: const TextStyle(
                                    fontSize: 15,
                                    fontWeight: FontWeight.w600,
                                    color: Colors.white,
                                  ),
                                ),
                              ),
                            )
                          : Padding(
                              padding: const EdgeInsets.symmetric(vertical: 12),
                              child: Text(
                                isSelected
                                    ? 'Selected ✓'
                                    : (plan.price == 0 ? 'Get Started' : 'Choose Plan'),
                                style: TextStyle(
                                  fontSize: 15,
                                  fontWeight: FontWeight.w600,
                                  color: plan.popular
                                      ? Colors.white
                                      : (isDarkMode
                                          ? const Color(0xFFD1D5DB)
                                          : const Color(0xFF0369A1)),
                                ),
                              ),
                            ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildFAQItem(String question, String answer, bool isDarkMode) {
    return _FAQItem(question: question, answer: answer, isDarkMode: isDarkMode);
  }
}

class _FAQItem extends StatefulWidget {
  final String question;
  final String answer;
  final bool isDarkMode;

  const _FAQItem({
    required this.question,
    required this.answer,
    required this.isDarkMode,
  });

  @override
  State<_FAQItem> createState() => _FAQItemState();
}

class _FAQItemState extends State<_FAQItem> {
  bool isOpen = false;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: widget.isDarkMode ? const Color(0xFF2D2D2D) : Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: widget.isDarkMode ? const Color(0xFF4B5563) : const Color(0xFFE5E7EB),
        ),
      ),
      child: Column(
        children: [
          InkWell(
            onTap: () {
              setState(() {
                isOpen = !isOpen;
              });
            },
            borderRadius: BorderRadius.circular(12),
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Row(
                children: [
                  Expanded(
                    child: Text(
                      widget.question,
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                        color: widget.isDarkMode ? Colors.white : const Color(0xFF1F2937),
                      ),
                    ),
                  ),
                  AnimatedRotation(
                    turns: isOpen ? 0.5 : 0,
                    duration: const Duration(milliseconds: 200),
                    child: Icon(
                      Icons.keyboard_arrow_down,
                      size: 20,
                      color: widget.isDarkMode
                          ? const Color(0xFF9CA3AF)
                          : const Color(0xFF6B7280),
                    ),
                  ),
                ],
              ),
            ),
          ),
          AnimatedCrossFade(
            firstChild: const SizedBox.shrink(),
            secondChild: Padding(
              padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
              child: Text(
                widget.answer,
                style: TextStyle(
                  fontSize: 13,
                  color: widget.isDarkMode
                      ? const Color(0xFF9CA3AF)
                      : const Color(0xFF6B7280),
                ),
              ),
            ),
            crossFadeState:
                isOpen ? CrossFadeState.showSecond : CrossFadeState.showFirst,
            duration: const Duration(milliseconds: 200),
          ),
        ],
      ),
    );
  }
}
