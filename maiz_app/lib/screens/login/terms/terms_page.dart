import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter_pdfview/flutter_pdfview.dart';
import 'package:path_provider/path_provider.dart';
import 'dart:io';
import 'package:flutter/services.dart';
import 'package:permission_handler/permission_handler.dart';

class TermsAndConditionsPage extends StatefulWidget {
  const TermsAndConditionsPage({super.key});

  @override
  State<TermsAndConditionsPage> createState() => _TermsAndConditionsPageState();
}

class _TermsAndConditionsPageState extends State<TermsAndConditionsPage> {
  String? localPath;

  @override
  void initState() {
    super.initState();
    _loadPdf();
  }

  Future<void> _loadPdf() async {
    try {
      final byteData =
          await rootBundle.load('assets/terms/terms_and_conditions.pdf');
      final tempDir = await getTemporaryDirectory();
      final file = File('${tempDir.path}/terms_and_conditions.pdf');

      await file.writeAsBytes(byteData.buffer.asUint8List(), flush: true);
      setState(() {
        localPath = file.path;
      });
    } catch (e) {
      print("Error cargando el PDF: $e");
    }
  }

  Future<Directory?> getDownloadsDirectory() async {
    if (Platform.isAndroid) {
      final directory = Directory('/storage/emulated/0/Download');
      if (await directory.exists()) {
        return directory;
      } else {
        return await getExternalStorageDirectory(); // Por si falla
      }
    } else {
      return await getDownloadsDirectory();
    }
  }
  Future<void> _requestStoragePermission() async {
    var status = await Permission.storage.status;

    if (status.isDenied || status.isPermanentlyDenied) {
      status = await Permission.storage.request();
    }

    if (status.isGranted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Permiso concedido')),
      );
    } else if (status.isPermanentlyDenied) {
      openAppSettings(); // Esto lleva al usuario a los ajustes si bloqueó el permiso
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Permiso denegado')),
      );
    }
  }

 final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
    FlutterLocalNotificationsPlugin();

  Future<void> _initNotifications() async {
    const AndroidInitializationSettings initializationSettingsAndroid =
        AndroidInitializationSettings('@mipmap/ic_launcher');

    const InitializationSettings initializationSettings =
        InitializationSettings(android: initializationSettingsAndroid);

    await flutterLocalNotificationsPlugin.initialize(initializationSettings);
  }

  Future<void> _showDownloadProgressNotification(int progress) async {
    const AndroidNotificationDetails androidPlatformChannelSpecifics =
        AndroidNotificationDetails(
      'download_channel',
      'Descargas',
      channelDescription: 'Notificaciones de descargas',
      importance: Importance.high,
      priority: Priority.high,
      onlyAlertOnce: true,
      showProgress: true,
      maxProgress: 100,
      progress: 0,
    );

    const NotificationDetails platformChannelSpecifics =
        NotificationDetails(android: androidPlatformChannelSpecifics);

    await flutterLocalNotificationsPlugin.show(
      0,
      'Descargando PDF',
      '$progress% completado',
      platformChannelSpecifics,
    );
  }

  Future<void> _downloadPdf() async {
    await _initNotifications(); // Inicializa las notificaciones

    var status = await Permission.manageExternalStorage.status;
    if (!status.isGranted) {
      status = await Permission.manageExternalStorage.request();
      if (!status.isGranted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Permiso denegado para el almacenamiento.')),
        );
        if (status.isPermanentlyDenied) {
          await openAppSettings();
        }

        return;
      }
    }

    try {
      final byteData = await rootBundle.load('assets/terms/terms_and_conditions.pdf');
      final downloadDir = await getDownloadsDirectory();

      if (downloadDir != null) {
        final file = File('${downloadDir.path}/terms_and_conditions.pdf');

        const totalBytes = 100;
        int writtenBytes = 0;

        // Simulación de progreso
        for (int i = 1; i <= totalBytes; i++) {
          await Future.delayed(const Duration(milliseconds: 50));
          writtenBytes = i;
          await _showDownloadProgressNotification((writtenBytes / totalBytes * 100).toInt());
        }

        await file.writeAsBytes(byteData.buffer.asUint8List(), flush: true);

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('PDF guardado en ${file.path}')),
        );

        // Notificación de descarga completa
        await flutterLocalNotificationsPlugin.cancel(0); // Elimina la notificación de progreso
        await flutterLocalNotificationsPlugin.show(
          1,
          'Descarga completada',
          'El PDF se ha guardado correctamente',
          const NotificationDetails(
            android: AndroidNotificationDetails(
              'download_channel',
              'Descargas',
              channelDescription: 'Notificaciones de descargas',
              importance: Importance.high,
              priority: Priority.high,
            ),
          ),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('No se pudo acceder al directorio de descargas.')),
        );
      }
    } catch (e) {
      print('Error al descargar el PDF: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Error al guardar el PDF')),
      );
    }
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Términos y Condiciones'),
        actions: [
          IconButton(
            icon: const Icon(Icons.download),
            onPressed: _downloadPdf,
          ),
        ],
      ),
      body: localPath == null
          ? const Center(child: CircularProgressIndicator())
          : PDFView(
              filePath: localPath!,
              enableSwipe: true,
              swipeHorizontal: false,
              autoSpacing: true,
              pageFling: true,
            ),
    );
  }
}
