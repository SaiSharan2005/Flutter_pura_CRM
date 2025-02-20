import 'package:pura_crm/features/auth/domain/entities/manager_entity.dart';

abstract class ManagerRepository {
  Future<ManagerEntity> getManagerDetailsAboutSelf();
  Future<bool> createManagerDetails(ManagerEntity manager);
  Future<ManagerEntity> getManagerDetailsById(String id);
  Future<bool> updateManagerById(String id, ManagerEntity manager);
  Future<void> deleteManagerById(String id);
  Future<void> updateManagerAboutSelf(ManagerEntity manager);
  Future<List<ManagerEntity>> getAllManagerDetails();
}
