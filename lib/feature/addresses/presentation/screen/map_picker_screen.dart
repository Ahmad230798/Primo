import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
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
  GoogleMapController? _mapController;
  late LatLng _currentPosition;
  bool _isLoadingLocation = false;
  Set<Marker> _markers = {};

  @override
  void initState() {
    super.initState();
    _currentPosition = LatLng(widget.initialLat, widget.initialLng);
    _setMarker(_currentPosition);
    _checkAndGetCurrentLocation();
  }

  // دالة لتحديث الدبوس في الموقع المحدد فقط
  void _setMarker(LatLng position) {
    setState(() {
      _currentPosition = position;
      _markers = {
        Marker(
          markerId: const MarkerId('selected_delivery_location'),
          position: position,
          icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueRed),
        ),
      };
    });
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
        final newPos = LatLng(position.latitude, position.longitude);
        _setMarker(newPos);
        setState(() => _isLoadingLocation = false);
        _mapController?.animateCamera(CameraUpdate.newLatLngZoom(newPos, 16.0));
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
                  // --- خريطة جوجل (Google Maps) ---
                  GoogleMap(
                    initialCameraPosition: CameraPosition(
                      target: _currentPosition,
                      zoom: 15.0,
                    ),
                    onMapCreated: (controller) {
                      _mapController = controller;
                    },
                    // النقر على الخريطة هو الوحيد الذي يُغيّر موقع الدبوس
                    onTap: (point) {
                      _setMarker(point);
                    },
                    markers: _markers,
                    myLocationEnabled: true,
                    myLocationButtonEnabled: false,
                    zoomControlsEnabled: false,
                  ),

                  // --- صندوق الإرشادات العلوي ---
                  Positioned(
                    top: 16.h,
                    right: 16.w,
                    left: 16.w,
                    child: Container(
                      padding: EdgeInsets.symmetric(
                        horizontal: 16.w,
                        vertical: 12.h,
                      ),
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
                          Icon(
                            Icons.touch_app,
                            color: AppColors.primary,
                            size: 22.sp,
                          ),
                          8.horizontalSpace,
                          Expanded(
                            child: Text(
                              "اضغط في أي مكان على الخريطة لتحديد موقع التوصيل بدقة",
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
                      onPressed: _isLoadingLocation
                          ? null
                          : _checkAndGetCurrentLocation,
                      child: _isLoadingLocation
                          ? SizedBox(
                              width: 24.w,
                              height: 24.h,
                              child: const CircularProgressIndicator(
                                strokeWidth: 2.5,
                              ),
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
                      Icon(
                        Icons.location_city,
                        color: AppColors.greyMedium3,
                        size: 20.sp,
                      ),
                      8.horizontalSpace,
                      Expanded(
                        child: Text(
                          "الإحداثيات: Lat ${_currentPosition.latitude.toStringAsFixed(5)}, Lng ${_currentPosition.longitude.toStringAsFixed(5)}",
                          style: AppTextStyle.font12.copyWith(
                            color: AppColors.greyMedium2,
                          ),
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
                      Navigator.pop(context, _currentPosition);
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
