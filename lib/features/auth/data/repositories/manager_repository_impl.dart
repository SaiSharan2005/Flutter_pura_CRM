import 'dart:convert';

import 'package:pura_crm/core/utils/api_client.dart';
import 'package:pura_crm/features/auth/domain/entities/manager_entity.dart';
import 'package:pura_crm/features/auth/domain/repositories/manager_repository.dart';

class ManagerRepositoryImpl implements ManagerRepository {
    final ApiClient apiClient;

    ManagerRepositoryImpl(this.apiClient);

    @override
    Future<ManagerEntity> getManagerDetailsAboutSelf() async {
        try {
            final response = await apiClient.get('/managers/');
            if (response.statusCode == 200) {
                return ManagerEntity.fromJson(json.decode(response.body));
            } else {
                throw Exception("Failed to fetch manager details. Status: ${response.statusCode}");
            }
        } catch (e) {
            throw Exception("Error fetching manager details: $e");
        }
    }

    @override
    Future<bool> createManagerDetails(ManagerEntity manager) async {
        try {
            final response = await apiClient.post(
                '/managers/create',
                json.encode(manager.toJson()),
            );
            return response.statusCode == 200 || response.statusCode == 201;
        } catch (e) {
            print("Error creating manager: $e");
            return false;
        }
    }

    @override
    Future<ManagerEntity> getManagerDetailsById(String id) async {
        try {
            final response = await apiClient.get('/managers/$id');
            if (response.statusCode == 200) {
                return ManagerEntity.fromJson(json.decode(response.body));
            } else {
                throw Exception("Failed to fetch manager by ID. Status: ${response.statusCode}");
            }
        } catch (e) {
            throw Exception("Error fetching manager by ID: $e");
        }
    }

    @override
    Future<bool> updateManagerById(String id, ManagerEntity manager) async {
        try {
            final response = await apiClient.put(
                '/managers/$id',
                json.encode(manager.toJson()),
            );
            return response.statusCode == 200;
        } catch (e) {
            print("Error updating manager: $e");
            return false;
        }
    }

    @override
    Future<void> deleteManagerById(String id) async {
        try {
            final response = await apiClient.delete('/managers/$id');
            if (response.statusCode != 200) {
                throw Exception("Failed to delete manager. Status: ${response.statusCode}");
            }
        } catch (e) {
            throw Exception("Error deleting manager: $e");
        }
    }

    @override
    Future<void> updateManagerAboutSelf(ManagerEntity manager) async {
        try {
            await apiClient.put(
                '/managers/',
                json.encode(manager.toJson()),
            );
        } catch (e) {
            throw Exception("Error updating self details: $e");
        }
    }

    @override
    Future<List<ManagerEntity>> getAllManagerDetails() async {
        try {
            final response = await apiClient.get('/managers/all');
            if (response.statusCode == 200) {
                final List<dynamic> jsonList = json.decode(response.body);
                return jsonList.map((json) => ManagerEntity.fromJson(json)).toList();
            } else {
                throw Exception("Failed to fetch all managers. Status: ${response.statusCode}");
            }
        } catch (e) {
            throw Exception("Error fetching all managers: $e");
        }
    }
}
