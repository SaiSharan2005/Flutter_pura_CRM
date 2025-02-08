import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pura_crm/features/deals/domain/usecases/create_deal_usecase.dart';
import 'package:pura_crm/features/deals/domain/usecases/delete_deal_usecase.dart';
import 'package:pura_crm/features/deals/domain/usecases/get_all_deals_usecase.dart';
import 'package:pura_crm/features/deals/domain/usecases/get_deals_of_user_usecase.dart';
import 'package:pura_crm/features/deals/domain/usecases/update_deal_usecase.dart';
import 'package:pura_crm/features/deals/presentation/state/deal_events.dart';
import 'package:pura_crm/features/deals/presentation/state/deal_state.dart';

class DealBloc extends Bloc<DealEvent, DealState> {
  final CreateDealUseCase createDealUseCase;
  final GetAllDealsUseCase getAllDealsUseCase;
  final GetDealsOfUserUseCase getDealsOfUserUseCase;
  final UpdateDealUseCase updateDealUseCase;
  final DeleteDealUseCase deleteDealUseCase;

  DealBloc({
    required this.createDealUseCase,
    required this.getAllDealsUseCase,
    required this.getDealsOfUserUseCase,
    required this.updateDealUseCase,
    required this.deleteDealUseCase,
  }) : super(DealInitial()) {
    on<GetAllDealsEvent>((event, emit) async {
      emit(DealLoading());
      try {
        final deals = await getAllDealsUseCase();
        emit(DealLoaded(deals));
      } catch (e) {
        emit(DealError(e.toString()));
      }
    });

    on<GetDealsOfUserEvent>((event, emit) async {
      emit(DealLoading());
      try {
        final deals = await getDealsOfUserUseCase(event.userId);
        emit(DealLoaded(deals));
      } catch (e) {
        emit(DealError(e.toString()));
      }
    });

    on<CreateDealEvent>((event, emit) async {
      emit(DealLoading());
      try {
        final deal = await createDealUseCase(event.deal);
        emit(DealOperationSuccess(deal));
      } catch (e) {
        emit(DealError(e.toString()));
      }
    });

    on<UpdateDealEvent>((event, emit) async {
      emit(DealLoading());
      try {
        final deal = await updateDealUseCase(event.id, event.deal);
        emit(DealOperationSuccess(deal));
      } catch (e) {
        emit(DealError(e.toString()));
      }
    });

    on<DeleteDealEvent>((event, emit) async {
      emit(DealLoading());
      try {
        await deleteDealUseCase(event.id);
        // Optionally, you can refresh the list of deals after deletion:
        final deals = await getAllDealsUseCase();
        emit(DealLoaded(deals));
      } catch (e) {
        emit(DealError(e.toString()));
      }
    });
  }
}
