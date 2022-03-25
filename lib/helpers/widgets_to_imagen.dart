import 'dart:ui' as ui;
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:maps_app/markers/markers.dart';

Future<BitmapDescriptor> getInicioCustomMarker(int minutos, String destino) async {
  // este codigo crea el canvas, dibuja todo y genera la imagen
  final recorder = ui.PictureRecorder();
  final canvas = ui.Canvas(recorder);
  const size = ui.Size(350, 150);

  final startMarker = StartMarkerPainter(minutos: minutos, destino: destino);
  startMarker.paint(canvas, size);

  final picture = recorder.endRecording();
  final imagen = await picture.toImage(size.width.toInt(), size.height.toInt());

  final byteData = await imagen.toByteData(format: ui.ImageByteFormat.png);

  return BitmapDescriptor.fromBytes(byteData!.buffer.asUint8List());
}

Future<BitmapDescriptor> getEndCustomMarker(int km, String destino) async {
  // este codigo crea el canvas, dibuja todo y genera la imagen
  final recorder = ui.PictureRecorder();
  final canvas = ui.Canvas(recorder);
  const size = ui.Size(350, 150);

  final startMarker = EndMarkerPainter(km: km, destino: destino);
  startMarker.paint(canvas, size);

  final picture = recorder.endRecording();
  final imagen = await picture.toImage(size.width.toInt(), size.height.toInt());

  final byteData = await imagen.toByteData(format: ui.ImageByteFormat.png);

  return BitmapDescriptor.fromBytes(byteData!.buffer.asUint8List());
}
