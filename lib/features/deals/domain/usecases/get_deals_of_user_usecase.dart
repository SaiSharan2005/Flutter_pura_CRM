import 'package:pura_crm/features/deals/domain/entities/deal_entity.dart';
import 'package:pura_crm/features/deals/domain/respositories/deal_repository.dart';

class GetDealsOfUserUseCase {
  final DealRepository repository;

  GetDealsOfUserUseCase(this.repository);

  Future<List<DealEntity>> call(int userId) async {
    // Since userId is non-nullable, no extra null-check is needed.
    print(userId);
    final data = await repository.getDealsOfUser(userId);
    print("test");

    return data;
  }
}
