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
    final count = useRef(0);
    final scores = useState(<int>[]);
    final sortAsc = useState(true);

    final textEditingController = TextEditingController();

    print("renderCount : ${count.value++}");

    return Scaffold(
      body: Center(
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                SizedBox(
                    width: 200,
                    child: TextField(
                      controller: textEditingController,
                      keyboardType: TextInputType.number,
                      decoration: const InputDecoration(
                        labelText: '점수',
                        hintText: '점수를 입력하세요.',
                      ),
                    )),
                ElevatedButton(
                  onPressed: () {
                    if (textEditingController.text.isEmpty) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text('점수를 입력하세요.'),
                        ),
                      );
                      return;
                    }

                    final newScore = int.parse(textEditingController.text);

                    scores.value = [...scores.value, newScore];
                  },
                  child: const Text('점수 추가'),
                ),
                ElevatedButton(
                  onPressed: () {
                    sortAsc.value = !sortAsc.value;
                  },
                  child: Text('${sortAsc.value ? '정순' : '역순'}정렬'),
                ),
              ],
            ),
            Expanded(
              child: SingleChildScrollView(
                child: Column(
                  children: (sortAsc.value
                          ? scores.value
                          : scores.value.reversed.toList())
                      .asMap()
                      .entries
                      .map((entry) {
                    final index = entry.key;
                    final score = entry.value;

                    return Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Text(
                            '점수: $score',
                            style: const TextStyle(
                              fontSize: 20,
                            ),
                          ),
                        ),
                        TextButton(
                            onPressed: () {
                              scores.value = [
                                ...scores.value.sublist(0, index),
                                score - 1,
                                ...scores.value.sublist(index + 1),
                              ];
                            },
                            child: const Text('+')),
                        TextButton(
                            onPressed: () {
                              scores.value = [
                                ...scores.value.sublist(0, index),
                                score - 1,
                                ...scores.value.sublist(index + 1),
                              ];
                            },
                            child: const Text('-')),
                        TextButton(
                            onPressed: () {
                              scores.value = List.from(scores.value)
                                ..removeAt(index);
                            },
                            child: const Text('삭제')),
                      ],
                    );
                  }).toList(),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
