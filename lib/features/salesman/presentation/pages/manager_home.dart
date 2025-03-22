import 'package:flutter/material.dart';

const primaryColor = Color(0xFFE41B47);
const secondaryColor = Color(0xFFF5F5F5);

class ManagerApp extends StatelessWidget {
  const ManagerApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Manager Dashboard',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primaryColor: primaryColor,
        scaffoldBackgroundColor: secondaryColor,
      ),
      home: const ManagerHomePage(),
    );
  }
}

class ManagerHomePage extends StatefulWidget {
  const ManagerHomePage({super.key});

  @override
  _ManagerHomePageState createState() => _ManagerHomePageState();
}

class _ManagerHomePageState extends State<ManagerHomePage> {
  // Dummy KPI data for analysis.
  final List<Map<String, String>> kpiData = [
    {'title': 'Total Sales', 'value': '\$25,000'},
    {'title': 'New Products', 'value': '12'},
    {'title': 'Revenue Growth', 'value': '8%'},
    {'title': 'Active Deals', 'value': '7'},
  ];

  // Dummy report data.
  final List<Map<String, String>> reportData = [
    {
      'title': 'Product Performance',
      'subtitle': 'Review top performing products'
    },
    {'title': 'Deal Analysis', 'subtitle': 'Conversion rates & deal pipeline'},
    {'title': 'Inventory Status', 'subtitle': 'Stock levels & reorder alerts'},
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Manager Dashboard',
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
        backgroundColor: primaryColor,
        elevation: 2,
        actions: [
          // Manager profile icon.
          Padding(
            padding: const EdgeInsets.only(right: 16.0),
            child: CircleAvatar(
              backgroundImage:
                  const AssetImage('assets/logo.png'), // Replace as needed.
              radius: 16,
            ),
          ),
          IconButton(
            icon: const Icon(Icons.notifications, color: Colors.white),
            onPressed: () {
              // Handle notifications.
            },
          ),
        ],
      ),
      body: RefreshIndicator(
        onRefresh: () async {
          // Dummy refresh delay.
          await Future.delayed(const Duration(seconds: 1));
          setState(() {});
        },
        child: SingleChildScrollView(
          physics: const AlwaysScrollableScrollPhysics(),
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // KPI Summary Section
              SizedBox(
                height: 150,
                child: ListView.builder(
                  scrollDirection: Axis.horizontal,
                  itemCount: kpiData.length,
                  itemBuilder: (context, index) {
                    final kpi = kpiData[index];
                    return _buildSummaryCard(kpi['title']!, kpi['value']!);
                  },
                ),
              ),
              const SizedBox(height: 24),
              const Text(
                'Reports & Analysis',
                style: TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                  color: Colors.black87,
                ),
              ),
              const SizedBox(height: 16),
              ListView.separated(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: reportData.length,
                separatorBuilder: (context, index) =>
                    const SizedBox(height: 12),
                itemBuilder: (context, index) {
                  final report = reportData[index];
                  return _buildReportCard(
                      report['title']!, report['subtitle']!);
                },
              ),
            ],
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: primaryColor,
        onPressed: () {
          // For example, navigate to a report details page.
        },
        child: const Icon(Icons.analytics),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
    );
  }

  Widget _buildSummaryCard(String title, String value) {
    return Container(
      width: 160,
      margin: const EdgeInsets.only(right: 16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [primaryColor.withOpacity(0.9), primaryColor],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: primaryColor.withOpacity(0.4),
            blurRadius: 8,
            offset: const Offset(2, 4),
          ),
        ],
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            value,
            style: const TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            title,
            style: const TextStyle(
              fontSize: 16,
              color: Colors.white70,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildReportCard(String title, String subtitle) {
    return Card(
      elevation: 3,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      child: ListTile(
        contentPadding:
            const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        title: Text(
          title,
          style: const TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
        subtitle: Text(
          subtitle,
          style: const TextStyle(fontSize: 16),
        ),
        trailing: const Icon(Icons.arrow_forward_ios),
        onTap: () {
          // Handle tap: e.g. show details or navigate to another page.
        },
      ),
    );
  }
}
