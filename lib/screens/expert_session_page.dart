import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/theme_provider.dart';
import 'video_session_page.dart';

class Expert {
  final int id;
  final String name;
  final String title;
  final String specialty;
  final double rating;
  final int reviews;
  final int hourlyRate;
  final String image;
  final String availability;
  final int yearsExperience;
  final int sessionsCompleted;
  final String bio;

  Expert({
    required this.id,
    required this.name,
    required this.title,
    required this.specialty,
    required this.rating,
    required this.reviews,
    required this.hourlyRate,
    required this.image,
    required this.availability,
    required this.yearsExperience,
    required this.sessionsCompleted,
    required this.bio,
  });
}

class ExpertSessionPage extends StatefulWidget {
  const ExpertSessionPage({super.key});

  @override
  State<ExpertSessionPage> createState() => _ExpertSessionPageState();
}

class _ExpertSessionPageState extends State<ExpertSessionPage> {
  Expert? selectedExpert;
  bool showBookingModal = false;
  bool showConfirmation = false;
  
  final TextEditingController _dateController = TextEditingController();
  final TextEditingController _timeController = TextEditingController();
  final TextEditingController _notesController = TextEditingController();
  String selectedDuration = '60';

  final List<Expert> expertsData = [
    Expert(
      id: 1,
      name: 'Dr. Sarah Johnson',
      title: 'Business Strategy Consultant',
      specialty: 'Business Growth & Strategy',
      rating: 4.9,
      reviews: 127,
      hourlyRate: 150,
      image: 'https://images.unsplash.com/photo-1573497019940-1c28c88b4f3e?w=400',
      availability: 'Available Today',
      yearsExperience: 12,
      sessionsCompleted: 450,
      bio: 'Expert in business strategy with over 12 years helping companies scale and optimize their operations.',
    ),
    Expert(
      id: 2,
      name: 'Michael Chen',
      title: 'Data Analytics Expert',
      specialty: 'Data Science & Analytics',
      rating: 4.8,
      reviews: 98,
      hourlyRate: 120,
      image: 'https://images.unsplash.com/photo-1701463387028-3947648f1337?w=400',
      availability: 'Available Tomorrow',
      yearsExperience: 8,
      sessionsCompleted: 320,
      bio: 'Specialized in advanced analytics, machine learning, and turning data into actionable insights.',
    ),
    Expert(
      id: 3,
      name: 'Emily Rodriguez',
      title: 'Marketing Strategist',
      specialty: 'Digital Marketing & Growth',
      rating: 5.0,
      reviews: 156,
      hourlyRate: 140,
      image: 'https://images.unsplash.com/photo-1689600944138-da3b150d9cb8?w=400',
      availability: 'Available Today',
      yearsExperience: 10,
      sessionsCompleted: 520,
      bio: 'Digital marketing expert helping businesses increase online presence and customer engagement.',
    ),
    Expert(
      id: 4,
      name: 'David Kumar',
      title: 'Financial Advisor',
      specialty: 'Finance & Investment',
      rating: 4.7,
      reviews: 89,
      hourlyRate: 180,
      image: 'https://images.unsplash.com/photo-1651684215020-f7a5b6610f23?w=400',
      availability: 'Available Next Week',
      yearsExperience: 15,
      sessionsCompleted: 380,
      bio: 'Financial planning and investment strategies for businesses looking to optimize their capital.',
    ),
    Expert(
      id: 5,
      name: 'Lisa Anderson',
      title: 'AI & Technology Consultant',
      specialty: 'AI Implementation',
      rating: 4.9,
      reviews: 112,
      hourlyRate: 160,
      image: 'https://images.unsplash.com/photo-1590563152569-bd0b2dae4418?w=400',
      availability: 'Available Today',
      yearsExperience: 9,
      sessionsCompleted: 290,
      bio: 'Helping organizations implement AI solutions and leverage technology for competitive advantage.',
    ),
    Expert(
      id: 6,
      name: 'James Wilson',
      title: 'Operations Expert',
      specialty: 'Operations & Efficiency',
      rating: 4.8,
      reviews: 95,
      hourlyRate: 130,
      image: 'https://images.unsplash.com/photo-1738750908048-14200459c3c9?w=400',
      availability: 'Available Tomorrow',
      yearsExperience: 11,
      sessionsCompleted: 410,
      bio: 'Optimizing business operations and implementing efficient processes for maximum productivity.',
    ),
  ];

  @override
  void dispose() {
    _dateController.dispose();
    _timeController.dispose();
    _notesController.dispose();
    super.dispose();
  }

  void _handleBookSession() {
    setState(() {
      showBookingModal = false;
      showConfirmation = true;
    });

    Future.delayed(const Duration(seconds: 3), () {
      if (mounted) {
        setState(() {
          showConfirmation = false;
          selectedExpert = null;
          _dateController.clear();
          _timeController.clear();
          _notesController.clear();
          selectedDuration = '60';
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
                            'EXPERT SESSIONS',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w500,
                              color: Colors.white,
                              letterSpacing: 2.4,
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
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(24, 80, 24, 24),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Header Section
                        Text(
                          'Connect with Experts',
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                            color: isDarkMode ? Colors.white : const Color(0xFF1F2937),
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          'Book one-on-one sessions with industry professionals',
                          style: TextStyle(
                            fontSize: 14,
                            color: isDarkMode ? const Color(0xFF9CA3AF) : const Color(0xFF6B7280),
                          ),
                        ),
                        const SizedBox(height: 24),

                        // Experts List
                        Expanded(
                          child: ListView.builder(
                            padding: EdgeInsets.zero,
                            itemCount: expertsData.length,
                            itemBuilder: (context, index) {
                              return _buildExpertCard(expertsData[index], isDarkMode);
                            },
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
                    color: isDarkMode ? const Color(0xFF132F4C) : Colors.white,
                    shape: BoxShape.circle,
                    border: Border.all(
                      color: isDarkMode ? const Color(0xFF1E4976) : Colors.white,
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
                  child: Icon(
                    Icons.video_call,
                    size: 64,
                    color: isDarkMode ? const Color(0xFF0EA5E9) : const Color(0xFF5B9FF3),
                  ),
                ),
              ),
            ),

            // Expert Details Modal
            if (selectedExpert != null && !showBookingModal)
              _buildExpertDetailsModal(isDarkMode),

            // Booking Modal
            if (showBookingModal && selectedExpert != null)
              _buildBookingModal(isDarkMode),

            // Success Confirmation
            if (showConfirmation)
              _buildSuccessConfirmation(isDarkMode),
          ],
        ),
      ),
    );
  }

  Widget _buildExpertCard(Expert expert, bool isDarkMode) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      decoration: BoxDecoration(
        color: isDarkMode ? const Color(0xFF132F4C) : Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: isDarkMode ? const Color(0xFF1E4976) : const Color(0xFFE5E7EB),
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      padding: const EdgeInsets.all(16),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Avatar
          ClipRRect(
            borderRadius: BorderRadius.circular(32),
            child: Image.network(
              expert.image,
              width: 64,
              height: 64,
              fit: BoxFit.cover,
              errorBuilder: (context, error, stackTrace) {
                return Container(
                  width: 64,
                  height: 64,
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: isDarkMode
                          ? [const Color(0xFF0EA5E9), const Color(0xFF06B6D4)]
                          : [const Color(0xFF5B9FF3), const Color(0xFF7DB6F7)],
                    ),
                    borderRadius: BorderRadius.circular(32),
                  ),
                  child: Center(
                    child: Text(
                      expert.name[0],
                      style: const TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
          const SizedBox(width: 16),

          // Info
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  expert.name,
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: isDarkMode ? Colors.white : const Color(0xFF1F2937),
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  expert.title,
                  style: TextStyle(
                    fontSize: 13,
                    color: isDarkMode ? const Color(0xFF9CA3AF) : const Color(0xFF6B7280),
                  ),
                ),
                const SizedBox(height: 8),

                // Rating
                Row(
                  children: [
                    const Icon(Icons.star, size: 16, color: Color(0xFFFBBF24)),
                    const SizedBox(width: 4),
                    Text(
                      expert.rating.toString(),
                      style: TextStyle(
                        fontSize: 13,
                        color: isDarkMode ? const Color(0xFFD1D5DB) : const Color(0xFF374151),
                      ),
                    ),
                    const SizedBox(width: 8),
                    Text(
                      '(${expert.reviews} reviews)',
                      style: TextStyle(
                        fontSize: 13,
                        color: isDarkMode ? const Color(0xFF6B7280) : const Color(0xFF9CA3AF),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 8),

                // Specialty
                Row(
                  children: [
                    Icon(
                      Icons.business_center,
                      size: 16,
                      color: isDarkMode ? const Color(0xFF6B7280) : const Color(0xFF9CA3AF),
                    ),
                    const SizedBox(width: 4),
                    Expanded(
                      child: Text(
                        expert.specialty,
                        style: TextStyle(
                          fontSize: 13,
                          color: isDarkMode ? const Color(0xFF9CA3AF) : const Color(0xFF6B7280),
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 12),

                // Bottom Row
                Row(
                  children: [
                    Icon(
                      Icons.attach_money,
                      size: 16,
                      color: isDarkMode ? const Color(0xFF0EA5E9) : const Color(0xFF5B9FF3),
                    ),
                    Text(
                      '${expert.hourlyRate}/hr',
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                        color: isDarkMode ? const Color(0xFFD1D5DB) : const Color(0xFF374151),
                      ),
                    ),
                    const SizedBox(width: 16),
                    Text(
                      expert.availability,
                      style: const TextStyle(
                        fontSize: 13,
                        color: Color(0xFF10B981),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 12),

                // Action Buttons
                Row(
                  children: [
                    Expanded(
                      child: OutlinedButton(
                        onPressed: () {
                          setState(() {
                            selectedExpert = expert;
                          });
                        },
                        style: OutlinedButton.styleFrom(
                          side: BorderSide(
                            color: isDarkMode ? const Color(0xFF0EA5E9) : const Color(0xFF5B9FF3),
                          ),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(24),
                          ),
                          padding: const EdgeInsets.symmetric(vertical: 8),
                        ),
                        child: Text(
                          'View Details',
                          style: TextStyle(
                            fontSize: 13,
                            color: isDarkMode ? const Color(0xFF0EA5E9) : const Color(0xFF5B9FF3),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: ElevatedButton(
                        onPressed: () {
                          setState(() {
                            selectedExpert = expert;
                            showBookingModal = true;
                          });
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.transparent,
                          shadowColor: Colors.transparent,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(24),
                          ),
                          padding: EdgeInsets.zero,
                        ),
                        child: Ink(
                          decoration: BoxDecoration(
                            gradient: LinearGradient(
                              colors: isDarkMode
                                  ? [const Color(0xFF0369A1), const Color(0xFF0EA5E9)]
                                  : [const Color(0xFF5B9FF3), const Color(0xFF7DB6F7)],
                            ),
                            borderRadius: BorderRadius.circular(24),
                          ),
                          child: Container(
                            padding: const EdgeInsets.symmetric(vertical: 8),
                            alignment: Alignment.center,
                            child: const Text(
                              'Book Now',
                              style: TextStyle(
                                fontSize: 13,
                                color: Colors.white,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildExpertDetailsModal(bool isDarkMode) {
    return GestureDetector(
      onTap: () {
        setState(() {
          selectedExpert = null;
        });
      },
      child: Container(
        color: (isDarkMode ? const Color(0xFF0A1929) : Colors.black).withOpacity(0.5),
        child: Align(
          alignment: Alignment.bottomCenter,
          child: GestureDetector(
            onTap: () {}, // Prevent closing when tapping modal
            child: Container(
              decoration: BoxDecoration(
                color: isDarkMode ? const Color(0xFF132F4C) : Colors.white,
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(24),
                  topRight: Radius.circular(24),
                ),
              ),
              constraints: BoxConstraints(
                maxHeight: MediaQuery.of(context).size.height * 0.7,
              ),
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(24),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Header
                    Row(
                      children: [
                        ClipRRect(
                          borderRadius: BorderRadius.circular(32),
                          child: Image.network(
                            selectedExpert!.image,
                            width: 64,
                            height: 64,
                            fit: BoxFit.cover,
                          ),
                        ),
                        const SizedBox(width: 16),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                selectedExpert!.name,
                                style: TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                  color: isDarkMode ? Colors.white : const Color(0xFF1F2937),
                                ),
                              ),
                              Text(
                                selectedExpert!.title,
                                style: TextStyle(
                                  fontSize: 14,
                                  color: isDarkMode ? const Color(0xFF9CA3AF) : const Color(0xFF6B7280),
                                ),
                              ),
                            ],
                          ),
                        ),
                        IconButton(
                          onPressed: () {
                            setState(() {
                              selectedExpert = null;
                            });
                          },
                          icon: Icon(
                            Icons.close,
                            color: isDarkMode ? const Color(0xFF9CA3AF) : const Color(0xFF6B7280),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 24),

                    // Stats
                    Row(
                      children: [
                        Expanded(
                          child: Container(
                            padding: const EdgeInsets.all(12),
                            decoration: BoxDecoration(
                              color: isDarkMode ? const Color(0xFF132F4C) : const Color(0xFFF0F9FF),
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: Column(
                              children: [
                                Icon(
                                  Icons.workspace_premium,
                                  size: 20,
                                  color: isDarkMode ? const Color(0xFF0EA5E9) : const Color(0xFF0284C7),
                                ),
                                const SizedBox(height: 4),
                                Text(
                                  'Experience',
                                  style: TextStyle(
                                    fontSize: 11,
                                    color: isDarkMode ? const Color(0xFF6B7280) : const Color(0xFF6B7280),
                                  ),
                                ),
                                Text(
                                  '${selectedExpert!.yearsExperience} years',
                                  style: TextStyle(
                                    fontSize: 14,
                                    fontWeight: FontWeight.bold,
                                    color: isDarkMode ? Colors.white : const Color(0xFF1F2937),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Container(
                            padding: const EdgeInsets.all(12),
                            decoration: BoxDecoration(
                              color: isDarkMode ? const Color(0xFF132F4C) : const Color(0xFFF0F9FF),
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: Column(
                              children: [
                                Icon(
                                  Icons.check_circle,
                                  size: 20,
                                  color: isDarkMode ? const Color(0xFF0EA5E9) : const Color(0xFF0284C7),
                                ),
                                const SizedBox(height: 4),
                                Text(
                                  'Sessions',
                                  style: TextStyle(
                                    fontSize: 11,
                                    color: isDarkMode ? const Color(0xFF6B7280) : const Color(0xFF6B7280),
                                  ),
                                ),
                                Text(
                                  '${selectedExpert!.sessionsCompleted}',
                                  style: TextStyle(
                                    fontSize: 14,
                                    fontWeight: FontWeight.bold,
                                    color: isDarkMode ? Colors.white : const Color(0xFF1F2937),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Container(
                            padding: const EdgeInsets.all(12),
                            decoration: BoxDecoration(
                              color: isDarkMode ? const Color(0xFF132F4C) : const Color(0xFFF0F9FF),
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: Column(
                              children: [
                                Icon(
                                  Icons.star,
                                  size: 20,
                                  color: isDarkMode ? const Color(0xFF0EA5E9) : const Color(0xFF0284C7),
                                ),
                                const SizedBox(height: 4),
                                Text(
                                  'Rating',
                                  style: TextStyle(
                                    fontSize: 11,
                                    color: isDarkMode ? const Color(0xFF6B7280) : const Color(0xFF6B7280),
                                  ),
                                ),
                                Text(
                                  '${selectedExpert!.rating}',
                                  style: TextStyle(
                                    fontSize: 14,
                                    fontWeight: FontWeight.bold,
                                    color: isDarkMode ? Colors.white : const Color(0xFF1F2937),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 24),

                    // About
                    Text(
                      'About',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: isDarkMode ? Colors.white : const Color(0xFF1F2937),
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      selectedExpert!.bio,
                      style: TextStyle(
                        fontSize: 14,
                        height: 1.5,
                        color: isDarkMode ? const Color(0xFF9CA3AF) : const Color(0xFF6B7280),
                      ),
                    ),
                    const SizedBox(height: 24),

                    // Specialty
                    Text(
                      'Specialty',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: isDarkMode ? Colors.white : const Color(0xFF1F2937),
                      ),
                    ),
                    const SizedBox(height: 8),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                      decoration: BoxDecoration(
                        color: isDarkMode
                            ? const Color(0xFF0EA5E9).withOpacity(0.2)
                            : const Color(0xFFE0F2FE),
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Text(
                        selectedExpert!.specialty,
                        style: TextStyle(
                          fontSize: 14,
                          color: isDarkMode ? const Color(0xFF0EA5E9) : const Color(0xFF0284C7),
                        ),
                      ),
                    ),
                    const SizedBox(height: 24),

                    // Book Button
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        onPressed: () {
                          setState(() {
                            showBookingModal = true;
                          });
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.transparent,
                          shadowColor: Colors.transparent,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(24),
                          ),
                          padding: EdgeInsets.zero,
                        ),
                        child: Ink(
                          decoration: BoxDecoration(
                            gradient: LinearGradient(
                              colors: isDarkMode
                                  ? [const Color(0xFF0369A1), const Color(0xFF0EA5E9)]
                                  : [const Color(0xFF0284C7), const Color(0xFF06B6D4)],
                            ),
                            borderRadius: BorderRadius.circular(24),
                          ),
                          child: Container(
                            padding: const EdgeInsets.symmetric(vertical: 12),
                            alignment: Alignment.center,
                            child: Text(
                              'Book Session - \$${selectedExpert!.hourlyRate}/hr',
                              style: const TextStyle(
                                fontSize: 16,
                                color: Colors.white,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildBookingModal(bool isDarkMode) {
    return GestureDetector(
      onTap: () {
        setState(() {
          showBookingModal = false;
        });
      },
      child: Container(
        color: (isDarkMode ? const Color(0xFF0A1929) : Colors.black).withOpacity(0.5),
        child: Align(
          alignment: Alignment.bottomCenter,
          child: GestureDetector(
            onTap: () {}, // Prevent closing when tapping modal
            child: Container(
              decoration: BoxDecoration(
                color: isDarkMode ? const Color(0xFF132F4C) : Colors.white,
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(24),
                  topRight: Radius.circular(24),
                ),
              ),
              constraints: BoxConstraints(
                maxHeight: MediaQuery.of(context).size.height * 0.8,
              ),
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(24),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Header
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'Book Session',
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                            color: isDarkMode ? Colors.white : const Color(0xFF1F2937),
                          ),
                        ),
                        IconButton(
                          onPressed: () {
                            setState(() {
                              showBookingModal = false;
                            });
                          },
                          icon: Icon(
                            Icons.close,
                            color: isDarkMode ? const Color(0xFF9CA3AF) : const Color(0xFF6B7280),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),

                    // Expert Info
                    Container(
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: isDarkMode ? const Color(0xFF0A1929) : const Color(0xFFF9FAFB),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Row(
                        children: [
                          ClipRRect(
                            borderRadius: BorderRadius.circular(24),
                            child: Image.network(
                              selectedExpert!.image,
                              width: 48,
                              height: 48,
                              fit: BoxFit.cover,
                            ),
                          ),
                          const SizedBox(width: 12),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                selectedExpert!.name,
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.w600,
                                  color: isDarkMode ? Colors.white : const Color(0xFF1F2937),
                                ),
                              ),
                              Text(
                                selectedExpert!.title,
                                style: TextStyle(
                                  fontSize: 13,
                                  color: isDarkMode ? const Color(0xFF9CA3AF) : const Color(0xFF6B7280),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 24),

                    // Date
                    Row(
                      children: [
                        Icon(
                          Icons.calendar_today,
                          size: 16,
                          color: isDarkMode ? const Color(0xFF0EA5E9) : const Color(0xFF5B9FF3),
                        ),
                        const SizedBox(width: 8),
                        Text(
                          'Select Date',
                          style: TextStyle(
                            fontSize: 14,
                            color: isDarkMode ? const Color(0xFFD1D5DB) : const Color(0xFF374151),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    TextField(
                      controller: _dateController,
                      readOnly: true,
                      onTap: () async {
                        final date = await showDatePicker(
                          context: context,
                          initialDate: DateTime.now(),
                          firstDate: DateTime.now(),
                          lastDate: DateTime.now().add(const Duration(days: 365)),
                        );
                        if (date != null) {
                          _dateController.text = date.toString().split(' ')[0];
                        }
                      },
                      decoration: InputDecoration(
                        hintText: 'Select a date',
                        filled: true,
                        fillColor: isDarkMode ? const Color(0xFF0A1929) : Colors.white,
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: BorderSide(
                            color: isDarkMode ? const Color(0xFF1E4976) : const Color(0xFFE5E7EB),
                          ),
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: BorderSide(
                            color: isDarkMode ? const Color(0xFF1E4976) : const Color(0xFFE5E7EB),
                          ),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: BorderSide(
                            color: isDarkMode ? const Color(0xFF0EA5E9) : const Color(0xFF5B9FF3),
                            width: 2,
                          ),
                        ),
                      ),
                      style: TextStyle(
                        color: isDarkMode ? Colors.white : const Color(0xFF1F2937),
                      ),
                    ),
                    const SizedBox(height: 16),

                    // Time
                    Row(
                      children: [
                        Icon(
                          Icons.access_time,
                          size: 16,
                          color: isDarkMode ? const Color(0xFF0EA5E9) : const Color(0xFF5B9FF3),
                        ),
                        const SizedBox(width: 8),
                        Text(
                          'Select Time',
                          style: TextStyle(
                            fontSize: 14,
                            color: isDarkMode ? const Color(0xFFD1D5DB) : const Color(0xFF374151),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    TextField(
                      controller: _timeController,
                      readOnly: true,
                      onTap: () async {
                        final time = await showTimePicker(
                          context: context,
                          initialTime: TimeOfDay.now(),
                        );
                        if (time != null) {
                          _timeController.text = time.format(context);
                        }
                      },
                      decoration: InputDecoration(
                        hintText: 'Select a time',
                        filled: true,
                        fillColor: isDarkMode ? const Color(0xFF0A1929) : Colors.white,
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: BorderSide(
                            color: isDarkMode ? const Color(0xFF1E4976) : const Color(0xFFE5E7EB),
                          ),
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: BorderSide(
                            color: isDarkMode ? const Color(0xFF1E4976) : const Color(0xFFE5E7EB),
                          ),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: BorderSide(
                            color: isDarkMode ? const Color(0xFF0EA5E9) : const Color(0xFF5B9FF3),
                            width: 2,
                          ),
                        ),
                      ),
                      style: TextStyle(
                        color: isDarkMode ? Colors.white : const Color(0xFF1F2937),
                      ),
                    ),
                    const SizedBox(height: 16),

                    // Duration
                    Row(
                      children: [
                        Icon(
                          Icons.timer,
                          size: 16,
                          color: isDarkMode ? const Color(0xFF0EA5E9) : const Color(0xFF5B9FF3),
                        ),
                        const SizedBox(width: 8),
                        Text(
                          'Session Duration',
                          style: TextStyle(
                            fontSize: 14,
                            color: isDarkMode ? const Color(0xFFD1D5DB) : const Color(0xFF374151),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    DropdownButtonFormField<String>(
                      value: selectedDuration,
                      decoration: InputDecoration(
                        filled: true,
                        fillColor: isDarkMode ? const Color(0xFF0A1929) : Colors.white,
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: BorderSide(
                            color: isDarkMode ? const Color(0xFF1E4976) : const Color(0xFFE5E7EB),
                          ),
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: BorderSide(
                            color: isDarkMode ? const Color(0xFF1E4976) : const Color(0xFFE5E7EB),
                          ),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: BorderSide(
                            color: isDarkMode ? const Color(0xFF0EA5E9) : const Color(0xFF5B9FF3),
                            width: 2,
                          ),
                        ),
                      ),
                      dropdownColor: isDarkMode ? const Color(0xFF0A1929) : Colors.white,
                      style: TextStyle(
                        color: isDarkMode ? Colors.white : const Color(0xFF1F2937),
                      ),
                      items: [
                        DropdownMenuItem(
                          value: '30',
                          child: Text('30 minutes - \$${selectedExpert!.hourlyRate ~/ 2}'),
                        ),
                        DropdownMenuItem(
                          value: '60',
                          child: Text('1 hour - \$${selectedExpert!.hourlyRate}'),
                        ),
                        DropdownMenuItem(
                          value: '90',
                          child: Text('1.5 hours - \$${(selectedExpert!.hourlyRate * 1.5).toInt()}'),
                        ),
                        DropdownMenuItem(
                          value: '120',
                          child: Text('2 hours - \$${selectedExpert!.hourlyRate * 2}'),
                        ),
                      ],
                      onChanged: (value) {
                        setState(() {
                          selectedDuration = value!;
                        });
                      },
                    ),
                    const SizedBox(height: 16),

                    // Notes
                    Row(
                      children: [
                        Icon(
                          Icons.person,
                          size: 16,
                          color: isDarkMode ? const Color(0xFF0EA5E9) : const Color(0xFF5B9FF3),
                        ),
                        const SizedBox(width: 8),
                        Text(
                          'Additional Notes (Optional)',
                          style: TextStyle(
                            fontSize: 14,
                            color: isDarkMode ? const Color(0xFFD1D5DB) : const Color(0xFF374151),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    TextField(
                      controller: _notesController,
                      maxLines: 3,
                      decoration: InputDecoration(
                        hintText: 'What would you like to discuss?',
                        filled: true,
                        fillColor: isDarkMode ? const Color(0xFF0A1929) : Colors.white,
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: BorderSide(
                            color: isDarkMode ? const Color(0xFF1E4976) : const Color(0xFFE5E7EB),
                          ),
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: BorderSide(
                            color: isDarkMode ? const Color(0xFF1E4976) : const Color(0xFFE5E7EB),
                          ),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: BorderSide(
                            color: isDarkMode ? const Color(0xFF0EA5E9) : const Color(0xFF5B9FF3),
                            width: 2,
                          ),
                        ),
                      ),
                      style: TextStyle(
                        color: isDarkMode ? Colors.white : const Color(0xFF1F2937),
                      ),
                    ),
                    const SizedBox(height: 16),

                    // Email Notice
                    Container(
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: isDarkMode
                            ? const Color(0xFF0EA5E9).withOpacity(0.1)
                            : const Color(0xFFDDEEFF),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Row(
                        children: [
                          Icon(
                            Icons.email,
                            size: 20,
                            color: isDarkMode ? const Color(0xFF0EA5E9) : const Color(0xFF5B9FF3),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: Text(
                              '${selectedExpert!.name} will receive an email notification with your booking details and will confirm the session.',
                              style: TextStyle(
                                fontSize: 13,
                                color: isDarkMode ? const Color(0xFFD1D5DB) : const Color(0xFF374151),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 24),

                    // Confirm Button
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        onPressed: (_dateController.text.isEmpty || _timeController.text.isEmpty)
                            ? null
                            : _handleBookSession,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.transparent,
                          shadowColor: Colors.transparent,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(24),
                          ),
                          padding: EdgeInsets.zero,
                          disabledBackgroundColor: Colors.grey,
                        ),
                        child: Ink(
                          decoration: BoxDecoration(
                            gradient: LinearGradient(
                              colors: (_dateController.text.isEmpty || _timeController.text.isEmpty)
                                  ? [Colors.grey, Colors.grey]
                                  : (isDarkMode
                                      ? [const Color(0xFF0369A1), const Color(0xFF0EA5E9)]
                                      : [const Color(0xFF5B9FF3), const Color(0xFF7DB6F7)]),
                            ),
                            borderRadius: BorderRadius.circular(24),
                          ),
                          child: Container(
                            padding: const EdgeInsets.symmetric(vertical: 12),
                            alignment: Alignment.center,
                            child: const Text(
                              'Confirm Booking',
                              style: TextStyle(
                                fontSize: 16,
                                color: Colors.white,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildSuccessConfirmation(bool isDarkMode) {
    return Container(
      color: (isDarkMode ? const Color(0xFF0A1929) : Colors.black).withOpacity(0.5),
      child: Center(
        child: Container(
          margin: const EdgeInsets.all(24),
          padding: const EdgeInsets.all(32),
          decoration: BoxDecoration(
            color: isDarkMode ? const Color(0xFF132F4C) : Colors.white,
            borderRadius: BorderRadius.circular(24),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: 80,
                height: 80,
                decoration: BoxDecoration(
                  color: isDarkMode
                      ? const Color(0xFF10B981).withOpacity(0.2)
                      : const Color(0xFFD1FAE5),
                  shape: BoxShape.circle,
                ),
                child: const Icon(
                  Icons.check_circle,
                  size: 40,
                  color: Color(0xFF10B981),
                ),
              ),
              const SizedBox(height: 16),
              Text(
                'Booking Confirmed!',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: isDarkMode ? Colors.white : const Color(0xFF1F2937),
                ),
              ),
              const SizedBox(height: 8),
              Text(
                'An email has been sent to ${selectedExpert?.name}. You\'ll receive a confirmation once the expert accepts your booking.',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 14,
                  color: isDarkMode ? const Color(0xFF9CA3AF) : const Color(0xFF6B7280),
                ),
              ),
              const SizedBox(height: 16),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.email,
                    size: 16,
                    color: isDarkMode ? const Color(0xFF6B7280) : const Color(0xFF6B7280),
                  ),
                  const SizedBox(width: 8),
                  Text(
                    'Check your email for details',
                    style: TextStyle(
                      fontSize: 13,
                      color: isDarkMode ? const Color(0xFF6B7280) : const Color(0xFF6B7280),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 24),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () {
                    setState(() {
                      showConfirmation = false;
                    });
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => const VideoSessionPage()),
                    );
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.transparent,
                    shadowColor: Colors.transparent,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(24),
                    ),
                    padding: EdgeInsets.zero,
                  ),
                  child: Ink(
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: isDarkMode
                            ? [const Color(0xFF0369A1), const Color(0xFF0EA5E9)]
                            : [const Color(0xFF5B9FF3), const Color(0xFF7DB6F7)],
                      ),
                      borderRadius: BorderRadius.circular(24),
                    ),
                    child: Container(
                      padding: const EdgeInsets.symmetric(vertical: 12),
                      alignment: Alignment.center,
                      child: const Text(
                        'Join Video Session Now',
                        style: TextStyle(
                          fontSize: 16,
                          color: Colors.white,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
