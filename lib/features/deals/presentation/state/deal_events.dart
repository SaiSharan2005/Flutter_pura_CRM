import 'package:equatable/equatable.dart';
import 'package:pura_crm/features/deals/domain/entities/deal_entity.dart';

abstract class DealEvent extends Equatable {
  const DealEvent();

  @override
  List<Object?> get props => [];
}

class GetAllDealsEvent extends DealEvent {}

class GetDealsOfUserEvent extends DealEvent {
  final int userId;
  const GetDealsOfUserEvent(this.userId);

  @override
  List<Object?> get props => [userId];
}

class CreateDealEvent extends DealEvent {
  final DealEntity deal;
  const CreateDealEvent(this.deal);

  @override
  List<Object?> get props => [deal];
}

class UpdateDealEvent extends DealEvent {
  final int id;
  final DealEntity deal;
  const UpdateDealEvent(this.id, this.deal);

  @override
  List<Object?> get props => [id, deal];
}

class DeleteDealEvent extends DealEvent {
  final int id;
  const DeleteDealEvent(this.id);

  @override
  List<Object?> get props => [id];
}
