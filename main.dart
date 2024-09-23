import 'package:flutter/material.dart';
import 'dart:async'; // Import Timer class

void main() {
  runApp(MaterialApp(
    home: DigitalPetApp(),
  ));
}

class DigitalPetApp extends StatefulWidget {
  @override
  _DigitalPetAppState createState() => _DigitalPetAppState();
}

class _DigitalPetAppState extends State<DigitalPetApp> {
  String petName = "Your Pet";
  int happinessLevel = 50;
  int hungerLevel = 50;
  TextEditingController _nameController = TextEditingController();
  Timer? hungerTimer;

  @override
  void initState() {
    super.initState();
    // Timer to increase hunger every 30 seconds
    hungerTimer = Timer.periodic(Duration(seconds: 30), (Timer timer) {
      setState(() {
        hungerLevel = (hungerLevel + 5).clamp(0, 100);
        if (hungerLevel >= 100) {
          happinessLevel = (happinessLevel - 20).clamp(0, 100);
        }
      });
      _checkWinLoss(); // Check win/loss after updating hunger
    });
  }

  @override
  void dispose() {
    hungerTimer?.cancel(); // Cancel the timer when widget is disposed
    super.dispose();
  }

  // Function to increase happiness and update hunger when playing with the pet
  void _playWithPet() {
    setState(() {
      happinessLevel = (happinessLevel + 10).clamp(0, 100);
      _updateHunger();
    });
    _checkWinLoss(); // Check win/loss after playing
  }

  // Function to decrease hunger and update happiness when feeding the pet
  void _feedPet() {
    setState(() {
      hungerLevel = (hungerLevel - 10).clamp(0, 100);
      _updateHappiness();
    });
    _checkWinLoss(); // Check win/loss after feeding
  }

  // Update happiness based on hunger level
  void _updateHappiness() {
    if (hungerLevel < 30) {
      happinessLevel = (happinessLevel - 20).clamp(0, 100);
    } else {
      happinessLevel = (happinessLevel + 10).clamp(0, 100);
    }
  }

  // Increase hunger level slightly when playing with the pet
  void _updateHunger() {
    hungerLevel = (hungerLevel + 5).clamp(0, 100);
    if (hungerLevel > 100) {
      hungerLevel = 100;
      happinessLevel = (happinessLevel - 20).clamp(0, 100);
    }
  }

  // Get the pet's color based on its happiness level
  Color _getPetColor() {
    if (happinessLevel > 70) {
      return Colors.green;  // Happy
    } else if (happinessLevel >= 30 && happinessLevel <= 70) {
      return Colors.yellow;  // Neutral
    } else {
      return Colors.red;  // Unhappy
    }
  }

  // Get the pet's mood based on its happiness level
  String _getPetMood() {
    if (happinessLevel > 70) {
      return 'Happy 😊';
    } else if (happinessLevel >= 30 && happinessLevel <= 70) {
      return 'Neutral 😐';
    } else {
      return 'Unhappy 😞';
    }
  }

  // Check win/loss conditions
  void _checkWinLoss() {
    if (hungerLevel == 100 && happinessLevel <= 10) {
      _showDialog('Game Over');
    } else if (happinessLevel >= 80) {
      // Start a timer for 3 minutes to check win condition
      Timer(Duration(minutes: 3), () {
        if (happinessLevel >= 80) {
          _showDialog('You Win!');
        }
      });
    }
  }

  // Show dialog for win/loss message
  void _showDialog(String message) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(message),
          actions: <Widget>[
            TextButton(
              child: Text('OK'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Digital Pet'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            TextField(
              controller: _nameController,
              decoration: InputDecoration(hintText: 'Enter Pet Name'),
            ),
            ElevatedButton(
              onPressed: () {
                setState(() {
                  petName = _nameController.text;
                });
              },
              child: Text('Set Pet Name'),
            ),
            SizedBox(height: 16.0),
            Text(
              'Name: $petName',
              style: TextStyle(fontSize: 20.0),
            ),
            SizedBox(height: 16.0),
            Container(
              width: 100.0,
              height: 100.0,
              color: _getPetColor(),
              child: Icon(Icons.pets, size: 50),
            ),
            SizedBox(height: 16.0),
            Text(
              'Happiness Level: $happinessLevel',
              style: TextStyle(fontSize: 20.0),
            ),
            SizedBox(height: 16.0),
            Text(
              'Hunger Level: $hungerLevel',
              style: TextStyle(fontSize: 20.0),
            ),
            SizedBox(height: 16.0),
            Text(
              'Mood: ${_getPetMood()}',
              style: TextStyle(fontSize: 20.0),
            ),
            SizedBox(height: 32.0),
            ElevatedButton(
              onPressed: _playWithPet,
              child: Text('Play with Your Pet'),
            ),
            SizedBox(height: 16.0),
            ElevatedButton(
              onPressed: _feedPet,
              child: Text('Feed Your Pet'),
            ),
          ],
        ),
      ),
    );
  }
}
