import 'package:flutter/material.dart';
import 'package:speech_to_text/speech_to_text.dart';
import 'package:url_launcher/url_launcher.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Speech to Text',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.deepPurple,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: const SpeechScreen(),
    );
  }
}

class SpeechScreen extends StatefulWidget {
  const SpeechScreen({super.key});

  @override
  _SpeechScreenState createState() => _SpeechScreenState();
}

class _SpeechScreenState extends State<SpeechScreen> {
  final SpeechToText _speechToText = SpeechToText();
  bool _isSpeechEnabled = false;
  String _wordsSpoken = "";

  @override
  void initState() {
    super.initState();
    initSpeech();
  }

  void initSpeech() async {
    _isSpeechEnabled = await _speechToText.initialize();
    setState(() {});
  }

  void _startListening() async {
    await _speechToText.listen(onResult: _onSpeechResult);
    setState(() {});
  }

  void _stopListening() async {
    await _speechToText.stop();
    setState(() {});
  }

  void _onSpeechResult(result) {
    setState(() {
      _wordsSpoken = result.recognizedWords;
    });
    _performAction(_wordsSpoken);
  }

  void _performAction(String command) async {
    if (command.toLowerCase().contains('open gmail')) {
      final Uri email = Uri(
        scheme: 'mailto',
      );
      if (await launchUrl(email)) {
        await launchUrl(email);
      } else {
        throw 'Could not launch $email';
      }
    } else if (command.toLowerCase() == ('search')) {
      final startIndex = command.toLowerCase().indexOf('search') + 6;
      if (startIndex < command.length) {
        const query = "";
        final url = Uri.https('www.google.com', '/search', {'q': query});
        try {
          if (await launchUrl(url)) {
            await launchUrl(url);
          } else {
            throw 'Could not launch $url';
          }
        } catch (e) {
          throw 'Could not launch $url';
        }
      }
    } else if (command.toLowerCase().contains('search')) {
      final startIndex = command.toLowerCase().indexOf('search') + 6;
      if (startIndex < command.length) {
        final query =
            command.substring(command.toLowerCase().indexOf('search') + 7);
        final url = Uri.https('www.google.com', '/search', {'q': query});
        try {
          if (await launchUrl(url)) {
            await launchUrl(url);
          } else {
            throw 'Could not launch $url';
          }
        } catch (e) {
          throw 'Could not launch $url';
        }
      }
    } else if (command.toLowerCase().contains('open youtube')) {
      final url = Uri.https('www.youtube.com');
      try {
        if (await launchUrl(url)) {
          await launchUrl(url);
        } else {
          throw 'Could not launch $url';
        }
      } catch (e) {
        throw 'Could not launch $url';
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color.fromARGB(255, 110, 80, 163),
        title: const Center(
          child: Text(
            'Speech To Text',
            style: TextStyle(
              color: Colors.white,
            ),
          ),
        ),
      ),
      body: Center(
        child: Column(
          children: [
            Container(
              padding: const EdgeInsets.all(16),
              child: Text(
                _speechToText.isListening
                    ? "Listening... say something cool!"
                    : _isSpeechEnabled
                        ? "Tap the mic, and let's rock 'n' roll!"
                        : "Oops! Speech recognition isn't available.",
                style: const TextStyle(
                  fontSize: 20.0,
                  fontWeight: FontWeight.bold,
                  color: Colors.blueAccent,
                ),
              ),
            ),
            Expanded(
              child: Container(
                padding: const EdgeInsets.all(16),
                child: Text(
                  _wordsSpoken,
                  style: const TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.w400,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _speechToText.isListening ? _stopListening : _startListening,
        tooltip: 'Listen',
        backgroundColor: const Color.fromARGB(255, 110, 80, 163),
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Icon(
            _speechToText.isNotListening ? Icons.mic_off : Icons.mic,
            color: Colors.white,
          ),
        ),
      ),
    );
  }
}
