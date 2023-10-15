import 'package:flutter/material.dart';

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      home: acercaDe(),
    );
  }
}

// ignore: camel_case_types
class acercaDe extends StatelessWidget {
  const acercaDe({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Integrantes'),
      ),
      body: const Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text(
              'Integrantes:',
              style: TextStyle(fontSize: 24),
            ),
            SizedBox(height: 16),
            Text('Daniel Michel'),
          ],
        ),
      ),
    );
  }
}
