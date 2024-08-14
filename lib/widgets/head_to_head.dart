class HeadToHead {
  final List<MatchResult> pastMatches;

  HeadToHead({required this.pastMatches});

  factory HeadToHead.fromJson(Map<String, dynamic> json) {
    var matchesList = json['h2h'] as List;
    List<MatchResult> pastMatches =
        matchesList.map((i) => MatchResult.fromJson(i)).toList();
    return HeadToHead(pastMatches: pastMatches);
  }
}

class MatchResult {
  final int fixtureId;
  final String date;
  final TeamH teamHome;
  final TeamH teamAway;
  final Score score;

  MatchResult({
    required this.fixtureId,
    required this.date,
    required this.teamHome,
    required this.teamAway,
    required this.score,
  });

  factory MatchResult.fromJson(Map<String, dynamic> json) {
    return MatchResult(
      fixtureId: json['fixture']['id'],
      date: json['fixture']['date'],
      teamHome: TeamH.fromJson(json['teams']['home']),
      teamAway: TeamH.fromJson(json['teams']['away']),
      score: Score.fromJson(
          json['goals']), // Updated to use 'goals' instead of 'score'
    );
  }
}

class TeamH {
  final int id;
  final String name;
  final String logo;

  TeamH({required this.id, required this.name, required this.logo});

  factory TeamH.fromJson(Map<String, dynamic> json) {
    return TeamH(
      id: json['id'],
      name: json['name'],
      logo: json['logo'],
    );
  }
}

class Score {
  final int? home;
  final int? away;

  Score({this.home, this.away});

  factory Score.fromJson(Map<String, dynamic> json) {
    return Score(
      home: json['home'],
      away: json['away'],
    );
  }
}
