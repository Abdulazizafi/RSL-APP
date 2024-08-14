import 'package:flutter/material.dart';
import 'package:football_app/api/soccermodel.dart';
import 'package:football_app/constants.dart';
import 'package:football_app/screens/MatchDetailsScreen.dart';

Widget box(List<SoccerMatch> allmatches, BuildContext context) {
  List<SoccerMatch> liveMatches = allmatches
      .where((match) =>
          match.fixture.status.short == '1H' ||
          match.fixture.status.short == 'HT' ||
          match.fixture.status.short == '2H')
      .toList();
  liveMatches.sort((a, b) => b.fixture.date.compareTo(a.fixture.date));
  if (liveMatches.isEmpty) {
    return Center(child: Text("No live matches available"));
  }

  return Row(
    children: [
      Expanded(
        flex: 5,
        child: Container(
          height: 2550,
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
                    padding: const EdgeInsets.only(left: 20),
                    shrinkWrap: true,
                    primary: false,
                    scrollDirection: Axis.horizontal,
                    itemCount: liveMatches.length,
                    itemBuilder: (context, index) {
                      return boxw(liveMatches[index], context);
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

Widget boxw(SoccerMatch match, BuildContext context) {
  var homeGoal = match.goal.home;
  var awayGoal = match.goal.away;
  bool matchHT = match.fixture.status.short == 'HT';
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
      margin: const EdgeInsets.only(right: 10),
      padding: const EdgeInsets.symmetric(
        vertical: 15,
        horizontal: 20,
      ),
      height: 250,
      width: 350,
      decoration: BoxDecoration(
        color: kprimaryColor,
        borderRadius: BorderRadius.circular(25),
        image: const DecorationImage(
          image: AssetImage(
              "assets/images/file_0bfae61b-c268-48f2-9476-268a438e946c.png"),
          opacity: 0.99,
          alignment: Alignment.bottomRight,
        ),
      ),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  Icon(Icons.stadium, color: Colors.white, size: 24),
                  SizedBox(width: 8),
                  Text(
                    match.fixture.venue.name,
                    style: TextStyle(
                      fontSize: 8,
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
              Row(
                children: [
                  Icon(Icons.access_time, color: Colors.white, size: 24),
                  SizedBox(width: 3),
                  Text(
                    matchHT
                        ? 'HT'
                        : match.fixture.status.elapsedTime.toString(),
                    style: TextStyle(
                      fontSize: 14,
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ],
          ),
          const SizedBox(height: 20),
          Row(
            children: [
              Image.network(
                match.home.logoUrl,
                width: 90,
                height: 90,
              ),
              const Spacer(),
              Column(
                children: [
                  Container(
                    padding: const EdgeInsets.all(5),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      color: const Color(0xffFFF4E5),
                    ),
                    child: const Row(
                      children: [
                        Icon(
                          Icons.circle,
                          color: kprimaryColor,
                          size: 10,
                        ),
                        SizedBox(width: 5),
                        Text(
                          "Live",
                          style: TextStyle(
                            color: kprimaryColor,
                            fontSize: 14,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 10),
                  Text.rich(
                    TextSpan(
                      children: [
                        TextSpan(
                          text: '$homeGoal',
                          style: const TextStyle(
                            fontSize: 36,
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        TextSpan(
                          text: " : $awayGoal",
                          style: TextStyle(
                            fontSize: 36,
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const Row(
                    children: [
                      Column(
                        children: [
                          Text(
                            "",
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 10,
                            ),
                          ),
                          SizedBox(height: 5),
                          Text(
                            "",
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 10,
                            ),
                          ),
                        ],
                      ),
                      SizedBox(width: 10),
                    ],
                  ),
                ],
              ),
              const Spacer(),
              Image.network(
                match.away.logoUrl,
                width: 90,
                height: 90,
              ),
            ],
          ),
          const Spacer(),
          const SizedBox(
            height: 20,
          ),
          const Spacer(),
        ],
      ),
    ),
  );
}
