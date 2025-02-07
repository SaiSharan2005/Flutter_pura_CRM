// lib/features/deals/domain/usecases/create_deal_usecase.dart


import 'package:pura_crm/features/deals/domain/entities/deal_entity.dart';
import 'package:pura_crm/features/deals/domain/respositories/deal_repository.dart';

class CreateDealUseCase {
  final DealRepository repository;

  CreateDealUseCase(this.repository);

  Future<DealEntity> call(DealEntity deal) async {
    return await repository.createDeal(deal);
  }
}
