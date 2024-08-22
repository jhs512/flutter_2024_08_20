import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:go_router/go_router.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import 'custom_hook.dart';

class ScoreListPage extends HookConsumerWidget {
  const ScoreListPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final textEditingController = useTextEditingController();
    final focusNode = useFocusNode();
    final scoreFormFieldKey =
        useMemoized(() => GlobalKey<FormFieldState<String>>());

    final scoresResult = useScores(ref);

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
                            // 생성날짜, 수정날짜 표시 제거
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
                      TextButton(
                        onPressed: () {
                          context.go('/scores/${score.id}');
                        },
                        child: const Text('상세보기'),
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
