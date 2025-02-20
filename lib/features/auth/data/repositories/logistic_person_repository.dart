import 'dart:convert';

import 'package:pura_crm/core/utils/api_client.dart';
import 'package:pura_crm/features/auth/domain/entities/logistic_entity.dart';
import 'package:pura_crm/features/auth/domain/repositories/logistic_repository.dart';
// import 'package:your_project_name/core/utils/api_client.dart';
// import 'package:your_project_name/features/logistics/domain/entities/logistic_person_entity.dart';
// import 'package:your_project_name/features/logistics/domain/repositories/logistic_person_repository.dart';

class LogisticPersonRepositoryImpl implements LogisticPersonRepository {
  final ApiClient apiClient;

  LogisticPersonRepositoryImpl(this.apiClient);

  @override
  Future<LogisticPersonEntity> getLogisticPersonDetailsAboutSelf() async {
    final response = await apiClient.get('/logistics/');
    if (response.statusCode == 200) {
      return LogisticPersonEntity.fromJson(json.decode(response.body));
    }
    throw Exception("Failed to fetch logistic person details");
  }

  @override
  Future<bool> createLogisticPersonDetails(
      LogisticPersonEntity logisticPerson) async {
    final response = await apiClient.post(
      '/logistics/create',
      json.encode(logisticPerson.toJson()),
    );
    return response.statusCode == 200 || response.statusCode == 201;
  }

  @override
  Future<LogisticPersonEntity> getLogisticPersonDetailsById(String id) async {
    final response = await apiClient.get('/logistics/$id');
    if (response.statusCode == 200) {
      return LogisticPersonEntity.fromJson(json.decode(response.body));
    }
    throw Exception("Failed to fetch logistic person by ID");
  }

  @override
  Future<bool> updateLogisticPersonById(
      String id, LogisticPersonEntity logisticPerson) async {
    final response = await apiClient.put(
      '/logistics/$id',
      json.encode(logisticPerson.toJson()),
    );
    return response.statusCode == 200;
  }

  @override
  Future<void> deleteLogisticPersonById(String id) async {
    final response = await apiClient.delete('/logistics/$id');
    if (response.statusCode != 204) {
      throw Exception("Failed to delete logistic person");
    }
  }

  @override
  Future<void> updateLogisticPersonAboutSelf(
      LogisticPersonEntity logisticPerson) async {
    await apiClient.put(
      '/logistics/',
      json.encode(logisticPerson.toJson()),
    );
  }

  @override
  Future<List<LogisticPersonEntity>> getAllLogisticPersons() async {
    final response = await apiClient.get('/logistics/all');
    if (response.statusCode == 200) {
      final List<dynamic> data = json.decode(response.body);
      return data.map((json) => LogisticPersonEntity.fromJson(json)).toList();
    }
    throw Exception("Failed to fetch all logistic persons");
  }
}
