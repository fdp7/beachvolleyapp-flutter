import 'package:beachvolley_flutter/models/Mate.dart';
import 'package:flutter/material.dart';


class MateCard extends StatelessWidget {

  final String title;
  final Mate mate;

  const MateCard(this.mate, this.title, {super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        gradient: const LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [
            Colors.white,
            Colors.white,
          ],
          tileMode: TileMode.repeated,
        ),
      ),
      child: Column(
        children: [
          Container(
              height: 50,
              margin: const EdgeInsets.symmetric(horizontal: 16),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(title, style: TextStyle(fontSize: 30, fontWeight: FontWeight.w600, color: Colors.blueGrey.shade800),),
                ],
              )
          ),
          const Divider(),
          Container(
              height: 50,
              margin: const EdgeInsets.symmetric(horizontal: 16),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.sports_handball_outlined, size: 32, color: Colors.blueGrey.shade800),
                  Text("    ${mate.name}", style: TextStyle(fontSize: 24, fontWeight: FontWeight.w600, color: Colors.blueGrey.shade800),),
                ],
              )
          ),
          const Divider(),
          Row(
            children: [
              Expanded(
                child: Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Column(
                            children: [
                              Row(
                                children: [
                                  Icon(Icons.handshake, color: Colors.blueGrey.shade800, size: 29,),
                                  Text("   ${mate.wonLossCount}", style: TextStyle(fontSize: 26, fontWeight: FontWeight.w500, color: Colors.blueGrey.shade800)),
                                ],
                              ),
                              Text("won/loss", style: TextStyle(color: Colors.blueGrey.shade800),),
                            ]
                        )
                      ],
                    ),
                  ],
                ),
              ),
              const VerticalDivider(),
              Expanded(
                child: Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Column(
                            children: [
                              Row(
                                children: [
                                  Icon(Icons.percent, color: Colors.blueGrey.shade800, size: 29,),
                                  Text("  ${(customDivision(mate.wonLossCount, mate.totalMatchesCount)*100).toInt()}", style: TextStyle(fontSize: 26, fontWeight: FontWeight.w500, color: Colors.blueGrey.shade800)),
                                ],
                              ),
                              Text("win/loss rate", style: TextStyle(color: Colors.blueGrey.shade800),),
                            ]
                        )
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  double customDivision(int a, int b) {
    if( b == 0) {
      return 0;
    } else {
      return a/b;
    }
  }
}