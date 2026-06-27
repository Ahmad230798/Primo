import 'package:flutter/material.dart';
import 'package:flutter_screenutil_plus/flutter_screenutil_plus.dart';
import 'package:primo/core/utils/appcolor/app_colors.dart';
import 'package:primo/core/utils/apptextstyle/app_text_style.dart';

import '../widgets/request_product_section.dart';
import '../widgets/search_filter_chips.dart';
import '../widgets/user_product_card.dart';

class SearchResultsScreen extends StatelessWidget {
  const SearchResultsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: Column(
          children: [
            // 1. شريط البحث العلوي (Header)
            Container(
              padding: EdgeInsets.symmetric(horizontal: 24.w, vertical: 12.h),
              decoration: BoxDecoration(color: AppColors.background),
              child: Row(
                children: [
                  // سهم الرجوع
                  InkWell(
                    onTap: () => Navigator.pop(context),
                    borderRadius: BorderRadius.circular(99.r),
                    child: Padding(
                      padding: EdgeInsets.all(4.w),
                      child: Icon(
                        Icons
                            .arrow_forward_rounded, // سهم لليمين لأن التطبيق RTL
                        color: AppColors.greyDark,
                        size: 26.sp,
                      ),
                    ),
                  ),
                  12.horizontalSpace,
                  // حقل البحث
                  Expanded(
                    child: Container(
                      height: 48.h,
                      decoration: BoxDecoration(
                        color: AppColors.white,
                        borderRadius: BorderRadius.circular(12.r),
                        border: Border.all(color: AppColors.formBorder),
                      ),
                      child: Row(
                        children: [
                          Expanded(
                            child: TextField(
                              controller: TextEditingController(
                                text: "شوكولاتة داكنة",
                              ),
                              style: AppTextStyle.font14.copyWith(
                                color: AppColors.textMain,
                                fontWeight: FontWeight.w600,
                              ),
                              decoration: InputDecoration(
                                border: InputBorder.none,
                                contentPadding: EdgeInsets.symmetric(
                                  horizontal: 16.w,
                                ),
                                isDense: true,
                              ),
                            ),
                          ),
                          // زر مسح النص (X)
                          InkWell(
                            onTap: () {},
                            child: Padding(
                              padding: EdgeInsets.symmetric(horizontal: 12.w),
                              child: Icon(
                                Icons.close_rounded,
                                color: AppColors.greyMedium3,
                                size: 20.sp,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),

            // 2. محتوى الصفحة القابل للتمرير
            Expanded(
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    // شريط الفلاتر (الكل، الأعلى تقييماً...)
                    const SearchFilterChips(),
                    16.verticalSpace,

                    // شبكة المنتجات (Grid)
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: 24.w),
                      child: GridView.builder(
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        itemCount: _dummyProducts.length,
                        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 2,
                          crossAxisSpacing: 16.w,
                          mainAxisSpacing: 16.h,
                          childAspectRatio:
                              0.65, // لضمان ظهور الكارد بشكل طولي مريح
                        ),
                        itemBuilder: (context, index) {
                          final product = _dummyProducts[index];
                          return UserProductCard(
                            title: product['title'],
                            weight: product['weight'],
                            price: product['price'],
                            imageUrl: product['image'],
                            isFavorite: product['isFavorite'],
                            isOutOfStock: product['isOutOfStock'],
                          );
                        },
                      ),
                    ),
                    32.verticalSpace,

                    // قسم "لم تجد ما تبحث عنه؟"
                    const RequestProductSection(),
                    40.verticalSpace, // مساحة سفلية
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// بيانات وهمية للاختبار مطابقة للصور
final List<Map<String, dynamic>> _dummyProducts = [
  {
    "title": "شوكولاتة داكنة باللوز وملح البحر",
    "weight": "120 جرام",
    "price": "32.00",
    "image":
        "https://lh3.googleusercontent.com/aida-public/AB6AXuAO_bU1Ut4Nu165E56mDZDtLa_EKPc5TLJLN9gWW3o2awkG_je2Pl9zSTLh6YnvoEY0uqBiZLpcaZFaH4GUJxxj0Fc5qWm39H6lcKAu7ayVVRWNC_qNQH5JRUXxLw7vhukdNVIUbtdYEF59E8BS8u6LLwPnV5KfpajJL-a-kyzVbDLOldfmM_YWH4TNbTYj7Yh7uInfPY9zFUjj1J2Hfzjkupr3qjEqRyee1Vwm-T_ZxY73ZsWPpt3nmewykq1_HSXrn7ItEm8WaJk3",
    "isFavorite": false,
    "isOutOfStock": false,
  },
  {
    "title": "شوكولاتة داكنة 85% كاكاو بريميوم",
    "weight": "100 جرام",
    "price": "24.50",
    "image":
        "https://lh3.googleusercontent.com/aida-public/AB6AXuDxMRZ2iWKvhFChgxSEDY4-BOzBtQ2q2kF91aapcKxMSQldbbpCcnrT55opR7HUMBvSF8bGS_0DS4pazdqYU7fbQMlihxvAX7YKw_t69GKRqG5247PSMUmLC5lW-ohx6rPSRH50Zk8PMh3niyn-utss-3DMWNdvMvRPFfKBuBfTTOkFN5Fv6u-WPrDLsPCBVEdBCRQaBEbUKEqxD_T2ChWBKsf8kX4hJzG7Hphd7_uM9HByrKMYy7KCYm-s2LE-18YlXg9jZZ-gCcxl",
    "isFavorite": false,
    "isOutOfStock": false,
  },
  {
    "title": "شوكولاتة داكنة نباتية بلمسة البرتقال",
    "weight": "80 جرام",
    "price": "28.75",
    "image":
        "https://lh3.googleusercontent.com/aida-public/AB6AXuCwv06jO4O3NsBK-nG0uOugwnx0C1H1ARNgARAmqh5H66OTnLkZjRFvJQXoSqoGYH4qm0faFak7OXNM9xiwMyg6XQx39fx4xfMxqx3jElVhkx4fAP1vM17ba0bX6D8vb9CjfJqFYTWkWaaoc-h4QR2i-CyWSvQe5_tU8ybLBzrKv3CGCL8ewslmiE5W8MyIJptmhAJ0lpkZj4OnGGHdHwmboWn6BnjFXmW_QWZ78HiNQRzLPh7S1HbGvEudI4QeoOXnBQySEvUiSMCi",
    "isFavorite": false,
    "isOutOfStock": false,
  },
  {
    "title": "ترافل الشوكولاتة الداكنة الكلاسيكية",
    "weight": "150 جرام",
    "price": "45.00",
    "image":
        "https://lh3.googleusercontent.com/aida-public/AB6AXuAgOkwm8SxJXxv1Szeabu55kKGZT9uG7MsAI0uMGVoBNp-JmkfJ1rMzfA7Vb1VslKFxWKDWlrvl2asjN4lxchQ3d0bMPRX794ddsVxvigGKdqEg3aN8TlBkFP0arPgG8WkVUQm_CPKCZ5FbvuM3tqhkwpvGcptA5ormEiMRixqBpFqyuynKbXzsTc56TKxuWddNHInVLFFh82Hvl9a0Wah8czlsNHmgjrc81J5m4Y5d_8Uw7NNRDOo_Do0E-7ZRp5Zmax3S5LwiqK3S",
    "isFavorite": true,
    "isOutOfStock": true,
  },
];
