import 'dart:io';

import 'package:google_mlkit_text_recognition/google_mlkit_text_recognition.dart';
import 'package:image/image.dart' as img;
import 'package:path/path.dart' as p;
import 'package:path_provider/path_provider.dart';

/// Google ML Kit（オンデバイス）でテキスト認識を行う
class OcrService {
  final TextRecognizer _recognizer = TextRecognizer(script: TextRecognitionScript.latin);

  Future<String> recognizeText(img.Image croppedImage) async {
    final tempDir = await getTemporaryDirectory();
    final file = File(
      p.join(tempDir.path, 'ocr_${DateTime.now().microsecondsSinceEpoch}.jpg'),
    );
    await file.writeAsBytes(img.encodeJpg(croppedImage));
    try {
      final inputImage = InputImage.fromFilePath(file.path);
      final result = await _recognizer.processImage(inputImage);
      return result.text.trim();
    } finally {
      if (await file.exists()) await file.delete();
    }
  }

  void dispose() => _recognizer.close();
}
