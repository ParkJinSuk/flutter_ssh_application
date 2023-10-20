import 'dart:io';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:yaml/yaml.dart';
import 'package:yaml_writer/yaml_writer.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter SSH Program',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const MyHomePage(title: '메인 페이지'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  int _counter1 = 0;
  int _counter2 = 0;

  @override
  void initState() {
    super.initState();
    _loadCounters();
  }

  void _loadCounters() async {
    try {
      final file = File('dm_config.yaml');
      if (await file.exists()) {
        final contents = await file.readAsString();
        final yamlData = loadYaml(contents);

        setState(() {
          _counter1 = yamlData['counter1'] ?? 0;
          _counter2 = yamlData['counter2'] ?? 0;
        });
      }
    } catch (e) {
      print('Error loading counters: $e');
    }
  }

  void _incrementCounters() {
    setState(() {
      _counter1++;
      _counter2--;
      _saveCounters();
    });
  }

  void _saveCounters() async {
    try {
      final file = File('dm_config.yaml');
      var yamlWriter = YAMLWriter();
      var yamlDoc = yamlWriter.write({
        'counter1': _counter1,
        'counter2': _counter2,
      });
      await file.writeAsString(yamlDoc);
    } catch (e) {
      print('Error saving counters: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text(widget.title),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            const Text(
              'Counter 1:',
            ),
            Text(
              '$_counter1',
              style: Theme.of(context).textTheme.headlineMedium,
            ),
            const Text(
              'Counter 2:',
            ),
            Text(
              '$_counter2',
              style: Theme.of(context).textTheme.headlineMedium,
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _incrementCounters,
        tooltip: 'Increment',
        child: const Icon(Icons.add),
      ),
    );
  }
}
