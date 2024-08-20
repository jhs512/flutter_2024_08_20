import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const HomeMainPage(),
    );
  }
}

class HomeMainPage extends HookWidget {
  const HomeMainPage({super.key});

  @override
  Widget build(BuildContext context) {
    final scores = useState(<int>[10, 20, 30]);

    return Scaffold(
      body: Center(
        child: Column(
          children: [
            ElevatedButton(
              onPressed: () {
                final newScore = scores.value.last + 10;
                scores.value = [...scores.value, newScore];
              },
              child: const Text('점수 추가'),
            ),
            const Text('점수 시작'),
            Expanded(
              child: SingleChildScrollView(
                child: Column(
                  children: scores.value.map((score) {
                    return Text('점수: $score');
                  }).toList(),
                ),
              ),
            ),
            const Text('점수 끝'),
          ],
        ),
      ),
    );
  }
}
