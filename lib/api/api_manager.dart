import 'dart:convert';

import 'package:football_app/api/soccermodel.dart';
import 'package:http/http.dart' as http;
//import 'package:soccer_tutorial/soccermodel.dart';
import 'package:football_app/widgets/matchstatistics.dart'; // Ensure this is the correct path
import 'package:football_app/widgets/lineup.dart'; // Ensure this is the correct path
import 'package:football_app/widgets/head_to_head.dart'; // Ensure this is the correct path
import 'package:football_app/widgets/matchInfo.dart';
import 'package:football_app/widgets/Event.dart';
import 'package:football_app/screens/Team_details.dart';

class SoccerApi {
  //now let's set our variables
  //first : let's add the endpoint URL
  // we will get all the data from api-sport.io
  // we will just change our endpoint
  //the null means that the match didn't started yet
  //let's fix that
  final String apiUrl =
      "https://v3.football.api-sports.io/fixtures?season=2023&league=307";
  //In our tutorial we will only see how to get the live matches
  //make sure to read the api documentation to be ables too understand it

  // you will find your api key in your dashboard
  //so create your account it's free
  //Now let's add the headers
  static const headers = {
    'x-rapidapi-key': 'd3ef1f2f7adcaa5ce2bff6f4ace877a1',
    'x-rapidapi-host': 'v3.football.api-sports.io'
  };
  static final String _baseUrl = "https://v3.football.api-sports.io";
  static const _headers = {
    'x-rapidapi-key':
        'd3ef1f2f7adcaa5ce2bff6f4ace877a1', // Added missing comma here
    'x-rapidapi-host': 'v3.football.api-sports.io'
  };

  //Now we will create our method
  //but before this we need to create our model

  //Now we finished with our Model
  Future<List<SoccerMatch>> getAllMatches() async {
    try {
      http.Response res = await http.get(Uri.parse(apiUrl), headers: headers);

      if (res.statusCode == 200) {
        Map<String, dynamic> body = jsonDecode(res.body);
        List<dynamic> matchesList = body['response'];
        print("Api service: ${body}"); // for debugging
        List<SoccerMatch> matches = matchesList
            .map((dynamic item) => SoccerMatch.fromJson(item))
            .toList();

        return matches;
      } else {
        print("Failed to load data: ${res.statusCode}");
        return [];
      }
    } catch (e) {
      print("Exception: $e");
      return [];
    }
  }

  static Future<MatchStatistics> getMatchStatistics(int fixtureId) async {
    var response = await http.get(
      Uri.parse('$_baseUrl/fixtures/statistics?fixture=$fixtureId'),
      headers: _headers,
    );

    if (response.statusCode == 200) {
      var data = jsonDecode(response.body);
      if (data['response'] is List && data['response'].length == 2) {
        // Pass the list directly to the factory constructor
        return MatchStatistics.fromJson(data['response']);
      } else {
        throw Exception('Expected statistics for both home and away teams');
      }
    } else {
      throw Exception(
          'Failed to fetch match statistics: ${response.statusCode}');
    }
  }

  static Future<List<Lineup>> getMatchLineup(int fixtureId) async {
    var response = await http.get(
        Uri.parse('$_baseUrl/fixtures/lineups?fixture=$fixtureId'),
        headers: _headers);

    if (response.statusCode == 200) {
      var data = jsonDecode(response.body);

      // Check if the response contains the lineup data for both teams
      if (data['response'] is List && data['response'].length >= 2) {
        // Convert each team's lineup data to a Lineup object
        List<Lineup> lineups = (data['response'] as List)
            .map((item) => Lineup.fromJson(item))
            .toList();
        return lineups;
      } else {
        throw Exception('Lineup data incomplete for fixtureId: $fixtureId');
      }
    } else {
      throw Exception('Failed to load lineup: ${response.statusCode}');
    }
  }

  // Fetch head-to-head data
  static Future<HeadToHead> getHeadToHead(int team1Id, int team2Id) async {
    var response = await http.get(
        Uri.parse('$_baseUrl/fixtures/headtohead?h2h=$team1Id-$team2Id'),
        headers: _headers);

    if (response.statusCode == 200) {
      var data = jsonDecode(response.body);
      print(
          "Head to Head Response Data: ${jsonEncode(data)}"); // Print the raw JSON data

      // Log the response for debugging
      print("Head to Head Response Data: $data");

      if (data['response'] is! List) {
        throw Exception('Expected a list for head-to-head data');
      }
      return HeadToHead.fromJson({'h2h': data['response']});
    } else {
      // Log error details
      print("Failed to load head-to-head data: ${response.statusCode}");
      print("Response body: ${response.body}");
      throw Exception('Failed to load head-to-head data');
    }
  }

  // Fetch match details for a specific fixture
  static Future<SoccerMatch> getMatchDetails(int fixtureId) async {
    var url = Uri.parse('$_baseUrl/fixtures?id=$fixtureId');
    var response = await http.get(url, headers: _headers);

    if (response.statusCode == 200) {
      var body = jsonDecode(response.body);
      if (body != null &&
          body['response'] != null &&
          body['response'].isNotEmpty) {
        return SoccerMatch.fromJson(body['response'][0]);
      } else {
        throw Exception('Match data not found for fixtureId: $fixtureId');
      }
    } else {
      throw Exception('Failed to load match details: ${response.statusCode}');
    }
  }

  static Future<MatchInfo> getMatchInfo(int fixtureId) async {
    var url = Uri.parse('$_baseUrl/fixtures?id=$fixtureId');
    var response = await http.get(url, headers: _headers);

    if (response.statusCode == 200) {
      var body = jsonDecode(response.body);
      if (body != null &&
          body['response'] != null &&
          body['response'].isNotEmpty) {
        return MatchInfo.fromJson(body['response'][0]);
      } else {
        throw Exception('Match info data not found for fixtureId: $fixtureId');
      }
    } else {
      throw Exception('Failed to load match info: ${response.statusCode}');
    }
  }

  static Future<List<Event>> getFixtureEvents(int fixtureId,
      {int? teamId, int? playerId, String? type}) async {
    String url = '$_baseUrl/fixtures/events?fixture=$fixtureId';

    if (teamId != null) {
      url += '&team=$teamId';
    }
    if (playerId != null) {
      url += '&player=$playerId';
    }
    if (type != null) {
      url += '&type=$type';
    }

    var response = await http.get(Uri.parse(url), headers: _headers);

    if (response.statusCode == 200) {
      var data = jsonDecode(response.body);
      List<Event> events = (data['response'] as List)
          .map((item) => Event.fromJson(item))
          .toList();
      return events;
    } else {
      throw Exception('Failed to load events: ${response.statusCode}');
    }
  }

  static Future<List<PlayerRating>> getPlayersRatings(int fixtureId) async {
    var response = await http.get(
      Uri.parse('$_baseUrl/fixtures/players?fixture=$fixtureId'),
      headers: _headers,
    );

    if (response.statusCode == 200) {
      var body = jsonDecode(response.body);
      List<PlayerRating> playerRatings = (body['response'] as List)
          .map((team) => team['players'] as List)
          .expand((playerList) => playerList)
          .map((playerJson) => PlayerRating.fromJson(playerJson))
          .toList();

      return playerRatings;
    } else {
      throw Exception('Failed to fetch player ratings: ${response.statusCode}');
    }
  }

  static Future<Map<String, List<PlayerRating>>> getPlayersRatingsByTeam(
      int fixtureId) async {
    var response = await http.get(
      Uri.parse('$_baseUrl/fixtures/players?fixture=$fixtureId'),
      headers: _headers,
    );

    if (response.statusCode == 200) {
      var body = jsonDecode(response.body);
      Map<String, List<PlayerRating>> teamRatings = {};

      for (var teamData in body['response']) {
        String teamId = teamData['team']['id'].toString();
        List<PlayerRating> ratings = (teamData['players'] as List)
            .map((playerJson) => PlayerRating.fromJson(playerJson))
            .toList();
        teamRatings[teamId] = ratings;
      }

      return teamRatings;
    } else {
      throw Exception('Failed to fetch player ratings: ${response.statusCode}');
    }
  }

  static Future<Prediction> getFixturePrediction(int fixtureId) async {
    var url = Uri.parse('$_baseUrl/predictions?fixture=$fixtureId');
    var response = await http.get(url, headers: _headers);

    if (response.statusCode == 200) {
      var body = jsonDecode(response.body);
      if (body['response'].isNotEmpty) {
        return Prediction.fromJson(body['response'][0]['predictions']);
      } else {
        throw Exception('No prediction data found for fixtureId: $fixtureId');
      }
    } else {
      throw Exception('Failed to load predictions: ${response.statusCode}');
    }
  }

  Future<TeamInfo> fetchTeamDetailsById(int teamId) async {
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
