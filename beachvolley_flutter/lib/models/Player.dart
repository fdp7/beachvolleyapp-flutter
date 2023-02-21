import 'dart:ffi';

class Player {
  Player(this.name, this.match_count, this.win_count, this.elo, this.last_elo, this.rank);

  final String name;
  final int match_count;
  final int win_count;
  final List<double> elo;
  final double last_elo;
  final int rank;
}