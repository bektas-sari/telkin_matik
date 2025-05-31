import 'package:flutter/material.dart';

void main() {
  runApp(const TelkinMatikApp());
}

class TelkinMatikApp extends StatefulWidget {
  const TelkinMatikApp({super.key});

  @override
  State<TelkinMatikApp> createState() => _TelkinMatikAppState();
}

class _TelkinMatikAppState extends State<TelkinMatikApp> {
  bool isDarkMode = false;

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Telkin Matik',
      debugShowCheckedModeBanner: false,
      theme: isDarkMode ? ThemeData.dark() : ThemeData.light(),
      home: TelkinScreen(
        isDarkMode: isDarkMode,
        onThemeToggle: () {
          setState(() {
            isDarkMode = !isDarkMode;
          });
        },
      ),
    );
  }
}

class TelkinScreen extends StatefulWidget {
  final bool isDarkMode;
  final VoidCallback onThemeToggle;

  const TelkinScreen({
    super.key,
    required this.isDarkMode,
    required this.onThemeToggle,
  });

  @override
  State<TelkinScreen> createState() => _TelkinScreenState();
}

class _TelkinScreenState extends State<TelkinScreen> {
  int _counter = 0;
  String _telkinCumlesi = "Ben değerliyim";
  final TextEditingController _controller = TextEditingController();

  TextStyle _getTelkinStyle() {
    double scale = 1 + (_counter ~/ 10) * 0.2;
    FontWeight weight;
    Color color;

    if (_counter < 10) {
      weight = FontWeight.w300;
      color = Colors.grey;
    } else if (_counter < 20) {
      weight = FontWeight.w500;
      color = Colors.blueGrey;
    } else {
      weight = FontWeight.bold;
      color = Colors.indigo;
    }

    return TextStyle(
      fontSize: 24 * scale,
      fontWeight: weight,
      color: color,
    );
  }

  void _increaseCounter() {
    if (_counter >= 50) {
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: const Text("Bugünlük yeterli"),
          content: const Text("Harika bir iş çıkardın! Kendine iyi bak."),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text("Tamam"),
            ),
          ],
        ),
      );
      return;
    }

    setState(() {
      _counter++;
    });
  }


  void _resetCounter() {
    setState(() {
      _counter = 0;
    });
  }

  void _changeTelkinText() {
    if (_controller.text.trim().isNotEmpty) {
      setState(() {
        _telkinCumlesi = _controller.text.trim();
        _counter = 0;
        _controller.clear();
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Telkin Matik'),
        actions: [
          IconButton(
            onPressed: _resetCounter,
            icon: const Icon(Icons.refresh),
            tooltip: "Sıfırla",
          ),
          Switch(
            value: widget.isDarkMode,
            onChanged: (_) => widget.onThemeToggle(),
          )
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(32.0),
        child: Column(
          children: [
            Text(
              _telkinCumlesi,
              style: _getTelkinStyle(),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 20),
            Text("Tekrar sayısı: $_counter"),
            const SizedBox(height: 40),
            ElevatedButton(
              onPressed: _increaseCounter,
              child: const Text("Tekrar Ettim"),
            ),
            const Divider(height: 50),
            TextField(
              controller: _controller,
              decoration: const InputDecoration(
                labelText: "Yeni Telkin Cümlesi",
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 10),
            ElevatedButton(
              onPressed: _changeTelkinText,
              child: const Text("Cümleyi Değiştir"),
            ),
          ],
        ),
      ),
    );
  }
}
