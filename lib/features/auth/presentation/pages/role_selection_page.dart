import 'package:flutter/material.dart';
// import 'salesman_detail_form.dart';
// import 'manager_detail_form.dart';

class RoleSelectionPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('CRMPro'),
        backgroundColor: Colors.red,
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'Select Your Role',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                // Navigator.push(
                //   context,
                //   MaterialPageRoute(
                //     builder: (context) => SalesmanDetailForm(),
                //   ),
                // );
              },
              style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
              child: Text('Salesman'),
            ),
            ElevatedButton(
              onPressed: () {
                // Navigator.push(
                //   context,
                  // MaterialPageRoute(
                  //   builder: (context) => ManagerDetailForm(),
                  // ),
                // );
              },
              style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
              child: Text('Manager'),
            ),
            ElevatedButton(
              onPressed: () {
                // Navigate to Logistics detail page
              },
              style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
              child: Text('Logistics'),
            ),
            ElevatedButton(
              onPressed: () {
                // Navigate to Admin detail page
              },
              style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
              child: Text('Admin'),
            ),
          ],
        ),
      ),
    );
  }
}
