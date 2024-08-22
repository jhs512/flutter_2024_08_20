import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import 'score.dart';

class ScoresNotifier extends Notifier<List<Score>> {
  @override
  List<Score> build() {
    return [];
  }

  void addScore(int content) {
    final newScore = Score(
      id: ++Score.lastId,
      content: content,
      createdAt: DateTime.now(),
      updatedAt: DateTime.now(),
    );
    state = [...state, newScore];
  }

  void removeScore(int id) {
    state = state.where((score) => score.id != id).toList();
  }

  void editScore(int id, int delta) {
    state = state.map((score) {
      if (score.id == id) {
        return delta == 1 ? score.increment() : score.decrement();
      }
      return score;
    }).toList();
  }

  Score? getScoreById(int id) {
    return state.firstWhere((score) => score.id == id);
  }
}

final scoresProvider =
    NotifierProvider<ScoresNotifier, List<Score>>(ScoresNotifier.new);

({
  bool sortAsc,
  List<Score> sortedScores,
  void Function(int content) addScore,
  void Function(int id) removeScore,
  void Function(int id, int delta) editScore,
  void Function() toggleSortOrder,
  Score? Function(int id) getScoreById,
}) useScores(WidgetRef ref) {
  final scores = ref.watch(scoresProvider);
  final sortAsc = useState(true);

  void addScore(int content) {
    ref.read(scoresProvider.notifier).addScore(content);
  }

  void removeScore(int id) {
    ref.read(scoresProvider.notifier).removeScore(id);
  }

  void editScore(int id, int delta) {
    ref.read(scoresProvider.notifier).editScore(id, delta);
  }

  void toggleSortOrder() {
    sortAsc.value = !sortAsc.value;
  }

  List<Score> getSortedScores() {
    return sortAsc.value ? scores : scores.reversed.toList();
  }

  Score? getScoreById(int id) {
    return ref.read(scoresProvider.notifier).getScoreById(id);
  }

  return (
    sortAsc: sortAsc.value,
    sortedScores: getSortedScores(),
    addScore: addScore,
    removeScore: removeScore,
    editScore: editScore,
    toggleSortOrder: toggleSortOrder,
    getScoreById: getScoreById,
  );
}
