import 'package:pura_crm/features/auth/domain/entities/logistic_entity.dart';
import 'package:pura_crm/features/auth/domain/repositories/logistic_repository.dart';

class CreateLogisticPersonUseCase {
  final LogisticPersonRepository repository;

  CreateLogisticPersonUseCase(this.repository);

  Future<bool> execute(LogisticPersonEntity logisticPerson) async {
    return await repository.createLogisticPersonDetails(logisticPerson);
  }
}

class GetAllLogisticPersonsUseCase {
  final LogisticPersonRepository repository;

  GetAllLogisticPersonsUseCase(this.repository);

  Future<List<LogisticPersonEntity>> execute() async {
    return await repository.getAllLogisticPersons();
  }
}

class GetLogisticPersonByIdUseCase {
  final LogisticPersonRepository repository;

  GetLogisticPersonByIdUseCase(this.repository);

  Future<LogisticPersonEntity> execute(String id) async {
    return await repository.getLogisticPersonDetailsById(id);
  }
}

class UpdateLogisticPersonUseCase {
  final LogisticPersonRepository repository;

  UpdateLogisticPersonUseCase(this.repository);

  Future<bool> execute(String id, LogisticPersonEntity logisticPerson) async {
    return await repository.updateLogisticPersonById(id, logisticPerson);
  }
}

class DeleteLogisticPersonUseCase {
  final LogisticPersonRepository repository;

  DeleteLogisticPersonUseCase(this.repository);

  Future<void> execute(String id) async {
    await repository.deleteLogisticPersonById(id);
  }
}
