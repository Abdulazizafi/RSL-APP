class Lineup {
  final String formation;
  final Coach coach;
  final List<Players> startXI;
  final List<Players> substitutes;
  final String teamName;
  final String teamLogoUrl;

  Lineup({
    required this.formation,
    required this.coach,
    required this.teamName,
    required this.teamLogoUrl,
    this.startXI = const [],
    this.substitutes = const [],
  });

  factory Lineup.fromJson(Map<String, dynamic> json) {
    var startXIList = json['startXI'] as List;
    var substitutesList = json['substitutes'] as List;
    var teamData = json['team'];

    return Lineup(
      formation: json['formation'],
      coach: Coach.fromJson(json['coach']),
      teamName: teamData['name'],
      teamLogoUrl: teamData['logo'],
      startXI: startXIList.map((x) => Players.fromJson(x['player'])).toList(),
      substitutes:
          substitutesList.map((x) => Players.fromJson(x['player'])).toList(),
    );
  }
}

class Players {
  final int id;
  final String? name;
  final int? number;
  final String? position;
  final String? logoUrl;
  final int teamId; // Add this line

  Players({
    required this.id,
    this.name,
    this.number,
    this.position,
    this.logoUrl,
    required this.teamId, // Initialize in constructor
  });

  factory Players.fromJson(Map<String, dynamic> json) {
    String? logoUrl;
    if (json.containsKey('photo') && json['photo'] is String) {
      logoUrl = json['photo'];
    }

    // Ensure 'teamId' is fetched correctly from your JSON structure
    int teamId =
        json['teamId'] ?? 0; // Adjust this line based on your API's structure

    return Players(
      id: json['id'],
      name: json['name'],
      number: json['number'],
      position: json['pos'],
      logoUrl: logoUrl,
      teamId: teamId,
    );
  }
}

class Coach {
  final int id;
  final String name;
  final String photo;

  Coach({required this.id, required this.name, required this.photo});

  factory Coach.fromJson(Map<String, dynamic> json) {
    return Coach(
      id: json['id'],
      name: json['name'],
      photo: json['photo'],
    );
  }
}
