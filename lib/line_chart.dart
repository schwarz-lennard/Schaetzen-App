import 'package:flutter/material.dart';

class LineChart extends StatelessWidget {
  final List<List<int>> allScores;
  final List<Color> colors;

  const LineChart({
    super.key,
    required this.allScores,
    required this.colors,
  });

  @override
  Widget build(BuildContext context) {
    return CustomPaint(
      size: const Size(double.infinity, 250),
      painter: _LineChartPainter(allScores, colors),
    );
  }
}

class _LineChartPainter extends CustomPainter {
  final List<List<int>> allScores;
  final List<Color> colors;

  _LineChartPainter(this.allScores, this.colors);

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..strokeWidth = 3
      ..style = PaintingStyle.stroke;

    final int rounds = allScores.isNotEmpty ? allScores[0].length : 0;
    if (rounds == 0) return;

    int minScore = allScores
        .expand((list) => list)
        .reduce((value, element) => value < element ? value : element);
    int maxScore = allScores
        .expand((list) => list)
        .reduce((value, element) => value > element ? value : element);

    final double padding = 40.0;
    final double chartWidth = size.width - 2 * padding;
    final double chartHeight = size.height - 2 * padding;
    double xStep = rounds > 1 ? chartWidth / (rounds - 1) : chartWidth;

    final textPainter = TextPainter(
        textAlign: TextAlign.center, textDirection: TextDirection.ltr);

    // Linien und Punkte zeichnen
    for (int playerIdx = 0; playerIdx < allScores.length; playerIdx++) {
      List<int> scores = allScores[playerIdx];
      paint.color = colors[playerIdx % colors.length];

      Path path = Path();

      for (int i = 0; i < rounds; i++) {
        double score = scores[i].toDouble();
        double x = padding + i * xStep;
        double y = padding + chartHeight * (1 - (score - minScore) / (maxScore - minScore));

        if (i == 0) {
          path.moveTo(x, y);
        } else {
          path.lineTo(x, y);
        }

        canvas.drawCircle(Offset(x, y), 4, Paint()..color = paint.color);
      }

      canvas.drawPath(path, paint);
    }

    // Achsen
    final axisPaint = Paint()
      ..color = Colors.grey
      ..strokeWidth = 1;

    canvas.drawLine(
        Offset(padding, padding), Offset(padding, size.height - padding), axisPaint);
    canvas.drawLine(
        Offset(padding, size.height - padding),
        Offset(size.width - padding, size.height - padding),
        axisPaint);

    // Y-Achsenbeschriftung
    int yStep = ((maxScore - minScore) ~/ 5).clamp(1, maxScore - minScore);
    for (int i = minScore; i <= maxScore; i += yStep) {
      double y = padding + chartHeight * (1 - (i - minScore) / (maxScore - minScore));
      textPainter.text = TextSpan(
          text: i.toString(),
          style: const TextStyle(color: Colors.black, fontSize: 12));
      textPainter.layout();
      textPainter.paint(canvas, Offset(0, y - textPainter.height / 2));

      canvas.drawLine(
          Offset(padding, y),
          Offset(size.width - padding, y),
          axisPaint..color = Colors.grey.withAlpha((0.2 * 255).round()));
    }

    // X-Achsen-Beschriftung
    for (int i = 0; i < rounds; i++) {
      double x = padding + i * xStep;
      textPainter.text = TextSpan(
          text: (i + 1).toString(),
          style: const TextStyle(color: Colors.black, fontSize: 12));
      textPainter.layout();
      textPainter.paint(canvas, Offset(x - textPainter.width / 2, size.height - padding + 4));
    }

    // Achsenbeschriftung Y
    textPainter.text = const TextSpan(
        text: "Punkte",
        style: TextStyle(color: Colors.black, fontSize: 14, fontWeight: FontWeight.bold));
    textPainter.layout();
    canvas.save();
    canvas.translate(12, padding + chartHeight / 2 + textPainter.width / 2);
    canvas.rotate(-3.14159 / 2);
    textPainter.paint(canvas, Offset(0, 0));
    canvas.restore();

    // Achsenbeschriftung X
    textPainter.text = const TextSpan(
        text: "Runden",
        style: TextStyle(color: Colors.black, fontSize: 14, fontWeight: FontWeight.bold));
    textPainter.layout();
    textPainter.paint(canvas, Offset(padding + chartWidth / 2 - textPainter.width / 2, size.height - 20));
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}