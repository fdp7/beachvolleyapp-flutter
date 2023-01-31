import 'package:beachvolley_flutter/league_components/matchCard.dart';
import 'package:beachvolley_flutter/models/Match.dart';
import 'package:flutter/cupertino.dart';

class LastMatches extends StatelessWidget {
  final List<Match> matches;

  const LastMatches(this.matches, {super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          children: [
            Container(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: const [
                  SizedBox(
                    height: 10,
                  ),
                  Text(
                    "Last Matches",
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.w400
                    ),
                  )
                ],
              ),
            )
          ],
        ),
        SizedBox(
          height: 260,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            itemCount: matches.length,
            itemBuilder: (BuildContext context, int index) => MatchCard(matches[index]),
          ),
        )
      ],
    );
  }
}