import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:go_router/go_router.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends HookWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    final router = useMemoized(() => GoRouter(
          routes: [
            GoRoute(
                path: '/',
                builder: (context, state) => const ScoreListPage(),
                routes: [
                  GoRoute(
                    path: 'scores',
                    builder: (context, state) => const HomePage(),
                  )
                ])
          ],
        ));

    return MaterialApp.router(
      routerConfig: router,
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
    );
  }
}

class HomePage extends HookWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('홈'),
      ),
      body: Center(
        child: ElevatedButton(
          onPressed: () {
            // 버튼을 눌렀을 때 '/scores' 페이지로 이동
            context.go('/');
          },
          child: const Text('점수 리스트 페이지로 이동'),
        ),
      ),
    );
  }
}

@immutable
class Score {
  static int lastId = 0;

  final int id;
  final int content;
  final DateTime createdAt;
  final DateTime updatedAt;

  const Score({
    required this.id,
    required this.content,
    required this.createdAt,
    required this.updatedAt,
  });

  Score increment() {
    return Score(
      id: id,
      content: content + 1,
      createdAt: createdAt,
      updatedAt: DateTime.now(),
    );
  }

  Score decrement() {
    return Score(
      id: id,
      content: content - 1,
      createdAt: createdAt,
      updatedAt: DateTime.now(),
    );
  }
}

// useScores Hook을 정의
({
  bool sortAsc,
  List<Score> sortedScores,
  void Function(int content) addScore,
  void Function(int id) removeScore,
  void Function(int id, int delta) editScore,
  void Function() toggleSortOrder,
}) useScores() {
  final scores = useState(<Score>[]);
  final sortAsc = useState(true);

  void addScore(int content) {
    final newScore = Score(
      id: ++Score.lastId,
      content: content,
      createdAt: DateTime.now(),
      updatedAt: DateTime.now(),
    );
    scores.value = [...scores.value, newScore];
  }

  void removeScore(int id) {
    scores.value = scores.value.where((score) => score.id != id).toList();
  }

  void editScore(int id, int delta) {
    scores.value = scores.value.map((score) {
      if (score.id == id) {
        return delta == 1 ? score.increment() : score.decrement();
      }
      return score;
    }).toList();
  }

  void toggleSortOrder() {
    sortAsc.value = !sortAsc.value;
  }

  List<Score> getSortedScores() {
    return sortAsc.value ? scores.value : scores.value.reversed.toList();
  }

  return (
    sortAsc: sortAsc.value,
    sortedScores: getSortedScores(),
    addScore: addScore,
    removeScore: removeScore,
    editScore: editScore,
    toggleSortOrder: toggleSortOrder,
  );
}

class ScoreListPage extends HookWidget {
  const ScoreListPage({super.key});

  @override
  Widget build(BuildContext context) {
    final textEditingController = useTextEditingController();
    final focusNode = useFocusNode();
    final scoreFormFieldKey =
        useMemoized(() => GlobalKey<FormFieldState<String>>());

    final scoresResult = useScores();

    void handleAddScore() {
      if (scoreFormFieldKey.currentState?.validate() == false) {
        focusNode.requestFocus();
        return;
      }

      final newScoreValue = int.parse(textEditingController.text);
      textEditingController.clear();
      focusNode.requestFocus();

      scoresResult.addScore(newScoreValue);
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text('점수 리스트'),
      ),
      body: Center(
        child: Column(
          children: [
            TextButton(
                onPressed: () {
                  context.go('/scores');
                },
                child: const Text('홈으로 이동')),
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
                      handleAddScore();
                    },
                  ),
                ),
                ElevatedButton(
                  onPressed: handleAddScore,
                  child: const Text('점수 추가'),
                ),
                ElevatedButton(
                  onPressed: () {
                    scoresResult.toggleSortOrder();
                  },
                  child: Text('${scoresResult.sortAsc ? '정순' : '역순'}정렬'),
                ),
              ],
            ),
            Expanded(
              child: ListView.builder(
                itemCount: scoresResult.sortedScores.length,
                itemBuilder: (context, index) {
                  final score = scoresResult.sortedScores[index];

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
                          scoresResult.editScore(score.id, 1);
                        },
                        child: const Text('+'),
                      ),
                      TextButton(
                        onPressed: () {
                          scoresResult.editScore(score.id, -1);
                        },
                        child: const Text('-'),
                      ),
                      TextButton(
                        onPressed: () {
                          scoresResult.removeScore(score.id);
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
