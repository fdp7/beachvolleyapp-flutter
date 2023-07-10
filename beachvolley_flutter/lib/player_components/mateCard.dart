import 'package:beachvolley_flutter/models/Mate.dart';
import 'package:flutter/material.dart';


class MateCard extends StatelessWidget {
  final String title;
  final Mate mate;
  final bool isWinCase;

  const MateCard(this.mate, this.title, {this.isWinCase = true, Key? key})
      : super(key: key);

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
                  Text(title,
                    style: const TextStyle(
                        fontFamily: "Gaoel",
                        color: Colors.black,
                        fontWeight: FontWeight.w600,
                        fontSize: 22
                    ),
                  ),
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
                  Icon(
                    isWinCase
                        ? Icons.favorite_outline_sharp
                        : Icons.sports_kabaddi_outlined,
                    color: Colors.black,
                    size: 29,
                  ),
                  Text("    ${mate.name}", style: const TextStyle(fontSize: 22, fontWeight: FontWeight.w500)),
                ],
              )
          ),
          const Divider(),
          const SizedBox(
            height: 20,
          ),
          Container(
            height: 50,
            margin: const EdgeInsets.symmetric(horizontal: 16),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Expanded(
                  child: Column(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Row(
                                  children: [
                                    Icon(
                                      isWinCase
                                        ? Icons.handshake_outlined
                                        : Icons.dangerous_outlined,
                                      size: 29,
                                    ),
                                    Text("   ${mate.wonLossCount}", style: const TextStyle(fontSize: 26)),
                                  ],
                                ),
                                const SizedBox(
                                  height: 8,
                                ),
                                Text(
                                    isWinCase
                                        ? "won together"
                                        : "lost against",
                                  style: const TextStyle( fontSize: 13),
                                )
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
                                    const Icon(Icons.percent, size: 29,),
                                    Text(
                                      "  ${(customDivision(mate.wonLossCount, mate.totalMatchesCount)*100).toInt()}",
                                      style: const TextStyle(fontSize: 26),
                                    )
                                  ],
                                ),
                                const SizedBox(
                                  height: 7,
                                ),
                                Text(
                                    isWinCase
                                        ? "win rate"
                                        : "loss rate",
                                  style: const TextStyle( fontSize: 13),
                                )
                              ]
                          )
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
          )
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