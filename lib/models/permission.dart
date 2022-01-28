import 'package:flutter/foundation.dart';
import 'package:geolocator/geolocator.dart';
import 'package:geocoding/geocoding.dart';
import 'package:permission_handler/permission_handler.dart';

class Izinler extends ChangeNotifier {
  Position? currentPosition;
  String? adresBilgisi;

  Future<Position> getLocation() async {
    LocationPermission? permission;
    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        return Future.error('Location permissions are denied');
      }
    }
    if (permission == LocationPermission.always) {
      permission = await Geolocator.requestPermission();
    }

    if (permission == LocationPermission.deniedForever) {
      return Future.error(
          'Location permissions are permanently denied, we cannot request permissions.');
    }
    notifyListeners();
    return await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high);
  }

  void getAdress(String adresBilgisi) async {
    try {
      var enlemBoylam = await Geolocator.getCurrentPosition(
          desiredAccuracy: LocationAccuracy.high);
      List<Placemark> placemark = await GeocodingPlatform.instance
          .placemarkFromCoordinates(
              enlemBoylam.latitude, enlemBoylam.longitude);
      Placemark place = placemark[0];
      adresBilgisi = ("${place.administrativeArea}/${place.locality}");
    } catch (e) {
      if (kDebugMode) {
        print(e);
      }
    }
    notifyListeners();
  }

  Future audioPermission() async {
    final status = await Permission.microphone.request();
    if (status != PermissionStatus.granted) {}
    notifyListeners();
  }

  Future storagePermission() async {
    if (await Permission.storage.request().isGranted) {
      await Permission.storage.request();
    } else if (await Permission.storage.request().isPermanentlyDenied) {
      await openAppSettings();
    } else if (await Permission.storage.request().isDenied) {}
    notifyListeners();
  }
}
