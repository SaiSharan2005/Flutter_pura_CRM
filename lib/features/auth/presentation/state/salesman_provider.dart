import 'package:flutter/material.dart';
import 'package:pura_crm/features/salesman/domain/repositories/salesman_repository.dart';
import 'package:pura_crm/features/salesman/domain/entities/salesman.dart';

class SalesmanProvider with ChangeNotifier {
  final SalesmanRepository salesmanRepository;
  Salesman? salesman;
  List<Salesman>? allSalesmen;

  SalesmanProvider(this.salesmanRepository);

  Future<void> fetchSalesmanDetailsAboutSelf() async {
    salesman = await salesmanRepository.getSalesmanDetailsAboutSelf();
    notifyListeners();
  }

  // Future<bool> createSalesmanDetails(Salesman salesman) async {
  //   try {
  //     await salesmanRepository.createSalesmanDetails(salesman);
  //     notifyListeners();
  //     return true;  // Indicating success
  //   } catch (e) {
  //     // Handle any error appropriately (e.g., log the error)
  //     return false;  // Indicating failure
  //   }

//  }

  Future<bool> createSalesmanDetails(Salesman salesman) async {
    try {
      // Calling the repository method to create a salesman
      bool isSuccess = await salesmanRepository.createSalesmanDetails(salesman);

      if (isSuccess) {
        // Notifying listeners if successful
        notifyListeners();
      }
      return isSuccess; // Return success/failure status
    } catch (e) {
      // Handle any errors here
      print("Error in provider: $e");
      return false; // Return failure
    }
  }

  Future<void> fetchAllSalesmanDetails() async {
    final details = await salesmanRepository.getAllSalesmanDetails();
    if (details.isNotEmpty) {
      allSalesmen = details;
    } else {
      allSalesmen = [];
    }
    notifyListeners();
  }

  Future<void> updateSalesmanDetails(Salesman updatedSalesman) async {
    await salesmanRepository.updateSalesmanAboutSelf(updatedSalesman);
    await fetchSalesmanDetailsAboutSelf();
  }

  Future<void> deleteSalesman(String id) async {
    await salesmanRepository.deleteSalesmanById(id);
    await fetchAllSalesmanDetails();
  }
}
