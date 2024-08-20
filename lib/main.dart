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
    final number1 = useState(10);
    final number2 = useState(10);
    final number3 = useState(10);

    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            GestureDetector(
                onTap: () {
                  number1.value++;
                },
                child: Text('number : ${number1.value}',
                    style: const TextStyle(
                      fontSize: 30,
                    ))),
            GestureDetector(
                onTap: () {
                  number2.value++;
                },
                child: Text('number : ${number2.value}',
                    style: const TextStyle(
                      fontSize: 30,
                    ))),
            GestureDetector(
                onTap: () {
                  number3.value++;
                },
                child: Text('number : ${number3.value}',
                    style: const TextStyle(
                      fontSize: 30,
                    ))),
          ],
        ),
      ),
    );
  }
}
