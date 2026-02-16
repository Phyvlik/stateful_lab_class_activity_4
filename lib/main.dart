import 'package:flutter/material.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Stateful Lab',
      theme: ThemeData(primarySwatch: Colors.blue),
      home: CounterWidget(),
    );
  }
}

class CounterWidget extends StatefulWidget {
  @override
  _CounterWidgetState createState() => _CounterWidgetState();
}

class _CounterWidgetState extends State<CounterWidget> {
  int _counter = 0;

  // Level 3: TextField controller
  final TextEditingController _controller = TextEditingController();

  // Bonus: History for Undo
  final List<int> _history = [];

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  // Save current counter before changing it
  void _saveHistory() {
    _history.add(_counter);
  }

  // Level 2: text color logic
  Color get _counterColor {
    if (_counter == 0) return Colors.red;
    if (_counter > 50) return Colors.green;
    return Colors.black;
  }

  void _showSnack(String msg) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(msg)),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Interactive Counter')),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Center(
            child: Container(
              color: Colors.blue.shade100,
              padding: EdgeInsets.all(20),
              child: Text(
                '$_counter',
                style: TextStyle(
                  fontSize: 50.0,
                  color: _counterColor,
                ),
              ),
            ),
          ),

          SizedBox(height: 20),

          Slider(
            min: 0,
            max: 100,
            value: _counter.toDouble(),
            onChanged: (double value) {
              setState(() {
                _saveHistory();
                _counter = value.toInt();
              });
            },
          ),

          SizedBox(height: 20),

          // Level 1 + Level 2 + Bonus buttons
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              ElevatedButton(
                onPressed: () {
                  setState(() {
                    if (_counter > 0) {
                      _saveHistory();
                      _counter--;
                    }
                  });
                },
                child: Text('-1'),
              ),

              SizedBox(width: 10),

              ElevatedButton(
                onPressed: () {
                  setState(() {
                    if (_counter < 100) {
                      _saveHistory();
                      _counter++;
                    } else {
                      _showSnack('Limit Reached!');
                    }
                  });
                },
                child: Text('+1'),
              ),

              SizedBox(width: 10),

              ElevatedButton(
                onPressed: () {
                  setState(() {
                    _saveHistory();
                    _counter = 0;
                  });
                },
                child: Text('Reset'),
              ),

              SizedBox(width: 10),

              // ✅ BONUS: Undo Button
              ElevatedButton(
                onPressed: () {
                  setState(() {
                    if (_history.isNotEmpty) {
                      _counter = _history.removeLast();
                    }
                  });
                },
                child: Text('Undo'),
              ),
            ],
          ),

          SizedBox(height: 25),

          // Level 3: custom set value input
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 30),
            child: TextField(
              controller: _controller,
              keyboardType: TextInputType.number,
              decoration: InputDecoration(
                labelText: 'Enter a number (0-100)',
                border: OutlineInputBorder(),
              ),
            ),
          ),

          SizedBox(height: 12),

          ElevatedButton(
            onPressed: () {
              final int? input = int.tryParse(_controller.text.trim());

              // Handle non-number input
              if (input == null) {
                _showSnack('Please enter a valid number');
                return;
              }

              // Enforce max limit
              if (input > 100) {
                _showSnack('Limit Reached!');
                return;
              }

              setState(() {
                _saveHistory();
                _counter = input < 0 ? 0 : input;
              });
            },
            child: Text('Set Value'),
          ),
        ],
      ),
    );
  }
}
