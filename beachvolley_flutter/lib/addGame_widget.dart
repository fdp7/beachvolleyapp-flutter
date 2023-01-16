import 'dart:convert';
import 'package:beachvolley_flutter/controllers/api_endpoints.dart';
import 'package:beachvolley_flutter/utils/JwtManager.dart';
import 'package:flutter/material.dart';
import 'package:multi_select_flutter/multi_select_flutter.dart';
import 'package:numberpicker/numberpicker.dart';
import 'package:http/http.dart' as http;

class AddGame extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _AddGameState();
}

class _AddGameState extends State<AddGame> {

  static var jwtManager = JwtManager();

  bool isButtonDisabled = false;

  List<String> playerList = [];
  List<String> teamA = [];
  List<String> teamB = [];
  int _scoreA = 0;
  int _scoreB = 0;


  @override
  void initState(){
    jwtManager.init();
    loadPlayersList();
    super.initState();
  }

  // get ranking and sort names in alphabetical order
  void loadPlayersList() async {
    Future.delayed(Duration(milliseconds: 500)).then((_) async {
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

  String? _player1;

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
                            Icon(Icons.pregnant_woman_rounded, color: Colors.black87),
                            Text("  Team A", style: TextStyle(color: Colors.black87, fontSize: 24, fontWeight: FontWeight.w500),)
                          ],
                        ),
                        const SizedBox(height: 1,),
                        MultiSelectDialogField(
                          title: const Text("Team A players"),
                          buttonIcon: const Icon(Icons.arrow_drop_down_circle_outlined),
                          buttonText: const Text("select"),
                          searchable: true,
                          items: playerList.map((e) => MultiSelectItem(e, e)).toList(),
                          listType: MultiSelectListType.CHIP,
                          onConfirm: (values) {
                            teamA = values;
                          },
                        ),
                        const SizedBox(height: 1,),
                        NumberPicker(
                          value: _scoreA,
                          selectedTextStyle: TextStyle(color: Colors.tealAccent.shade700, fontSize: 50, fontWeight: FontWeight.w400),
                          minValue: 0,
                          maxValue: 40,
                          itemHeight: 120,
                          itemWidth: 80,
                          onChanged: (num) {
                            setState(() {
                              _scoreA = num;
                            });
                          },
                          axis: Axis.horizontal,
                        ),
                        const SizedBox(height: 40,),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: const [
                            Icon(Icons.precision_manufacturing_sharp, color: Colors.black87),
                            Text("  Team B", style: TextStyle(color: Colors.black87, fontSize: 24, fontWeight: FontWeight.w500),)
                          ],
                        ),
                        const SizedBox(height: 1,),
                        MultiSelectDialogField(
                          title: const Text("Team B players"),
                          buttonIcon: const Icon(Icons.arrow_drop_down_circle_outlined),
                          buttonText: const Text("select"),
                          searchable: true,
                          items: playerList.map((e) => MultiSelectItem(e, e)).toList(),
                          listType: MultiSelectListType.CHIP,
                          onConfirm: (values) {
                            teamB = values;
                          },
                        ),
                        const SizedBox(height: 1,),
                        NumberPicker(
                          value: _scoreB,
                          selectedTextStyle: TextStyle(color: Colors.tealAccent.shade700, fontSize: 50, fontWeight: FontWeight.w400),
                          minValue: 0,
                          maxValue: 40,
                          itemHeight: 120,
                          itemWidth: 80,
                          onChanged: (num) {
                            setState(() {
                              _scoreB = num;
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
                  onPressed: isButtonDisabled ? null : () { saveGame(); },
                  style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.green,
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

  bool validateTeams(List<String> teamA, List<String> teamB){
    bool areValid = true;
    teamA.forEach((a) {
      teamB.forEach((b) {
        if (a == b) {
          areValid = false;
        }
      });
    });
    return areValid;
  }

  Future<String?> saveGame() async {
    setState(() {
      isButtonDisabled = true;
    });

    // if no player is in both teams, save game, else print error
    bool areValid = validateTeams(teamA,teamB);
    if (areValid) {
      final url = ApiEndpoints.baseUrl + ApiEndpoints.addMatchEndpoint;
      final currentDate = getDate();

      debugPrint(teamA.toString());
      debugPrint(teamB.toString());
      debugPrint(_scoreA.toString());
      debugPrint(_scoreB.toString());
      debugPrint(currentDate.toString());

      var result = await http.post(
        Uri.parse(url),
        body: jsonEncode({
          "team_a": teamA,
          "team_b": teamB,
          "score_a": _scoreA,
          "score_b": _scoreB,
          "date": currentDate //"2024-12-13T00:21:30.000+00:00"
        }),
        headers: {
          'Authorization': 'Bearer ${jwtManager.jwt.toString()}'
        },
      );
      if (result.statusCode == 201) {
        debugPrint(teamA.toString());
        debugPrint(teamB.toString());
        debugPrint(_scoreA.toString());
        debugPrint(_scoreB.toString());
        debugPrint(currentDate.toString());
        return null;
      }
      else {
        setState(() {
          isButtonDisabled = false;
        });
        return "An unexpected error occured!\n Please refer to Dippi";
      }
    } else {
      setState(() {
        isButtonDisabled = false;
      });
      return "A player can't be on both teams!\n Please check teams";
    }
  }

  String getDate(){
    String current = DateTime.now().toString();
    current = current.replaceFirst(" ", "T").replaceRange(20, current.length, "000+00:00");
    return current;
  }
}


