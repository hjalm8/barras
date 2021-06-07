import 'dart:async';
import 'package:flutter/material.dart';

import 'package:flutter_beep/flutter_beep.dart';
import 'package:qrcode/qrcode.dart';
import 'barcode_reader_overlay_painter.dart';

class BarcodeReaderPage extends StatefulWidget {
  final showBorder;
  final borderFlashDuration;
  final viewfinderWidth;
  final viewfinderHeight;
  final borderRadius;
  final scrimColor;
  final borderColor;
  final borderStrokeWidth;
  final buttonColor;
  final cancelButtonText;
  final successBeep;

  BarcodeReaderPage({
    this.showBorder = true,
    this.borderFlashDuration = 500,
    this.viewfinderWidth = 240.0,
    this.viewfinderHeight = 240.0,
    this.borderRadius = 16.0,
    this.scrimColor = Colors.black54,
    this.borderColor = Colors.green,
    this.borderStrokeWidth = 4.0,
    this.buttonColor = Colors.white,
    this.cancelButtonText = "Cancel",
    this.successBeep = true,
  });

  @override
  _BarcodeReaderPageState createState() => _BarcodeReaderPageState();
}

class _BarcodeReaderPageState extends State<BarcodeReaderPage> {
  QRCaptureController _captureController = QRCaptureController();

  bool _hasTorch = false;
  bool _isTorchOn = false;
  bool _isBorderVisible = false;
  Timer _borderFlashTimer;

  @override
  void initState() {
    super.initState();

    if (widget.showBorder) {
      setState(() {
        _isBorderVisible = true;
      });

      if (widget.borderFlashDuration > 0) {
        _borderFlashTimer = Timer.periodic(
            Duration(milliseconds: widget.borderFlashDuration), (timer) {
          setState(() {
            _isBorderVisible = !_isBorderVisible;
          });
        });
      }
    }

    _captureController.onCapture((data) {
      _captureController.pause();
      if (widget.successBeep) {
        FlutterBeep.beep();
      }
      Navigator.of(context).pop(data);
    });
  }

  @override
  void dispose() {
    _borderFlashTimer.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Stack(
        alignment: Alignment.center,
        children: <Widget>[
          _buildCaptureView(),
          _buildViewfinder(context),
        ],
      ),
    );
  }

  Widget _buildCaptureView() {
    return QRCaptureView(
      controller: _captureController,
    );
  }

  Widget _buildViewfinder(BuildContext context) {
    return CustomPaint(
      size: MediaQuery.of(context).size,
      painter: BarcodeReaderOverlayPainter(
        drawBorder: _isBorderVisible,
        viewfinderWidth: widget.viewfinderWidth,
        viewfinderHeight: widget.viewfinderHeight,
        borderRadius: widget.borderRadius,
        scrimColor: widget.scrimColor,
        borderColor: widget.borderColor,
        borderStrokeWidth: widget.borderStrokeWidth,
      ),
    );
  }
}
