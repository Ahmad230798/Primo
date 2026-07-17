import 'dart:io';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';
import 'package:primo/core/models/user_model.dart';
import 'package:primo/core/network/app_storage.dart';
import 'package:primo/feature/auth/domain/usecases/delete_account_usecase.dart';
import 'package:primo/feature/auth/domain/usecases/log_out_usecase.dart';
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
  final LogoutUseCase _logoutUseCase; // 💡 2. أضف هذا السطر هنا

  UserModel? user;
  File? selectedAvatar;
  final ImagePicker _picker = ImagePicker();

  ProfileCubit(
    this._getProfileUseCase,
    this._updateProfileUseCase,
    this._changePasswordUseCase,
    this._deleteAccountUseCase,
    this._logoutUseCase,
  ) : super(ProfileInitial());

  Future<void> pickAvatar() async {
    final XFile? image = await _picker.pickImage(source: ImageSource.gallery);
    if (image != null) {
      selectedAvatar = File(image.path);
      if (!isClosed) emit(ProfileAvatarPicked(selectedAvatar!));
    }
  }

  Future<void> getProfile() async {
    if (!isClosed) emit(ProfileLoading());
    try {
      final response = await _getProfileUseCase.execute();

      response.fold(
        (failure) {
          if (!isClosed) emit(ProfileError(failure.errorMessage));
        },
        (data) {
          user = data.data;
          if (!isClosed) {
            if (user != null) {
              emit(ProfileLoaded(user!));
            } else {
              emit(const ProfileError("لم يتم العثور على بيانات المستخدم"));
            }
          }
        },
      );
    } catch (e) {
      if (!isClosed) emit(ProfileError(e.toString()));
    }
  }

  Future<void> updateProfile({
    required String name,
    String? phone,
    File? avatar,
  }) async {
    if (!isClosed) emit(UpdateProfileLoading());
    try {
      final body = UpdateProfileRequestBody(
        name: name,
        phone: phone,
        avatar: avatar ?? selectedAvatar,
      );
      final response = await _updateProfileUseCase.execute(body);
      response.fold((failure) {
        if (!isClosed) emit(UpdateProfileError(failure.errorMessage));
      }, (data) {
        if (data.data != null) {
          user = data.data;
          selectedAvatar = null;
          if (!isClosed) {
            emit(
              UpdateProfileSuccess(
                user!,
                data.message ?? "تم تحديث الملف الشخصي بنجاح",
              ),
            );
            emit(ProfileLoaded(user!));
          }
        } else {
          if (!isClosed) emit(const UpdateProfileError("فشل تحديث البيانات"));
        }
      });
    } catch (e) {
      if (!isClosed) emit(UpdateProfileError(e.toString()));
    }
  }

  Future<void> changePassword({
    required String currentPassword,
    required String newPassword,
    required String newPasswordConfirmation,
  }) async {
    if (newPassword != newPasswordConfirmation) {
      if (!isClosed) emit(const ChangePasswordError("كلمة المرور الجديدة غير متطابقة"));
      return;
    }
    if (!isClosed) emit(ChangePasswordLoading());
    try {
      final body = ChangePasswordRequestBody(
        currentPassword: currentPassword,
        newPassword: newPassword,
        newPasswordConfirmation: newPasswordConfirmation,
      );
      final response = await _changePasswordUseCase.execute(body);
      response.fold(
        (failure) {
          if (!isClosed) emit(ChangePasswordError(failure.errorMessage));
        },
        (message) {
          if (!isClosed) emit(ChangePasswordSuccess(message));
        },
      );
    } catch (e) {
      if (!isClosed) emit(ChangePasswordError(e.toString()));
    }
  }

  Future<void> deleteAccount() async {
    if (!isClosed) emit(DeleteAccountLoading());
    try {
      final response = await _deleteAccountUseCase.execute();
      response.fold((failure) {
        if (!isClosed) emit(DeleteAccountError(failure.errorMessage));
      }, (message) async {
        await AppStorage.clearAllData();
        if (!isClosed) emit(DeleteAccountSuccess(message));
      });
    } catch (e) {
      if (!isClosed) emit(DeleteAccountError(e.toString()));
    }
  }

  Future<void> logout() async {
    if (!isClosed) emit(LogoutLoading());
    try {
      final response = await _logoutUseCase.execute();

      response.fold(
        (failure) {
          if (!isClosed) emit(LogoutError(failure.errorMessage));
        },
        (message) async {
          await AppStorage.clearAllData();
          if (!isClosed) emit(LogoutSuccess(message));
        },
      );
    } catch (e) {
      if (!isClosed) emit(LogoutError(e.toString()));
    }
  }
}
