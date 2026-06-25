import 'package:equatable/equatable.dart';

sealed class AddressesState extends Equatable {
  const AddressesState();

  @override
  List<Object?> get props => [];
}

final class AddressesInitial extends AddressesState {}

// حالة تحميل العناوين بنجاح (تحمل القائمة معها)
final class AddressesLoaded extends AddressesState {
  final List<Map<String, dynamic>> addresses;

  const AddressesLoaded({required this.addresses});

  @override
  List<Object?> get props => [addresses]; // لمراقبة أي تغيير في القائمة وإعادة الرسم
}
