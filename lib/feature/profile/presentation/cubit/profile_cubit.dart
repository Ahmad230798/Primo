import 'dart:io';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';
import 'package:primo/core/models/user_model.dart';
import 'package:primo/core/network/app_storage.dart';
import 'package:primo/feature/auth/domain/usecases/delete_account_usecase.dart';
import '../../data/models/update_profile_request_body.dart';
import '../../data/models/change_password_request_body.dart';
import '../../domain/usecases/get_profile_usecase.dart';
import '../../domain/usecases/update_profile_usecase.dart';
import '../../domain/usecases/change_password_usecase.dart';
import 'profile_state.dart';

class ProfileCubit extends Cubit<ProfileState> {
  final GetProfileUseCase _getProfileUseCase;
  final UpdateProfileUseCase _updateProfileUseCase;
  final ChangePasswordUseCase _changePasswordUseCase;
  final DeleteAccountUseCase _deleteAccountUseCase;

  UserModel? user;
  File? selectedAvatar;
  final ImagePicker _picker = ImagePicker();

  ProfileCubit(
    this._getProfileUseCase,
    this._updateProfileUseCase,
    this._changePasswordUseCase,
    this._deleteAccountUseCase,
  ) : super(ProfileInitial());

  Future<void> pickAvatar() async {
    final XFile? image = await _picker.pickImage(source: ImageSource.gallery);
    if (image != null) {
      selectedAvatar = File(image.path);
      emit(ProfileAvatarPicked(selectedAvatar!));
    }
  }

  Future<void> getProfile() async {
    emit(ProfileLoading());
    final response = await _getProfileUseCase.execute();
    response.fold(
      (failure) => emit(ProfileError(failure.errorMessage)),
      (data) {
        user = data.data;
        if (user != null) {
          emit(ProfileLoaded(user!));
        } else {
          emit(const ProfileError("لم يتم العثور على بيانات المستخدم"));
        }
      },
    );
  }

  Future<void> updateProfile({
    required String name,
    String? phone,
    File? avatar,
  }) async {
    emit(UpdateProfileLoading());
    final body = UpdateProfileRequestBody(
      name: name,
      phone: phone,
      avatar: avatar ?? selectedAvatar,
    );
    final response = await _updateProfileUseCase.execute(body);
    response.fold(
      (failure) => emit(UpdateProfileError(failure.errorMessage)),
      (data) {
        if (data.data != null) {
          user = data.data;
          selectedAvatar = null;
          emit(UpdateProfileSuccess(user!, data.message ?? "تم تحديث الملف الشخصي بنجاح"));
          emit(ProfileLoaded(user!));
        } else {
          emit(const UpdateProfileError("فشل تحديث البيانات"));
        }
      },
    );
  }

  Future<void> changePassword({
    required String currentPassword,
    required String newPassword,
    required String newPasswordConfirmation,
  }) async {
    if (newPassword != newPasswordConfirmation) {
      emit(const ChangePasswordError("كلمة المرور الجديدة غير متطابقة"));
      return;
    }
    emit(ChangePasswordLoading());
    final body = ChangePasswordRequestBody(
      currentPassword: currentPassword,
      newPassword: newPassword,
      newPasswordConfirmation: newPasswordConfirmation,
    );
    final response = await _changePasswordUseCase.execute(body);
    response.fold(
      (failure) => emit(ChangePasswordError(failure.errorMessage)),
      (message) => emit(ChangePasswordSuccess(message)),
    );
  }

  Future<void> deleteAccount() async {
    emit(DeleteAccountLoading());
    final response = await _deleteAccountUseCase.execute();
    response.fold(
      (failure) => emit(DeleteAccountError(failure.errorMessage)),
      (message) async {
        await AppStorage.clearAllData();
        emit(DeleteAccountSuccess(message));
      },
    );
  }
}
