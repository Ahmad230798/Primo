import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:primo/feature/addresses/presentation/bloc/adresses_state.dart';

class AddressesCubit extends Cubit<AddressesState> {
  AddressesCubit() : super(AddressesInitial()) {
    // تحميل العناوين فور إنشاء الـ Cubit
    _loadAddresses();
  }

  // نقلنا البيانات الوهمية إلى هنا لتكون تحت إدارة الـ Cubit
  List<Map<String, dynamic>> _addresses = [
    {
      "id": "1",
      "title": "المنزل",
      "details":
          "شارع الملك فهد، حي العليا\nمبنى 45، شقة 12\nالرياض، المملكة العربية السعودية",
      "icon": Icons.home_filled,
      "isDefault": true,
    },
    {
      "id": "2",
      "title": "العمل",
      "details":
          "طريق التخصصي، برج العقيق\nالدور 8، مكتب 805\nالرياض، المملكة العربية السعودية",
      "icon": Icons.business_center_rounded,
      "isDefault": false,
    },
    {
      "id": "3",
      "title": "بيت العائلة",
      "details":
          "شارع خالد بن الوليد، حي الروضة\nفيلا 15\nالرياض، المملكة العربية السعودية",
      "icon": Icons.location_on_rounded,
      "isDefault": false,
    },
  ];

  void _loadAddresses() {
    emit(AddressesLoaded(addresses: _addresses));
  }

  // --- الدالة المسؤولة عن تغيير العنوان الافتراضي ---
  void setDefaultAddress(String selectedId) {
    // 1. إنشاء قائمة جديدة مع تحديث حالة الافتراضي
    _addresses = _addresses.map((address) {
      return {
        ...address, // نسخ باقي البيانات كما هي
        "isDefault":
            address["id"] == selectedId, // يصبح true فقط للـ ID المختار
      };
    }).toList();

    // 2. إرسال القائمة الجديدة للواجهة لتحديثها فوراً
    emit(AddressesLoaded(addresses: _addresses));
  }
}
