import 'dart:math' as math;

import 'package:image/image.dart' as img;

class MarkerRegion {
  const MarkerRegion({
    required this.left,
    required this.top,
    required this.width,
    required this.height,
  });

  final int left;
  final int top;
  final int width;
  final int height;
}

class _Blob {
  _Blob(this.left, this.top, this.width, this.height);
  final int left;
  final int top;
  final int width;
  final int height;
}

/// HSV色検出でマーカー（蛍光ペン）による強調領域を検出する
class MarkerDetector {
  /// 処理速度のため長辺をこのサイズまで縮小してから検出する
  static const _maxWorkingDimension = 900;
  static const _minBlobArea = 30;

  List<MarkerRegion> detect(img.Image original) {
    final longSide = math.max(original.width, original.height);
    final scale = longSide > _maxWorkingDimension ? _maxWorkingDimension / longSide : 1.0;
    final work = scale < 1.0
        ? img.copyResize(original, width: (original.width * scale).round())
        : original;

    final w = work.width;
    final h = work.height;
    final mask = List.generate(h, (_) => List<bool>.filled(w, false));

    for (var y = 0; y < h; y++) {
      for (var x = 0; x < w; x++) {
        final p = work.getPixel(x, y);
        final r = p.r / 255.0;
        final g = p.g / 255.0;
        final b = p.b / 255.0;
        final v = math.max(r, math.max(g, b));
        final minc = math.min(r, math.min(g, b));
        final s = v == 0 ? 0.0 : (v - minc) / v;
        // 蛍光ペンは彩度・明度がともに高いパステル系の色になりやすい一方、
        // 黒文字(明度低)や白紙(彩度が低い)は除外したいので彩度を主な判定基準にする。
        // 彩度が既に白紙を除外するため、明度側は下限のみでよい（黄色マーカーはV=1.0になりうる）
        if (s > 0.28 && v > 0.45) {
          mask[y][x] = true;
        }
      }
    }

    // マーカー内の黒文字部分は彩度・明度が低くマスクの穴になり、1つの単語が
    // 複数領域に分裂してしまうため、膨張処理で文字の隙間を埋めてから連結成分を取る
    final dilated = _dilate(mask, w, h, 4);

    final blobs = _connectedComponents(dilated, w, h)
        .where((b) => b.width * b.height >= _minBlobArea)
        .toList();

    final scaleBack = 1 / scale;
    final regions = blobs
        .map(
          (b) => MarkerRegion(
            left: (b.left * scaleBack).round(),
            top: (b.top * scaleBack).round(),
            width: (b.width * scaleBack).round(),
            height: (b.height * scaleBack).round(),
          ),
        )
        .toList();

    // 1文字ずつのブロブが隣り合っているだけのケースを1つの単語/フレーズにまとめる
    return _mergeNearby(_mergeNearby(regions));
  }

  /// 水平・垂直の2パスによるボックス膨張（半径radius px）
  List<List<bool>> _dilate(List<List<bool>> mask, int w, int h, int radius) {
    final horizontal = List.generate(h, (_) => List<bool>.filled(w, false));
    for (var y = 0; y < h; y++) {
      var count = 0;
      for (var x = -radius; x < w; x++) {
        final addIdx = x + radius;
        if (addIdx < w && addIdx >= 0 && mask[y][addIdx]) count++;
        final removeIdx = x - radius - 1;
        if (removeIdx >= 0 && removeIdx < w && mask[y][removeIdx]) count--;
        if (x >= 0) horizontal[y][x] = count > 0;
      }
    }

    final result = List.generate(h, (_) => List<bool>.filled(w, false));
    for (var x = 0; x < w; x++) {
      var count = 0;
      for (var y = -radius; y < h; y++) {
        final addIdx = y + radius;
        if (addIdx < h && addIdx >= 0 && horizontal[addIdx][x]) count++;
        final removeIdx = y - radius - 1;
        if (removeIdx >= 0 && removeIdx < h && horizontal[removeIdx][x]) count--;
        if (y >= 0) result[y][x] = count > 0;
      }
    }
    return result;
  }

  List<_Blob> _connectedComponents(List<List<bool>> mask, int w, int h) {
    final visited = List.generate(h, (_) => List<bool>.filled(w, false));
    final blobs = <_Blob>[];

    for (var y = 0; y < h; y++) {
      for (var x = 0; x < w; x++) {
        if (!mask[y][x] || visited[y][x]) continue;

        var minX = x, maxX = x, minY = y, maxY = y;
        final queue = <int>[x, y];
        visited[y][x] = true;
        var qi = 0;
        while (qi < queue.length) {
          final cx = queue[qi];
          final cy = queue[qi + 1];
          qi += 2;
          if (cx < minX) minX = cx;
          if (cx > maxX) maxX = cx;
          if (cy < minY) minY = cy;
          if (cy > maxY) maxY = cy;

          const dx = [1, -1, 0, 0];
          const dy = [0, 0, 1, -1];
          for (var d = 0; d < 4; d++) {
            final nx = cx + dx[d];
            final ny = cy + dy[d];
            if (nx >= 0 && nx < w && ny >= 0 && ny < h && mask[ny][nx] && !visited[ny][nx]) {
              visited[ny][nx] = true;
              queue.add(nx);
              queue.add(ny);
            }
          }
        }
        blobs.add(_Blob(minX, minY, maxX - minX + 1, maxY - minY + 1));
      }
    }
    return blobs;
  }

  List<MarkerRegion> _mergeNearby(List<MarkerRegion> regions) {
    if (regions.length <= 1) return regions;
    final sorted = [...regions]..sort((a, b) => a.top.compareTo(b.top));
    final merged = <MarkerRegion>[];

    for (final r in sorted) {
      final idx = merged.indexWhere((m) {
        final overlapTop = math.max(m.top, r.top);
        final overlapBottom = math.min(m.top + m.height, r.top + r.height);
        final verticalOverlap = overlapBottom - overlapTop;
        final avgHeight = (m.height + r.height) / 2;
        if (verticalOverlap < avgHeight * 0.35) return false;
        final gap = math.max(m.left, r.left) - math.min(m.left + m.width, r.left + r.width);
        return gap < avgHeight * 1.8;
      });

      if (idx == -1) {
        merged.add(r);
      } else {
        final m = merged[idx];
        final left = math.min(m.left, r.left);
        final top = math.min(m.top, r.top);
        final right = math.max(m.left + m.width, r.left + r.width);
        final bottom = math.max(m.top + m.height, r.top + r.height);
        merged[idx] = MarkerRegion(left: left, top: top, width: right - left, height: bottom - top);
      }
    }
    return merged;
  }
}
