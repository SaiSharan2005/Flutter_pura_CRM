import 'package:flutter/material.dart';
import 'package:pura_crm/features/products/presentation/widgets/add_cart_fab.dart';

const primaryColor = Color(0xFFE41B47);

class SalesmanApp extends StatelessWidget {
  const SalesmanApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: SalesmanHomePage(),
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
      // Customized AppBar with a header and a notification icon.
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Today, ${DateTime.now().toLocal().toString().split(" ")[0]}',
              style: TextStyle(fontSize: 14, color: Colors.grey[700]),
            ),
            const SizedBox(height: 4),
            const Text(
              'Welcome, Salesman!',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: Colors.black,
              ),
            ),
          ],
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.notifications, color: Colors.black87),
            onPressed: () {
              // Handle notifications
            },
          )
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // KPI Summary Section
            SizedBox(
              height: 120,
              child: ListView(
                scrollDirection: Axis.horizontal,
                children: [
                  _buildSummaryCard("Sales Today", "\$1,200"),
                  _buildSummaryCard("New Deals", "5"),
                  _buildSummaryCard("Pending Tasks", "3"),
                ],
              ),
            ),
            const SizedBox(height: 16),
            const Text(
              'My Tasks',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 10),
            Expanded(
              child: ListView.separated(
                itemCount: tasks.length,
                separatorBuilder: (context, index) =>
                    const SizedBox(height: 10),
                itemBuilder: (context, index) {
                  final task = tasks[index];
                  return Card(
                    elevation: 3,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: CheckboxListTile(
                      activeColor: Colors.green,
                      controlAffinity: ListTileControlAffinity.leading,
                      title: Text(
                        task['title'],
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      subtitle: task['completed']
                          ? Container(
                              margin: const EdgeInsets.only(top: 4),
                              padding: const EdgeInsets.symmetric(
                                  vertical: 4, horizontal: 8),
                              decoration: BoxDecoration(
                                color: Colors.redAccent,
                                borderRadius: BorderRadius.circular(8),
                              ),
                              child: const Text(
                                'Completed',
                                style: TextStyle(
                                    color: Colors.white, fontSize: 12),
                              ),
                            )
                          : Text(
                              task['subtitle'],
                              style: const TextStyle(fontSize: 14),
                            ),
                      value: task['completed'],
                      onChanged: (value) {
                        setState(() {
                          tasks[index]['completed'] = value;
                        });
                      },
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: AddCartFAB(),
      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
    );
  }

  Widget _buildSummaryCard(String title, String value) {
    return Container(
      width: 140,
      margin: const EdgeInsets.only(right: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: primaryColor,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            value,
            style: const TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            title,
            style: const TextStyle(
              fontSize: 14,
              color: Colors.white70,
            ),
          ),
        ],
      ),
    );
  }
}
