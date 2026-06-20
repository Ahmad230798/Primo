// import 'package:flutter/material.dart';
// import 'package:flutter_screenutil_plus/flutter_screenutil_plus.dart';
// import 'package:primo/core/utils/appcolor/app_colors.dart';
// import 'package:primo/core/utils/apptextstyle/app_text_style.dart';
// import 'package:primo/core/widgets/app_button.dart';
// import 'package:primo/core/widgets/custom_app_bar.dart';
// import 'package:primo/feature/orders/presentation/widgets/adress_selection.dart';

// class CheckoutPage extends StatefulWidget {
//   const CheckoutPage({super.key});

//   @override
//   State<CheckoutPage> createState() => _CheckoutPageState();
// }

// class _CheckoutPageState extends State<CheckoutPage> {
//   // متغيرات لإدارة حالة الواجهة (UI State) مؤقتاً
//   int selectedDeliveryType = 0; // 0: توصيل للمنزل, 1: استلام من الفرع
//   int selectedPaymentMethod = 0; // 0: الدفع عند الاستلام, 1: بطاقة ائتمانية

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: AppColors.white, // أو لون الخلفية الأساسي لتطبيقك
//       body: SafeArea(
//         child: SingleChildScrollView(
//           // هنا فعلنا التمرير لأن صفحة الدفع قد تكون طويلة
//           physics: const BouncingScrollPhysics(),
//           child: Padding(
//             padding: EdgeInsets.symmetric(horizontal: 24.w),
//             child: Column(
//               crossAxisAlignment: CrossAxisAlignment.start,
//               children: [
//                 16.verticalSpace,
//                 const CustomAppBar(
//                   title: "إتمام الطلب",
//                   // يمكنك إضافة أيقونة الرجوع هنا إذا كان الـ CustomAppBar يدعمها
//                 ),
//                 32.verticalSpace,

//                 // --- 1. نوع الطلب (توصيل / استلام) ---
//                 Text("نوع الطلب", style: AppTextStyle.font20),
//                 16.verticalSpace,
//                 Row(
//                   children: [
//                     Expanded(
//                       child: _buildSelectionCard(
//                         title: "توصيل للمنزل",
//                         icon: Icons.local_shipping_outlined,
//                         isSelected: selectedDeliveryType == 0,
//                         onTap: () => setState(() => selectedDeliveryType = 0),
//                       ),
//                     ),
//                     12.horizontalSpace,
//                     Expanded(
//                       child: _buildSelectionCard(
//                         title: "استلام من الفرع",
//                         icon: Icons.storefront_outlined,
//                         isSelected: selectedDeliveryType == 1,
//                         onTap: () => setState(() => selectedDeliveryType = 1),
//                       ),
//                     ),
//                   ],
//                 ),
//                 32.verticalSpace,

//                 // --- 2. عنوان التوصيل (يظهر فقط إذا اختار المستخدم "توصيل") ---
//                 if (selectedDeliveryType == 0) ...[
//                   Row(
//                     mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                     children: [
//                       Text("عنوان التوصيل", style: AppTextStyle.font20),
//                       TextButton(
//                         onPressed: () {
//                           showModalBottomSheet(
//                             context: context,
//                             isScrollControlled:
//                                 true, // مهم جداً ليأخذ الارتفاع المناسب
//                             backgroundColor: Colors
//                                 .transparent, // لجعل الحواف العلوية الدائرية تظهر بشكل صحيح
//                             builder: (context) {
//                               return const AddressSelectionSheet(); // استدعاء الويدجت الذي صنعناه
//                             },
//                           );
//                           // TODO: فتح نافذة تغيير العنوان
//                         },
//                         child: Text(
//                           "تغيير",
//                           style: AppTextStyle.font14.copyWith(
//                             color: Colors.blue, // أو AppColors.primary
//                             fontWeight: FontWeight.bold,
//                           ),
//                         ),
//                       ),
//                     ],
//                   ),
//                   8.verticalSpace,
//                   Container(
//                     padding: EdgeInsets.all(16.w),
//                     decoration: BoxDecoration(
//                       color: AppColors.formBorder.withOpacity(0.5),
//                       borderRadius: BorderRadius.circular(12),
//                     ),
//                     child: Row(
//                       children: [
//                         Icon(
//                           Icons.location_on,
//                           color: AppColors.greyMedium1,
//                           size: 28.sp,
//                         ),
//                         12.horizontalSpace,
//                         Expanded(
//                           child: Column(
//                             crossAxisAlignment: CrossAxisAlignment.start,
//                             children: [
//                               Text(
//                                 "المنزل",
//                                 style: AppTextStyle.font14.copyWith(
//                                   fontWeight: FontWeight.bold,
//                                 ),
//                               ),
//                               4.verticalSpace,
//                               Text(
//                                 "شارع الثورة, بناء رقم 12, الطابق 3",
//                                 style: AppTextStyle.font14.copyWith(
//                                   color: AppColors.greyMedium2,
//                                 ),
//                               ),
//                             ],
//                           ),
//                         ),
//                       ],
//                     ),
//                   ),
//                   32.verticalSpace,
//                 ],

//                 // --- 3. طريقة الدفع ---
//                 Text("طريقة الدفع", style: AppTextStyle.font20),
//                 16.verticalSpace,
//                 _buildPaymentMethodTile(
//                   title: "الدفع عند الاستلام",
//                   icon: Icons.money,
//                   value: 0,
//                   groupValue: selectedPaymentMethod,
//                   onChanged: (val) =>
//                       setState(() => selectedPaymentMethod = val!),
//                 ),
//                 8.verticalSpace,
//                 _buildPaymentMethodTile(
//                   title: "بطاقة ائتمانية",
//                   icon: Icons.credit_card,
//                   value: 1,
//                   groupValue: selectedPaymentMethod,
//                   onChanged: (val) =>
//                       setState(() => selectedPaymentMethod = val!),
//                 ),
//                 32.verticalSpace,

//                 // --- 4. ملخص الطلب ---
//                 Text("ملخص الطلب", style: AppTextStyle.font20),
//                 16.verticalSpace,
//                 Container(
//                   padding: EdgeInsets.all(16.w),
//                   decoration: BoxDecoration(
//                     border: Border.all(color: AppColors.formBorder),
//                     borderRadius: BorderRadius.circular(12),
//                   ),
//                   child: Column(
//                     children: [
//                       _buildSummaryRow("المجموع الفرعي", "255.00 ل.س"),
//                       12.verticalSpace,
//                       _buildSummaryRow(
//                         "رسوم التوصيل",
//                         selectedDeliveryType == 0 ? "15.00 ل.س" : "مجاناً",
//                       ),
//                       12.verticalSpace,
//                       const Divider(),
//                       12.verticalSpace,
//                       _buildSummaryRow(
//                         "الإجمالي",
//                         selectedDeliveryType == 0 ? "270.00 ل.س" : "255.00 ل.س",
//                         isTotal: true,
//                       ),
//                     ],
//                   ),
//                 ),
//                 32.verticalSpace,

//                 // --- 5. زر التأكيد ---
//                 AppButton(
//                   text: "تأكيد الطلب",
//                   icon: Icons.check_circle_outline,
//                   // سيتم ربط هذا الزر لاحقاً بـ CheckoutBloc
//                   // onPressed: () {},
//                 ),
//                 32.verticalSpace, // مسافة أمان أسفل الشاشة
//               ],
//             ),
//           ),
//         ),
//       ),
//     );
//   }

//   // ---------------- الويدجتس المساعدة (Helper Widgets) ----------------

//   // بطاقة اختيار نوع التوصيل
//   Widget _buildSelectionCard({
//     required String title,
//     required IconData icon,
//     required bool isSelected,
//     required VoidCallback onTap,
//   }) {
//     return GestureDetector(
//       onTap: onTap,
//       child: AnimatedContainer(
//         duration: const Duration(milliseconds: 200),
//         padding: EdgeInsets.symmetric(vertical: 16.h),
//         decoration: BoxDecoration(
//           color: isSelected
//               ? Colors.red.withOpacity(0.1)
//               : AppColors.formBorder.withOpacity(
//                   0.5,
//                 ), // استبدل اللون الأحمر بلون التطبيق الأساسي
//           borderRadius: BorderRadius.circular(12),
//           border: Border.all(
//             color: isSelected
//                 ? Colors.red
//                 : Colors
//                       .transparent, // استبدل اللون الأحمر بلون التطبيق الأساسي
//             width: 1.5,
//           ),
//         ),
//         child: Column(
//           children: [
//             Icon(
//               icon,
//               color: isSelected ? Colors.red : AppColors.greyMedium1,
//               size: 28.sp,
//             ),
//             8.verticalSpace,
//             Text(
//               title,
//               style: AppTextStyle.font14.copyWith(
//                 fontWeight: isSelected ? FontWeight.bold : FontWeight.w500,
//                 color: isSelected ? Colors.red : AppColors.greyMedium2,
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }

//   // عنصر طريقة الدفع
//   Widget _buildPaymentMethodTile({
//     required String title,
//     required IconData icon,
//     required int value,
//     required int groupValue,
//     required ValueChanged<int?> onChanged,
//   }) {
//     bool isSelected = value == groupValue;
//     return GestureDetector(
//       onTap: () => onChanged(value),
//       child: Container(
//         padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
//         decoration: BoxDecoration(
//           border: Border.all(
//             color: isSelected ? Colors.red : AppColors.formBorder,
//           ), // استبدل اللون الأحمر
//           borderRadius: BorderRadius.circular(12),
//           color: isSelected ? Colors.red.withOpacity(0.05) : Colors.transparent,
//         ),
//         child: Row(
//           children: [
//             Icon(
//               icon,
//               color: isSelected ? Colors.red : AppColors.greyMedium1,
//               size: 24.sp,
//             ),
//             12.horizontalSpace,
//             Text(
//               title,
//               style: AppTextStyle.font14.copyWith(
//                 fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
//                 color: isSelected ? Colors.black : AppColors.greyMedium2,
//               ),
//             ),
//             const Spacer(),
//             Radio<int>(
//               value: value,
//               groupValue: groupValue,
//               onChanged: onChanged,
//               activeColor: Colors.red, // استبدل اللون الأحمر
//             ),
//           ],
//         ),
//       ),
//     );
//   }

//   // سطر ملخص الفاتورة
//   Widget _buildSummaryRow(String title, String value, {bool isTotal = false}) {
//     return Row(
//       mainAxisAlignment: MainAxisAlignment.spaceBetween,
//       children: [
//         Text(
//           title,
//           style: isTotal
//               ? AppTextStyle.font20.copyWith(fontWeight: FontWeight.bold)
//               : AppTextStyle.font14.copyWith(color: AppColors.greyMedium2),
//         ),
//         Text(
//           value,
//           style: isTotal
//               ? AppTextStyle.font20.copyWith(
//                   fontWeight: FontWeight.bold,
//                   color: Colors.red,
//                 ) // استبدل اللون الأحمر
//               : AppTextStyle.font14.copyWith(fontWeight: FontWeight.bold),
//         ),
//       ],
//     );
//   }
// }
