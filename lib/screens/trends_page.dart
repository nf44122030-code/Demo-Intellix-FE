import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:fl_chart/fl_chart.dart';
import '../providers/theme_provider.dart';

class TrendsPage extends StatefulWidget {
  const TrendsPage({super.key});

  @override
  State<TrendsPage> createState() => _TrendsPageState();
}

class _TrendsPageState extends State<TrendsPage> {
  String selectedTimeframe = 'month';

  final List<Map<String, dynamic>> revenueData = [
    {'month': 'Jan', 'value': 4200},
    {'month': 'Feb', 'value': 3800},
    {'month': 'Mar', 'value': 5100},
    {'month': 'Apr', 'value': 4600},
    {'month': 'May', 'value': 6200},
    {'month': 'Jun', 'value': 7100},
  ];

  final List<Map<String, dynamic>> weeklyData = [
    {'day': 'Mon', 'sales': 120},
    {'day': 'Tue', 'sales': 145},
    {'day': 'Wed', 'sales': 110},
    {'day': 'Thu', 'sales': 160},
    {'day': 'Fri', 'sales': 190},
    {'day': 'Sat', 'sales': 210},
    {'day': 'Sun', 'sales': 180},
  ];

  final List<Map<String, dynamic>> categoryData = [
    {'name': 'Electronics', 'value': 35, 'color': Color(0xFF0284C7)},
    {'name': 'Fashion', 'value': 28, 'color': Color(0xFF0EA5E9)},
    {'name': 'Home', 'value': 20, 'color': Color(0xFF06B6D4)},
    {'name': 'Sports', 'value': 17, 'color': Color(0xFF67E8F9)},
  ];

  final List<Map<String, String>> topProducts = [
    {'name': 'Wireless Headphones', 'sales': '\$12,450'},
    {'name': 'Smart Watch Pro', 'sales': '\$9,830'},
    {'name': 'Laptop Stand', 'sales': '\$7,290'},
    {'name': 'USB-C Hub', 'sales': '\$6,140'},
  ];

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
                            'TRENDS',
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
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Timeframe Selector
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            _buildTimeframeButton('week', 'Week', isDarkMode),
                            const SizedBox(width: 8),
                            _buildTimeframeButton('month', 'Month', isDarkMode),
                            const SizedBox(width: 8),
                            _buildTimeframeButton('year', 'Year', isDarkMode),
                          ],
                        ),
                        const SizedBox(height: 24),

                        // Key Metrics Grid (2x2)
                        Row(
                          children: [
                            Expanded(
                              child: _buildMetricCard(
                                icon: Icons.attach_money,
                                iconColor: const Color(0xFF10B981),
                                label: 'Revenue',
                                value: '\$47.2K',
                                change: 12.5,
                                isPositive: true,
                                isDarkMode: isDarkMode,
                              ),
                            ),
                            const SizedBox(width: 16),
                            Expanded(
                              child: _buildMetricCard(
                                icon: Icons.people,
                                iconColor: const Color(0xFF3B82F6),
                                label: 'Active Users',
                                value: '2,847',
                                change: 8.3,
                                isPositive: true,
                                isDarkMode: isDarkMode,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 16),
                        Row(
                          children: [
                            Expanded(
                              child: _buildMetricCard(
                                icon: Icons.shopping_cart,
                                iconColor: const Color(0xFF06B6D4),
                                label: 'Orders',
                                value: '1,284',
                                change: -3.2,
                                isPositive: false,
                                isDarkMode: isDarkMode,
                              ),
                            ),
                            const SizedBox(width: 16),
                            Expanded(
                              child: _buildMetricCard(
                                icon: Icons.visibility,
                                iconColor: const Color(0xFFF97316),
                                label: 'Page Views',
                                value: '18.9K',
                                change: 15.7,
                                isPositive: true,
                                isDarkMode: isDarkMode,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 24),

                        // Revenue Trend Chart
                        _buildChartCard(
                          title: 'Revenue Trend',
                          icon: Icons.show_chart,
                          isDarkMode: isDarkMode,
                          child: SizedBox(
                            height: 200,
                            child: Padding(
                              padding: const EdgeInsets.only(right: 16, top: 16),
                              child: LineChart(
                                LineChartData(
                                  gridData: FlGridData(
                                    show: true,
                                    drawVerticalLine: false,
                                    horizontalInterval: 2000,
                                    getDrawingHorizontalLine: (value) {
                                      return FlLine(
                                        color: isDarkMode
                                            ? const Color(0xFF4B5563)
                                            : const Color(0xFFE5E7EB),
                                        strokeWidth: 1,
                                        dashArray: [5, 5],
                                      );
                                    },
                                  ),
                                  titlesData: FlTitlesData(
                                    leftTitles: AxisTitles(
                                      sideTitles: SideTitles(
                                        showTitles: true,
                                        reservedSize: 40,
                                        interval: 2000,
                                        getTitlesWidget: (value, meta) {
                                          return Text(
                                            '${(value / 1000).toInt()}K',
                                            style: TextStyle(
                                              fontSize: 10,
                                              color: isDarkMode
                                                  ? const Color(0xFF9CA3AF)
                                                  : const Color(0xFF6B7280),
                                            ),
                                          );
                                        },
                                      ),
                                    ),
                                    bottomTitles: AxisTitles(
                                      sideTitles: SideTitles(
                                        showTitles: true,
                                        getTitlesWidget: (value, meta) {
                                          const months = ['Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun'];
                                          if (value.toInt() < 0 || value.toInt() >= months.length) {
                                            return const SizedBox();
                                          }
                                          return Padding(
                                            padding: const EdgeInsets.only(top: 8),
                                            child: Text(
                                              months[value.toInt()],
                                              style: TextStyle(
                                                fontSize: 10,
                                                color: isDarkMode
                                                    ? const Color(0xFF9CA3AF)
                                                    : const Color(0xFF6B7280),
                                              ),
                                            ),
                                          );
                                        },
                                      ),
                                    ),
                                    topTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
                                    rightTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
                                  ),
                                  borderData: FlBorderData(show: false),
                                  minX: 0,
                                  maxX: 5,
                                  minY: 0,
                                  maxY: 8000,
                                  lineBarsData: [
                                    LineChartBarData(
                                      spots: revenueData
                                          .asMap()
                                          .entries
                                          .map((e) => FlSpot(
                                              e.key.toDouble(), e.value['value'].toDouble()))
                                          .toList(),
                                      isCurved: true,
                                      color: const Color(0xFF0284C7),
                                      barWidth: 3,
                                      isStrokeCapRound: true,
                                      dotData: FlDotData(
                                        show: true,
                                        getDotPainter: (spot, percent, barData, index) {
                                          return FlDotCirclePainter(
                                            radius: 4,
                                            color: const Color(0xFF0284C7),
                                            strokeWidth: 2,
                                            strokeColor: Colors.white,
                                          );
                                        },
                                      ),
                                      belowBarData: BarAreaData(show: false),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(height: 16),

                        // Weekly Sales Bar Chart
                        _buildChartCard(
                          title: 'Weekly Sales',
                          icon: Icons.bar_chart,
                          isDarkMode: isDarkMode,
                          child: SizedBox(
                            height: 180,
                            child: Padding(
                              padding: const EdgeInsets.only(right: 16, top: 16),
                              child: BarChart(
                                BarChartData(
                                  gridData: FlGridData(
                                    show: true,
                                    drawVerticalLine: false,
                                    horizontalInterval: 50,
                                    getDrawingHorizontalLine: (value) {
                                      return FlLine(
                                        color: isDarkMode
                                            ? const Color(0xFF4B5563)
                                            : const Color(0xFFE5E7EB),
                                        strokeWidth: 1,
                                        dashArray: [5, 5],
                                      );
                                    },
                                  ),
                                  titlesData: FlTitlesData(
                                    leftTitles: AxisTitles(
                                      sideTitles: SideTitles(
                                        showTitles: true,
                                        reservedSize: 40,
                                        interval: 50,
                                        getTitlesWidget: (value, meta) {
                                          return Text(
                                            value.toInt().toString(),
                                            style: TextStyle(
                                              fontSize: 10,
                                              color: isDarkMode
                                                  ? const Color(0xFF9CA3AF)
                                                  : const Color(0xFF6B7280),
                                            ),
                                          );
                                        },
                                      ),
                                    ),
                                    bottomTitles: AxisTitles(
                                      sideTitles: SideTitles(
                                        showTitles: true,
                                        getTitlesWidget: (value, meta) {
                                          const days = ['Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat', 'Sun'];
                                          if (value.toInt() < 0 || value.toInt() >= days.length) {
                                            return const SizedBox();
                                          }
                                          return Padding(
                                            padding: const EdgeInsets.only(top: 8),
                                            child: Text(
                                              days[value.toInt()],
                                              style: TextStyle(
                                                fontSize: 10,
                                                color: isDarkMode
                                                    ? const Color(0xFF9CA3AF)
                                                    : const Color(0xFF6B7280),
                                              ),
                                            ),
                                          );
                                        },
                                      ),
                                    ),
                                    topTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
                                    rightTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
                                  ),
                                  borderData: FlBorderData(show: false),
                                  barGroups: weeklyData
                                      .asMap()
                                      .entries
                                      .map((e) => BarChartGroupData(
                                            x: e.key,
                                            barRods: [
                                              BarChartRodData(
                                                toY: e.value['sales'].toDouble(),
                                                color: const Color(0xFF0284C7),
                                                width: 20,
                                                borderRadius: const BorderRadius.only(
                                                  topLeft: Radius.circular(8),
                                                  topRight: Radius.circular(8),
                                                ),
                                              ),
                                            ],
                                          ))
                                      .toList(),
                                  minY: 0,
                                  maxY: 250,
                                ),
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(height: 16),

                        // Category Distribution
                        _buildChartCard(
                          title: 'Sales by Category',
                          icon: Icons.pie_chart,
                          isDarkMode: isDarkMode,
                          child: Row(
                            children: [
                              // Pie Chart
                              SizedBox(
                                width: 150,
                                height: 150,
                                child: PieChart(
                                  PieChartData(
                                    sections: categoryData
                                        .map((item) => PieChartSectionData(
                                              value: item['value'].toDouble(),
                                              color: item['color'] as Color,
                                              title: '${item['value']}%',
                                              radius: 60,
                                              titleStyle: const TextStyle(
                                                fontSize: 12,
                                                fontWeight: FontWeight.bold,
                                                color: Colors.white,
                                              ),
                                            ))
                                        .toList(),
                                    sectionsSpace: 2,
                                    centerSpaceRadius: 40,
                                  ),
                                ),
                              ),
                              const SizedBox(width: 24),
                              // Legend
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: categoryData.map((item) {
                                    return Padding(
                                      padding: const EdgeInsets.only(bottom: 8),
                                      child: Row(
                                        children: [
                                          Container(
                                            width: 12,
                                            height: 12,
                                            decoration: BoxDecoration(
                                              color: item['color'] as Color,
                                              shape: BoxShape.circle,
                                            ),
                                          ),
                                          const SizedBox(width: 8),
                                          Expanded(
                                            child: Text(
                                              item['name'],
                                              style: TextStyle(
                                                fontSize: 13,
                                                color: isDarkMode
                                                    ? const Color(0xFFD1D5DB)
                                                    : const Color(0xFF6B7280),
                                              ),
                                            ),
                                          ),
                                          Text(
                                            '${item['value']}%',
                                            style: TextStyle(
                                              fontSize: 13,
                                              fontWeight: FontWeight.w600,
                                              color: isDarkMode ? Colors.white : const Color(0xFF1F2937),
                                            ),
                                          ),
                                        ],
                                      ),
                                    );
                                  }).toList(),
                                ),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(height: 16),

                        // Top Performing Products
                        _buildChartCard(
                          title: 'Top Performing Products',
                          icon: Icons.star,
                          isDarkMode: isDarkMode,
                          child: Column(
                            children: topProducts.asMap().entries.map((entry) {
                              final index = entry.key;
                              final product = entry.value;
                              return _buildProductItem(
                                rank: index + 1,
                                name: product['name']!,
                                sales: product['sales']!,
                                isDarkMode: isDarkMode,
                              );
                            }).toList(),
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
                    color: isDarkMode ? const Color(0xFF2D2D2D) : Colors.white,
                    shape: BoxShape.circle,
                    border: Border.all(
                      color: isDarkMode ? const Color(0xFF2D2D2D) : Colors.white,
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
                    Icons.trending_up,
                    size: 64,
                    color: isDarkMode ? const Color(0xFF0EA5E9) : const Color(0xFF0284C7),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTimeframeButton(String value, String label, bool isDarkMode) {
    final isActive = selectedTimeframe == value;
    return GestureDetector(
      onTap: () {
        setState(() {
          selectedTimeframe = value;
        });
      },
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 8),
        decoration: BoxDecoration(
          gradient: isActive
              ? const LinearGradient(
                  colors: [Color(0xFF0284C7), Color(0xFF06B6D4)],
                )
              : null,
          color: isActive
              ? null
              : (isDarkMode ? const Color(0xFF2D2D2D) : Colors.white),
          borderRadius: BorderRadius.circular(24),
          border: Border.all(
            color: isActive
                ? Colors.transparent
                : (isDarkMode ? const Color(0xFF2D2D2D) : const Color(0xFFBAE6FD)),
          ),
          boxShadow: isActive
              ? [
                  BoxShadow(
                    color: const Color(0xFF0284C7).withOpacity(0.3),
                    blurRadius: 8,
                    offset: const Offset(0, 4),
                  ),
                ]
              : null,
        ),
        child: Text(
          label,
          style: TextStyle(
            fontSize: 14,
            fontWeight: isActive ? FontWeight.w600 : FontWeight.normal,
            color: isActive
                ? Colors.white
                : (isDarkMode ? const Color(0xFF0EA5E9) : const Color(0xFF0369A1)),
          ),
        ),
      ),
    );
  }

  Widget _buildMetricCard({
    required IconData icon,
    required Color iconColor,
    required String label,
    required String value,
    required double change,
    required bool isPositive,
    required bool isDarkMode,
  }) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: isDarkMode ? const Color(0xFF2D2D2D) : Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: isDarkMode ? const Color(0xFF4B5563) : const Color(0xFFE5E7EB),
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
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: isDarkMode ? const Color(0xFF1A1A1A) : const Color(0xFFF9FAFB),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Icon(icon, size: 20, color: iconColor),
              ),
              Row(
                children: [
                  Icon(
                    isPositive ? Icons.arrow_upward : Icons.arrow_downward,
                    size: 16,
                    color: isPositive ? const Color(0xFF10B981) : const Color(0xFFEF4444),
                  ),
                  const SizedBox(width: 4),
                  Text(
                    '${change.abs()}%',
                    style: TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.w600,
                      color: isPositive ? const Color(0xFF10B981) : const Color(0xFFEF4444),
                    ),
                  ),
                ],
              ),
            ],
          ),
          const SizedBox(height: 12),
          Text(
            label,
            style: TextStyle(
              fontSize: 12,
              color: isDarkMode ? const Color(0xFF9CA3AF) : const Color(0xFF6B7280),
            ),
          ),
          const SizedBox(height: 4),
          Text(
            value,
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: isDarkMode ? Colors.white : const Color(0xFF1F2937),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildChartCard({
    required String title,
    required IconData icon,
    required bool isDarkMode,
    required Widget child,
  }) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: isDarkMode ? const Color(0xFF2D2D2D) : Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: isDarkMode ? const Color(0xFF4B5563) : const Color(0xFFE5E7EB),
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
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                title,
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  color: isDarkMode ? Colors.white : const Color(0xFF1F2937),
                ),
              ),
              Icon(
                icon,
                size: 20,
                color: const Color(0xFF0284C7),
              ),
            ],
          ),
          const SizedBox(height: 16),
          child,
        ],
      ),
    );
  }

  Widget _buildProductItem({
    required int rank,
    required String name,
    required String sales,
    required bool isDarkMode,
  }) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(8),
      decoration: BoxDecoration(
        color: isDarkMode ? const Color(0xFF1A1A1A).withOpacity(0.3) : Colors.transparent,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        children: [
          Container(
            width: 32,
            height: 32,
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                colors: [Color(0xFF0284C7), Color(0xFF06B6D4)],
              ),
              shape: BoxShape.circle,
            ),
            child: Center(
              child: Text(
                '$rank',
                style: const TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              name,
              style: TextStyle(
                fontSize: 14,
                color: isDarkMode ? Colors.white : const Color(0xFF1F2937),
              ),
            ),
          ),
          Text(
            sales,
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w600,
              color: isDarkMode ? const Color(0xFFD1D5DB) : const Color(0xFF6B7280),
            ),
          ),
        ],
      ),
    );
  }
}
