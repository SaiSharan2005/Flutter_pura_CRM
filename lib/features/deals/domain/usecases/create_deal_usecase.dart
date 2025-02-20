// lib/features/deals/domain/usecases/create_deal_usecase.dart

import 'package:pura_crm/features/deals/data/models/deal_request.dart';
import 'package:pura_crm/features/deals/domain/entities/deal_entity.dart';
import 'package:pura_crm/features/deals/domain/respositories/deal_repository.dart';

class CreateDealUseCase {
  final DealRepository repository;

  CreateDealUseCase(this.repository);

  Future<DealEntity> call(DealEntity deal) async {
    // Convert the DealEntity to a DealRequestDto.
    final dealRequestDto = DealRequestDto(
      id: deal.id,
      customerId: deal.customerId.id,
      cartId: deal.cartId.id,
      userId: deal.userId.id!,
      dealName: deal.dealName,
      dealStage: deal.dealStage,
      amount: deal.amount,
      quantity: deal.quantity,
      deliveryAddress: deal.deliveryAddress,
      expectedCloseDate: deal.expectedCloseDate,
      actualClosedDate: deal.actualClosedDate,
      note: deal.note,
    );
    // Pass the DTO to the repository.
    return await repository.createDeal(dealRequestDto);
  }
}
