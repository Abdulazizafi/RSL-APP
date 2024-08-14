class TeamsStatistics {
  int? shotsOnGoal;
  int? shotsOffGoal;
  int? totalShots;
  int? blockedShots;
  int? shotsInsideBox;
  int? shotsOutsideBox;
  int? fouls;
  int? cornerKicks;
  int? offsides;
  String? ballPossession;
  int? yellowCards;
  int? redCards;
  int? goalkeeperSaves;
  int? totalPasses;
  int? passesAccurate;
  String? passesPercentage;
  String teamName;
  String logoUrl;

  TeamsStatistics({
    this.shotsOnGoal,
    this.shotsOffGoal,
    this.totalShots,
    this.blockedShots,
    this.shotsInsideBox,
    this.shotsOutsideBox,
    this.fouls,
    this.cornerKicks,
    this.offsides,
    this.ballPossession,
    this.yellowCards,
    this.redCards,
    this.goalkeeperSaves,
    this.totalPasses,
    this.passesAccurate,
    this.passesPercentage,
    required this.teamName,
    required this.logoUrl,
  });

  factory TeamsStatistics.fromJson(Map<String, dynamic> json) {
    var statsList = json['statistics'] as List<dynamic>;
    Map<String, dynamic> statsMap = {};

    for (var stat in statsList) {
      var type = stat['type'];
      var value = stat['value'];

      if (type == 'Ball Possession' || type == 'Passes %') {
        // Assuming these are always strings like '50%'
        statsMap[type] = value;
      } else if (value is String) {
        int? intValue = int.tryParse(value);
        statsMap[type] = intValue; // intValue will be null if parsing fails
      } else {
        statsMap[type] = value; // This could be int or null
      }
    }

    return TeamsStatistics(
      teamName: json['team']['name'],
      logoUrl: json['team']['logo'],
      shotsOnGoal: statsMap['Shots on Goal'],
      shotsOffGoal: statsMap['Shots off Goal'],
      totalShots: statsMap['Total Shots'],
      blockedShots: statsMap['Blocked Shots'],
      shotsInsideBox: statsMap['Shots insidebox'],
      shotsOutsideBox: statsMap['Shots outsidebox'],
      fouls: statsMap['Fouls'],
      cornerKicks: statsMap['Corner Kicks'],
      offsides: statsMap['Offsides'],
      ballPossession: statsMap['Ball Possession'],
      yellowCards:
          statsMap['Yellow Cards'] is int ? statsMap['Yellow Cards'] : null,
      redCards: statsMap['Red Cards'] is int ? statsMap['Red Cards'] : null,
      goalkeeperSaves: statsMap['Goalkeeper Saves'],
      totalPasses: statsMap['Total passes'],
      passesAccurate: statsMap['Passes accurate'],
      passesPercentage: statsMap['Passes %'],
    );
  }
}

class MatchStatistics {
  TeamsStatistics homeTeam;
  TeamsStatistics awayTeam;

  MatchStatistics({required this.homeTeam, required this.awayTeam});

  factory MatchStatistics.fromJson(List<dynamic> response) {
    // Assuming that the first element in the list is always the home team's statistics,
    // and the second element is always the away team's statistics.
    var homeStats = TeamsStatistics.fromJson(response[0]);
    var awayStats = TeamsStatistics.fromJson(response[1]);

    return MatchStatistics(
      homeTeam: homeStats,
      awayTeam: awayStats,
    );
  }
}

class PlayerRating {
  final int playerId;
  final String name;
  final String photo;
  final int jerseyNumber;
  final String position;
  final String rating;
  final int teamId; // Keep this field

  PlayerRating({
    required this.playerId,
    required this.name,
    required this.photo,
    required this.jerseyNumber,
    required this.position,
    required this.rating,
    required this.teamId,
  });

  factory PlayerRating.fromJson(Map<String, dynamic> json) {
    // Ensure 'statistics' is not only non-null but also has at least one item
    var playerStats = json['statistics'] as List<dynamic>?;
    var gameStats = playerStats != null && playerStats.isNotEmpty
        ? playerStats[0]['games']
        : null;

    // Further null checks and safe access with '?'
    return PlayerRating(
      playerId: json['player']?['id'] as int? ?? 0,
      name: json['player']?['name'] as String? ?? 'Unknown Player',
      photo: json['player']?['photo'] as String? ??
          'https://example.com/default_photo.jpg',
      jerseyNumber: gameStats?['number'] as int? ?? 0,
      position: gameStats?['position'] as String? ?? 'Unknown Position',
      rating: gameStats?['rating'] as String? ?? 'N/A',
      teamId: json['team']?['id'] as int? ?? 0,
    );
  }
}
