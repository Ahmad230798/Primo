import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:primo/core/network/api_consumer.dart';
import 'package:primo/core/network/api_constant.dart';
import 'package:primo/feature/profile/data/models/help_center_model.dart';
import 'help_center_state.dart';

class HelpCenterCubit extends Cubit<HelpCenterState> {
  final ApiConsumer _apiConsumer;

  HelpCenterCubit(this._apiConsumer) : super(HelpCenterInitial());

  Future<void> getHelpCenterData() async {
    emit(HelpCenterLoading());
    try {
      final response = await _apiConsumer.get(path: ApiConstant.userGeneralSettings);
      if (response is Map<String, dynamic>) {
        final model = HelpCenterModel.fromJson(response);
        emit(HelpCenterLoaded(model));
      } else {
        emit(const HelpCenterLoaded(HelpCenterModel(
          supportPhone: '',
          managerPhone: '',
          facebookAccount: '',
          workingHours: '',
          address: '',
        )));
      }
    } catch (e) {
      emit(const HelpCenterLoaded(HelpCenterModel(
        supportPhone: '',
        managerPhone: '',
        facebookAccount: '',
        workingHours: '',
        address: '',
      )));
    }
  }
}
