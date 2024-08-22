import 'package:flutter/material.dart';

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
