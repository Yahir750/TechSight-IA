import 'package:flutter/material.dart';
import 'package:flutter_tts/flutter_tts.dart';
import 'package:speech_to_text/speech_to_text.dart' as stt;
import 'package:vibration/vibration.dart';

void main() {
  runApp(const TechSightApp());
}

class TechSightApp extends StatelessWidget {
  const TechSightApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      debugShowCheckedModeBanner: false,
      home: HomeScreen(),
    );
  }
}

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final FlutterTts flutterTts = FlutterTts();
  final stt.SpeechToText speech = stt.SpeechToText();
  bool isListening = false;

  @override
  void initState() {
    super.initState();
    _startApp();
  }

  Future<void> _startApp() async {
    // Vibración al iniciar
    if (await Vibration.hasVibrator()) {
      Vibration.vibrate(duration: 500);
    }

    // Mensaje de voz al iniciar
    await flutterTts.speak(
      "Aplicación preparada, preciona la parte de arriba para usar la càmara de tus lentes y la de abajo para la càmara de tu celular",
    );

    // Iniciar escucha automática
    Future.delayed(const Duration(seconds: 2), () => _startListening());
  }

  void _startListening() async {
    bool available = await speech.initialize(
      // ignore: avoid_print
      onStatus: (status) => print("Estado: $status"),
      // ignore: avoid_print
      onError: (error) => print("Error: $error"),
    );

    if (available) {
      setState(() => isListening = true);
      speech.listen(
        onResult: (result) {
          String command = result.recognizedWords.toLowerCase();
          if (command.contains("utilizar cámara")) {
            _speak("Abriendo cámara");
          } else if (command.contains("utilizar lentes")) {
            _speak("Activando lentes");
          } else {
            _speak("No entendí, por favor repite");
          }
        },
      );
    }
  }

  Future<void> _speak(String text) async {
    await flutterTts.speak(text);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 88, 96, 96),
      appBar: AppBar(
        title: const Text(
          'TechSight IA',
          style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
        backgroundColor: const Color.fromARGB(255, 54, 58, 57),
        leading: const Icon(
          Icons.remove_red_eye,
          color: Color.fromARGB(255, 44, 111, 187),
        ),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ElevatedButton.icon(
              onPressed: () {
                _speak("Activando lentes");
              },
              icon: const Icon(Icons.remove_red_eye, color: Colors.white),
              label: const Text("Utilizar lentes"),
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color.fromARGB(255, 35, 114, 37),
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(
                  horizontal: 60,
                  vertical: 120,
                ),
                textStyle: const TextStyle(
                  fontSize: 30,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            const SizedBox(height: 20),
            ElevatedButton.icon(
              onPressed: () {
                _speak("Abriendo cámara");
              },
              icon: const Icon(Icons.camera_alt, color: Colors.black),
              label: const Text("Utilizar cámara"),
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color.fromARGB(255, 255, 255, 255),
                foregroundColor: Colors.black,
                padding: const EdgeInsets.symmetric(
                  horizontal: 50,
                  vertical: 120,
                ),
                textStyle: const TextStyle(
                  fontSize: 30,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
