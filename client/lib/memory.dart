import 'package:flutter/material.dart';
import 'package:pwa_dict/database.dart';
import 'package:pwa_dict/entry.dart';
import 'package:pwa_dict/jputils.dart';
import 'dart:math';

class MemoryGame extends StatefulWidget {
  const MemoryGame({super.key});

  @override
  _MemoryGameState createState() => _MemoryGameState();
}

class _MemoryGameState extends State<MemoryGame> {
  var selectedWord;
  var selectedCharacter;
  int counter = 1;
  int rightChoices = 0;
  int? selectedIndex;
  bool? wasCorrect;
  bool showEndScreen = false;
  bool isTapDisabled = false;
  List<Vocabulary> list = [];
  late Future<List<Vocabulary>> _futureWords;

  @override
  void initState() {
    super.initState();
    _futureWords = fetchWords();
  }

  Future<List<Vocabulary>> fetchWords() async {
    List<String> characters = JPUtils.romajiMapping.keys.toList();
    list = [];

    for (int i = 0; i < 3; i++) {
      do {
        selectedCharacter = characters[randomNumber(0, characters.length - 1)];
      } while (selectedCharacter == "ゐ" ||
          selectedCharacter == " ヰ" ||
          selectedCharacter == "ヱ" ||
          selectedCharacter == "ゑ");
      List<Vocabulary> result = await Database.search(selectedCharacter);
      if (result.isEmpty) {
        i--;
        continue;
      }
      list.add(result[randomNumber(0, result.length - 1)]);
    }
    selectedWord = list[randomNumber(0, 2)].word;
    return list;
  }

  int randomNumber(int min, int max) {
    final random = Random();
    return min + random.nextInt(max - min + 1);
  }

  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;
    return FutureBuilder(
      future: _futureWords,
      builder: (context, snapshot) {
        List<Widget> children;
        if (showEndScreen) {
          children = [
            Container(
              width: 400,
              padding: EdgeInsets.all(24.0),
              decoration: BoxDecoration(
                color: Theme.of(context).colorScheme.primary,
                borderRadius: BorderRadius.circular(32.0),
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    "Hai completato il gioco con un totale di $rightChoices/10",
                    style: Theme.of(context).textTheme.bodyLarge,
                    textAlign: TextAlign.center,
                  ),
                  SizedBox(height: 20),
                  ElevatedButton(
                    onPressed: () {
                      setState(() {
                        counter = 1;
                        selectedIndex = null;
                        wasCorrect = null;
                        showEndScreen = false;
                        rightChoices = 0;
                        _futureWords = fetchWords();
                      });
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Theme.of(context).colorScheme.secondary,
                      padding: EdgeInsets.symmetric(
                        horizontal: 24,
                        vertical: 12,
                      ),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16),
                      ),
                    ),
                    child: Center(
                      child: Text(
                        "Gioca Ancora!",
                        style: Theme.of(context).textTheme.bodyLarge,
                        textAlign: TextAlign.center,
                        softWrap: true,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ];
        } else if (snapshot.hasData) {
          var currentList = snapshot.data!;
          children = [
            Container(
              width: screenWidth * 0.3, // 40% della larghezza dello schermo
              height: screenHeight * 0.2,
              decoration: BoxDecoration(
                color: Theme.of(context).colorScheme.primary,
                borderRadius: BorderRadius.circular(32.0),
              ),
              padding: EdgeInsets.all(16.0),
              child: Center(
                child: Text(
                  "$selectedWord",
                  style: Theme.of(context).textTheme.bodyMedium,
                  textAlign: TextAlign.center,
                  softWrap: true,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ),
            SizedBox(height: 20),
            Container(
              padding: const EdgeInsets.all(16),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: List.generate(3, (index) {
                  Color getColor() {
                    if (selectedIndex == index) {
                      if (wasCorrect == true) {
                        rightChoices++;
                        return Colors.green;
                      } else {
                        return Colors.red;
                      }
                    }
                    return Theme.of(context).colorScheme.primary;
                  }

                  return GestureDetector(
                    onTap: () async {
                      if (isTapDisabled) {
                        return;
                      }
                      if (counter < 10) {
                        setState(() {
                          isTapDisabled = true;
                          selectedIndex = index;
                          var currentList = snapshot.data!;
                          wasCorrect = currentList[index].word == selectedWord;
                          counter++;
                        });

                        await Future.delayed(Duration(milliseconds: 1000));
                        setState(() {
                          selectedIndex = null;
                          wasCorrect = null;
                          _futureWords = fetchWords();
                          isTapDisabled = false;
                        });
                      } else {
                        setState(() {
                          showEndScreen = true;
                          isTapDisabled = false;
                        });
                      }
                    },
                    child: Container(
                      width: screenWidth * 0.30,
                      height: screenHeight * 0.35,
                      decoration: BoxDecoration(
                        color: getColor(),
                        borderRadius: BorderRadius.circular(32.0),
                      ),
                      child: Center(
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Text(
                            (currentList[index].senses[0].meaning[0].text),
                            style: Theme.of(context).textTheme.bodyMedium,
                            textAlign: TextAlign.center,
                            softWrap: true,
                            overflow: TextOverflow.visible,
                          ),
                        ),
                      ),
                    ),
                  );
                }),
              ),
            ),
          ];
        } else if (snapshot.hasError) {
          children = [Text("${snapshot.error}")];
        } else {
          children = const [
            SizedBox(
              width: 100,
              height: 100,
              child: CircularProgressIndicator(),
            ),
          ];
        }
        return Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: children,
          ),
        );
      },
    );
  }
}
