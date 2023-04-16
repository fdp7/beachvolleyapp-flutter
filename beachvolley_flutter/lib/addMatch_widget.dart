import 'dart:convert';
import 'package:beachvolley_flutter/controllers/api_endpoints.dart';
import 'package:beachvolley_flutter/utils/JwtManager.dart';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:multi_select_flutter/multi_select_flutter.dart';
import 'package:numberpicker/numberpicker.dart';
import 'package:http/http.dart' as http;

class AddMatch extends StatefulWidget {

  const AddMatch({super.key});

  @override
  State<StatefulWidget> createState() => _AddMatchState();
}

class _AddMatchState extends State<AddMatch> {

  static var jwtManager = JwtManager();
  var storage = const FlutterSecureStorage();

  bool isButtonDisabled = false;

  List<String> playerList = ["Please close popup and retry."];
  List<String> teamA = [];
  List<String> teamB = [];
  int scoreA = 0;
  int scoreB = 0;


  @override
  void initState(){
    loadPlayersList();
    jwtManager.init();
    super.initState();
  }

  @override
  Widget build(BuildContext context){
    return Material(
      type: MaterialType.transparency,
      child:  Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          color: Colors.white
        ),
        child: Column(
          children: [
            Row(
              children: [
                Expanded(
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 15),
                    child: Column(
                      children: [
                        const SizedBox(height: 30,),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: const [
                            Icon(Icons.elderly_rounded, color: Colors.black87),
                            Text("  Friends", style: TextStyle(color: Colors.black87, fontSize: 24, fontWeight: FontWeight.w500),)
                          ],
                        ),
                        const SizedBox(height: 1,),
                        MultiSelectDialogField(
                          //title: const Text("Team A players"),
                          buttonIcon: const Icon(Icons.person_add),
                          buttonText: const Text("select friends"),
                          searchable: true,
                          selectedColor: const Color(0xffd81159),
                          selectedItemsTextStyle: const TextStyle(
                            color: Colors.white
                          ),
                          unselectedColor: const Color(0xffebebea),
                          items: playerList.map((e) => MultiSelectItem(e, e)).toList(),
                          listType: MultiSelectListType.CHIP,
                          onConfirm: (values) {
                            teamA = values;
                          },
                        ),
                        const SizedBox(height: 1,),
                        NumberPicker(
                          value: scoreA,
                          selectedTextStyle: const TextStyle(color: Color(0xffd81159), fontSize: 50, fontWeight: FontWeight.w400),
                          minValue: 0,
                          maxValue: 40,
                          itemHeight: 120,
                          itemWidth: 80,
                          onChanged: (num) {
                            setState(() {
                              scoreA = num;
                            });
                          },
                          axis: Axis.horizontal,
                        ),
                        const SizedBox(height: 40,),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: const [
                            Icon(Icons.precision_manufacturing_rounded, color: Colors.black87),
                            Text("  Foes", style: TextStyle(color: Colors.black87, fontSize: 24, fontWeight: FontWeight.w500),)
                          ],
                        ),
                        const SizedBox(height: 1,),
                        MultiSelectDialogField(
                          //title: const Text("Team B players"),
                          buttonIcon: const Icon(Icons.person_add),
                          buttonText: const Text("select foes"),
                          searchable: true,
                          selectedColor: const Color(0xffd81159),
                          selectedItemsTextStyle: const TextStyle(
                              color: Colors.white
                          ),
                          unselectedColor: const Color(0xffebebea),
                          items: playerList.map((e) => MultiSelectItem(e, e)).toList(),
                          listType: MultiSelectListType.CHIP,
                          onConfirm: (values) {
                            teamB = values;
                          },
                        ),
                        const SizedBox(height: 1,),
                        NumberPicker(
                          value: scoreB,
                          selectedTextStyle: const TextStyle(color: Color(0xffd81159), fontSize: 50, fontWeight: FontWeight.w400),
                          minValue: 0,
                          maxValue: 40,
                          itemHeight: 120,
                          itemWidth: 80,
                          onChanged: (num) {
                            setState(() {
                              scoreB = num;
                            });
                          },
                          axis: Axis.horizontal,
                        ),
                      ],
                    ),
                  )
                ),
              ],
            ),
            const SizedBox(height: 15),
            Expanded(
              child: Align(
                alignment: Alignment.bottomCenter,
                child: ElevatedButton(
                  onPressed: isButtonDisabled ? null : () { saveMatch(); },
                  style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xffd81159),
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10.0)
                      )
                  ),
                  child: Text('Save Match'.toUpperCase(), style: const TextStyle(fontSize: 20, color: Colors.white)),
                ),
              )
            )
          ],
        )
      ),
    );
  }

  /// Summary: get ranking and sort names in alphabetical order
  void loadPlayersList() async {
    Future.delayed(const Duration(milliseconds: 1000)).then((_) async {
      final url = ApiEndpoints.baseUrl + ApiEndpoints.getRankingEndpoint;
      var result = await http.get(
          Uri.parse(url),
          headers: {
            'Authorization': 'Bearer ${jwtManager.jwt.toString()}'
          }
      );
      var data = json.decode(result.body);
      if (result.statusCode == 200) {
        playerList.clear();
        for (var i = 0; i < data["ranking"].length; i++) {
          setState(() {
            playerList.add(data["ranking"][i]["name"]);
          });
        }
        playerList.sort();
        debugPrint(playerList.toString());
      }
    });
  }

  /// Summary: teams must be notEmpty and players can't be on both teams.
  /// Returns: 0-->valid, 1-->empty, 2-->duplicate
  int validateTeams(List<String> teamA, List<String> teamB){
    int areValid = 0;
    if (teamA.isEmpty || teamB.isEmpty) {
      areValid = 1;
    } else if (teamA.isNotEmpty && teamB.isNotEmpty) {
      teamA.forEach((a) {
        teamB.forEach((b) {
          if (a == b) {
            areValid = 2;
          }
        });
      });
    }
    return areValid;
  }

  /// Summary: draw match is not allowed
  /// Returns bool
  bool validateScores(scoreA, scoreB){
    bool areValid = true;
    if (scoreA == scoreB) {
      areValid = false;
    }
    return areValid;
  }

  Future<String?> saveMatch() async {
    // if no player is in both teams, save match, else print error
    late String messageContent;
    int validTeams = validateTeams(teamA,teamB);
    bool validScores = validateScores(scoreA, scoreB);
    if (validTeams == 0 && validScores) {
      final url = ApiEndpoints.baseUrl + ApiEndpoints.addMatchEndpoint;
      final currentDate = getDate();

      var result = await http.post(
        Uri.parse(url),
        body: jsonEncode({
          "team_a": teamA,
          "team_b": teamB,
          "score_a": scoreA,
          "score_b": scoreB,
          "date": currentDate
        }),
        headers: {
          'Authorization': 'Bearer ${jwtManager.jwt.toString()}'
        },
      );
      // if created
      if (result.statusCode == 201) {
        Navigator.pop(context);
        debugPrint(teamA.toString());
        debugPrint(teamB.toString());
        debugPrint(scoreA.toString());
        debugPrint(scoreB.toString());
        debugPrint(currentDate.toString());
        messageContent = "Dippi said the match shall be saved";
        setState(() {
          isButtonDisabled = true;
        });
      }
      else {
        setState(() {
          isButtonDisabled = false;
        });
        debugPrint("An unexpected error occurred! Please report to Dippi");
        messageContent = "An unexpected error occurred!\n\nPlease report to Dippi";
      }
    } else if (validTeams == 1) {
      setState(() {
        isButtonDisabled = false;
      });
      debugPrint("In the beginning the Good God Dippi was alone... but I guess you were not. Please check players");
      messageContent = "In the beginning Dippi was alone...\nbut I guess you were not\n\nPlease check the players";
    } else if (validTeams == 2) {
      setState(() {
        isButtonDisabled = false;
      });
      debugPrint("A player can't be ubiquitous as the Good God Dippi! Please check players");
      messageContent = "A player can't be ubiquitous as Dippi!\n\nPlease check duplicate players";
    } else if (!validScores) {
      setState(() {
        isButtonDisabled = false;
      });
      debugPrint("Only the Good God Dippi can establish a draw... YOU CANNOT. Please check scores");
      messageContent = "Not even Dippi can establish a draw,\nof course you cannot!\n\nPlease check the scores";
    }

    setState(() {
      isButtonDisabled = false;
      ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Container(
              padding: const EdgeInsets.all(16),
              alignment: Alignment.bottomCenter,
              height: 110,
              child: Text(
                messageContent,
                style: const TextStyle(
                  fontSize: 15
                ),
              ),
            ),
            backgroundColor: const Color(0xffd81159),
          )
      );
    });
    return null;
  }

  String getDate(){
    String current = DateTime.now().toString();
    current = current.replaceFirst(" ", "T").replaceRange(20, current.length, "000+00:00");
    return current;
  }
}


