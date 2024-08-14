class MatchInfo {
  DateTime dateTime;
  String round;
  LeagueInfo league;
  Stadium stadium;
  String? referee;

  MatchInfo({
    required this.dateTime,
    required this.round,
    required this.league,
    required this.stadium,
    this.referee,
  });

  factory MatchInfo.fromJson(Map<String, dynamic> json) {
    DateTime parsedDateTime = DateTime.parse(json['fixture']['date'] as String);
    DateTime ksaDateTime = parsedDateTime.add(const Duration(hours: 3));

    // Ensuring that the 'round' value is treated safely
    String round = json['league']['round'] as String? ?? "N/A";
    RegExp regExp = RegExp(r'\d+');
    String roundNumber = regExp.firstMatch(round)?.group(0) ?? "N/A";

    return MatchInfo(
      dateTime: ksaDateTime,
      round: roundNumber,
      league: LeagueInfo.fromJson(json['league']),
      stadium: Stadium.fromJson(json['fixture']['venue']),
      referee: json['fixture']['referee'] as String?,
    );
  }
}

class LeagueInfo {
  int id;
  String name;
  String logo;

  LeagueInfo({
    required this.id,
    required this.name,
    required this.logo,
  });

  factory LeagueInfo.fromJson(Map<String, dynamic> json) {
    int id = json['id'] as int? ?? 0; // Using 0 as a fallback ID
    return LeagueInfo(
      id: id,
      name: json['name'] as String? ?? "Unknown", // Safe fallback for strings
      logo: json['logo'] as String? ?? "", // Safe fallback for strings
    );
  }
}

class Stadium {
  int id;
  String name;
  String city;

  Stadium({
    required this.id,
    required this.name,
    required this.city,
  });

  factory Stadium.fromJson(Map<String, dynamic> json) {
    int id = json['id'] as int? ?? 0; // Using 0 as a fallback ID
    return Stadium(
      id: id,
      name: json['name'] as String? ?? "Unknown Venue", // Safe fallback
      city: json['city'] as String? ?? "Unknown City", // Safe fallback
    );
  }
}

class Prediction {
  final int? winnerId;
  final String? winnerName;
  final bool winOrDraw;
  final String? underOver;
  final String? goalsHome;
  final String? goalsAway;

  final Map<String, String?> percentages;

  Prediction({
    required this.winnerId,
    required this.winnerName,
    required this.winOrDraw,
    required this.underOver,
    required this.goalsHome,
    required this.goalsAway,
    required this.percentages,
  });

  factory Prediction.fromJson(Map<String, dynamic> json) {
    return Prediction(
      winnerId: json['winner']?['id'],
      winnerName: json['winner']?['name'],
      winOrDraw: json['win_or_draw'],
      underOver: json['under_over'],
      goalsHome: json['goals']['home'],
      goalsAway: json['goals']['away'],
      percentages: {
        'home': json['percent']['home'],
        'draw': json['percent']['draw'],
        'away': json['percent']['away'],
      },
    );
  }
}
