import 'package:permission_handler/permission_handler.dart';
import 'dart:io' show Platform;

class PermissionService {

  static final instance = PermissionService();
  // Checking Permission
  Future<bool> hasPermission(Permission permission) async {
    return await permission.isGranted;
  }

  // Requesting Permission
  Future<bool> requestPermission(Permission permission) async {
    var result = await permission.request();
    return result.isGranted;
  }

  // Camera Permission
  Future<bool> hasCameraPermission() async {
    return hasPermission(Permission.camera);
  }

  Future<bool> requestCameraPermission() async {
    return requestPermission(Permission.camera);
  }

  // Gallery Permission
  Future<bool> hasStoragePermission() async {
    return hasPermission(
        Platform.isAndroid ? Permission.storage : Permission.photos);
  }

  Future<bool> requestStoragePermission() async {
    return requestPermission(
        Platform.isAndroid ? Permission.storage : Permission.photos);
  }

  // Contact Permission
  Future<bool> hasContactsPermission() async {
    return hasPermission(Permission.contacts);
  }

  Future<bool> requestContactsPermission() async {
    return requestPermission(Permission.contacts);
  }

  // Location Permission
  Future<bool> hasLocationPermission() async {
    return hasPermission(Permission.locationWhenInUse);
  }

  Future<bool> requestLocationPermission() async {
    return requestPermission(Permission.locationWhenInUse);
  }
}

/**
 *  Add permission_handler as a dependency in your pubspec.yaml file. For example:

    dependencies:
    permission_handler: '^3.3.0'

    1.  Add the following to your "gradle.properties" file:
    android.useAndroidX=true
    android.enableJetifier=true

    2. Make sure you set the compileSdkVersion in your "android/app/build.gradle" file to 28:
    android {
    compileSdkVersion 28
    ...
    }

    3. Make sure you replace all the android. dependencies to their AndroidX counterparts (a full list can be found here:

    4. Must add permission in Android Manifest and Info.Plist file

 */
