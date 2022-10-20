import 'dart:async';

import 'package:flutter/material.dart';

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
        primarySwatch: Colors.blue,
      ),
      home: const MyHomePage(title: 'Flutter Demo Home Page'),
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

  var stream;

  @override
  void initState() {
    super.initState();
    stream = NumberCreator().stream;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title,),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            StreamBuilder<int>(
                stream: stream,
                builder:
                    (BuildContext context, AsyncSnapshot<int> snapshot) {
                  if (snapshot.hasData) {
                    return Text("${snapshot.data}", style: TextStyle(fontSize: 40),);
                  } else if (snapshot.hasError) {
                    return Column(
                      children: [
                        const Icon(Icons.error),
                        Text(snapshot.error.toString())
                      ],
                    );
                  } else {
                    return const CircularProgressIndicator();
                  }
                })
          ],
        ),
      ),
    );
  }
}

class NumberCreator {
  var _count = 1;

  final _controller = StreamController<int>();

  NumberCreator() {
    Timer.periodic(const Duration(seconds: 1), (t) {
      if (_count % 10 == 4) {
        _controller.sink.addError("$_count acaba en 4!!");
      } else {
        _controller.sink.add(_count);
      }
      _count++;
    });
  }

  Stream<int> get stream => _controller.stream;
}
