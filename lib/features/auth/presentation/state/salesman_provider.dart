import 'package:flutter/material.dart';
import 'package:pura_crm/features/auth/domain/repositories/salesman_repository.dart';
import 'package:pura_crm/features/auth/domain/entities/salesman.dart';

class SalesmanProvider with ChangeNotifier {
  final SalesmanRepository salesmanRepository;
  Salesman? salesman;
  List<Salesman>? allSalesmen;

  SalesmanProvider(this.salesmanRepository);

  Future<void> fetchSalesmanDetailsAboutSelf() async {
    salesman = await salesmanRepository.getSalesmanDetailsAboutSelf();
    notifyListeners();
  }

  Future<void> createSalesmanDetails(Salesman salesman) async {
    salesman = await salesmanRepository.createSalesmanDetails(salesman);
    notifyListeners();
  }

  Future<void> fetchAllSalesmanDetails() async {
    allSalesmen = await salesmanRepository.getAllSalesmanDetails();
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
