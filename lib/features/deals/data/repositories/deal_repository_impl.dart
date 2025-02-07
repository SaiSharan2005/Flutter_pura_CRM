import 'dart:convert';

import 'package:pura_crm/features/deals/data/datasource/deal_remote_data_source.dart';
import 'package:pura_crm/features/deals/data/models/deal_model.dart';
import 'package:pura_crm/features/deals/data/models/deal_request.dart';
import 'package:pura_crm/features/deals/domain/entities/deal_entity.dart';
import 'package:pura_crm/features/deals/domain/respositories/deal_repository.dart';

class DealRepositoryImpl implements DealRepository {
  final DealRemoteDataSource remoteDataSource;

  DealRepositoryImpl({required this.remoteDataSource});

  @override
  Future<DealEntity> createDeal(DealRequestDto deal) async {
    final dealModel = DealRequestDto(
      id: deal.id,
      customerId: deal.customerId,
      cartId: deal.cartId,
      userId: deal.userId,
      dealName: deal.dealName,
      dealStage: deal.dealStage,
      amount: deal.amount,
      quantity: deal.quantity,
      deliveryAddress: deal.deliveryAddress,
      expectedCloseDate: deal.expectedCloseDate,
      actualClosedDate: deal.actualClosedDate,
      note: deal.note,
    );
    final createdDealModel = await remoteDataSource.createDeal(dealModel);
    return createdDealModel;
  }

  @override
  Future<List<DealEntity>> getAllDeals() async {
    final deals = await remoteDataSource.getAllDeals();
    return deals;
  }

  @override
  Future<List<DealEntity>> getDealsOfUser(int userId) async {
    final deals = await remoteDataSource.getDealsOfUser(userId);
    return deals;
  }

  @override
  Future<DealEntity> updateDeal(int id, DealEntity deal) async {
    final dealModel = DealModel(
      id: deal.id,
      customerId: deal.customerId,
      cartId: deal.cartId,
      userId: deal.userId,
      dealName: deal.dealName,
      dealStage: deal.dealStage,
      amount: deal.amount,
      quantity: deal.quantity,
      deliveryAddress: deal.deliveryAddress,
      expectedCloseDate: deal.expectedCloseDate,
      actualClosedDate: deal.actualClosedDate,
      note: deal.note,
    );
    final updatedDealModel = await remoteDataSource.updateDeal(id, dealModel);
    return updatedDealModel;
  }

  @override
  Future<void> deleteDeal(int id) async {
    await remoteDataSource.deleteDeal(id);
  }
}
