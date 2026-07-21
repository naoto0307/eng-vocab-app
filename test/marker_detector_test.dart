import 'package:eng_vocab_app/core/vision/marker_detector.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:image/image.dart' as img;

void main() {
  test('白背景に黄色マーカー矩形を1つ描くと1領域を検出する', () {
    final image = img.Image(width: 400, height: 200);
    img.fill(image, color: img.ColorRgb8(255, 255, 255));
    img.fillRect(
      image,
      x1: 50,
      y1: 50,
      x2: 150,
      y2: 90,
      color: img.ColorRgb8(255, 245, 100), // 黄色マーカー相当
    );

    final regions = MarkerDetector().detect(image);

    expect(regions.length, 1);
    final r = regions.first;
    expect(r.left, lessThan(60));
    expect(r.top, lessThan(60));
    expect(r.left + r.width, greaterThan(140));
    expect(r.top + r.height, greaterThan(80));
  });

  test('離れた2つのマーカー矩形は別々の領域として検出する', () {
    final image = img.Image(width: 500, height: 200);
    img.fill(image, color: img.ColorRgb8(255, 255, 255));
    img.fillRect(
      image,
      x1: 20,
      y1: 50,
      x2: 100,
      y2: 90,
      color: img.ColorRgb8(255, 245, 100),
    );
    img.fillRect(
      image,
      x1: 350,
      y1: 50,
      x2: 430,
      y2: 90,
      color: img.ColorRgb8(150, 255, 150), // 緑マーカー相当
    );

    final regions = MarkerDetector().detect(image);

    expect(regions.length, 2);
  });

  test('マーカーが無い画像では領域を検出しない', () {
    final image = img.Image(width: 300, height: 150);
    img.fill(image, color: img.ColorRgb8(255, 255, 255));

    final regions = MarkerDetector().detect(image);

    expect(regions, isEmpty);
  });
}
