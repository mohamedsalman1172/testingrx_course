import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:rxdart/rxdart.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: HomePage(),
    );
  }
}

class HomePage extends HookWidget {
  // late final BehaviorSubject<String> subject;
  // //final name = StreamController<String>();
  // @override
  // void initState() {
  //   super.initState();
  //   subject = BehaviorSubject<String>();
  // }

  // @override
  // void dispose() async {
  //   await subject.close();
  //   super.dispose();
  // }

  @override
  Widget build(BuildContext context) {
    // create our behavior subject every time the widget rebuilt
    final subject = useMemoized(
      () => BehaviorSubject<String>(),
      [key],
    );
    // dispose of the old subject every time the widget rebuilt
    useEffect(
      () => subject.close,
      [subject],
    );
    return Scaffold(
      appBar: AppBar(
        title: StreamBuilder<String>(
          stream: subject.stream
              .distinct()
              .debounceTime(const Duration(seconds: 1)),
          initialData: 'please start typing.....',
          builder: (context, snapshot) {
            return Text(snapshot.requireData);
          },
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: TextField(
          onChanged: subject.sink.add,
        ),
      ),
    );
  }
}
