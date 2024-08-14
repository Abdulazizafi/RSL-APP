import 'dart:convert';
import 'package:football_app/screens/table_leags.dart';
import 'package:http/http.dart' as http;

class SoccerApiii {
  //now let's set our variables
  //first : let's add the endpoint URL
  // we will get all the data from api-sport.io
  // we will just change our endpoint
  //the null means that the match didn't started yet
  //let's fix that

  //In our tutorial we will only see how to get the live matches
  //make sure to read the api documentation to be ables too understand it

// Assuming `apiUrl` is correctly pointing to the API Football standings endpoint
// and `your_api_key_here` is replaced with your actual API key.
  var headers = {
    "x-rapidapi-host": "v3.football.api-sports.io",
    'x-rapidapi-key': "969d647cf3msh6632b8718ee892dp176220jsn2a5079773049"
  };

  Future<List<TeamStanding>> fetchTeamStandings() async {
    const String apiUrl =
        'https://v3.football.api-sports.io/standings?league=307&&season=2023';
    const Map<String, String> headers = {
      'x-rapidapi-host': "v3.football.api-sports.io",
      'x-rapidapi-key': "d3ef1f2f7adcaa5ce2bff6f4ace877a1",
    };

    // Example: Premier League (league 39) for the 2022 season
    final response = await http.get(Uri.parse(apiUrl), headers: headers);

    if (response.statusCode == 200) {
      final body = json.decode(response.body);
      List<dynamic> standingsData =
          body['response'][0]['league']['standings'][0];
      return standingsData
          .map<TeamStanding>((json) => TeamStanding.fromJson(json))
          .toList();
    } else {
      throw Exception('Failed to load team standings');
    }
  }

   
}

