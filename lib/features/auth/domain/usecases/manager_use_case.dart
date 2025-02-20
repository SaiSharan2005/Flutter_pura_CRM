import 'package:pura_crm/features/auth/domain/entities/manager_entity.dart';
import 'package:pura_crm/features/auth/domain/repositories/manager_repository.dart';

class CreateManagerUseCase {
  final ManagerRepository repository;

  CreateManagerUseCase(this.repository);

  Future<bool> execute(ManagerEntity manager) async {
    return await repository.createManagerDetails(manager);
  }
}

class GetAllManagersUseCase {
  final ManagerRepository repository;

  GetAllManagersUseCase(this.repository);

  Future<List<ManagerEntity>> execute() async {
    return await repository.getAllManagerDetails();
  }
}

class GetManagerByIdUseCase {
  final ManagerRepository repository;

  GetManagerByIdUseCase(this.repository);

  Future<ManagerEntity> execute(String id) async {
    return await repository.getManagerDetailsById(id);
  }
}

class UpdateManagerUseCase {
  final ManagerRepository repository;

  UpdateManagerUseCase(this.repository);

  Future<bool> execute(String id, ManagerEntity manager) async {
    return await repository.updateManagerById(id, manager);
  }
}

class DeleteManagerUseCase {
  final ManagerRepository repository;

  DeleteManagerUseCase(this.repository);

  Future<void> execute(String id) async {
    await repository.deleteManagerById(id);
  }
}
