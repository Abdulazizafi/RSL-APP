import 'package:flutter/material.dart';
import 'package:football_app/api/soccermodel.dart';
import 'package:football_app/constants.dart';
import 'package:intl/intl.dart';
import 'package:football_app/screens/MatchDetailsScreen.dart';

Widget upcc(List<SoccerMatch> allmatches, BuildContext context) {
  List<SoccerMatch> nextmatches =
      allmatches.where((match) => match.fixture.status.short == 'NS').toList();
  nextmatches.sort((a, b) => a.fixture.date.compareTo(b.fixture.date));
  if (nextmatches.isEmpty) {
    return Center(child: Text("No up-coming matches available"));
  }

  return Row(
    children: [
      Expanded(
        flex: 5,
        child: Container(
          height: 300,
          width: double.infinity,
          decoration: BoxDecoration(
            color: Color.fromARGB(255, 255, 255, 255),
          ),
          child: Padding(
            padding: EdgeInsets.all(3.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Expanded(
                  child: ListView.builder(
                    itemCount: nextmatches.length,
                    itemBuilder: (context, index) {
                      return upc(nextmatches[index], context);
                    },
                  ),
                ),
              ],
            ),
          ),
        ),
      )
    ],
  );
}

Widget upc(SoccerMatch match, BuildContext context) {
  String date = match.fixture.date;
  DateTime dateTime = DateTime.parse(date);
  String formattedDate = DateFormat('yyyy-MM-dd').format(dateTime);
  DateTime dateTimeUtc = DateTime.parse(match.fixture.date);
  DateTime dateTimeKsa = dateTimeUtc.add(const Duration(hours: 3));
  String matchStartTime = DateFormat('HH:mm').format(dateTimeKsa);

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
      margin: const EdgeInsets.only(bottom: 15),
      padding: const EdgeInsets.symmetric(vertical: 20),
      height: 152,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(25),
        color: kbackgroundColor,
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.2),
            spreadRadius: 2,
            blurRadius: 5,
            offset: Offset(0, 3),
          ),
        ],
      ),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(formattedDate,
                  style: TextStyle(color: Colors.grey.shade600)),
            ],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Expanded(
                flex: 1,
                child: Column(
                  children: [
                    Image.network(
                      match.home.logoUrl,
                      width: 50,
                    ),
                    const SizedBox(height: 5),
                    Text(
                      match.home.name,
                      style: const TextStyle(fontSize: 12),
                    ),
                  ],
                ),
              ),
              Center(
                child: Image.asset(
                  'assets/images/file_0bfae61b-c268-48f2-9476-268a438e946c.png',
                  height: 65,
                  width: 65,
                ),
              ),
              Expanded(
                flex: 1,
                child: Column(
                  children: [
                    Image.network(
                      match.away.logoUrl,
                      width: 50,
                    ),
                    const SizedBox(height: 5),
                    Text(
                      match.away.name,
                      style: const TextStyle(fontSize: 12),
                    ),
                  ],
                ),
              ),
            ],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(matchStartTime.toString(),
                  style: TextStyle(color: Colors.grey.shade600)),
            ],
          ),
        ],
      ),
    ),
  );
}
