import 'package:pura_crm/features/salesman/domain/entities/salesman.dart';

abstract class SalesmanRepository {
  Future<Salesman> getSalesmanDetailsAboutSelf();
  Future<Salesman> getSalesmanDetailsById(String id);
  Future<void> updateSalesmanById(String id, Salesman salesman);
  Future<void> deleteSalesmanById(String id);
  Future<void> updateSalesmanAboutSelf(Salesman salesman);
  Future<List<Salesman>> getAllSalesmanDetails();
  Future<bool> createSalesmanDetails(Salesman salesman);
}
