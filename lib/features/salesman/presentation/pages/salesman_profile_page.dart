import 'package:flutter/material.dart';
import 'package:pura_crm/features/auth/domain/entities/user.dart';
import 'package:pura_crm/features/salesman/domain/repositories/salesman_repository.dart';
import 'package:pura_crm/features/salesman/domain/entities/salesman.dart';
// import 'package:pura_crm/features/salesman/domain/repositories/salesman_repository.dart';

class SalesmanProfilePage extends StatefulWidget {
  final String? salesmanId;
  final SalesmanRepository repository;

  const SalesmanProfilePage({
    super.key,
    this.salesmanId,
    required this.repository,
  });

  @override
  _SalesmanProfilePageState createState() => _SalesmanProfilePageState();
}

class _SalesmanProfilePageState extends State<SalesmanProfilePage> {
  bool _isEditing = false;
  bool isLoading = true;
  Salesman? salesman;

  // Controllers for fields that can be updated
  late TextEditingController phoneController;
  late TextEditingController addressController;
  late TextEditingController dateOfBirthController;
  late TextEditingController notesController;

  // Controllers for view-only fields
  late TextEditingController usernameController;
  late TextEditingController emailController;

  @override
  void initState() {
    super.initState();
    _fetchSalesmanDetails();
  }

  // Helper function to format a DateTime as "YYYY-MM-DD"
  String _formatDate(DateTime date) {
    return "${date.year}-${date.month.toString().padLeft(2, '0')}-${date.day.toString().padLeft(2, '0')}";
  }

  Future<void> _fetchSalesmanDetails() async {
    try {
      Salesman fetchedSalesman = widget.salesmanId != null
          ? await widget.repository.getSalesmanDetailsById(widget.salesmanId!)
          : await widget.repository.getSalesmanDetailsAboutSelf();
      setState(() {
        salesman = fetchedSalesman;
        _initializeControllers();
        isLoading = false;
      });
    } catch (e) {
      // Optionally, display an error message.
      setState(() {
        isLoading = false;
      });
    }
  }

  void _initializeControllers() {
    // Editable fields with date formatted as only date.
    phoneController = TextEditingController(text: salesman?.phoneNumber ?? '');
    addressController = TextEditingController(text: salesman?.address ?? '');
    dateOfBirthController = TextEditingController(
        text: salesman != null ? _formatDate(salesman!.dateOfBirth) : '');
    notesController = TextEditingController(text: salesman?.notes ?? '');

    // View-only fields
    usernameController =
        TextEditingController(text: salesman?.user?.username ?? '');
    emailController = TextEditingController(text: salesman?.user?.email ?? '');
  }

  void _toggleEditing() {
    setState(() {
      _isEditing = !_isEditing;
    });
  }

  // Save only the allowed fields: phone, address, date of birth, and notes.
  void _saveProfile() async {
    if (salesman == null) return;

    // Create an updated User object (unchanged)
    final updatedUser = salesman!.user != null
        ? User(
            id: salesman!.user!.id,
            username: salesman!.user!.username, // not updated
            email: salesman!.user!.email, // not updated
            password: salesman!.user!.password,
          )
        : null;

    // Parse the updated date of birth from the controller.
    final updatedDob =
        DateTime.tryParse(dateOfBirthController.text) ?? salesman!.dateOfBirth;

    // Create an updated Salesman instance using only the allowed updates.
    final updatedSalesman = Salesman(
      user: updatedUser,
      phoneNumber: phoneController.text,
      address: addressController.text,
      dateOfBirth: updatedDob,
      // The following fields remain unchanged:
      regionAssigned: salesman!.regionAssigned,
      totalSales: salesman!.totalSales,
      hireDate: salesman!.hireDate,
      status: salesman!.status,
      notes: notesController.text.isEmpty ? null : notesController.text,
    );

    try {
      // Call the repository to update your details.
      await widget.repository.updateSalesmanAboutSelf(updatedSalesman);
      setState(() {
        salesman = updatedSalesman;
        _isEditing = false;
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Profile Updated Successfully')),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to update profile')),
      );
    }
  }

  /// Build view (read-only) mode
  Widget _buildViewMode() {
    return SingleChildScrollView(
      padding: EdgeInsets.all(16.0),
      child: Column(
        children: [
          // Profile image
          CircleAvatar(
            radius: 50,
            backgroundImage: AssetImage('assets/logo.png'),
          ),
          SizedBox(height: 20),
          Card(
            child: ListTile(
              title: Text("Username"),
              subtitle: Text(usernameController.text),
            ),
          ),
          Card(
            child: ListTile(
              title: Text("Email"),
              subtitle: Text(emailController.text),
            ),
          ),
          Card(
            child: ListTile(
              title: Text("Phone"),
              subtitle: Text(phoneController.text),
            ),
          ),
          Card(
            child: ListTile(
              title: Text("Address"),
              subtitle: Text(addressController.text),
            ),
          ),
          Card(
            child: ListTile(
              title: Text("Date of Birth"),
              subtitle: Text(dateOfBirthController.text),
            ),
          ),
          Card(
            child: ListTile(
              title: Text("Notes"),
              subtitle: Text(notesController.text),
            ),
          ),
          // Additional read-only details
          Card(
            child: ListTile(
              title: Text("Region Assigned"),
              subtitle: Text(salesman?.regionAssigned ?? ''),
            ),
          ),
          Card(
            child: ListTile(
              title: Text("Status"),
              subtitle: Text(salesman?.status ?? ''),
            ),
          ),
          Card(
            child: ListTile(
              title: Text("Total Sales"),
              subtitle: Text(salesman?.totalSales.toString() ?? ''),
            ),
          ),
          Card(
            child: ListTile(
              title: Text("Hire Date"),
              subtitle:
                  Text(salesman != null ? _formatDate(salesman!.hireDate) : ''),
            ),
          ),
        ],
      ),
    );
  }

  /// Build edit mode (show all data as in view mode, but allow updating certain fields)
  Widget _buildEditMode() {
    return SingleChildScrollView(
      padding: EdgeInsets.all(16.0),
      child: Column(
        children: [
          // Profile image remains the same.
          CircleAvatar(
            radius: 50,
            backgroundImage: AssetImage('assets/logo.png'),
          ),
          SizedBox(height: 20),
          // Non-editable fields displayed as cards.
          Card(
            child: ListTile(
              title: Text("Username"),
              subtitle: Text(usernameController.text),
            ),
          ),
          Card(
            child: ListTile(
              title: Text("Email"),
              subtitle: Text(emailController.text),
            ),
          ),
          // Editable fields displayed as input boxes.
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 8.0),
            child: TextField(
              controller: phoneController,
              decoration: InputDecoration(
                labelText: "Phone",
                border: OutlineInputBorder(),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 8.0),
            child: TextField(
              controller: addressController,
              decoration: InputDecoration(
                labelText: "Address",
                border: OutlineInputBorder(),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 8.0),
            child: TextField(
              controller: dateOfBirthController,
              decoration: InputDecoration(
                labelText: "Date of Birth",
                hintText: "YYYY-MM-DD",
                border: OutlineInputBorder(),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 8.0),
            child: TextField(
              controller: notesController,
              decoration: InputDecoration(
                labelText: "Notes",
                border: OutlineInputBorder(),
              ),
            ),
          ),
          // Additional read-only fields displayed as cards.
          Card(
            child: ListTile(
              title: Text("Region Assigned"),
              subtitle: Text(salesman?.regionAssigned ?? ''),
            ),
          ),
          Card(
            child: ListTile(
              title: Text("Status"),
              subtitle: Text(salesman?.status ?? ''),
            ),
          ),
          Card(
            child: ListTile(
              title: Text("Total Sales"),
              subtitle: Text(salesman?.totalSales.toString() ?? ''),
            ),
          ),
          Card(
            child: ListTile(
              title: Text("Hire Date"),
              subtitle:
                  Text(salesman != null ? _formatDate(salesman!.hireDate) : ''),
            ),
          ),
          SizedBox(height: 20),
          // Save changes button
          ElevatedButton.icon(
            onPressed: _saveProfile,
            icon: Icon(Icons.save),
            label: Text("Save Changes"),
            style: ElevatedButton.styleFrom(
              padding: EdgeInsets.symmetric(horizontal: 24, vertical: 12),
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Salesman Profile"),
        actions: [
          // Toggle edit mode.
          IconButton(
            icon: Icon(_isEditing ? Icons.cancel : Icons.edit),
            onPressed: _toggleEditing,
          ),
        ],
      ),
      body: isLoading
          ? Center(child: CircularProgressIndicator())
          : _isEditing
              ? _buildEditMode()
              : _buildViewMode(),
    );
  }
}
