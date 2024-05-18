import 'dart:developer';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:qr_code_scanner/qr_code_scanner.dart';
import 'package:viko_absensi/core/bloc/qrscan/qrscan_bloc.dart';
import 'package:viko_absensi/pages/ambil_absen_mahasiswa_page.dart';

class AbsenPage extends StatefulWidget {
  final String uid;
  const AbsenPage({super.key, required this.uid});

  @override
  State<AbsenPage> createState() => _AbsenPageState();
}

class _AbsenPageState extends State<AbsenPage> {
  final GlobalKey qrkey = GlobalKey(debugLabel: 'QR');
  Barcode? result;
  QRViewController? controller;
  String hasil = '';

  bool isSelected = false;
  bool isScanned = false;

  @override
  void reassemble() {
    if (Platform.isAndroid) {
      controller!.pauseCamera();
    } else if (Platform.isIOS) {
      controller!.resumeCamera();
    }
    super.reassemble();
  }

  @override
  void dispose() {
    controller!.dispose();
    super.dispose();
  }

  Widget _buildQrView(BuildContext context) {
    // For this example we check how width or tall the device is and change the scanArea and overlay accordingly.
    var scanArea = (MediaQuery.of(context).size.width < 400 ||
            MediaQuery.of(context).size.height < 400)
        ? 150.0
        : 300.0;
    // To ensure the Scanner view is properly sizes after rotation
    // we need to listen for Flutter SizeChanged notification and update controller
    return QRView(
      key: qrkey,
      onQRViewCreated: _onQRViewCreated,
      overlay: QrScannerOverlayShape(
          borderColor: Colors.red,
          borderRadius: 20,
          borderLength: 30,
          borderWidth: 10,
          cutOutSize: scanArea),
      onPermissionSet: (ctrl, p) => _onPermissionSet(context, ctrl, p),
    );
  }

  void _onQRViewCreated(QRViewController controller) {
    setState(() {
      this.controller = controller;
    });
    controller.scannedDataStream.listen((scanData) {
      controller.stopCamera();
      if (scanData.code.toString().length == 20) {
        Navigator.pushReplacement(
            context,
            MaterialPageRoute(
              builder: (context) => AmbilAbsenMahasiswa(
                  kelasid: scanData.code.toString(), uid: widget.uid),
            ));
      } else {
        Navigator.of(context).pop();
        showDialog(
            context: context,
            builder: (context) {
              return const AlertDialog(
                content: Text('Barcode tidak valid'),
              );
            });
      }
    });
  }

  void _onPermissionSet(BuildContext context, QRViewController ctrl, bool p) {
    log('${DateTime.now().toIso8601String()}_onPermissionSet $p');
    if (!p) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('no Permission')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        foregroundColor: Colors.grey.shade700,
        title: Text(
          'Absen QR',
          style: GoogleFonts.poppins(
            color: Colors.grey.shade700,
          ),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(15.0),
        child: Column(
          children: [
            Container(
              color: Colors.white,
              child: Column(
                children: [
                  Text(
                    'Silahkan Scan Untuk Ambil Absen',
                    style: GoogleFonts.poppins(color: Colors.grey.shade700),
                  ),
                  if (result != null)
                    Text('Data Barcode: ${result!.code}',
                        style: GoogleFonts.poppins(color: Colors.grey.shade700))
                  else
                    Text(
                      'Scan a Code',
                      style: GoogleFonts.poppins(color: Colors.grey.shade700),
                    ),
                ],
              ),
            ),
            Expanded(
                flex: 4,
                child: Padding(
                  padding: const EdgeInsets.symmetric(
                      horizontal: 20.0, vertical: 50),
                  child: BlocListener<QrscanBloc, QrscanState>(
                    listener: (context, state) {
                      state.maybeWhen(
                          error: (message) {
                            controller!.pauseCamera();
                            ScaffoldMessenger.of(context)
                                .showSnackBar(SnackBar(content: Text(message)));
                          },
                          orElse: () {});
                    },
                    child: BlocBuilder<QrscanBloc, QrscanState>(
                      builder: (context, state) {
                        return state.maybeWhen(loading: () {
                          return const Center(
                            child: CircularProgressIndicator(),
                          );
                        }, orElse: () {
                          // return Text('initial');
                          return _buildQrView(context);
                        });
                      },
                    ),
                  ),
                )),
            Expanded(
                child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 15.0),
                  child: Container(
                    width: double.infinity,
                    height: 60,
                    decoration: BoxDecoration(
                        color: Colors.blueAccent,
                        borderRadius: BorderRadius.circular(20)),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        InkWell(
                          onTap: () async {
                            await controller?.toggleFlash();
                            setState(() {});
                          },
                          child: FutureBuilder(
                              future: controller?.getFlashStatus(),
                              builder: (context, snapshot) {
                                if (snapshot.data == false) {
                                  return const Icon(
                                    Icons.flash_off,
                                    size: 40,
                                    color: Colors.white,
                                  );
                                } else {
                                  return const Icon(
                                    Icons.flash_on,
                                    size: 40,
                                    color: Colors.white,
                                  );
                                }
                              }),
                        ),
                        InkWell(
                          onTap: () async {
                            await controller?.flipCamera();
                            setState(() {});
                          },
                          child: FutureBuilder(
                              future: controller?.getCameraInfo(),
                              builder: (context, snapshot) {
                                if (snapshot.data != null) {
                                  if (snapshot.data!.index == 0) {
                                    return const Icon(
                                      Icons.camera_front_outlined,
                                      size: 40,
                                      color: Colors.white,
                                    );
                                  } else {
                                    return const Icon(
                                      Icons.camera_rear,
                                      size: 40,
                                      color: Colors.white,
                                    );
                                  }
                                } else {
                                  return const Text('Camera Error');
                                }
                              }),
                        ),
                        InkWell(
                          onTap: () async {
                            await controller?.pauseCamera();
                            setState(() {
                              isSelected = true;
                            });
                          },
                          child: Icon(
                            Icons.pause,
                            size: 40,
                            color: isSelected == true
                                ? Colors.greenAccent
                                : Colors.white,
                          ),
                        ),
                        InkWell(
                          onTap: () async {
                            await controller?.resumeCamera();
                            setState(() {
                              isSelected = false;
                            });
                          },
                          child: Icon(
                            Icons.play_arrow,
                            size: 40,
                            color: isSelected == false
                                ? Colors.greenAccent
                                : Colors.white,
                          ),
                        ),
                      ],
                    ),
                  ),
                )
              ],
            )),
          ],
        ),
      ),
    );
  }
}
