import 'package:flutter/material.dart';

class EndMarkerPainter extends CustomPainter {
  final int km;
  final String destino;

  EndMarkerPainter({
    required this.km,
    required this.destino,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final lapizNegro = Paint()..color = Colors.black;
    final lapizBlanco = Paint()..color = Colors.white;
    const double radioCirculoNegro = 20.0;
    const double radioCirculoBlanco = 7.0;

    canvas.drawCircle(
      Offset(size.width * 0.5, size.height - radioCirculoNegro),
      radioCirculoNegro,
      lapizNegro,
    );
    canvas.drawCircle(
      Offset(size.width * 0.5, size.height - radioCirculoNegro),
      radioCirculoBlanco,
      lapizBlanco,
    );

    final path = Path();
    path.moveTo(10, 20);
    path.lineTo(size.width - 10, 20);
    path.lineTo(size.width - 10, 100);
    path.lineTo(10, 100);
    //sombra
    canvas.drawShadow(path, Colors.black, 10, false);
    //caja
    canvas.drawPath(path, lapizBlanco);

    // otra caja con otro metodo
    const cajaNegra = Rect.fromLTWH(10, 20, 70, 80);
    canvas.drawRect(cajaNegra, lapizNegro);

    // textos
    final textSpan = TextSpan(
        style: const TextStyle(
            color: Colors.white, fontSize: 30, fontWeight: FontWeight.w400),
        text: '$km');
    final minutosPainter = TextPainter(
      text: textSpan,
      textDirection: TextDirection.ltr,
      textAlign: TextAlign.center,
    )..layout(minWidth: 70, maxWidth: 70);

    minutosPainter.paint(canvas, const Offset(10, 35));

    // minutos
    const minutesTxtSpan = TextSpan(
        style: TextStyle(color: Colors.white, fontSize: 15, fontWeight: FontWeight.w300),
        text: 'km');
    final minutosTxtPainter = TextPainter(
      text: minutesTxtSpan,
      textDirection: TextDirection.ltr,
      textAlign: TextAlign.center,
    )..layout(minWidth: 70, maxWidth: 70);
    minutosTxtPainter.paint(canvas, const Offset(10, 68));

    // descripcion
    final locationSpan = TextSpan(
        style: const TextStyle(
            color: Colors.black, fontSize: 18, fontWeight: FontWeight.w400),
        text: destino);
    final locationPainter = TextPainter(
      maxLines: 2,
      ellipsis: '...',
      text: locationSpan,
      textDirection: TextDirection.ltr,
      textAlign: TextAlign.left,
    )..layout(minWidth: size.width - 95, maxWidth: size.width - 95);

    double offsetY = (destino.length > 25) ? 37 : 49;
    locationPainter.paint(canvas, Offset(90, offsetY));
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;

  @override
  bool shouldRebuildSemantics(covariant CustomPainter oldDelegate) => false;
}
