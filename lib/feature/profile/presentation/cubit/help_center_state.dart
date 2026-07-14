import 'package:primo/feature/profile/data/models/help_center_model.dart';

abstract class HelpCenterState {
  const HelpCenterState();
}

class HelpCenterInitial extends HelpCenterState {}

class HelpCenterLoading extends HelpCenterState {}

class HelpCenterLoaded extends HelpCenterState {
  final HelpCenterModel model;
  const HelpCenterLoaded(this.model);
}

class HelpCenterError extends HelpCenterState {
  final String message;
  const HelpCenterError(this.message);
}
