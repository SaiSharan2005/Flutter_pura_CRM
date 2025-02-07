// // lib/features/deals/presentation/pages/create_deal_page.dart

// import 'package:flutter/material.dart';
// import 'package:flutter_bloc/flutter_bloc.dart';
// import 'package:pura_crm/features/deals/domain/entities/deal_entity.dart';
// import 'package:pura_crm/features/deals/presentation/state/deal_bloc.dart';
// import 'package:pura_crm/features/deals/presentation/state/deal_events.dart';

// class CreateDealPage extends StatefulWidget {
//   final int userId;
//   const CreateDealPage({Key? key, required this.userId}) : super(key: key);

//   @override
//   _CreateDealPageState createState() => _CreateDealPageState();
// }

// class _CreateDealPageState extends State<CreateDealPage> {
//   final _formKey = GlobalKey<FormState>();

//   // Form field controllers.
//   final TextEditingController _dealNameController = TextEditingController();
//   final TextEditingController _dealStageController = TextEditingController();
//   final TextEditingController _amountController = TextEditingController();
//   final TextEditingController _quantityController = TextEditingController();
//   final TextEditingController _deliveryAddressController = TextEditingController();
//   final TextEditingController _expectedCloseDateController = TextEditingController();
//   final TextEditingController _noteController = TextEditingController();

//   // For simplicity, hardcoded IDs (in a real app these would be chosen by the user).
//   final int customerId = 1;
//   final int cartId = 1;

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: const Text('Create Deal'),
//       ),
//       body: Padding(
//         padding: const EdgeInsets.all(16.0),
//         child: Form(
//           key: _formKey,
//           child: ListView(
//             children: [
//               TextFormField(
//                 controller: _dealNameController,
//                 decoration: const InputDecoration(labelText: 'Deal Name'),
//                 validator: (value) =>
//                     value == null || value.isEmpty ? 'Enter deal name' : null,
//               ),
//               TextFormField(
//                 controller: _dealStageController,
//                 decoration: const InputDecoration(labelText: 'Deal Stage'),
//                 validator: (value) =>
//                     value == null || value.isEmpty ? 'Enter deal stage' : null,
//               ),
//               TextFormField(
//                 controller: _amountController,
//                 decoration: const InputDecoration(labelText: 'Amount'),
//                 keyboardType: TextInputType.number,
//                 validator: (value) =>
//                     value == null || value.isEmpty ? 'Enter amount' : null,
//               ),
//               TextFormField(
//                 controller: _quantityController,
//                 decoration: const InputDecoration(labelText: 'Quantity'),
//                 keyboardType: TextInputType.number,
//                 validator: (value) =>
//                     value == null || value.isEmpty ? 'Enter quantity' : null,
//               ),
//               TextFormField(
//                 controller: _deliveryAddressController,
//                 decoration: const InputDecoration(labelText: 'Delivery Address'),
//                 validator: (value) =>
//                     value == null || value.isEmpty ? 'Enter delivery address' : null,
//               ),
//               TextFormField(
//                 controller: _expectedCloseDateController,
//                 decoration: const InputDecoration(labelText: 'Expected Close Date (YYYY-MM-DD)'),
//                 validator: (value) =>
//                     value == null || value.isEmpty ? 'Enter expected close date' : null,
//               ),
//               TextFormField(
//                 controller: _noteController,
//                 decoration: const InputDecoration(labelText: 'Note'),
//               ),
//               const SizedBox(height: 20),
//               ElevatedButton(
//                 onPressed: () {
//                   if (_formKey.currentState!.validate()) {
//                     final deal = DealEntity(
//                       customerId: customerId,
//                       cartId: cartId,
//                       userId: widget.userId,
//                       dealName: _dealNameController.text,
//                       dealStage: _dealStageController.text,
//                       amount: double.tryParse(_amountController.text) ?? 0.0,
//                       quantity: int.tryParse(_quantityController.text) ?? 1,
//                       deliveryAddress: _deliveryAddressController.text,
//                       expectedCloseDate: DateTime.parse(_expectedCloseDateController.text),
//                       actualClosedDate: null,
//                       note: _noteController.text,
//                     );

//                     context.read<DealBloc>().add(CreateDealEvent(deal));
//                     Navigator.pop(context);
//                   }
//                 },
//                 child: const Text('Create Deal'),
//               ),
//             ],
//           ),
//         ),
//       ),
//     );
//   }
// }
