import 'dart:math';

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
    final random = Random();
    final scores = useState(<int>[]);

    return Scaffold(
      body: Center(
        child: Column(
          children: [
            ElevatedButton(
              onPressed: () {
                final newScore = random.nextInt(10) + 1;

                scores.value = [...scores.value, newScore];
              },
              child: const Text('점수 추가'),
            ),
            const Text('점수 시작'),
            Expanded(
              child: SingleChildScrollView(
                child: Column(
                  children: scores.value.asMap().entries.map((entry) {
                    final index = entry.key;
                    final score = entry.value;

                    return InkWell(
                      onTap: () {
                        scores.value = List.from(scores.value)..removeAt(index);
                      },
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Text(
                          '점수: $score',
                          style: const TextStyle(
                            fontSize: 20,
                          ),
                        ),
                      ),
                    );
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
