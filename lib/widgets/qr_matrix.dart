import 'dart:math' as math;

import 'package:flutter/material.dart';

/// Decorative QR-style matrix, deterministic for a given seed — the same
/// idea as the prototype's generateVisualQrSvg: a hash from the seed string,
/// three finder patterns in the corners, and pseudo-random modules.
class QrMatrix extends StatelessWidget {
  const QrMatrix({super.key, required this.seed, this.size = 160});

  final String seed;
  final double size;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: size,
      height: size,
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: Colors.black.withValues(alpha: 0.06)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.06),
            blurRadius: 12,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: CustomPaint(
        painter: _QrMatrixPainter(seed: seed),
      ),
    );
  }
}

class _QrMatrixPainter extends CustomPainter {
  _QrMatrixPainter({required this.seed}) : _modules = _buildModules(seed);

  final String seed;
  final List<List<bool>> _modules;

  static List<List<bool>> _buildModules(String seed) {
    var hash = 0;
    for (var i = 0; i < seed.length; i++) {
      hash = ((hash << 5) - hash) + seed.codeUnitAt(i);
      hash |= 0;
    }
    const n = 21;
    final grid = List.generate(n, (_) => List<bool>.filled(n, false));
    for (var row = 0; row < n; row++) {
      for (var col = 0; col < n; col++) {
        if (_inFinder(row, col, n)) continue;
        final bit = math.sin(hash + row * 13 + col * 7).abs();
        grid[row][col] = bit > 0.45;
      }
    }
    return grid;
  }

  static bool _inFinder(int row, int col, int n) {
    bool inCorner(int r0, int c0) =>
        row >= r0 && row < r0 + 7 && col >= c0 && col < c0 + 7;
    return inCorner(0, 0) || inCorner(0, n - 7) || inCorner(n - 7, 0);
  }

  @override
  void paint(Canvas canvas, Size size) {
    const n = 21;
    final cell = size.width / n;
    final paint = Paint()..color = Colors.black;

    void finder(double x, double y) {
      // Outer 7x7 ring + inner 3x3 block, like a real QR finder pattern.
      canvas.drawRRect(
        RRect.fromRectAndRadius(
          Rect.fromLTWH(x, y, cell * 7, cell * 7),
          const Radius.circular(4),
        ),
        Paint()
          ..color = Colors.black
          ..style = PaintingStyle.stroke
          ..strokeWidth = cell,
      );
      canvas.drawRect(
        Rect.fromLTWH(x + cell * 2, y + cell * 2, cell * 3, cell * 3),
        paint,
      );
    }

    finder(0, 0);
    finder(size.width - cell * 7, 0);
    finder(0, size.height - cell * 7);

    for (var row = 0; row < n; row++) {
      for (var col = 0; col < n; col++) {
        if (_inFinder(row, col, n)) continue;
        if (!_modules[row][col]) continue;
        canvas.drawRRect(
          RRect.fromRectAndRadius(
            Rect.fromLTWH(col * cell + 0.5, row * cell + 0.5, cell - 1, cell - 1),
            const Radius.circular(1.5),
          ),
          paint,
        );
      }
    }
  }

  @override
  bool shouldRepaint(covariant _QrMatrixPainter oldDelegate) =>
      oldDelegate.seed != seed;
}
