import 'package:equatable/equatable.dart';
import 'package:pura_crm/features/deals/domain/entities/deal_entity.dart';

abstract class DealState extends Equatable {
  const DealState();

  @override
  List<Object?> get props => [];
}

class DealInitial extends DealState {}

class DealLoading extends DealState {}

class DealLoaded extends DealState {
  final List<DealEntity> deals;
  const DealLoaded(this.deals);

  @override
  List<Object?> get props => [deals];
}

class DealOperationSuccess extends DealState {
  final DealEntity deal;
  const DealOperationSuccess(this.deal);

  @override
  List<Object?> get props => [deal];
}

class DealError extends DealState {
  final String message;
  const DealError(this.message);

  @override
  List<Object?> get props => [message];
}
