import 'package:beachvolley_flutter/models/Mate.dart';
import 'package:beachvolley_flutter/player_components/mateCard.dart';
import 'package:card_swiper/card_swiper.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class Mates extends StatelessWidget {

  final List<Mate> mates;
  Mates(this.mates);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        Row(
          children: [
            Container(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: const [
                  SizedBox(height: 10,),
                  Text(
                    "Mates",
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.w400),
                  ),
                ],
              ),
            )
          ],
        ),
        Container(
          padding: const EdgeInsets.all(16),
          height: 310,
          child: Swiper(
            itemCount: mates.length,
            itemBuilder: (BuildContext context, int index) => MateCard(mates[index], mates[index].title),
            itemWidth: 320.0,
            itemHeight: 320.0,
            layout: SwiperLayout.STACK,
          ),
        )
      ],
    );
  }



}
