import 'package:flutter/material.dart';
import 'package:pura_crm/features/products/presentation/widgets/add_cart_fab.dart';

class SalesmanApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: SalesmanHomePage(),
    );
  }
}

class SalesmanHomePage extends StatefulWidget {
  @override
  _SalesmanHomePageState createState() => _SalesmanHomePageState();
}

class _SalesmanHomePageState extends State<SalesmanHomePage> {
  List<Map<String, dynamic>> tasks = [
    {
      'title': 'Update customer profiles',
      'subtitle': 'EOD',
      'completed': false
    },
    {'title': 'Send follow-up emails', 'subtitle': 'Sent', 'completed': true},
    {'title': 'Update deal status', 'subtitle': 'Reviewed', 'completed': true},
    {
      'title': 'Review sales performance',
      'subtitle': 'Noon',
      'completed': false
    },
    {
      'title': 'Product demo session',
      'subtitle': 'Afternoon',
      'completed': false
    },
    {'title': 'Attend team meeting', 'subtitle': 'Evening', 'completed': false},
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        title: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text('Today,',
                style: TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                    color: Colors.black)),
            Text('CRMPro',
                style: TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                    color: Colors.black)),
          ],
        ),
      ),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('My Tasks',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            SizedBox(height: 10),
            Expanded(
              child: ListView.builder(
                itemCount: tasks.length,
                itemBuilder: (context, index) {
                  return Card(
                    elevation: 2,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10)),
                    child: CheckboxListTile(
                      title: Text(tasks[index]['title'],
                          style: TextStyle(fontSize: 16)),
                      subtitle: tasks[index]['completed']
                          ? Container(
                              padding: EdgeInsets.symmetric(
                                  vertical: 4, horizontal: 10),
                              decoration: BoxDecoration(
                                color: Colors.redAccent,
                                borderRadius: BorderRadius.circular(10),
                              ),
                              child: Text(tasks[index]['subtitle'],
                                  style: TextStyle(
                                      color: Colors.white, fontSize: 12)),
                            )
                          : Text(tasks[index]['subtitle']),
                      value: tasks[index]['completed'],
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
      // bottomNavigationBar: BottomNavigationBar(
      //   items: [
      //     BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Home'),
      //     BottomNavigationBarItem(
      //         icon: Icon(Icons.add_circle_outline), label: 'Products'),
      //     BottomNavigationBarItem(icon: Icon(Icons.person), label: 'Profile'),
      //   ],
      // ),
      floatingActionButton: AddCartFAB(),
      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
    );
  }
}
