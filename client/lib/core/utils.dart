import 'dart:io';

import 'package:device_info_plus/device_info_plus.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';

void showSnackBar(BuildContext context, String content) {
  ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(
      content: Text(content),
    ),
  );
}

Future<File?> pickAudio() async {
  try {
    // Android'de SDK versiyonuna göre izin kontrolü
    if (Platform.isAndroid) {
      final androidInfo = await DeviceInfoPlugin().androidInfo;

      if (androidInfo.version.sdkInt >= 33) {
        // Android 13 ve üzeri
        var status = await Permission.audio.status;
        if (status.isDenied) {
          status = await Permission.audio.request();
          if (status.isPermanentlyDenied) {
            openAppSettings();
            return null;
          }
        }
      } else {
        // Android 12 ve altı
        var status = await Permission.storage.status;
        if (status.isDenied) {
          status = await Permission.storage.request();
          if (status.isPermanentlyDenied) {
            openAppSettings();
            return null;
          }
        }
      }
    }

    final result = await FilePicker.platform.pickFiles(
      type: FileType.audio,
      allowCompression: false,
      allowMultiple: false,
    );

    if (result != null && result.files.isNotEmpty && result.files.single.path != null) {
      return File(result.files.single.path!);
    }

    return null;
  } catch (e) {
    debugPrint('Ses seçme hatası: $e');
    return null;
  }
}

Future<File?> pickImage() async {
  try {
    // Android'de SDK versiyonuna göre izin kontrolü
    if (Platform.isAndroid) {
      final androidInfo = await DeviceInfoPlugin().androidInfo;

      if (androidInfo.version.sdkInt >= 33) {
        // Android 13 ve üzeri
        var status = await Permission.photos.status;
        if (status.isDenied) {
          status = await Permission.photos.request();
          if (status.isPermanentlyDenied) {
            openAppSettings();
            return null;
          }
        }
      } else {
        // Android 12 ve altı
        var status = await Permission.storage.status;
        if (status.isDenied) {
          status = await Permission.storage.request();
          if (status.isPermanentlyDenied) {
            openAppSettings();
            return null;
          }
        }
      }
    }

    final result = await FilePicker.platform.pickFiles(
      type: FileType.image,
      allowCompression: false,
      allowMultiple: false,
    );

    if (result != null && result.files.isNotEmpty && result.files.single.path != null) {
      return File(result.files.single.path!);
    }

    return null;
  } catch (e) {
    debugPrint('Resim seçme hatası: $e');
    return null;
  }
}

String rgbToHex(Color color) {
  return '${color.red.toRadixString(16).padLeft(2, '0')}${color.red.toRadixString(16).padLeft(2, '0')}${color.red.toRadixString(16).padLeft(2, '0')}';
}

Color hexToColor(String hex) {
  return Color(int.parse(hex, radix: 16) + 0xFF000000);
}
