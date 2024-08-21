import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
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

class Score {
  static int lastId = 0;

  final int id;
  int content;
  final DateTime createdAt;
  DateTime updatedAt;

  Score({
    required this.content,
  })  : id = ++lastId,
        createdAt = DateTime.now(),
        updatedAt = DateTime.now();

  void increment() {
    content++;
    updatedAt = DateTime.now();
  }

  void decrement() {
    content--;
    updatedAt = DateTime.now();
  }
}

class HomeMainPage extends HookWidget {
  const HomeMainPage({super.key});

  @override
  Widget build(BuildContext context) {
    final scores = useState(<Score>[]);
    final sortAsc = useState(true);

    final textEditingController = useTextEditingController();
    final focusNode = useFocusNode();
    final scoreFormFieldKey =
        useMemoized(() => GlobalKey<FormFieldState<String>>());

    void addScore() {
      if (scoreFormFieldKey.currentState?.validate() == false) {
        focusNode.requestFocus();
        return;
      }

      final newScoreValue = int.parse(textEditingController.text);
      textEditingController.clear();
      focusNode.requestFocus();

      final newScore = Score(content: newScoreValue); // 새 Score 객체 생성
      scores.value = [...scores.value, newScore];
    }

    return Scaffold(
      body: Center(
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                SizedBox(
                  width: 200,
                  child: TextFormField(
                    key: scoreFormFieldKey,
                    controller: textEditingController,
                    focusNode: focusNode,
                    keyboardType: TextInputType.number,
                    inputFormatters: [
                      FilteringTextInputFormatter.digitsOnly,
                    ],
                    decoration: const InputDecoration(
                      labelText: '점수',
                      hintText: '점수를 입력하세요.',
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return '숫자를 입력해주세요';
                      } else if (int.tryParse(value) == null) {
                        return '유효한 숫자를 입력해주세요';
                      }
                      return null;
                    },
                    onFieldSubmitted: (value) {
                      addScore();
                    },
                  ),
                ),
                ElevatedButton(
                  onPressed: addScore,
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
              child: ListView.builder(
                itemCount: scores.value.length,
                itemBuilder: (context, index) {
                  final displayedScores = sortAsc.value
                      ? scores.value
                      : scores.value.reversed.toList();

                  final score = displayedScores[index];

                  return Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'ID: ${score.id} 점수: ${score.content}',
                              style: const TextStyle(
                                fontSize: 20,
                              ),
                            ),
                            Text(
                              '생성: ${score.createdAt} 수정: ${score.updatedAt}',
                              style: const TextStyle(
                                fontSize: 12,
                                color: Colors.grey,
                              ),
                            ),
                          ],
                        ),
                      ),
                      TextButton(
                        onPressed: () {
                          score.increment(); // 점수 증가 및 수정 날짜 갱신
                          scores.value = List.from(scores.value);
                        },
                        child: const Text('+'),
                      ),
                      TextButton(
                        onPressed: () {
                          score.decrement(); // 점수 감소 및 수정 날짜 갱신
                          scores.value = List.from(scores.value);
                        },
                        child: const Text('-'),
                      ),
                      TextButton(
                        onPressed: () {
                          scores.value = List.from(scores.value)
                            ..removeAt(index);
                        },
                        child: const Text('삭제'),
                      ),
                    ],
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
