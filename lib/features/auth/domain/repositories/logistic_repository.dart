import 'package:pura_crm/features/auth/domain/entities/logistic_entity.dart';

abstract class LogisticPersonRepository {
  Future<LogisticPersonEntity> getLogisticPersonDetailsAboutSelf();
  Future<bool> createLogisticPersonDetails(LogisticPersonEntity logisticPerson);
  Future<LogisticPersonEntity> getLogisticPersonDetailsById(String id);
  Future<bool> updateLogisticPersonById(String id, LogisticPersonEntity logisticPerson);
  Future<void> deleteLogisticPersonById(String id);
  Future<void> updateLogisticPersonAboutSelf(LogisticPersonEntity logisticPerson);
  Future<List<LogisticPersonEntity>> getAllLogisticPersons();
}
