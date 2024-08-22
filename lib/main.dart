import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:go_router/go_router.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import 'domain/home/home_page.dart';
import 'domain/score/score_detail_page.dart';
import 'domain/score/score_list_page.dart';

void main() {
  runApp(const ProviderScope(
    child: MyApp(),
  ));
}

class MyApp extends HookWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    final router = useMemoized(() => GoRouter(
          routes: [
            GoRoute(
                path: '/',
                builder: (context, state) => const HomePage(),
                routes: [
                  GoRoute(
                    path: 'scores',
                    builder: (context, state) => const ScoreListPage(),
                    routes: [
                      GoRoute(
                        path: ':id',
                        builder: (context, state) => ScoreDetailPage(
                          id: int.parse(state.pathParameters['id']!),
                        ),
                      ),
                    ],
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
