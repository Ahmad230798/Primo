import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:primo/feature/admin_home/data/models/admin_dashboard_model.dart';
import '../../domain/usecases/get_admin_suggestions_usecase.dart';
import '../../domain/usecases/update_suggestion_status_usecase.dart';
import 'admin_suggestions_state.dart';

class AdminSuggestionsCubit extends Cubit<AdminSuggestionsState> {
  final GetAdminSuggestionsUseCase _getSuggestionsUseCase;
  final UpdateSuggestionStatusUseCase _updateStatusUseCase;

  AdminSuggestionsCubit(this._getSuggestionsUseCase, this._updateStatusUseCase)
    : super(AdminSuggestionsInitial());

  List<SuggestionModel> allSuggestions = [];
  String currentTab = 'new';

  Future<void> getSuggestions() async {
    emit(AdminSuggestionsLoading());
    final result = await _getSuggestionsUseCase();
    result.fold(
      (failure) {
        if (!isClosed) emit(AdminSuggestionsError(failure.errorMessage));
      },
      (list) {
        allSuggestions = list;
        // 💡 تحديث: عند جلب البيانات، نطبق الفلتر الحالي فوراً بدل إرسال القائمة كاملة
        if (!isClosed) filterSuggestions(currentTab);
      },
    );
  }

  void filterSuggestions(String tab) {
    currentTab = tab;

    // 💡 1. إنشاء قائمة مؤقتة للفلترة
    List<SuggestionModel> filteredList = [];

    // 💡 2. منطق التصفية بناءً على الـ status القادم من السيرفر والـ key الخاص بالـ Tabs
    if (tab == 'new') {
      // التبويب "الجديدة" يطابق الحالة "pending" أو null أو empty في الـ JSON
      filteredList = allSuggestions
          .where((item) => item.status == 'pending' || item.status == null || item.status!.trim().isEmpty)
          .toList();
    } else if (tab == 'approved') {
      // التبويب "المقبولة" يطابق الحالة "approved" في الـ JSON
      filteredList = allSuggestions
          .where((item) => item.status == 'approved')
          .toList();
    } else if (tab == 'rejected') {
      // التبويب "المرفوضة" يطابق الحالة "rejected" في الـ JSON
      filteredList = allSuggestions
          .where((item) => item.status == 'rejected')
          .toList();
    } else {
      filteredList = List.from(allSuggestions);
    }

    // 💡 3. إرسال القائمة المفلترة (filteredList) بدلاً من القائمة الكاملة
    if (!isClosed) {
      emit(AdminSuggestionsLoaded(filteredList, currentTab: currentTab));
    }
  }

  Future<void> updateStatus(int id, String status) async {
    emit(AdminSuggestionUpdating(id));
    final result = await _updateStatusUseCase(id, status);

    result.fold(
      (failure) {
        if (!isClosed) {
          emit(AdminSuggestionsError(failure.errorMessage));
          // 💡 نطبق الفلتر لتعود الشاشة لحالتها الطبيعية في حال الفشل
          filterSuggestions(currentTab);
        }
      },
      (msg) {
        // 💡 1. بدلاً من الحذف، نقوم بتحديث حالة المقترح محلياً (لكي يظهر في التبويب الآخر)
        final index = allSuggestions.indexWhere((item) => item.id == id);
        if (index != -1) {
          final oldItem = allSuggestions[index];
          // نقوم باستبدال العنصر القديم بنسخة محدثة تحمل الحالة الجديدة (approved أو rejected)
          // ملاحظة: إذا كان لديك دالة copyWith في المودل استخدمها، أو اكتب المتغيرات هكذا:
          allSuggestions[index] = SuggestionModel(
            id: oldItem.id,
            name: oldItem.name,
            description: oldItem.description,
            status: status, // الحالة الجديدة القادمة من الزر
            createdAt: oldItem.createdAt,
            user: oldItem.user,
          );
        }

        if (!isClosed) {
          emit(AdminSuggestionStatusSuccess(msg));

          // 💡 2. هنا السحر: نستدعي الفلتر!
          // إذا كنا في تبويب "الجديدة"، سيختفي المقترح فوراً لأنه لم يعد pending
          // وإذا ذهبنا لتبويب "تم التوفير"، سنجده هناك دون الحاجة لجلبه من السيرفر!
          filterSuggestions(currentTab);

          // 💡 3. قمنا بحذف await getSuggestions() لأن التطبيق أصبح يعتمد على التحديث المحلي السريع جداً
        }
      },
    );
  }
}
