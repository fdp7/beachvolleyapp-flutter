import 'package:beachvolley_flutter/models/Mate.dart';
import 'package:beachvolley_flutter/player_components/mateCard.dart';
import 'package:card_swiper/card_swiper.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class Mates extends StatelessWidget {

  final List<Mate> mates;
  const Mates(this.mates, {super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        Container(
          padding: const EdgeInsets.all(25),
          height: 310,
          child: Swiper(
            itemCount: mates.length,
            itemBuilder: (BuildContext context, int index)=>  MateCard(mates[index], mates[index].title, isWinCase: index == 0 ? true : false),
            itemWidth: 320.0,
            itemHeight: 320.0,
            layout: SwiperLayout.STACK,
          ),
        )
      ],
    );
  }



}
