import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import 'custom_hook.dart';

class ScoreDetailPage extends HookConsumerWidget {
  final int id;

  const ScoreDetailPage({super.key, required this.id});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final scoresResult = useScores(ref);
    final score = scoresResult.getScoreById(id);

    if (score == null) {
      return Scaffold(
        appBar: AppBar(
          title: const Text('점수 상세 페이지'),
        ),
        body: const Center(
          child: Text('점수를 찾을 수 없습니다.'),
        ),
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text('점수 상세 페이지'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'ID: ${score.id}',
              style: const TextStyle(fontSize: 24),
            ),
            Text(
              '점수: ${score.content}',
              style: const TextStyle(fontSize: 24),
            ),
            const SizedBox(height: 20),
            Text(
              '생성날짜: ${score.createdAt}',
              style: const TextStyle(fontSize: 16, color: Colors.grey),
            ),
            Text(
              '수정날짜: ${score.updatedAt}',
              style: const TextStyle(fontSize: 16, color: Colors.grey),
            ),
          ],
        ),
      ),
    );
  }
}
