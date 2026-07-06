import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil_plus/flutter_screenutil_plus.dart';
import 'package:primo/core/utils/appcolor/app_colors.dart';
import 'package:primo/core/utils/apptextstyle/app_text_style.dart';
import 'package:primo/core/widgets/app_button.dart';
import 'package:primo/core/widgets/app_text_form_field.dart';
import 'package:primo/core/widgets/custom_app_bar.dart';
import 'package:primo/feature/suggestions/presentation/cubit/suggestions_cubit.dart';
import 'package:primo/feature/suggestions/presentation/cubit/suggestions_state.dart';

class SuggestProductPage extends StatefulWidget {
  const SuggestProductPage({super.key});

  @override
  State<SuggestProductPage> createState() => _SuggestProductPageState();
}

class _SuggestProductPageState extends State<SuggestProductPage> {
  final TextEditingController productNameController = TextEditingController();
  final TextEditingController productDetailsController = TextEditingController();

  @override
  void dispose() {
    productNameController.dispose();
    productDetailsController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: BlocConsumer<SuggestionsCubit, SuggestionsState>(
          listener: (context, state) {
            if (state is SuggestionsSuccess) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(state.message),
                  backgroundColor: Colors.green,
                  behavior: SnackBarBehavior.floating,
                ),
              );
              productNameController.clear();
              productDetailsController.clear();
              Navigator.pop(context);
            } else if (state is SuggestionsError) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(state.message),
                  backgroundColor: Colors.red,
                  behavior: SnackBarBehavior.floating,
                ),
              );
            }
          },
          builder: (context, state) {
            final isSubmitting = state is SuggestionsSubmitting;

            return Column(
              children: [
                // --- 1. الـ AppBar المخصص حسب هويتك البصرية ---
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 24.w),
                  child: CustomAppBar(
                    title: "اقترح منتجاً",
                    showRightIcon: true,
                    // عرض كلمة Primo باللون الأحمر جهة اليسار كما في الصورة
                    icon: Padding(
                      padding: EdgeInsets.symmetric(horizontal: 8.w),
                      child: Text(
                        "Primo",
                        style: AppTextStyle.font18.copyWith(
                          fontWeight: FontWeight.bold,
                          color: AppColors.primary,
                        ),
                      ),
                    ),
                  ),
                ),

                // --- 2. محتوى الصفحة القابل للتمرير الحامي من الكيبورد ---
                Expanded(
                  child: SingleChildScrollView(
                    physics: const BouncingScrollPhysics(),
                    padding: EdgeInsets.symmetric(horizontal: 24.w),
                    child: Column(
                      children: [
                        24.verticalSpace,

                        // الجزء البصري: السلة واللمبة (Illustration Container)
                        Container(
                          width: 192.w,
                          height: 192.h,
                          decoration: BoxDecoration(
                            color: AppColors.white,
                            borderRadius: BorderRadius.circular(32.r),
                            border: Border.all(color: AppColors.formBorder),
                            image: const DecorationImage(
                              image: AssetImage("assets/images/suggest.png"),
                            ),
                          ),
                        ),
                        24.verticalSpace,

                        // النصوص التوضيحية
                        Text(
                          "لم تجد منتجك المفضل؟",
                          style: AppTextStyle.font16.copyWith(
                            fontWeight: FontWeight.w400,
                            color: AppColors.textMain,
                            height: 24 / 16,
                          ),
                          textAlign: TextAlign.center,
                        ),
                        8.verticalSpace,
                        Text(
                          "اكتب لنا اسم المنتج الذي تبحث عنه، وسيقوم فريق Primo بتوفيره لك في أقرب وقت.",
                          style: AppTextStyle.font16.copyWith(
                            color: AppColors.greyMedium3,
                            height: 24 / 16,
                          ),
                          textAlign: TextAlign.center,
                        ),
                        32.verticalSpace,

                        // حقل إدخال اسم المنتج (مطلوب)
                        AppTextFormField(
                          controller: productNameController,
                          hinttText: "اسم المنتج (مطلوب)",
                          borderWidth: 0,
                          focusColor: AppColors.white,
                          isFilled: true,
                          fillColor: AppColors.white,
                        ),
                        16.verticalSpace,

                        // حقل إدخال التفاصيل الإضافية (اختياري) - متعدد الأسطر
                        AppTextFormField(
                          controller: productDetailsController,
                          hinttText: "تفاصيل إضافية كالوزن أو النكهة (اختياري)",
                          linesCount: 4, // يعطيه ارتفاعاً أكبر يشبه التصميم تماماً
                          borderWidth: 0,
                          focusColor: AppColors.white,
                          isFilled: true,
                          fillColor: AppColors.white,
                        ),
                        32.verticalSpace,
                      ],
                    ),
                  ),
                ),

                // --- 3. زر الإرسال الثابت في الأسفل ---
                Container(
                  padding: EdgeInsets.only(
                    left: 24.w,
                    right: 24.w,
                    bottom: 24.h,
                    top: 16.h,
                  ),
                  color: AppColors.background,
                  child: AppButton(
                    text: "إرسال الاقتراح",
                    isIconExist: false,
                    isLoading: isSubmitting,
                    onPressed: isSubmitting
                        ? null
                        : () {
                            context.read<SuggestionsCubit>().sendSuggestion(
                                  name: productNameController.text,
                                  description: productDetailsController.text,
                                );
                          },
                  ),
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}
