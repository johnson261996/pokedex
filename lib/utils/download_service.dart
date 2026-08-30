import 'dart:typed_data';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:image_gallery_saver/image_gallery_saver.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';
import 'dart:io';

class DownloadService {
  static final Dio _dio = Dio();

  /// Download Pokémon card image
  static Future<bool> downloadPokemonCard({
    required String imageUrl,
    required String cardName,
    required BuildContext context,
  }) async {
    try {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('Downloading card...')));

      // Request storage permission
      final status = await Permission.storage.request();
      if (!status.isGranted) {
        _showError(context, 'Storage permission denied');
        return false;
      }

      // Download image bytes
      final response = await _dio.get<List<int>>(
        imageUrl,
        options: Options(responseType: ResponseType.bytes),
      );

      if (response.statusCode == 200 && response.data != null) {
        if (Platform.isAndroid || Platform.isIOS) {
          // Save to gallery on mobile
          return await _saveToGallery(response.data!, cardName, context);
        } else if (Platform.isWindows || Platform.isMacOS || Platform.isLinux) {
          // Save to downloads folder on desktop
          return await _saveToDesktop(response.data!, cardName, context);
        }
      }
      return false;
    } catch (e) {
      _showError(context, 'Download failed: $e');
      return false;
    }
  }

  /// Save image to mobile gallery
  static Future<bool> _saveToGallery(
    List<int> imageBytes,
    String cardName,
    BuildContext context,
  ) async {
    try {
      final result = await ImageGallerySaver.saveImage(
        Uint8List.fromList(imageBytes),
        quality: 100,
        name: 'pokemon_${cardName}_${DateTime.now().millisecondsSinceEpoch}',
      );

      if (result['isSuccess'] == true) {
        _showSuccess(context, 'Card saved to gallery!');
        return true;
      }
      return false;
    } catch (e) {
      _showError(context, 'Failed to save to gallery: $e');
      return false;
    }
  }

  /// Save image to desktop (Downloads folder)
  static Future<bool> _saveToDesktop(
    List<int> imageBytes,
    String cardName,
    BuildContext context,
  ) async {
    try {
      final directory = await getDownloadsDirectory();
      if (directory == null) {
        _showError(context, 'Downloads folder not found');
        return false;
      }

      final fileName =
          'pokemon_${cardName}_${DateTime.now().millisecondsSinceEpoch}.png';
      final file = File('${directory.path}/$fileName');

      await file.writeAsBytes(imageBytes);

      _showSuccess(context, 'Card saved to Downloads!\nPath: ${file.path}');
      return true;
    } catch (e) {
      _showError(context, 'Failed to save to Downloads: $e');
      return false;
    }
  }

  static void _showSuccess(BuildContext context, String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: Colors.green,
        duration: const Duration(seconds: 3),
      ),
    );
  }

  static void _showError(BuildContext context, String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: Colors.red,
        duration: const Duration(seconds: 3),
      ),
    );
  }
}
