import 'package:pura_crm/features/deals/domain/respositories/deal_repository.dart';

class DeleteDealUseCase {
  final DealRepository repository;

  DeleteDealUseCase(this.repository);

  Future<void> call(int id) async {
    return await repository.deleteDeal(id);
  }
}
