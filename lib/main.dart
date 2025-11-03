import 'dart:async';
import 'dart:math';
import 'package:flutter/material.dart';

// Main function that runs our application
void main() {
  runApp(const MyApp());
}

// Class to represent a target (animal/monster)
class Target {
  final String name;
  final String emoji;
  final int maxHp;
  final List<Color> backgroundColors;
  final int points; // Points awarded for defeating
  int currentHp;

  Target({
    required this.name,
    required this.emoji,
    required this.maxHp,
    required this.backgroundColors,
    required this.points,
  }) : currentHp = maxHp;

  // Method to restore HP to maximum
  void reset() {
    currentHp = maxHp;
  }
}

// The root of our application
class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter RPG',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
        textTheme: const TextTheme(
          bodyMedium: TextStyle(fontSize: 16, color: Colors.white),
          titleLarge: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
          headlineSmall: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
      ),
      home: const MyHomePage(title: 'RPG Battler'),
      debugShowCheckedModeBanner: false,
    );
  }
}

// The main screen widget
class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

// The class that manages the state
class _MyHomePageState extends State<MyHomePage> {
  // --- Game State ---
  bool _isGameStarted = false;
  late List<Target> _allTargets;
  int _currentTargetIndex = 0;
  final TextEditingController _textController = TextEditingController();
  final List<String> _actionLog = []; // Log of actions (emojis)
  final Random _random = Random();
  int _score = 0; // Player's score
  bool _isMathMode = false; // Is the user entering a math answer?

  // Math problem
  String _mathProblem = '';
  int _mathAnswer = 0;
  
  // Command maps
  final Map<String, dynamic> _weaponCommands = {
      'sword': {'damage': 15, 'emoji': '🗡️'},
      'spear': {'damage': 18, 'emoji': '🍢'},
      'bow arrow': {'damage': 20, 'emoji': '🏹'},
      'crossbow arrow': {'damage': 25, 'emoji': '🎯'},
  };

  final Map<String, dynamic> _magicCommands = {
      'ice': {'damage': 15, 'emoji': '🧊'},
      'avada kedavra': {'damage': 9999, 'emoji': '☠️'},
      'crucio': {'damage': 30, 'emoji': '😈'},
      'fireball': {'damage': 40, 'emoji': '🔥'},
  };


  // Getter for convenient access to the current target
  Target get _currentTarget => _allTargets[_currentTargetIndex];

  @override
  void initState() {
    super.initState();
    _initializeTargets();
  }

  // Initialize the list of targets and their backgrounds
  void _initializeTargets() {
    _allTargets = [
      Target(name: 'cow', emoji: '🐄', maxHp: 60, backgroundColors: [Colors.blue.shade300, Colors.green.shade500], points: 3),
      Target(name: 'pig', emoji: '🐖', maxHp: 40, backgroundColors: [Colors.pink.shade200, Colors.brown.shade400], points: 2),
      Target(name: 'chicken', emoji: '🐔', maxHp: 20, backgroundColors: [Colors.orange.shade200, Colors.yellow.shade600], points: 1),
      Target(name: 'dragon', emoji: '🐉', maxHp: 200, backgroundColors: [Colors.red.shade900, Colors.grey.shade800], points: 10),
      Target(name: 'goblin', emoji: '👺', maxHp: 50, backgroundColors: [Colors.green.shade900, Colors.brown.shade600], points: 4),
      Target(name: 'skeleton', emoji: '💀', maxHp: 30, backgroundColors: [Colors.grey.shade800, Colors.blueGrey.shade900], points: 2),
    ];
    _currentTargetIndex = _random.nextInt(_allTargets.length);
  }

  @override
  void dispose() {
    _textController.dispose();
    super.dispose();
  }

  // --- Game Logic ---

  void _startGame() {
    setState(() {
      _isGameStarted = true;
      _generateMathProblem();
    });
  }

  void _generateMathProblem() {
    int num1 = _random.nextInt(20) + 1;
    int num2 = _random.nextInt(20) + 1;
    bool isAddition = _random.nextBool();

    if (isAddition) {
      _mathAnswer = num1 + num2;
      _mathProblem = '$num1 + $num2 = ?';
    } else {
      // Prevent negative results
      if (num1 < num2) {
        int temp = num1;
        num1 = num2;
        num2 = temp;
      }
      _mathAnswer = num1; // The answer is the largest number in subtraction
      _mathProblem = '$num1 - $num2 = ?';
    }
    setState(() {});
  }

  void _manualAttack() {
    _applyDamage(1, '👆');
  }
  
  void _showInfoSnackBar(String title, Map<String, dynamic> commands) {
    final content = StringBuffer('$title\n\n');
    commands.forEach((key, value) {
        content.writeln('• $key: ${value['damage']} damage');
    });

    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        backgroundColor: Colors.black.withOpacity(0.8),
        content: Text(
            content.toString(),
            style: const TextStyle(fontSize: 16, height: 1.5),
        ),
    ));
  }

  // Main function for processing text input
  void _processTextInput(String value) {
    final text = value.trim().toLowerCase();
    if (text.isEmpty) return;
    _textController.clear();
    
    // Check if we are in math input mode
    if (_isMathMode) {
      int? enteredNumber = int.tryParse(text);
      if (enteredNumber != null && enteredNumber == _mathAnswer) {
        _applyDamage(_mathAnswer, '🧠');
        _generateMathProblem();
      } else {
        _actionLog.insert(0, '🤔'); // Incorrect answer emoji
      }
      setState(() {
        _isMathMode = false; // Exit math mode after an attempt
      });
      return;
    }

    if (text == 'm') {
      setState(() {
        _isMathMode = true;
      });
      return;
    }
    
    if (text == 'help') {
      _showInfoSnackBar('Weapon Commands:', _weaponCommands);
      return;
    }

    if (text == 'book') {
      _showInfoSnackBar('Magic Spells:', _magicCommands);
      return;
    }

    final Map<String, dynamic> allCommands = {..._weaponCommands, ..._magicCommands};

    if (allCommands.containsKey(text)) {
      _applyDamage(allCommands[text]['damage'] as int, allCommands[text]['emoji'] as String);
    } else if (text == _currentTarget.name) {
      final damage = 10 + _random.nextInt(6);
      _applyDamage(damage, _currentTarget.emoji);
    } else if (_allTargets.any((t) => t.name == text)) {
      final targetEmoji = _allTargets.firstWhere((t) => t.name == text).emoji;
      _applyDamage(5, targetEmoji);
    } else {
      _applyHealing(1 + _random.nextInt(5), '🩹'); // Random healing 1-5
    }
  }

  void _applyDamage(int amount, String emoji) {
    setState(() {
      _currentTarget.currentHp -= amount;
      _actionLog.insert(0, emoji);
      if (_currentTarget.currentHp <= 0) {
        _currentTarget.currentHp = 0;
        _handleTargetDefeated();
      }
    });
  }

  void _applyHealing(int amount, String emoji) {
    setState(() {
      _currentTarget.currentHp += amount;
      if (_currentTarget.currentHp > _currentTarget.maxHp) {
        _currentTarget.currentHp = _currentTarget.maxHp;
      }
      _actionLog.insert(0, emoji);
    });
  }

  void _handleTargetDefeated() {
    setState(() {
      _score += _currentTarget.points;
    });

    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      content: Text('${_currentTarget.emoji} ${_currentTarget.name} defeated! +${_currentTarget.points} points', style: const TextStyle(fontSize: 16)),
      backgroundColor: Colors.green[700],
    ));
    
    Future.delayed(const Duration(seconds: 2), () {
      setState(() {
        int newIndex;
        do {
          newIndex = _random.nextInt(_allTargets.length);
        } while (newIndex == _currentTargetIndex && _allTargets.length > 1);
        
        _currentTargetIndex = newIndex;
        _currentTarget.reset();
        _actionLog.clear();
        _generateMathProblem();
      });
    });
  }

  // --- UI Building ---

  @override
  Widget build(BuildContext context) {
    if (!_isGameStarted) {
      return _buildStartScreen();
    }
    return _buildGameScreen();
  }

  Widget _buildStartScreen() {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [Colors.lightBlue.shade200, Colors.green.shade400],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: Stack(
          fit: StackFit.expand,
          children: [
            if (_score > 0)
              Positioned(
                top: 60,
                left: 0,
                right: 0,
                child: Text(
                  'Score: $_score',
                  textAlign: TextAlign.center,
                  style: const TextStyle(fontSize: 32, color: Colors.white, fontWeight: FontWeight.bold, shadows: [Shadow(blurRadius: 2, color: Colors.black45)]),
                ),
              ),
            const Positioned(
              top: 100,
              left: 0,
              right: 0,
              child: Text('☀️', textAlign: TextAlign.center, style: TextStyle(fontSize: 80)),
            ),
            Center(
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 20),
                  textStyle: const TextStyle(fontSize: 24, color: Colors.black),
                ),
                onPressed: _startGame,
                child: const Text('Start'),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildGameScreen() {
    double hpPercentage = _currentTarget.maxHp > 0
        ? _currentTarget.currentHp / _currentTarget.maxHp
        : 0;

    return Scaffold(
      resizeToAvoidBottomInset: true, // Explicitly set to handle keyboard
      appBar: AppBar(
        backgroundColor: Colors.black.withOpacity(0.3),
        title: Text(widget.title, style: const TextStyle(color: Colors.white)),
        elevation: 0,
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 20.0),
            child: Text('Score: $_score', style: const TextStyle(fontSize: 20, color: Colors.white, fontWeight: FontWeight.bold)),
          )
        ],
      ),
      body: GestureDetector( // Add GestureDetector to dismiss keyboard on tap outside
        onTap: () => FocusScope.of(context).unfocus(),
        child: Container(
          // Removed redundant height and width properties to avoid layout conflicts
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: _currentTarget.backgroundColors,
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
            ),
          ),
          child: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(20.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Text(_currentTarget.emoji, style: const TextStyle(fontSize: 100)),
                  const SizedBox(height: 10),
                  Text('Target: ${_currentTarget.name.toUpperCase()}', style: Theme.of(context).textTheme.headlineSmall),
                  const SizedBox(height: 20),
                  LinearProgressIndicator(
                    value: hpPercentage,
                    minHeight: 20,
                    backgroundColor: Colors.black.withOpacity(0.3),
                    valueColor: AlwaysStoppedAnimation<Color>(
                        hpPercentage > 0.5 ? Colors.green.shade400 : (hpPercentage > 0.2 ? Colors.orange.shade400 : Colors.red.shade400)),
                  ),
                  const SizedBox(height: 5),
                  Text('HP: ${_currentTarget.currentHp} / ${_currentTarget.maxHp}', style: Theme.of(context).textTheme.titleLarge),
                  const SizedBox(height: 20),
                  
                  Text('Solve: $_mathProblem', style: const TextStyle(fontSize: 20, color: Colors.white, fontWeight: FontWeight.bold)),
                  const SizedBox(height: 20),

                  const Text("Attack History:", style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white)),
                  const SizedBox(height: 10),
                  Container(
                    height: 100,
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: Colors.black.withOpacity(0.3),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: SingleChildScrollView(
                      reverse: true,
                      child: Wrap(
                        spacing: 8.0,
                        runSpacing: 4.0,
                        children: _actionLog.map((emoji) => Text(emoji, style: const TextStyle(fontSize: 24))).toList(),
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),

                  TextField(
                    controller: _textController,
                    onSubmitted: _processTextInput,
                    style: const TextStyle(color: Colors.black),
                    decoration: InputDecoration(
                      fillColor: Colors.white.withOpacity(0.9),
                      filled: true,
                      labelText: _isMathMode ? 'Enter the answer now' : 'Enter command (type \'m\' to solve)',
                      labelStyle: const TextStyle(color: Colors.black54),
                      enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: BorderSide(
                              color: _isMathMode ? Colors.cyanAccent : Colors.transparent,
                              width: 2.0,
                          ),
                      ),
                      focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: BorderSide(
                              color: _isMathMode ? Colors.cyanAccent : Colors.deepPurple,
                              width: 2.0,
                          ),
                      ),
                      suffixIcon: IconButton(
                        icon: const Icon(Icons.send, color: Colors.deepPurple),
                        onPressed: () => _processTextInput(_textController.text),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _manualAttack,
        tooltip: 'Attack (-1 HP)',
        child: const Icon(Icons.touch_app),
      ),
    );
  }
}