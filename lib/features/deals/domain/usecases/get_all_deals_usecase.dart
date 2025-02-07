// lib/features/deals/domain/usecases/get_all_deals_usecase.dart


import 'package:pura_crm/features/deals/domain/entities/deal_entity.dart';
import 'package:pura_crm/features/deals/domain/respositories/deal_repository.dart';

class GetAllDealsUseCase {
  final DealRepository repository;

  GetAllDealsUseCase(this.repository);

  Future<List<DealEntity>> call() async {
    return await repository.getAllDeals();
  }
}
