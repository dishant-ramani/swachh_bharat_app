import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:http_parser/http_parser.dart';
import 'package:mime_type/mime_type.dart';

class CloudinaryService {
  static const String _cloudName = "dxmkgjdjz";
  static const String _uploadPreset = "swachh_bharat_upload";

  // ✅ FIXED URL (IMPORTANT)
  static const String _uploadUrl =
      "https://api.cloudinary.com/v1_1/$_cloudName/image/upload";

  Future<String> uploadImage(File imageFile) async {
    try {
      final mimeStr = mime(imageFile.path) ?? 'application/octet-stream';
      final mimeTypeData = mimeStr.split('/');
      final fileType = mimeTypeData[0];
      final fileExtension = mimeTypeData[1];

      final request = http.MultipartRequest('POST', Uri.parse(_uploadUrl))
        ..fields['upload_preset'] = _uploadPreset
        ..fields['folder'] = 'swachh_bharat/complaints'
        ..files.add(
          await http.MultipartFile.fromBytes(
            'file',
            await imageFile.readAsBytes(),
            filename:
                'image_${DateTime.now().millisecondsSinceEpoch}.$fileExtension',
            contentType: MediaType(fileType, fileExtension),
          ),
        );

      final response = await request.send();
      final responseData = await response.stream.bytesToString();
      final responseJson = json.decode(responseData);

      if (response.statusCode != 200) {
        throw Exception(
          'Failed to upload image: ${responseJson['error']?.toString() ?? 'Unknown error'}',
        );
      }

      // ✅ THIS WILL NOW WORK
      return responseJson['secure_url'];
    } catch (e) {
      throw Exception('Error uploading image to Cloudinary: $e');
    }
  }
}
