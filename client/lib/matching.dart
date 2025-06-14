import 'package:flutter/material.dart';
import 'database.dart';
import 'entry.dart';
import 'jputils.dart';

import 'dart:math';

class MatchingGame extends StatefulWidget {
  const MatchingGame({super.key});

  @override
  createState() => _MatchingGameState();
}

class _MatchingGameState extends State<MatchingGame> {
  String selectedWord = "";
  String selectedCharacter = "";
  int counter = 1;
  int rightChoices = 0;
  int? selectedIndex;
  bool? wasCorrect;
  bool showEndScreen = false;
  bool isTapDisabled = false;
  List<Vocabulary> list = [];
  late Future<List<Vocabulary>> _futureWords;
  List<Vocabulary> _backupWords = [];

  @override
  void initState() {
    super.initState();
    if (_backupWords.isNotEmpty) {
      _futureWords = Future.value(_backupWords);
    } else {
      _futureWords = fetchWords();
      _futureWords.then((future) {
        _backupWords = future;
      });
    }
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

      var vocab = result[randomNumber(0, result.length - 1)];
      if (list.contains(vocab)) {
        i--;
        continue;
      }
      list.add(vocab);
    }
    selectedWord = list[randomNumber(0, 2)].word;
    setState(() {
      isTapDisabled = false;
    });
    return list;
  }

  int randomNumber(int min, int max) {
    final random = Random();
    return min + random.nextInt(max - min + 1);
  }

  void select(AsyncSnapshot<List<Vocabulary>> snapshot, int index) async {
    setState(() {
                                isTapDisabled = true;
                                selectedIndex = index;
                                wasCorrect =
                                    snapshot.data![index].word == selectedWord;
                                if (wasCorrect!) rightChoices++;
                              });

                              await Future.delayed(Duration(milliseconds: 750));
                              if (counter > 9) {
                                setState(() {
                                  showEndScreen = true;
                                  isTapDisabled = false;
                                });
                              } else {
                                setState(() {
                                  counter++;
                                  selectedIndex = null;
                                  wasCorrect = null;
                                  _futureWords = fetchWords();
                                });
                              }
                            }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(future: _futureWords,
      builder: (context, snapshot) {
        return LayoutBuilder(builder: (context, constraints) {

          if (showEndScreen) {
            return Center(child: Container(
              width: constraints.maxWidth > 600 ? 400 : constraints.maxWidth * 0.8,
              padding: EdgeInsets.all(24.0),
              decoration: BoxDecoration(
                color: Theme.of(context).colorScheme.primary,
                borderRadius: BorderRadius.circular(32.0),
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    "Score: $rightChoices/10",
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
                        "Retry!",
                        style: Theme.of(context).textTheme.bodyLarge,
                        textAlign: TextAlign.center,
                        softWrap: true,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ),
                ],
              ),
            ),);
          }
          else if (snapshot.hasData) {
            var currentList = snapshot.data!;

            var options = List.generate(3, (index) {
                          Color getColor() {
                            if (selectedIndex == index) {
                              if (wasCorrect == true) {
                                return Colors.green;
                              } else {
                                return Colors.red;
                              }
                            }
                            return Theme.of(context).colorScheme.secondary;
                          }

                          return GestureDetector(
                            onTap: isTapDisabled ? null : () => select(snapshot, index),
                            child: Container(
                              width: constraints.maxWidth * 0.8,
                              height: constraints.maxHeight * 0.12,
                              decoration: BoxDecoration(
                                color: getColor(),
                                borderRadius: BorderRadius.circular(32.0),
                              ),
                              child: Center(
                                child: Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Text(
                                    (currentList[index]
                                        .senses[0]
                                        .meaning[0]
                                        .text),
                                    style: Theme.of(context).textTheme.bodyMedium,
                                    textAlign: TextAlign.center,
                                    softWrap: true,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                ),
                              ),
                            ),
                          );
                        });

            return Center(child: Column(mainAxisAlignment: MainAxisAlignment.center, spacing: 16.0, children: [Container(
              width: constraints.maxWidth * 0.8, // 30% della larghezza dello schermo
              height: constraints.maxHeight * 0.2,
              decoration: BoxDecoration(
                color: Theme.of(context).colorScheme.primary,
                borderRadius: BorderRadius.circular(32.0),
              ),
              padding: EdgeInsets.all(16.0),
              child: Center(
                child: Text(
                  selectedWord,
                  style: Theme.of(context).textTheme.bodyMedium,
                  textAlign: TextAlign.center,
                  softWrap: true,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ), ...options]));
            }
            return Center(child: const CircularProgressIndicator());
          }
        );
      }
    );
  }
}
