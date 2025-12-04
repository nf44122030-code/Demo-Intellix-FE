import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/theme_provider.dart';

class Category {
  final String id;
  final String name;
  final IconData icon;
  final List<Color> gradientColors;
  final int count;

  Category({
    required this.id,
    required this.name,
    required this.icon,
    required this.gradientColors,
    required this.count,
  });
}

class Article {
  final int id;
  final String title;
  final String category;
  final String readTime;
  final String views;
  final bool isFeatured;

  Article({
    required this.id,
    required this.title,
    required this.category,
    required this.readTime,
    required this.views,
    this.isFeatured = false,
  });
}

class Topic {
  final int id;
  final String name;
  final int posts;
  final bool trending;

  Topic({
    required this.id,
    required this.name,
    required this.posts,
    this.trending = false,
  });
}

class ExplorePage extends StatefulWidget {
  const ExplorePage({super.key});

  @override
  State<ExplorePage> createState() => _ExplorePageState();
}

class _ExplorePageState extends State<ExplorePage> {
  String _searchQuery = '';
  String? _selectedCategory;

  final List<Category> categories = [
    Category(
      id: 'business',
      name: 'Business',
      icon: Icons.business_center,
      gradientColors: [const Color(0xFF3B82F6), const Color(0xFF2563EB)],
      count: 142,
    ),
    Category(
      id: 'analytics',
      name: 'Analytics',
      icon: Icons.bar_chart,
      gradientColors: [const Color(0xFF06B6D4), const Color(0xFF0891B2)],
      count: 98,
    ),
    Category(
      id: 'marketing',
      name: 'Marketing',
      icon: Icons.campaign,
      gradientColors: [const Color(0xFFEC4899), const Color(0xFFDB2777)],
      count: 76,
    ),
    Category(
      id: 'technology',
      name: 'Technology',
      icon: Icons.code,
      gradientColors: [const Color(0xFF10B981), const Color(0xFF059669)],
      count: 124,
    ),
    Category(
      id: 'leadership',
      name: 'Leadership',
      icon: Icons.groups,
      gradientColors: [const Color(0xFFF97316), const Color(0xFFEA580C)],
      count: 89,
    ),
    Category(
      id: 'innovation',
      name: 'Innovation',
      icon: Icons.lightbulb,
      gradientColors: [const Color(0xFFF59E0B), const Color(0xFFD97706)],
      count: 67,
    ),
  ];

  final List<Article> featuredArticles = [
    Article(
      id: 1,
      title: '10 Data-Driven Strategies to Scale Your Business in 2025',
      category: 'Business Strategy',
      readTime: '8 min read',
      views: '12.5K',
      isFeatured: true,
    ),
  ];

  final List<Article> recentArticles = [
    Article(
      id: 4,
      title: 'Effective Marketing Strategies for Digital Transformation',
      category: 'Marketing',
      readTime: '5 min read',
      views: '6.7K',
    ),
    Article(
      id: 5,
      title: 'Building High-Performance Teams in Remote Environments',
      category: 'Leadership',
      readTime: '7 min read',
      views: '9.1K',
    ),
    Article(
      id: 6,
      title: 'Innovation Through Design Thinking Methodologies',
      category: 'Innovation',
      readTime: '9 min read',
      views: '7.4K',
    ),
  ];

  final List<Topic> trendingTopics = [
    Topic(id: 1, name: 'AI & Machine Learning', posts: 234, trending: true),
    Topic(id: 2, name: 'Business Growth', posts: 189, trending: true),
    Topic(id: 3, name: 'Data Visualization', posts: 156),
    Topic(id: 4, name: 'Customer Experience', posts: 142),
    Topic(id: 5, name: 'Digital Strategy', posts: 128),
    Topic(id: 6, name: 'Product Management', posts: 115),
  ];

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);
    final isDarkMode = themeProvider.isDarkMode;

    return SingleChildScrollView(
      padding: const EdgeInsets.fromLTRB(24, 24, 24, 96),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Search Bar
          Container(
            decoration: BoxDecoration(
              color: isDarkMode ? const Color(0xFF132F4C) : Colors.white,
              borderRadius: BorderRadius.circular(20),
              border: Border.all(
                color: isDarkMode ? const Color(0xFF1E4976) : const Color(0xFFE5E7EB),
              ),
            ),
            child: TextField(
              onChanged: (value) => setState(() => _searchQuery = value),
              style: TextStyle(
                color: isDarkMode ? Colors.white : const Color(0xFF111827),
              ),
              decoration: InputDecoration(
                hintText: 'Search topics, articles, experts...',
                hintStyle: TextStyle(
                  color: isDarkMode ? const Color(0xFF6B7280) : const Color(0xFF9CA3AF),
                ),
                prefixIcon: Icon(
                  Icons.search,
                  color: isDarkMode ? const Color(0xFF6B7280) : const Color(0xFF9CA3AF),
                ),
                border: InputBorder.none,
                contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              ),
            ),
          ),
          const SizedBox(height: 24),

          // Categories
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Categories',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: isDarkMode ? Colors.white : const Color(0xFF1F2937),
                ),
              ),
              TextButton(
                onPressed: () {},
                child: Text(
                  'See All',
                  style: TextStyle(
                    fontSize: 14,
                    color: isDarkMode ? const Color(0xFF7B96F5) : const Color(0xFF5B9FF3),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          GridView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 3,
              crossAxisSpacing: 12,
              mainAxisSpacing: 12,
              childAspectRatio: 0.85,
            ),
            itemCount: categories.length,
            itemBuilder: (context, index) {
              final category = categories[index];
              final isSelected = _selectedCategory == category.id;
              
              return GestureDetector(
                onTap: () => setState(() => _selectedCategory = category.id),
                child: Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: isDarkMode ? const Color(0xFF132F4C) : Colors.white,
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(
                      color: isSelected
                          ? (isDarkMode ? const Color(0xFF0EA5E9) : const Color(0xFF5B9FF3))
                          : (isDarkMode ? const Color(0xFF1E4976) : const Color(0xFFF3F4F6)),
                      width: isSelected ? 2 : 1,
                    ),
                    boxShadow: [
                      if (isSelected)
                        BoxShadow(
                          color: (isDarkMode ? const Color(0xFF0EA5E9) : const Color(0xFF5B9FF3))
                              .withOpacity(0.1),
                          blurRadius: 8,
                          offset: const Offset(0, 2),
                        ),
                    ],
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Container(
                        width: 40,
                        height: 40,
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            colors: category.gradientColors,
                            begin: Alignment.topLeft,
                            end: Alignment.bottomRight,
                          ),
                          shape: BoxShape.circle,
                        ),
                        child: Icon(
                          category.icon,
                          color: Colors.white,
                          size: 20,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        category.name,
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.w600,
                          color: isDarkMode ? Colors.white : const Color(0xFF1F2937),
                        ),
                      ),
                      const SizedBox(height: 2),
                      Text(
                        '${category.count} posts',
                        style: TextStyle(
                          fontSize: 10,
                          color: isDarkMode ? const Color(0xFF6B7280) : const Color(0xFF9CA3AF),
                        ),
                      ),
                    ],
                  ),
                ),
              );
            },
          ),
          const SizedBox(height: 24),

          // Featured Article
          Row(
            children: [
              const Icon(Icons.bolt, color: Color(0xFFF59E0B), size: 20),
              const SizedBox(width: 8),
              Text(
                'Featured',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: isDarkMode ? Colors.white : const Color(0xFF1F2937),
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          _buildFeaturedArticle(featuredArticles[0], isDarkMode),
          const SizedBox(height: 24),

          // Trending Topics
          Row(
            children: [
              Icon(
                Icons.trending_up,
                color: isDarkMode ? const Color(0xFF7B96F5) : const Color(0xFF5B9FF3),
                size: 20,
              ),
              const SizedBox(width: 8),
              Text(
                'Trending Topics',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: isDarkMode ? Colors.white : const Color(0xFF1F2937),
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          _buildTrendingTopics(isDarkMode),
          const SizedBox(height: 24),

          // Recent Articles
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  Icon(
                    Icons.menu_book,
                    color: isDarkMode ? const Color(0xFF0EA5E9) : const Color(0xFF5B9FF3),
                    size: 20,
                  ),
                  const SizedBox(width: 8),
                  Text(
                    'Recent Articles',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: isDarkMode ? Colors.white : const Color(0xFF1F2937),
                    ),
                  ),
                ],
              ),
              TextButton(
                onPressed: () {},
                child: Text(
                  'View All',
                  style: TextStyle(
                    fontSize: 14,
                    color: isDarkMode ? const Color(0xFF0EA5E9) : const Color(0xFF5B9FF3),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          ...recentArticles.map((article) => _buildRecentArticle(article, isDarkMode)),
          const SizedBox(height: 24),

          // Recommended for You
          Row(
            children: [
              const Icon(Icons.favorite, color: Color(0xFFEC4899), size: 20),
              const SizedBox(width: 8),
              Text(
                'Recommended for You',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: isDarkMode ? Colors.white : const Color(0xFF1F2937),
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          GridView.count(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            crossAxisCount: 2,
            crossAxisSpacing: 12,
            mainAxisSpacing: 12,
            childAspectRatio: 1.1,
            children: [
              _buildRecommendationCard(
                'Growth Strategies',
                45,
                [const Color(0xFF3B82F6), const Color(0xFF2563EB)],
                isDarkMode,
              ),
              _buildRecommendationCard(
                'Data Science',
                38,
                [const Color(0xFF06B6D4), const Color(0xFF0891B2)],
                isDarkMode,
              ),
              _buildRecommendationCard(
                'Team Building',
                29,
                [const Color(0xFF10B981), const Color(0xFF059669)],
                isDarkMode,
              ),
              _buildRecommendationCard(
                'Innovation',
                34,
                [const Color(0xFFF97316), const Color(0xFFEA580C)],
                isDarkMode,
              ),
            ],
          ),
          const SizedBox(height: 24),

          // Global Insights
          Row(
            children: [
              Icon(
                Icons.public,
                color: isDarkMode ? const Color(0xFF0EA5E9) : const Color(0xFF5B9FF3),
                size: 20,
              ),
              const SizedBox(width: 8),
              Text(
                'Global Insights',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: isDarkMode ? Colors.white : const Color(0xFF1F2937),
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          _buildGlobalInsights(isDarkMode),
        ],
      ),
    );
  }

  Widget _buildFeaturedArticle(Article article, bool isDarkMode) {
    return Container(
      decoration: BoxDecoration(
        color: isDarkMode ? const Color(0xFF132F4C) : Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: isDarkMode ? const Color(0xFF1E4976) : const Color(0xFFF3F4F6),
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
          // Image with Featured Badge
          Stack(
            children: [
              Container(
                height: 192,
                decoration: const BoxDecoration(
                  borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
                  gradient: LinearGradient(
                    colors: [Color(0xFF5B9FF3), Color(0xFF7DB6F7)],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                ),
                child: ClipRRect(
                  borderRadius: const BorderRadius.vertical(top: Radius.circular(16)),
                  child: Image.network(
                    'https://images.unsplash.com/photo-1460925895917-afdab827c52f?w=800&q=80',
                    width: double.infinity,
                    height: 192,
                    fit: BoxFit.cover,
                    errorBuilder: (context, error, stackTrace) {
                      return Container(
                        color: const Color(0xFF5B9FF3),
                        child: const Icon(Icons.image, size: 64, color: Colors.white),
                      );
                    },
                  ),
                ),
              ),
              Positioned(
                top: 12,
                right: 12,
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                  decoration: BoxDecoration(
                    color: const Color(0xFFF59E0B),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: const Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(Icons.star, color: Colors.white, size: 12),
                      SizedBox(width: 4),
                      Text(
                        'Featured',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 10,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
          // Article Info
          Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                  decoration: BoxDecoration(
                    color: (isDarkMode ? const Color(0xFF7B96F5) : const Color(0xFF5B9FF3))
                        .withOpacity(isDarkMode ? 0.2 : 0.1),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Text(
                    article.category,
                    style: TextStyle(
                      fontSize: 10,
                      color: isDarkMode ? const Color(0xFF7B96F5) : const Color(0xFF5B9FF3),
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  article.title,
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: isDarkMode ? Colors.white : const Color(0xFF1F2937),
                  ),
                ),
                const SizedBox(height: 8),
                Row(
                  children: [
                    Icon(
                      Icons.access_time,
                      size: 14,
                      color: isDarkMode ? const Color(0xFF9CA3AF) : const Color(0xFF6B7280),
                    ),
                    const SizedBox(width: 4),
                    Text(
                      article.readTime,
                      style: TextStyle(
                        fontSize: 12,
                        color: isDarkMode ? const Color(0xFF9CA3AF) : const Color(0xFF6B7280),
                      ),
                    ),
                    const SizedBox(width: 16),
                    Icon(
                      Icons.visibility,
                      size: 14,
                      color: isDarkMode ? const Color(0xFF9CA3AF) : const Color(0xFF6B7280),
                    ),
                    const SizedBox(width: 4),
                    Text(
                      article.views,
                      style: TextStyle(
                        fontSize: 12,
                        color: isDarkMode ? const Color(0xFF9CA3AF) : const Color(0xFF6B7280),
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

  Widget _buildTrendingTopics(bool isDarkMode) {
    return Container(
      decoration: BoxDecoration(
        color: isDarkMode ? const Color(0xFF132F4C) : Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: isDarkMode ? const Color(0xFF1E4976) : const Color(0xFFF3F4F6),
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
        children: List.generate(
          trendingTopics.length,
          (index) {
            final topic = trendingTopics[index];
            return Container(
              decoration: BoxDecoration(
                border: index < trendingTopics.length - 1
                    ? Border(
                        bottom: BorderSide(
                          color: isDarkMode ? const Color(0xFF1E4976) : const Color(0xFFF3F4F6),
                        ),
                      )
                    : null,
              ),
              child: Material(
                color: Colors.transparent,
                child: InkWell(
                  onTap: () {},
                  borderRadius: BorderRadius.vertical(
                    top: index == 0 ? const Radius.circular(16) : Radius.zero,
                    bottom: index == trendingTopics.length - 1 ? const Radius.circular(16) : Radius.zero,
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(12),
                    child: Row(
                      children: [
                        Container(
                          width: 32,
                          height: 32,
                          decoration: BoxDecoration(
                            color: topic.trending
                                ? (isDarkMode ? const Color(0xFF7B96F5) : const Color(0xFF5B9FF3))
                                : (isDarkMode ? const Color(0xFF1E4976) : const Color(0xFFF3F4F6)),
                            shape: BoxShape.circle,
                          ),
                          child: Center(
                            child: Text(
                              '${index + 1}',
                              style: TextStyle(
                                fontSize: 12,
                                fontWeight: FontWeight.bold,
                                color: topic.trending
                                    ? Colors.white
                                    : (isDarkMode ? const Color(0xFF9CA3AF) : const Color(0xFF6B7280)),
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                topic.name,
                                style: TextStyle(
                                  fontSize: 14,
                                  fontWeight: FontWeight.w600,
                                  color: isDarkMode ? Colors.white : const Color(0xFF1F2937),
                                ),
                              ),
                              Text(
                                '${topic.posts} posts',
                                style: TextStyle(
                                  fontSize: 12,
                                  color: isDarkMode ? const Color(0xFF6B7280) : const Color(0xFF9CA3AF),
                                ),
                              ),
                            ],
                          ),
                        ),
                        if (topic.trending)
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                            decoration: BoxDecoration(
                              color: (isDarkMode ? const Color(0xFF7B96F5) : const Color(0xFF5B9FF3))
                                  .withOpacity(0.1),
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Icon(
                                  Icons.trending_up,
                                  size: 12,
                                  color: isDarkMode ? const Color(0xFF7B96F5) : const Color(0xFF5B9FF3),
                                ),
                                const SizedBox(width: 4),
                                Text(
                                  'Hot',
                                  style: TextStyle(
                                    fontSize: 10,
                                    fontWeight: FontWeight.w600,
                                    color: isDarkMode ? const Color(0xFF7B96F5) : const Color(0xFF5B9FF3),
                                  ),
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
          },
        ),
      ),
    );
  }

  Widget _buildRecentArticle(Article article, bool isDarkMode) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: isDarkMode ? const Color(0xFF132F4C) : Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: isDarkMode ? const Color(0xFF1E4976) : const Color(0xFFF3F4F6),
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.03),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Row(
          children: [
            Container(
              width: 96,
              height: 96,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(12),
                gradient: const LinearGradient(
                  colors: [Color(0xFF5B9FF3), Color(0xFF7DB6F7)],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(12),
                child: Image.network(
                  'https://images.unsplash.com/photo-1551288049-bebda4e38f71?w=400&q=80',
                  fit: BoxFit.cover,
                  errorBuilder: (context, error, stackTrace) {
                    return const Icon(Icons.image, size: 48, color: Colors.white);
                  },
                ),
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                    decoration: BoxDecoration(
                      color: (isDarkMode ? const Color(0xFF7B96F5) : const Color(0xFF5B9FF3))
                          .withOpacity(isDarkMode ? 0.2 : 0.1),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Text(
                      article.category,
                      style: TextStyle(
                        fontSize: 10,
                        color: isDarkMode ? const Color(0xFF7B96F5) : const Color(0xFF5B9FF3),
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    article.title,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                      color: isDarkMode ? Colors.white : const Color(0xFF1F2937),
                    ),
                  ),
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      Icon(
                        Icons.access_time,
                        size: 12,
                        color: isDarkMode ? const Color(0xFF9CA3AF) : const Color(0xFF6B7280),
                      ),
                      const SizedBox(width: 4),
                      Text(
                        article.readTime,
                        style: TextStyle(
                          fontSize: 10,
                          color: isDarkMode ? const Color(0xFF9CA3AF) : const Color(0xFF6B7280),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Icon(
                        Icons.visibility,
                        size: 12,
                        color: isDarkMode ? const Color(0xFF9CA3AF) : const Color(0xFF6B7280),
                      ),
                      const SizedBox(width: 4),
                      Text(
                        article.views,
                        style: TextStyle(
                          fontSize: 10,
                          color: isDarkMode ? const Color(0xFF9CA3AF) : const Color(0xFF6B7280),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildRecommendationCard(
    String title,
    int count,
    List<Color> gradientColors,
    bool isDarkMode,
  ) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: isDarkMode ? const Color(0xFF132F4C) : Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: isDarkMode ? const Color(0xFF1E4976) : const Color(0xFFF3F4F6),
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
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: gradientColors,
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              shape: BoxShape.circle,
            ),
            child: const Icon(
              Icons.lightbulb,
              color: Colors.white,
              size: 20,
            ),
          ),
          const SizedBox(height: 12),
          Text(
            title,
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w600,
              color: isDarkMode ? Colors.white : const Color(0xFF1F2937),
            ),
          ),
          const SizedBox(height: 4),
          Text(
            '$count articles',
            style: TextStyle(
              fontSize: 12,
              color: isDarkMode ? const Color(0xFF9CA3AF) : const Color(0xFF6B7280),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildGlobalInsights(bool isDarkMode) {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          colors: [Color(0xFF5B9FF3), Color(0xFF7DB6F7)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.all(Radius.circular(16)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Icon(
            Icons.explore,
            color: Colors.white,
            size: 48,
          ),
          const SizedBox(height: 12),
          const Text(
            'Discover New Perspectives',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
          const SizedBox(height: 8),
          const Text(
            'Explore insights from business leaders and experts around the world.',
            style: TextStyle(
              fontSize: 14,
              color: Colors.white,
              height: 1.5,
            ),
          ),
          const SizedBox(height: 16),
          ElevatedButton(
            onPressed: () {},
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.white,
              foregroundColor: const Color(0xFF5B9FF3),
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(24),
              ),
            ),
            child: const Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  'Start Exploring',
                  style: TextStyle(fontWeight: FontWeight.w600),
                ),
                SizedBox(width: 8),
                Icon(Icons.arrow_forward, size: 16),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
