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
    final number1 = useState(30);
    final number2 = useState(30);
    final number3 = useState(30);

    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text('number1 : ${number1.value}',
                    style: TextStyle(
                      fontSize: number1.value.toDouble(),
                    )),
                TextButton(onPressed: () {}, child: const Text("+")),
                TextButton(onPressed: () {}, child: const Text("-")),
              ],
            ),
            GestureDetector(
                onTap: () {
                  number2.value++;
                },
                child: Text('number2 : ${number2.value}',
                    style: TextStyle(
                      fontSize: number2.value.toDouble(),
                    ))),
            GestureDetector(
                onTap: () {
                  number3.value++;
                },
                child: Text('number3 : ${number3.value}',
                    style: TextStyle(
                      fontSize: number3.value.toDouble(),
                    ))),
          ],
        ),
      ),
    );
  }
}
