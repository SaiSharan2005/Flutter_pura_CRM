import 'package:flutter/material.dart';
import 'package:pura_crm/features/deals/presentation/widgets/add_deal_fab.dart';
import 'package:pura_crm/features/products/presentation/widgets/add_cart_fab.dart';

const primaryColor = Color(0xFFE41B47);
const secondaryColor = Color(0xFFF5F5F5);

class SalesmanApp extends StatelessWidget {
  const SalesmanApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Salesman Dashboard',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primaryColor: primaryColor,
        scaffoldBackgroundColor: secondaryColor,
      ),
      home: const SalesmanHomePage(),
    );
  }
}

class SalesmanHomePage extends StatefulWidget {
  const SalesmanHomePage({super.key});

  @override
  _SalesmanHomePageState createState() => _SalesmanHomePageState();
}

class _SalesmanHomePageState extends State<SalesmanHomePage> {
  List<Map<String, dynamic>> tasks = [
    {
      'title': 'Update customer profiles',
      'subtitle': 'Due EOD',
      'completed': false
    },
    {'title': 'Send follow-up emails', 'subtitle': 'Sent', 'completed': true},
    {'title': 'Update deal status', 'subtitle': 'Reviewed', 'completed': true},
    {
      'title': 'Review sales performance',
      'subtitle': 'Due Noon',
      'completed': false
    },
    {
      'title': 'Product demo session',
      'subtitle': 'Scheduled Afternoon',
      'completed': false
    },
    {'title': 'Attend team meeting', 'subtitle': 'Evening', 'completed': false},
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // Compact AppBar with a simple title and icons.
      appBar: AppBar(
        backgroundColor: primaryColor,
        elevation: 2,
        title: const Text(
          "Dashboard",
          style: TextStyle(
              fontSize: 20, fontWeight: FontWeight.bold, color: Colors.white),
        ),
        actions: [
          GestureDetector(
            onTap: () {
              Navigator.of(context, rootNavigator: true)
                  .pushNamed('/salesman/profile');
            },
            child: Padding(
              padding: const EdgeInsets.only(right: 16.0),
              child: CircleAvatar(
                backgroundImage: const AssetImage(
                    'assets/logo.png'), // Replace with actual image.
                radius: 16,
              ),
            ),
          ),
          IconButton(
            icon:
                const Icon(Icons.notifications, color: Colors.white, size: 26),
            onPressed: () {
              // Handle notifications
            },
          ),
        ],
      ),
      body: RefreshIndicator(
        onRefresh: () async {
          // Simulate a refresh. Replace with your actual refresh logic.
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
                height: 140,
                child: ListView(
                  scrollDirection: Axis.horizontal,
                  children: [
                    _buildSummaryCard("Sales Today", "\$1,200"),
                    _buildSummaryCard("New Deals", "5"),
                    _buildSummaryCard("Pending Tasks", "3"),
                  ],
                ),
              ),
              const SizedBox(height: 24),
              const Text(
                'My Tasks',
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
                itemCount: tasks.length,
                separatorBuilder: (context, index) =>
                    const SizedBox(height: 12),
                itemBuilder: (context, index) {
                  final task = tasks[index];
                  return _buildTaskCard(task, index);
                },
              ),
            ],
          ),
        ),
      ),
      floatingActionButton: const AddDealFAB(),
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
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.center,
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

  Widget _buildTaskCard(Map<String, dynamic> task, int index) {
    return Card(
      elevation: 3,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: ListTile(
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        leading: Icon(
          task['completed'] ? Icons.check_circle : Icons.radio_button_unchecked,
          color: task['completed'] ? Colors.green : primaryColor,
          size: 28,
        ),
        title: Text(
          task['title'],
          style: const TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
        subtitle: Text(
          task['subtitle'],
          style: const TextStyle(fontSize: 16),
        ),
        trailing: Checkbox(
          activeColor: primaryColor,
          value: task['completed'],
          onChanged: (bool? value) {
            setState(() {
              tasks[index]['completed'] = value;
            });
          },
        ),
      ),
    );
  }
}
