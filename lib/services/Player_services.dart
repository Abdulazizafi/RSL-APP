import 'dart:convert';
//import 'dart:ffi';
import 'package:http/http.dart' as http;
import 'package:football_app/screens/Team_details.dart';

class Transferp {
  //final Playertrans player;
  final String update; // Assuming you might need the update timestamp
  final List<TransferDetail> transfers;

  Transferp({
    //required this.player,
    required this.update,
    required this.transfers,
  });

  factory Transferp.fromJson(Map<String, dynamic> json) {
    return Transferp(
      //player: Player.fromJson(json['player']),
      update: json['update'],
      transfers: List<TransferDetail>.from(
        json['transfers']?.map((x) => TransferDetail?.fromJson(x)),
      ),
    );
  }
}

class Teamp {
  final int? id;
  final String? name; // Making name nullable
  final String? logo; // Making logo nullable

  Teamp({this.id, this.name, this.logo});

  factory Teamp.fromJson(Map<String, dynamic> json) {
    return Teamp(
      id: json['id'] as int?,
      name: json['name'] as String?,
      logo: json['logo'] as String?,
    );
  }
}

class TransferDetail {
  final String date;
  final String? type; // Making type nullable
  final Teamp inTeam;
  final Teamp outTeam;

  TransferDetail(
      {required this.date,
      this.type,
      required this.inTeam,
      required this.outTeam});

  factory TransferDetail.fromJson(Map<String, dynamic> json) {
    return TransferDetail(
      date: json['date'],
      type: json['type'] as String? ?? 'N/A',
      inTeam: Teamp.fromJson(json['teams']['in']),
      outTeam: Teamp.fromJson(json['teams']['out']),
    );
  }
}

class Player {
  final int id;
  final String name;
  final String teamName;
  final String picture;
  final String nationality;
  final String weight;
  final String birthdate;
  final String position;
  final int goals;
  final int assists;
  final String height;
  final int age;
  final String? rating;
  final int matches;
  final int started;
  final int minutesplayed;
  final String teampic;
  final int teamid;
  final int yellowcards;
  final int redcards;
  final int shirt;
  final bool injury;
  final TeamInfo team;

  Player({
    required this.id,
    required this.name,
    required this.teamName,
    required this.picture,
    required this.nationality,
    required this.weight,
    required this.birthdate,
    required this.position,
    required this.goals,
    required this.assists,
    required this.height,
    required this.age,
    this.rating,
    required this.matches,
    required this.started,
    required this.minutesplayed,
    required this.teampic,
    required this.teamid,
    required this.yellowcards,
    required this.redcards,
    required this.shirt,
    required this.injury,
    required this.team,
  });

  factory Player.fromJson(Map<String, dynamic> json) {
    final teamData = json['statistics'][0]['team'];

    return Player(
      id: json['player']?['id'] ?? 0,
      name: json['player']?['name'] as String? ?? '',
      teamName: json['statistics']?[0]['team']?['name'] as String? ?? '',
      picture: json['player']?['photo'] as String? ?? '',
      nationality: json['player']?['nationality'] as String? ?? '',
      weight: json['player']?['weight'] as String? ?? '',
      birthdate: json['player']?['birth']?['date'] as String? ?? '',
      position: json['statistics']?[0]['games']?['position'] as String? ?? '',
      goals: json['statistics']?[0]['goals']?['total'] as int? ?? 0,
      assists: json['statistics']?[0]['goals']?['assists'] as int? ?? 0,
      height: json['player']?['height'] as String? ?? '',
      age: json['player']?['age'] as int? ?? 0,
      rating: json['statistics']?[0]['games']?['rating'] as String? ?? '0.0',
      matches: json['statistics']?[0]['games']?['appearences'] as int? ?? 0,
      started: json['statistics']?[0]['games']?['lineups'] as int? ?? 0,
      minutesplayed: json['statistics']?[0]['games']['minutes'] as int? ?? 0,
      teampic: json['statistics']?[0]['team']?['logo'] as String? ?? '',
      teamid: json['statistics']?[0]['team']?['id'] as int? ?? 0,
      yellowcards: json['statistics']?[0]['cards']?['yellow'] as int? ?? 0,
      redcards: json['statistics']?[0]['cards']?['red'] as int? ?? 0,
      shirt: json['statistics']?[0]['games']?['number'] as int? ?? 0,
      injury: json['player']?['injured'] as bool,
      team: TeamInfo(
        teamId: teamData['id'].toString(),
        teamName: teamData['name'],
        logoUrl: teamData['logo'],
        city:
            "", // You can leave these empty or fill them with appropriate values
        stadium: "",
        founded: 0,
        capacity: 0,
      ),
    );
  }
}

//search api
class SoccerApii {
  Future<List<Player>> fetchPlayers() async {
    const String apiUrl =
        'https://v3.football.api-sports.io/players?season=2023&league=307';
    const Map<String, String> headers = {
      'x-rapidapi-host': "v3.football.api-sports.io",
      'x-rapidapi-key':
          "d3ef1f2f7adcaa5ce2bff6f4ace877a1", // Replace with your actual API key
    };

    final response = await http.get(
        Uri.parse(
          apiUrl,
        ),
        headers: headers);

    if (response.statusCode == 200) {
      final body = json.decode(response.body);

      // Assuming the structure of the response is such that the teams' information
      // is under `response` key and directly accessible
      List<dynamic> playersData = body['response'];

      // Map each team's JSON data to a TeamInfo object
      return playersData.map<Player>((json) => Player.fromJson(json)).toList();
    } else {
      throw Exception('Failed to load team information');
    }
  }
}

//player fetch
class SoccerApi2 {
  Future<Player> fetchPlayerStatistics(
      {required int playerid, required int season, required int teamid}) async {
    final String url =
        'https://v3.football.api-sports.io/players?id=$playerid&season=$season&team=$teamid';
    final response = await http.get(
      Uri.parse(url),
      headers: {
        'x-rapidapi-host': "v3.football.api-sports.io",
        'x-rapidapi-key': "d3ef1f2f7adcaa5ce2bff6f4ace877a1",
      },
    );

    if (response.statusCode == 200) {
      final jsonResponse = json.decode(response.body);
      final Map<String, dynamic> playerData = jsonResponse['response']
          [0]; // Access the first element in the 'response' list
// Parse the player object from the JSON data
      Player player = Player.fromJson(playerData);
// Return the parsed player object
      return player;
    } else {
      throw Exception('Failed to load player statistics');
    }
  }
}

// player list fetch
class SoccerApi3 {
  Future<List<Player>> fetchPlayerStatistics(
      {required int playerid, required int season}) async {
    final String url =
        'https://v3.football.api-sports.io/players?id=$playerid&season=$season';
    final response = await http.get(
      Uri.parse(url),
      headers: {
        'x-rapidapi-host': "v3.football.api-sports.io",
        'x-rapidapi-key': "d3ef1f2f7adcaa5ce2bff6f4ace877a1",
      },
    );

    if (response.statusCode == 200) {
      final jsonResponse = json.decode(response.body);
      final List<dynamic> playersList = jsonResponse['response'];
      return playersList.map<Player>((json) => Player.fromJson(json)).toList();
    } else {
      throw Exception('Failed to load player statistics');
    }
  }
}

// top scorers
class SoccerApi4 {
  Future<List<Player>> fetchtopscorers() async {
    final String url =
        'https://v3.football.api-sports.io/players/topscorers?season=2023&league=307';
    final response = await http.get(
      Uri.parse(url),
      headers: {
        'x-rapidapi-host': "v3.football.api-sports.io",
        'x-rapidapi-key': "d3ef1f2f7adcaa5ce2bff6f4ace877a1",
      },
    );

    if (response.statusCode == 200) {
      final jsonResponse = json.decode(response.body);
      final List<dynamic> playersList = jsonResponse['response'];
      return playersList.map<Player>((json) => Player.fromJson(json)).toList();
    } else {
      throw Exception('Failed to load player statistics');
    }
  }
}

class SoccerApi5 {
  Future<List<Player>> fetchtopassisters() async {
    final String url =
        'https://v3.football.api-sports.io/players/topassists?season=2023&league=307';
    final response = await http.get(
      Uri.parse(url),
      headers: {
        'x-rapidapi-host': "v3.football.api-sports.io",
        'x-rapidapi-key': "d3ef1f2f7adcaa5ce2bff6f4ace877a1",
      },
    );

    if (response.statusCode == 200) {
      final jsonResponse = json.decode(response.body);
      final List<dynamic> playersList = jsonResponse['response'];
      return playersList.map<Player>((json) => Player.fromJson(json)).toList();
    } else {
      throw Exception('Failed to load player statistics');
    }
  }
}

class SoccerApi6 {
  Future<List<Player>> fetchtopyellowcards() async {
    final String url =
        'https://v3.football.api-sports.io/players/topyellowcards?season=2023&league=307';
    final response = await http.get(
      Uri.parse(url),
      headers: {
        'x-rapidapi-host': "v3.football.api-sports.io",
        'x-rapidapi-key': "d3ef1f2f7adcaa5ce2bff6f4ace877a1",
      },
    );

    if (response.statusCode == 200) {
      final jsonResponse = json.decode(response.body);
      final List<dynamic> playersList = jsonResponse['response'];
      return playersList.map<Player>((json) => Player.fromJson(json)).toList();
    } else {
      throw Exception('Failed to load player statistics');
    }
  }
}

class SoccerApi7 {
  Future<List<Player>> fetchtopredcards() async {
    final String url =
        'https://v3.football.api-sports.io/players/topredcards?season=2023&league=307';
    final response = await http.get(
      Uri.parse(url),
      headers: {
        'x-rapidapi-host': "v3.football.api-sports.io",
        'x-rapidapi-key': "d3ef1f2f7adcaa5ce2bff6f4ace877a1",
      },
    );

    if (response.statusCode == 200) {
      final jsonResponse = json.decode(response.body);
      final List<dynamic> playersList = jsonResponse['response'];
      return playersList.map<Player>((json) => Player.fromJson(json)).toList();
    } else {
      throw Exception('Failed to load player statistics');
    }
  }
}

class SoccerApi8 {
  Future<Transferp> fetchPlayerTransfers({required int PlayerId}) async {
    // Adjust the URL to the correct endpoint for transfers. This is just an example URL.
    final String url =
        'https://v3.football.api-sports.io/transfers?player=$PlayerId';
    final response = await http.get(
      Uri.parse(url),
      headers: {
        'x-rapidapi-host': "v3.football.api-sports.io",
        'x-rapidapi-key':
            "d3ef1f2f7adcaa5ce2bff6f4ace877a1", // Use your actual API key
      },
    );

    if (response.statusCode == 200) {
      final jsonResponse = json.decode(response.body);

      // Adjust the parsing logic according to the actual structure of the transfer data in the API response
      final dynamic transferData = jsonResponse['response'][0];

      // Parse the transfer data into a Transfer object
      return Transferp.fromJson(transferData);
    } else {
      // Log the error or handle it as you see fit
      throw Exception(
          'Failed to load team transfers with status code: ${response.statusCode}');
    }
  }
}

class SoccerApi9 {
  Future<TeamInfo> fetchTeams({required int teamId}) async {
    String apiUrl = 'https://v3.football.api-sports.io/teams?id=$teamId';
    const Map<String, String> headers = {
      'x-rapidapi-host': "v3.football.api-sports.io",
      'x-rapidapi-key':
          "d3ef1f2f7adcaa5ce2bff6f4ace877a1", // Replace with your actual API key
    };

    final response = await http.get(
        Uri.parse(
          apiUrl,
        ),
        headers: headers);

    if (response.statusCode == 200) {
      final body = json.decode(response.body);

      // Assuming the structure of the response is such that the teams' information
      // is under `response` key and directly accessible
      dynamic teamsData = body['response'];

      // Map each team's JSON data to a TeamInfo object
      return TeamInfo.fromJson(teamsData);
    } else {
      throw Exception('Failed to load team information');
    }
  }
}

class SoccerApi10 {
  Future<List<TeamInfo>> fetchTeams() async {
    const String apiUrl =
        'https://v3.football.api-sports.io/teams?league=307&season=2023';
    const Map<String, String> headers = {
      'x-rapidapi-host': "v3.football.api-sports.io",
      'x-rapidapi-key':
          "d3ef1f2f7adcaa5ce2bff6f4ace877a1", // Replace with your actual API key
    };

    final response = await http.get(
        Uri.parse(
          apiUrl,
        ),
        headers: headers);

    if (response.statusCode == 200) {
      final body = json.decode(response.body);

      // Assuming the structure of the response is such that the teams' information
      // is under `response` key and directly accessible
      List<dynamic> teamsData = body['response'];

      // Map each team's JSON data to a TeamInfo object
      return teamsData
          .map<TeamInfo>((json) => TeamInfo.fromJson(json))
          .toList();
    } else {
      throw Exception('Failed to load team information');
    }
  }
}

class SoccerApi11 {
  Future<TeamInfo> fetchTeamDetailsById(int? teamId) async {
    final String url = 'https://v3.football.api-sports.io/teams?id=$teamId';
    final response = await http.get(Uri.parse(url), headers: {
      'x-rapidapi-host': "v3.football.api-sports.io",
      'x-rapidapi-key': "d3ef1f2f7adcaa5ce2bff6f4ace877a1",
    });

    if (response.statusCode == 200) {
      final body = json.decode(response.body);
      final result = body['response']
          [0]; // Assuming the team details are in the first element
      return TeamInfo.fromJson(result);
    } else {
      throw Exception('Failed to load team details');
    }
  }
}

class SoccerApi12 {
  Future<List<Player>> fetchtopscorers(String searchparameter) async {
    final String url =
        'https://v3.football.api-sports.io/players?league=307&season=2023&search=$searchparameter';
    final response = await http.get(
      Uri.parse(url),
      headers: {
        'x-rapidapi-host': "v3.football.api-sports.io",
        'x-rapidapi-key': "d3ef1f2f7adcaa5ce2bff6f4ace877a1",
      },
    );

    if (response.statusCode == 200) {
      final jsonResponse = json.decode(response.body);
      final List<dynamic> playersList = jsonResponse['response'];
      return playersList.map<Player>((json) => Player.fromJson(json)).toList();
    } else {
      throw Exception('Failed to load player statistics');
    }
  }
}

class Trophy {
  final String league;
  final String country;
  final String season;
  final String place;

  Trophy({
    required this.league,
    required this.country,
    required this.season,
    required this.place,
  });

  factory Trophy.fromJson(Map<String, dynamic> json) {
    return Trophy(
      league: json['league'],
      country: json['country'],
      season: json['season'],
      place: json['place'],
    );
  }
}

class SoccerApi1 {
  final String _baseUrl = 'https://v3.football.api-sports.io/trophies';
  final String _apiKey =
      'd3ef1f2f7adcaa5ce2bff6f4ace877a1'; // Ensure this key is correct and active

  Future<List<Trophy>> fetchTrophies({int? player, int? coach}) async {
    var queryParameters = {
      if (player != null) 'player': player.toString(),
      if (coach != null) 'coach': coach.toString(),
    };

    var uri = Uri.parse(_baseUrl).replace(queryParameters: queryParameters);
    var response = await http.get(uri, headers: {
      'x-rapidapi-key': _apiKey, // Corrected header key
      'Content-Type': 'application/json'
    });

    if (response.statusCode == 200) {
      var jsonResponse = jsonDecode(response.body);
      List<dynamic> trophiesJson = jsonResponse['response'];
      return trophiesJson.map((data) => Trophy.fromJson(data)).toList();
    } else {
      throw Exception('Failed to load trophies: ${response.body}');
    }
  }
}
class SoccerApi22 {
  Future<Player> fetchPlayerDetails(
      {required int playerid, required int season}) async {
    final String url =
        'https://v3.football.api-sports.io/players?id=$playerid&season=$season';
    final response = await http.get(
      Uri.parse(url),
      headers: {
        'x-rapidapi-host': "v3.football.api-sports.io",
        'x-rapidapi-key': "d3ef1f2f7adcaa5ce2bff6f4ace877a1",
      },
    );

    if (response.statusCode == 200) {
      final jsonResponse = json.decode(response.body);
      final Map<String, dynamic> playerData = jsonResponse['response']
          [0]; // Access the first element in the 'response' list
// Parse the player object from the JSON data
      Player player = Player.fromJson(playerData);
// Return the parsed player object
      return player;
    } else {
      throw Exception('Failed to load player statistics');
    }
  }
}
