import 'package:flutter/material.dart';
import 'package:football_app/api/soccermodel.dart';
import 'package:intl/intl.dart';
import 'package:football_app/screens/MatchDetailsScreen.dart';

Widget matchW(SoccerMatch match, BuildContext context) {
  String date = match.fixture.date;
  DateTime dateTime = DateTime.parse(date);
  String formattedDate = DateFormat('yyyy-MM-dd').format(dateTime);
  DateTime dateTimeUtc = DateTime.parse(match.fixture.date);
  DateTime dateTimeKsa = dateTimeUtc.add(const Duration(hours: 3));
  String matchStartTime = DateFormat('HH:mm').format(dateTimeKsa);
  bool matchNotStarted =
      match.fixture.status.short == 'NS' || match.fixture.status.short == 'TBD';
  bool matchHT = match.fixture.status.short == 'HT';
  bool matchFT = match.fixture.status.short == 'FT';

  return GestureDetector(
    onTap: () {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => MatchDetailsScreen(fixtureId: match.fixture.id),
        ),
      );
    },
    child: Container(
      margin: const EdgeInsets.symmetric(vertical: 10.0, horizontal: 2.0),
      padding: const EdgeInsets.all(16.0),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8.0),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.2),
            spreadRadius: 2,
            blurRadius: 5,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Row(
            children: [
              Expanded(
                child: Text(
                  formattedDate,
                  style: TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w600,
                    color: Colors.grey.shade600,
                  ),
                ),
              ),
              matchNotStarted
                  ? Text('')
                  : Icon(Icons.timer, size: 16, color: Colors.grey.shade600),
              Expanded(
                flex: -1,
                child: Text(
                  matchNotStarted
                      ? ''
                      : matchHT
                          ? 'HT'
                          : matchFT
                              ? ''
                              : match.fixture.status.elapsedTime.toString(),
                  style: TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w600,
                    color: Colors.grey.shade600,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 4),
          Row(
            children: [
              Expanded(
                flex: 1,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    Text(
                      match.home.name,
                      style: const TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Image.network(
                      match.home.logoUrl,
                      width: 36.0,
                    ),
                    SizedBox(
                      width: 2,
                    ),
                  ],
                ),
              ),
              Expanded(
                flex: 0,
                child: Text(
                  matchNotStarted
                      ? matchStartTime
                      : (match.goal.home != null && match.goal.away != null
                          ? "${match.goal.home} - ${match.goal.away}"
                          : "TBD"),
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: Color.fromARGB(255, 0, 0, 0),
                    fontSize: 20.0,
                  ),
                ),
              ),
              Expanded(
                child: Row(
                  children: [
                    SizedBox(
                      width: 2,
                    ),
                    Image.network(
                      match.away.logoUrl,
                      width: 36.0,
                      //height: 36,
                    ),
                    Expanded(
                      flex: 0,
                      child: Text(
                        match.away.name,
                        textAlign: TextAlign.center,
                        style: const TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.bold,
                        ),
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Row(
            children: [
              Icon(Icons.stadium, size: 16, color: Colors.grey.shade600),
              const SizedBox(width: 4),
              Expanded(
                child: Text(
                  match.fixture.venue.name,
                  style: TextStyle(
                    fontSize: 12,
                    color: Colors.grey[850],
                  ),
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ],
          ),
        ],
      ),
    ),
  );
}
