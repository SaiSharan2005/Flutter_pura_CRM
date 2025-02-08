// lib/features/deals/domain/repositories/deal_repository.dart

// import '../entities/deal_entity.dart';

import 'package:pura_crm/features/deals/data/models/deal_request.dart';
import 'package:pura_crm/features/deals/domain/entities/deal_entity.dart';

abstract class DealRepository {
  Future<DealEntity> createDeal(DealRequestDto deal);
  Future<List<DealEntity>> getAllDeals();
  Future<List<DealEntity>> getDealsOfUser(int userId);
  Future<DealEntity> updateDeal(int id, DealEntity deal);
  Future<void> deleteDeal(int id);
}
