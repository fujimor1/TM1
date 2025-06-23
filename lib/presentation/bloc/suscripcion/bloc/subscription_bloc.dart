import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:tm1/data/datasource/tecnico_db_datasource.dart';
import 'package:tm1/data/repository/tecnico_repository_impl.dart';
import 'package:tm1/domain/repository/tecnico_repository.dart';

part 'subscription_event.dart';
part 'subscription_state.dart';

class SubscriptionBloc extends Bloc<SubscriptionEvent, SubscriptionState> {

  final TecnicoRepository _tecnicoRepository = TecnicoRepositoryImpl(TecnicoDbDatasource());

  SubscriptionBloc() : super(SubscriptionInitial()) {
    on<CreateSubscriptionPreferenceEvent>(_onCreateSubscriptionPreferenceEvent);
  }
  Future<void> _onCreateSubscriptionPreferenceEvent(
    CreateSubscriptionPreferenceEvent event,
    Emitter<SubscriptionState> emit,
  ) async {
    // 1. Emitimos el estado de carga para que la UI muestre un spinner.
    emit(SubscriptionLoading());

    try {
      // 2. Llamamos al repositorio para obtener los datos de la preferencia.
      final preferenceData =
          await _tecnicoRepository.createSubscriptionPreference(event.tecnicoId);

      // 3. Si la llamada es exitosa, emitimos el estado 'Created' con los datos.
      emit(SubscriptionPreferenceCreated(preferenceData));
    } catch (e) {
      // 4. Si ocurre un error, emitimos el estado de error con un mensaje.
      emit(SubscriptionError('Error al crear la preferencia de pago: $e'));
    }
  }
}
