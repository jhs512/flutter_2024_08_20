import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:go_router/go_router.dart';

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
            context.go('/scores');
          },
          child: const Text('점수 리스트 페이지로 이동'),
        ),
      ),
    );
  }
}
