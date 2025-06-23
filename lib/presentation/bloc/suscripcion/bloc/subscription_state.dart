part of 'subscription_bloc.dart';

sealed class SubscriptionState extends Equatable {
  const SubscriptionState();
  
  @override
  List<Object> get props => [];
}

final class SubscriptionInitial extends SubscriptionState {}

final class SubscriptionLoading extends SubscriptionState {}

final class SubscriptionPreferenceCreated extends SubscriptionState {
  final Map<String, dynamic> preferenceData;

  const SubscriptionPreferenceCreated(this.preferenceData);

  @override
  List<Object> get props => [preferenceData];
}

final class SubscriptionError extends SubscriptionState {
  final String message;

  const SubscriptionError(this.message);

  @override
  List<Object> get props => [message];
}