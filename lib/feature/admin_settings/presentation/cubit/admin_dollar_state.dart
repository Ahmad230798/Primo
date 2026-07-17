abstract class AdminDollarState {
  const AdminDollarState();
}

class AdminDollarInitial extends AdminDollarState {}

class AdminDollarLoading extends AdminDollarState {}

class AdminDollarLoaded extends AdminDollarState {
  final num dollarValue;
  const AdminDollarLoaded(this.dollarValue);
}

class AdminDollarUpdating extends AdminDollarState {}

class AdminDollarUpdateSuccess extends AdminDollarState {
  final String message;
  final num newDollarValue;
  const AdminDollarUpdateSuccess(this.message, this.newDollarValue);
}

class AdminDollarError extends AdminDollarState {
  final String message;
  const AdminDollarError(this.message);
}
