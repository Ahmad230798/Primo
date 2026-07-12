// // نافذة اختيار العنوان المنبثقة من الأسفل
// import 'package:flutter/material.dart';
// import 'package:flutter_screenutil_plus/flutter_screenutil_plus.dart';
// import 'package:primo/core/utils/appcolor/app_colors.dart';
// import 'package:primo/core/utils/apptextstyle/app_text_style.dart';

// class AddressSelectionSheet extends StatelessWidget {
//   const AddressSelectionSheet({super.key});

//   @override
//   Widget build(BuildContext context) {
//     // قائمة عناوين وهمية للتجربة
//     final List<Map<String, String>> savedAddresses = [
//       {"title": "المنزل", "details": "شارع الثورة, بناء رقم 12, الطابق 3"},
//       {"title": "العمل", "details": "المنطقة الصناعية, مبنى الشركة, مكتب 5"},
//     ];

//     return Container(
//       width: double.infinity,
//       padding: EdgeInsets.all(30),
//       decoration: const BoxDecoration(
//         color: Colors.white,
//         borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
//       ),
//       child: Column(
//         mainAxisSize: MainAxisSize.min, // لتأخذ مساحة العناصر التي بداخلها فقط
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: [
//           // عنوان النافذة
//           Row(
//             mainAxisAlignment: MainAxisAlignment.spaceBetween,
//             children: [
//               Text("اختر عنوان التوصيل", style: AppTextStyle.font20),
//               IconButton(
//                 icon: const Icon(Icons.close),
//                 onPressed: () => Navigator.pop(context),
//               ),
//             ],
//           ),
//           16.verticalSpace,

//           // قائمة العناوين المحفوظة
//           ListView.separated(
//             shrinkWrap: true,
//             physics: const NeverScrollableScrollPhysics(),
//             itemCount: savedAddresses.length,
//             separatorBuilder: (context, index) =>
//                 Divider(color: AppColors.formBorder),
//             itemBuilder: (context, index) {
//               return ListTile(
//                 contentPadding: EdgeInsets.zero,
//                 leading: Icon(
//                   Icons.location_on,
//                   color: AppColors.greyMedium1,
//                   size: 28.sp,
//                 ),
//                 title: Text(
//                   savedAddresses[index]["title"]!,
//                   style: AppTextStyle.font14.copyWith(
//                     fontWeight: FontWeight.bold,
//                   ),
//                 ),
//                 subtitle: Text(
//                   savedAddresses[index]["details"]!,
//                   style: AppTextStyle.font14.copyWith(
//                     color: AppColors.greyMedium2,
//                   ),
//                 ),
//                 trailing: Radio<int>(
//                   value: index,
//                   groupValue: 0, // هنا سنربطها لاحقاً بمتغير الحالة المختار
//                   onChanged: (value) {
//                     //  تحديث العنوان المختار ثم إغلاق النافذة
//                     Navigator.pop(context);
//                   },
//                   activeColor: Colors.red,
//                 ),
//                 onTap: () {
//                   // نفس عمل الـ Radio
//                   Navigator.pop(context);
//                 },
//               );
//             },
//           ),

//           24.verticalSpace,

//           // زر إضافة عنوان جديد
//           SizedBox(
//             width: double.infinity,
//             child: OutlinedButton.icon(
//               onPressed: () {
//                 Navigator.pop(context); // إغلاق النافذة الحالية
//                 //  توجيه المستخدم لشاشة الخريطة (Google Maps) لإضافة عنوان
//               },
//               icon: const Icon(
//                 Icons.add_location_alt_outlined,
//                 color: Colors.red,
//               ),
//               label: Text(
//                 "إضافة عنوان جديد",
//                 style: AppTextStyle.font14.copyWith(
//                   color: Colors.red,
//                   fontWeight: FontWeight.bold,
//                 ),
//               ),
//               style: OutlinedButton.styleFrom(
//                 padding: EdgeInsets.symmetric(vertical: 14.h),
//                 side: const BorderSide(color: Colors.red), // إطار أحمر
//                 shape: RoundedRectangleBorder(
//                   borderRadius: BorderRadius.circular(12),
//                 ),
//               ),
//             ),
//           ),
//           16.verticalSpace, // مسافة أمان من الأسفل
//         ],
//       ),
//     );
//   }
// }
