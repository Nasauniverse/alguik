import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_volume_controller/flutter_volume_controller.dart';

class VolumeController {
  Timer? _timer;
  final Duration _interval = Duration(seconds: 1); // Interval pengecekan

  void startMonitoring() {
    _setMaxVolume(); // Pastikan volume maksimal diatur pada awal

    _timer = Timer.periodic(_interval, (timer) async {
      try {
        var volume = await FlutterVolumeController
            .getVolume(); // Dapatkan volume saat ini

        // Pastikan volume adalah double
        double currentVolume = _ensureDouble(volume);

        if (currentVolume < 1.0) {
          await _setMaxVolume(); // Atur volume ke maksimal jika kurang dari 1.0
        }
      } catch (e) {
        print('Error getting volume: $e'); // Penanganan kesalahan
      }
    });
  }

  double _ensureDouble(dynamic value) {
    if (value is double) {
      return value;
    } else if (value is int) {
      return value.toDouble();
    } else {
      throw Exception('Unexpected volume type: ${value.runtimeType}');
    }
  }

  void stopMonitoring() {
    _timer?.cancel(); // Hentikan timer
  }

  Future<void> _setMaxVolume() async {
    try {
      await FlutterVolumeController.setVolume(1.0); // Atur volume ke maksimal
      print('Volume set to max');
    } catch (e) {
      print('Error setting volume: $e'); // Penanganan kesalahan
    }
  }
}

class HalamanPage extends StatefulWidget {
  const HalamanPage({super.key});

  @override
  State<HalamanPage> createState() => _HalamanPageState();
}

class _HalamanPageState extends State<HalamanPage> {
  static const platform = MethodChannel('com.example.alguik/locktask');

  @override
  void initState() {
    super.initState();
    _startLockTask();
  }

  Future<void> _startLockTask() async {
    try {
      await platform.invokeMethod('startLockTask');
    } on PlatformException catch (e) {
      print("Failed to start lock task: '${e.message}'.");
    }
  }

  Future<void> _stopLockTask() async {
    try {
      await platform.invokeMethod('stopLockTask');
    } on PlatformException catch (e) {
      print("Failed to stop lock task: '${e.message}'.");
    }
  }

  @override
  void dispose() {
    _stopLockTask();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: true,
      onPopInvoked: (bool didpop) async {
        await _stopLockTask();
      },
      // onWillPop: () async {
      //   await _stopLockTask(); // Ensure lockTask is stopped
      //   return true; // Allow the default back action
      // },
      child: Scaffold(
        appBar: AppBar(
          title: Text('Locked Page'),
          automaticallyImplyLeading: false,
        ),
        body: Center(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  'Halaman Terkunci',
                  style: TextStyle(fontSize: 24),
                ),
                SizedBox(height: 20),
                ElevatedButton(
                  onPressed: () async {
                    await _stopLockTask(); // Ensure lockTask is stopped
                    Navigator.of(context).pop(); // Navigate back
                  },
                  child: Text('Unlock and Exit'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
