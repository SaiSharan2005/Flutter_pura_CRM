import 'package:pura_crm/features/deals/domain/entities/deal_entity.dart';
import 'package:pura_crm/features/deals/domain/respositories/deal_repository.dart';

class UpdateDealUseCase {
  final DealRepository repository;

  UpdateDealUseCase(this.repository);

  Future<DealEntity> call(int id, DealEntity deal) async {
    return await repository.updateDeal(id, deal);
  }
}
