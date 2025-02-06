// import 'package:flutter/material.dart';
// import 'package:pura_crm/features/auth/domain/entities/manager_entity.dart';
// import 'package:pura_crm/features/auth/domain/repositories/manager_repository.dart';
// import 'package:pura_crm/features/auth/domain/usecases/manager_use_case.dart';
//
// class ManagerProvider with ChangeNotifier {
//   // final CreateManagerUseCase createManagerUseCase;
//   // final GetAllManagersUseCase getAllManagersUseCase;
//   // final GetManagerByIdUseCase getManagerByIdUseCase;
//   // final UpdateManagerUseCase updateManagerUseCase;
//   // final DeleteManagerUseCase deleteManagerUseCase;
//   final  managerRepository;
//   List<ManagerEntity> _managers = [];
//   List<ManagerEntity> get managers => _managers;
//
//   ManagerProvider(this.managerRepository);
//
//   // Fetch all managers
//   Future<void> fetchAllManagers() async {
//     _managers = await managerRepository.getAllManagersUseCase.execute();
//     notifyListeners();
//   }
//
//   // Add a new manager
//   Future<void> addManager(ManagerEntity manager) async {
//     final success = await createManagerUseCase.execute(manager);
//     if (success) {
//       fetchAllManagers(); // Refresh the list after adding
//     }
//   }
//
//   // Remove a manager by ID
//   Future<void> removeManager(String id) async {
//     await deleteManagerUseCase.execute(id);
//     fetchAllManagers(); // Refresh the list after removing
//   }
//
//   // Update manager by ID
//   Future<void> updateManager(String id, ManagerEntity manager) async {
//     final success = await updateManagerUseCase.execute(id, manager);
//     if (success) {
//       fetchAllManagers(); // Refresh the list after updating
//     }
//   }
// }
