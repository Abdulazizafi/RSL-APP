import 'dart:async';
import 'package:flutter/widgets.dart';
import 'package:iconsax/iconsax.dart';
import 'package:flutter/material.dart';
import 'package:football_app/api/api_manager.dart';
import 'package:football_app/api/soccermodel.dart';
import 'package:football_app/constants.dart';
import 'package:football_app/screens/all_matches_screen.dart';
import 'package:football_app/widgets/forbox.dart';
import 'package:football_app/widgets/upcoming_match.dart';
import 'package:football_app/screens/search_screen.dart';

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  late StreamController<List<SoccerMatch>> _matchesStreamController;

  @override
  void initState() {
    super.initState();
    _matchesStreamController = StreamController.broadcast();
    _startPeriodicUpdates();
  }

  void _startPeriodicUpdates() {
    // Fetch initial data immediately
    _updateMatches();

    // Set up a periodic timer to fetch data every certain amount of time
    // For example, here it's set to update every 30 seconds
    Timer.periodic(Duration(seconds: 10000000000000000), (timer) {
      _updateMatches();
    });
  }

  Future<void> _updateMatches() async {
    try {
      List<SoccerMatch> matches = await SoccerApi().getAllMatches();
      _matchesStreamController.sink.add(matches);
    } catch (e) {
      _matchesStreamController.sink.addError(e);
    }
  }

  void _openSearch() {
    Navigator.of(context)
        .push(MaterialPageRoute(builder: (context) => const SearchScreen()));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          onPressed: _openSearch,
          icon: const Icon(Iconsax.search_normal),
          color: Colors.white,
        ),
        title: Center(
          // Wrap the Image.asset with a Center widget
          child: Image.asset(
            "assets/images/file_0bfae61b-c268-48f2-9476-268a438e946c.png",
            width: 70,
            height: 70,
          ),
        ),
        backgroundColor: kprimaryColor,
        iconTheme: const IconThemeData(color: Colors.white),
        actions: [
          // Add an empty action if you want to balance the leading IconButton
          IconButton(
            icon: const Icon(null), // invisible icon or container
            onPressed: null,
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Padding(
            padding: const EdgeInsets.all(20),
            child: Row(
              children: [
                Text(
                  "Live Match",
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 18,
                    color: Colors.grey.shade800,
                  ),
                ),
                const Spacer(),
                Container(
                  padding: const EdgeInsets.all(3),
                  decoration: BoxDecoration(
                    color: kbackgroundColor,
                    borderRadius: BorderRadius.circular(20),
                    boxShadow: [
                      BoxShadow(
                          blurRadius: 20,
                          color: Color.fromARGB(255, 255, 255, 255)),
                    ],
                  ),
                )
              ],
            ),
          ),
          SizedBox(
            height: 250,
            child: StreamBuilder<List<SoccerMatch>>(
              stream: _matchesStreamController.stream,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return Center(child: CircularProgressIndicator());
                } else if (snapshot.hasError) {
                  return Center(child: Text("Error: ${snapshot.error}"));
                } else if (snapshot.hasData && snapshot.data != null) {
                  return box(snapshot.data!, context); // Pass context here
                  // Non-null assertion used
                } else {
                  return Center(child: Text("No matches available"));
                }
              },
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(20),
            child: Row(
              children: [
                Text(
                  "Up-Coming Matches",
                  style: TextStyle(
                    fontSize: 18,
                    color: Colors.grey.shade800,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const Spacer(),
                TextButton(
                  onPressed: () {
                    Navigator.of(context).push(MaterialPageRoute(
                        builder: (context) => AllMatchesScreen()));
                  },
                  style: TextButton.styleFrom(foregroundColor: kprimaryColor),
                  child: const Text("See all"),
                )
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: StreamBuilder<List<SoccerMatch>>(
              stream: _matchesStreamController.stream,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return Center(child: CircularProgressIndicator());
                } else if (snapshot.hasError) {
                  return Center(child: Text("Error: ${snapshot.error}"));
                } else if (snapshot.hasData && snapshot.data != null) {
                  return upcc(snapshot.data!, context); // Pass context here
                } else {
                  return Center(child: Text("No matches available"));
                }
              },
            ),
          )
        ]
            /*SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.all(20),
              child: Row(
                children: [
                  Text(
                    "Live Match",
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 18,
                      color: Colors.grey.shade800,
                    ),
                  ),
                  const Spacer(),
                  Container(
                    padding: const EdgeInsets.all(5),
                    decoration: BoxDecoration(
                      color: kbackgroundColor,
                      borderRadius: BorderRadius.circular(20),
                      boxShadow: [
                        BoxShadow(
                            blurRadius: 20,
                            color: Color.fromARGB(255, 255, 255, 255)),
                      ],
                    ),
                  )
                ],
              ),
            ),
            SizedBox(
              height: 250,
              child: ListView(
                padding: const EdgeInsets.only(left: 20),
                shrinkWrap: true,
                primary: false,
                scrollDirection: Axis.horizontal,
                children: const [
                  LiveMatchBox(
                    awayGoal: 2,
                    homeGoal: 0,
                    time: 83,
                    awayLogo:
                        "assets/images/fbe39e0164db936758854419bc05f037.png",
                    homeLogo: "assets/images/Alnassr_FC_Logo_2020.png",
                    awayTitle: " AL-Hilal",
                    homeTitle: "AL-Nassr",
                    color: kboxColor,
                    textColors: Colors.white,
                    backgroundImage: DecorationImage(
                      image: AssetImage(
                          "assets/images/file_0bfae61b-c268-48f2-9476-268a438e946c.png"),
                      fit: BoxFit.contain,
                      alignment: Alignment.bottomLeft,
                      opacity: 0.3,
                    ),
                  ),
                  LiveMatchBox1(
                    awayGoal: 1,
                    homeGoal: 0,
                    time: 65,
                    awayLogo: "assets/images/Al_Ahli_Saudi_FC_logo.svg.png",
                    homeLogo:
                        "assets/images/ittihad-club-logo-1657427BF0-seeklogo.com.png",
                    awayTitle: "AL-Ahli",
                    homeTitle: "AL-Ittihad",
                    color: ksecondBoxColor,
                    textColors: Colors.black,
                    backgroundImage: DecorationImage(
                      image: AssetImage(
                          "assets/images/file_0bfae61b-c268-48f2-9476-268a438e946c.png"),
                      fit: BoxFit.contain,
                      alignment: Alignment.bottomLeft,
                      opacity: 0.1,
                    ),
                  )
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(20),
              child: Row(
                children: [
                  Text(
                    "Up-Coming Matches",
                    style: TextStyle(
                      fontSize: 18,
                      color: Colors.grey.shade800,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const Spacer(),
                  TextButton(
                    onPressed: _navigateToAllMatches,
                    style: TextButton.styleFrom(foregroundColor: kprimaryColor),
                    child: const Text("See all"),
                  )
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: ListView(
                shrinkWrap: true,
                primary: false,
                physics: const NeverScrollableScrollPhysics(),
                children: const [
                  UpComingMatch(
                    awayLogo:
                        "assets/images/al-raed-saudi-football-club-logo-8DBFBF8894-seeklogo.com.png",
                    awayTitle: "AL-Raed",
                    homeLogo:
                        "assets/images/altai-logo-630D3C45F2-seeklogo.com.png",
                    homeTitle: "Al-Taie FC",
                    date: "30 Dec",
                    time: "06:30",
                    isFavorite: false,
                  ),
                  UpComingMatch(
                    awayLogo: "assets/images/Shabab_FC.png",
                    awayTitle: "AL-Shabab",
                    homeLogo: "assets/images/Al_Riyadh.png",
                    homeTitle: "AL-Riyadh",
                    date: "30 Dec",
                    time: "06:30",
                    isFavorite: false,
                  ),
                  UpComingMatch(
                    awayLogo: "assets/images/AL_Taawoun_new_logo.png",
                    awayTitle: "AL-Taawoun",
                    homeLogo: "assets/images/Al-Fateh_FC_logo.png",
                    homeTitle: "AL-Fateh",
                    date: "30 Dec",
                    time: "06:30",
                    isFavorite: false,
                  ),
                  UpComingMatch(
                    awayLogo: "assets/images/Al-Ettifaq_(logo).png",
                    awayTitle: "AL-Ettifaq",
                    homeLogo: "assets/images/saffteamlarge1628756061.png",
                    homeTitle: "AL-Hazem",
                    date: "30 Dec",
                    time: "06:30",
                    isFavorite: false,
                  ),
                ],
              ),
            )
          ],
        ),
      ),*/
            ),
      ),
    );
  }

  void dispose() {
    _matchesStreamController.close();
    super.dispose();
  }
}
