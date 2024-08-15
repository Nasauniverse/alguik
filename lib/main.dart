import 'dart:async';
import 'package:alguik/provider/default_view_model.dart';
import 'package:alguik/routes/routes.dart';
import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_volume_controller/flutter_volume_controller.dart';
import 'package:provider/provider.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const MyApp());
}

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
        print('Error getting volume: $e'); 
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

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> with WidgetsBindingObserver {
  final AudioPlayer _audioPlayer = AudioPlayer();
  final VolumeController _volumeController = VolumeController();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    _volumeController.startMonitoring(); // Mulai monitoring volume
    print('WidgetsBindingObserver added in main widget'); // Debug statement
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    _audioPlayer.dispose();
    _volumeController.stopMonitoring(); // Hentikan monitoring volume
    print('WidgetsBindingObserver removed in main widget'); // Debug statement
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    super.didChangeAppLifecycleState(state);
    print('AppLifecycleState changed: $state'); // Debug statement
    if (state == AppLifecycleState.paused) {
      print('App minimized'); // Debug statement
      _playSound('sound/sirine.mp3');
      _volumeController
          .startMonitoring(); // Pastikan volume maksimal saat app diminimize
    } else if (state == AppLifecycleState.resumed) {
      print('App resumed'); // Debug statement
      _audioPlayer.stop();
      // _playSound('assets/sound/kaget.mp3');
      _volumeController
          .startMonitoring(); // Pastikan volume maksimal saat app kembali aktif
    }
  }

  void _playSound(String path) async {
    try {
      print('Playing sound: $path'); // Debug statement
      await _audioPlayer.play(AssetSource(path));
    } catch (e) {
      print('Error playing sound: $e'); // Penanganan kesalahan
    }
  }

  @override
  Widget build(BuildContext context) {
    SystemChrome.setPreferredOrientations(
        [DeviceOrientation.portraitUp, DeviceOrientation.portraitDown]);
    return MultiProvider(
      providers: [
        // ChangeNotifierProvider<HomeViewModel>(
        //     create: (context) => HomeViewModel()),
        ChangeNotifierProvider<DefaultViewModel>
        (create: (context) => DefaultViewModel()),

      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Paguyuban',
        onGenerateRoute: Routes.generateRoute,
        initialRoute: initRoute,
        builder: EasyLoading.init(),
      ),
    );
  }
}
