part of 'subscription_bloc.dart';

sealed class SubscriptionEvent extends Equatable {
  const SubscriptionEvent();

  @override
  List<Object> get props => [];
}

class CreateSubscriptionPreferenceEvent extends SubscriptionEvent {
  final int tecnicoId;

  const CreateSubscriptionPreferenceEvent(this.tecnicoId);

  @override
  List<Object> get props => [tecnicoId];
}
