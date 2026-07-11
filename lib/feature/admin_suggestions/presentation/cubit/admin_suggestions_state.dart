import 'package:equatable/equatable.dart';
import 'package:primo/feature/admin_home/data/models/admin_dashboard_model.dart';

abstract class AdminSuggestionsState extends Equatable {
  const AdminSuggestionsState();

  @override
  List<Object?> get props => [];
}

class AdminSuggestionsInitial extends AdminSuggestionsState {}

class AdminSuggestionsLoading extends AdminSuggestionsState {}

class AdminSuggestionsLoaded extends AdminSuggestionsState {
  final List<SuggestionModel> suggestions;
  final String currentTab;

  const AdminSuggestionsLoaded(this.suggestions, {this.currentTab = 'new'});

  @override
  List<Object?> get props => [suggestions, currentTab];
}

class AdminSuggestionsError extends AdminSuggestionsState {
  final String errorMessage;

  const AdminSuggestionsError(this.errorMessage);

  @override
  List<Object?> get props => [errorMessage];
}

class AdminSuggestionUpdating extends AdminSuggestionsState {
  final int suggestionId;

  const AdminSuggestionUpdating(this.suggestionId);

  @override
  List<Object?> get props => [suggestionId];
}

class AdminSuggestionStatusSuccess extends AdminSuggestionsState {
  final String message;

  const AdminSuggestionStatusSuccess(this.message);

  @override
  List<Object?> get props => [message];
}
