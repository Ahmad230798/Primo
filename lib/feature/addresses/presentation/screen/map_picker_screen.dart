import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import 'package:geolocator/geolocator.dart';
import 'package:flutter_screenutil_plus/flutter_screenutil_plus.dart';
import 'package:primo/core/utils/appcolor/app_colors.dart';
import 'package:primo/core/utils/apptextstyle/app_text_style.dart';
import 'package:primo/core/widgets/app_button.dart';
import 'package:primo/core/widgets/custom_app_bar.dart';

class MapPickerScreen extends StatefulWidget {
  final double initialLat;
  final double initialLng;

  const MapPickerScreen({
    super.key,
    this.initialLat = 34.7706, // الحواش كمركز افتراضي
    this.initialLng = 36.3206,
  });

  @override
  State<MapPickerScreen> createState() => _MapPickerScreenState();
}

class _MapPickerScreenState extends State<MapPickerScreen> {
  final MapController _mapController = MapController();
  late LatLng _currentPosition;
  bool _isLoadingLocation = false;

  @override
  void initState() {
    super.initState();
    _currentPosition = LatLng(widget.initialLat, widget.initialLng);
    _checkAndGetCurrentLocation();
  }

  Future<void> _checkAndGetCurrentLocation() async {
    setState(() => _isLoadingLocation = true);
    try {
      bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
      if (!serviceEnabled) {
        setState(() => _isLoadingLocation = false);
        return;
      }

      LocationPermission permission = await Geolocator.checkPermission();
      if (permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();
        if (permission == LocationPermission.denied) {
          setState(() => _isLoadingLocation = false);
          return;
        }
      }

      if (permission == LocationPermission.deniedForever) {
        setState(() => _isLoadingLocation = false);
        return;
      }

      Position position = await Geolocator.getCurrentPosition(
        locationSettings: const LocationSettings(
          accuracy: LocationAccuracy.high,
        ),
      );

      if (mounted) {
        setState(() {
          _currentPosition = LatLng(position.latitude, position.longitude);
          _isLoadingLocation = false;
        });
        _mapController.move(_currentPosition, 15.0); // تحريك الكاميرا لموقعك
      }
    } catch (e) {
      if (mounted) {
        setState(() => _isLoadingLocation = false);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: Column(
          children: [
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h),
              child: CustomAppBar(
                title: "تحديد الموقع على الخريطة",
                onBackTap: () => Navigator.pop(context),
              ),
            ),
            Expanded(
              child: Stack(
                children: [
                  // --- الخريطة المجانية (OpenStreetMap) ---
                  FlutterMap(
                    mapController: _mapController,
                    options: MapOptions(
                      initialCenter: _currentPosition,
                      initialZoom: 15.0,
                      onTap: (tapPosition, point) {
                        setState(() {
                          _currentPosition = point; // تغيير مكان الدبوس عند النقر
                        });
                      },
                    ),
                    children: [
                      TileLayer(
                        urlTemplate: 'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
                        userAgentPackageName: 'com.example.primo',
                      ),
                      MarkerLayer(
                        markers: [
                          Marker(
                            point: _currentPosition,
                            width: 60.w,
                            height: 60.h,
                            child: Icon(
                              Icons.location_on,
                              color: AppColors.primary,
                              size: 40.sp,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                  
                  // --- صندوق الإرشادات العلوي ---
                  Positioned(
                    top: 16.h,
                    right: 16.w,
                    left: 16.w,
                    child: Container(
                      padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
                      decoration: BoxDecoration(
                        color: Colors.white.withValues(alpha: 0.95),
                        borderRadius: BorderRadius.circular(12.r),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withValues(alpha: 0.1),
                            blurRadius: 10,
                            offset: const Offset(0, 4),
                          ),
                        ],
                      ),
                      child: Row(
                        children: [
                          Icon(Icons.touch_app, color: AppColors.primary, size: 22.sp),
                          8.horizontalSpace,
                          Expanded(
                            child: Text(
                              "اضغط على الخريطة في أي مكان لتحديد موقع التوصيل بدقة",
                              style: AppTextStyle.font12.copyWith(
                                fontWeight: FontWeight.w600,
                                color: AppColors.textMain,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),

                  // --- زر تحديد موقعي (GPS) ---
                  Positioned(
                    bottom: 16.h,
                    left: 16.w,
                    child: FloatingActionButton(
                      backgroundColor: AppColors.white,
                      onPressed: _isLoadingLocation ? null : _checkAndGetCurrentLocation,
                      child: _isLoadingLocation
                          ? SizedBox(
                              width: 24.w,
                              height: 24.h,
                              child: const CircularProgressIndicator(strokeWidth: 2.5),
                            )
                          : Icon(
                              Icons.my_location,
                              color: AppColors.primary,
                              size: 26.sp,
                            ),
                    ),
                  ),
                ],
              ),
            ),
            
            // --- اللوحة السفلية للتأكيد ---
            Container(
              padding: EdgeInsets.symmetric(horizontal: 24.w, vertical: 16.h),
              decoration: BoxDecoration(
                color: AppColors.white,
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.05),
                    blurRadius: 10,
                    offset: const Offset(0, -4),
                  ),
                ],
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Row(
                    children: [
                      Icon(Icons.location_city, color: AppColors.greyMedium3, size: 20.sp),
                      8.horizontalSpace,
                      Expanded(
                        child: Text(
                          "الإحداثيات: Lat ${_currentPosition.latitude.toStringAsFixed(5)}, Lng ${_currentPosition.longitude.toStringAsFixed(5)}",
                          style: AppTextStyle.font12.copyWith(color: AppColors.greyMedium2),
                          textDirection: TextDirection.ltr,
                        ),
                      ),
                    ],
                  ),
                  16.verticalSpace,
                  AppButton(
                    text: "تأكيد هذا الموقع",
                    icon: Icons.check,
                    onPressed: () {
                      Navigator.pop(context, _currentPosition); // إرجاع القيمة للشيت
                    },
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}