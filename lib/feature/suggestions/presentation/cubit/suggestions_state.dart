import 'package:equatable/equatable.dart';

abstract class SuggestionsState extends Equatable {
  const SuggestionsState();

  @override
  List<Object?> get props => [];
}

class SuggestionsInitial extends SuggestionsState {}

class SuggestionsSubmitting extends SuggestionsState {}

class SuggestionsSuccess extends SuggestionsState {
  final String message;

  const SuggestionsSuccess(this.message);

  @override
  List<Object?> get props => [message];
}

class SuggestionsError extends SuggestionsState {
  final String message;

  const SuggestionsError(this.message);

  @override
  List<Object?> get props => [message];
}
