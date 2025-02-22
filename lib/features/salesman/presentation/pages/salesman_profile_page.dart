import 'package:flutter/material.dart';
import 'package:pura_crm/features/salesman/domain/repositories/salesman_repository.dart';
import 'package:pura_crm/features/salesman/domain/entities/salesman.dart';

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

  late TextEditingController phoneController;
  late TextEditingController addressController;
  late TextEditingController dateOfBirthController;
  late TextEditingController notesController;
  late TextEditingController usernameController;
  late TextEditingController emailController;

  @override
  void initState() {
    super.initState();
    _fetchSalesmanDetails();
  }

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
      setState(() {
        isLoading = false;
      });
    }
  }

  void _initializeControllers() {
    phoneController = TextEditingController(text: salesman?.phoneNumber ?? '');
    addressController = TextEditingController(text: salesman?.address ?? '');
    dateOfBirthController = TextEditingController(
        text: salesman != null ? _formatDate(salesman!.dateOfBirth) : '');
    notesController = TextEditingController(text: salesman?.notes ?? '');
    usernameController =
        TextEditingController(text: salesman?.user?.username ?? '');
    emailController = TextEditingController(text: salesman?.user?.email ?? '');
  }

  void _toggleEditing() {
    setState(() {
      _isEditing = !_isEditing;
    });
  }

  Widget _buildProfileField(String label, String value,
      {bool isEditable = false, TextEditingController? controller}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label,
            style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w500,
                color: Colors.grey[700])),
        SizedBox(height: 5),
        isEditable
            ? TextField(
                controller: controller,
                decoration: InputDecoration(
                  border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8)),
                  filled: true,
                  fillColor: Colors.grey[100],
                ),
              )
            : Text(value,
                style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Colors.black)),
        Divider(thickness: 1, color: Colors.grey[300]),
        SizedBox(height: 10),
      ],
    );
  }

  Widget _buildProfileView() {
    return Padding(
      padding: EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Center(
            child: CircleAvatar(
              radius: 50,
              backgroundImage: AssetImage('assets/logo.png'),
            ),
          ),
          SizedBox(height: 20),
          _buildProfileField("Username", usernameController.text),
          _buildProfileField("Email", emailController.text),
          _buildProfileField("Phone", phoneController.text),
          _buildProfileField("Address", addressController.text),
          _buildProfileField("Date of Birth", dateOfBirthController.text),
          _buildProfileField("Notes", notesController.text),
          _buildProfileField("Region Assigned", salesman?.regionAssigned ?? ''),
          _buildProfileField("Status", salesman?.status ?? ''),
          _buildProfileField(
              "Total Sales", salesman?.totalSales.toString() ?? ''),
          _buildProfileField("Hire Date",
              salesman != null ? _formatDate(salesman!.hireDate) : ''),
        ],
      ),
    );
  }

  Widget _buildEditProfileView() {
    return Padding(
      padding: EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Center(
            child: CircleAvatar(
              radius: 50,
              backgroundImage: AssetImage('assets/logo.png'),
            ),
          ),
          SizedBox(height: 20),
          _buildProfileField("Username", usernameController.text),
          _buildProfileField("Email", emailController.text),
          _buildProfileField("Phone", phoneController.text,
              isEditable: true, controller: phoneController),
          _buildProfileField("Address", addressController.text,
              isEditable: true, controller: addressController),
          _buildProfileField("Date of Birth", dateOfBirthController.text,
              isEditable: true, controller: dateOfBirthController),
          _buildProfileField("Notes", notesController.text,
              isEditable: true, controller: notesController),
          _buildProfileField("Region Assigned", salesman?.regionAssigned ?? ''),
          _buildProfileField("Status", salesman?.status ?? ''),
          _buildProfileField(
              "Total Sales", salesman?.totalSales.toString() ?? ''),
          _buildProfileField("Hire Date",
              salesman != null ? _formatDate(salesman!.hireDate) : ''),
          SizedBox(height: 20),
          ElevatedButton.icon(
            onPressed: () {}, // Implement save functionality
            icon: Icon(Icons.save, color: Colors.white),
            label: Text("Save Changes", style: TextStyle(color: Colors.white)),
            style: ElevatedButton.styleFrom(
              backgroundColor: Color(0xFFE41B47),
              padding: EdgeInsets.symmetric(horizontal: 24, vertical: 12),
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12)),
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
        title: Text(
          "Salesman Profile",
          style: TextStyle(color: Colors.white),
        ),
        backgroundColor: Color(0xFFE41B47),
        actions: [
          IconButton(
            icon: Icon(_isEditing ? Icons.cancel : Icons.edit,
                color: Colors.white),
            onPressed: _toggleEditing,
          ),
        ],
      ),
      body: isLoading
          ? Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
              // Wrapping the content in SingleChildScrollView to prevent overflow
              padding: EdgeInsets.only(bottom: 16),
              child: _isEditing ? _buildEditProfileView() : _buildProfileView(),
            ),
    );
  }
}
