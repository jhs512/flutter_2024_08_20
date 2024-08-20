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
    final number = useState(10);

    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            GestureDetector(
                onTap: () {
                  number.value++;
                  print('number : ${number.value}');
                },
                child: Text('number : ${number.value}')),
            GestureDetector(
                onTap: () {
                  number.value++;
                  print('number : ${number.value}');
                },
                child: Text('number : ${number.value}')),
            GestureDetector(
                onTap: () {
                  number.value++;
                  print('number : ${number.value}');
                },
                child: Text('number : ${number.value}')),
          ],
        ),
      ),
    );
  }
}
