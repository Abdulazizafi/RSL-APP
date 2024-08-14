import 'package:flutter/material.dart';
//import 'package:football_app/screens/statistics_screen.dart';
//import 'package:football_app/screens/standing_screen.dart';
//import 'package:football_app/screens/table_leags.dart';
import 'package:football_app/constants.dart';
import 'package:iconsax/iconsax.dart';
import 'package:football_app/services/Player_services.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:intl/intl.dart';
import 'package:football_app/screens/Team_details.dart';

class Player_profile_screen extends StatefulWidget {
  final Player player;
  
  const Player_profile_screen({Key? key, required this.player})
      : super(key: key);

  @override
  _Player_profile_screen createState() => _Player_profile_screen();
}

class _Player_profile_screen extends State<Player_profile_screen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
  }

  void _navigateToTeamDetails(BuildContext context, int team) async {
    try {
      // Fetch team details from API
      TeamInfo teamInfo = await SoccerApi11().fetchTeamDetailsById(team);
      // Navigate to the team details page with the fetched teamInfo
      Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => TeamDetailPage(teamInfo: teamInfo),
          ));
    } catch (e) {
      // You can optionally handle errors differently or log them
      print('Error fetching team details: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    int playerid = widget.player.id;
    int season = 2023;
    int teamid = widget.player.teamid;

    return FutureBuilder<List<dynamic>>(
      future: Future.wait([
        //SoccerApi9().fetchTeams(teamId: teamid,),
        SoccerApi2().fetchPlayerStatistics(
            playerid: playerid, season: season, teamid: teamid),
      ]),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(child: CircularProgressIndicator());
        } else if (snapshot.hasError) {
          return Center(child: Text('Error: ${snapshot.error}'));
        } else if (snapshot.hasData) {
          //TeamInfo team = snapshot.data![0];
          Player playerStats = snapshot.data![0];

          return Scaffold(
            appBar: PreferredSize(
              preferredSize:
                  const Size.fromHeight(180.0), // here the desired height
              child: AppBar(
                backgroundColor: kprimaryColor, // Set AppBar background color
                leading: IconButton(
                  onPressed: () => Navigator.pop(context),
                  style: IconButton.styleFrom(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                    backgroundColor: kbackgroundColor,
                    shadowColor: Colors.grey.shade200,
                    elevation: 2,
                  ),
                  icon: const Icon(Iconsax.arrow_square_left),
                ),
                // Add your icon
                flexibleSpace: Container(
                  margin: const EdgeInsets.only(bottom: 15),
                  padding: const EdgeInsets.symmetric(vertical: 20),
                  child: Column(
                    children: [
                      const Row(
                        children: [
                          SizedBox(
                            height: 60,
                          ),
                        ],
                      ),
                      Row(
                        children: [
                          const SizedBox(
                            width: 30,
                          ),
                          CircleAvatar(
                            radius: 28,
                            backgroundImage: CachedNetworkImageProvider(
                                playerStats.picture), // Use AssetImage
                          ),
                          const SizedBox(
                            width: 10,
                          ),
                          Text(playerStats.name,
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 18,
                              )),
                          const Expanded(
                            flex: 1,
                            child: SizedBox(
                              width: 110,
                            ),
                          ),
                          if (playerStats.position == 'Attacker') ...[
                            const CircleAvatar(
                              backgroundColor: Colors.red,
                              radius: 5,
                            ),
                            const SizedBox(
                              width: 3,
                            ),
                            const Text('ATK',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 12,
                                )),
                            const SizedBox(
                              width: 25,
                            )
                          ] else if (playerStats.position == 'Midfielder') ...[
                            const CircleAvatar(
                              backgroundColor: Color.fromARGB(255, 52, 190, 94),
                              radius: 5,
                            ),
                            const SizedBox(
                              width: 3,
                            ),
                            const Text('MID',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 12,
                                )),
                            const SizedBox(
                              width: 25,
                            )
                          ] else if (playerStats.position == 'Defender') ...[
                            const CircleAvatar(
                              backgroundColor:
                                  Color.fromARGB(255, 34, 117, 211),
                              radius: 5,
                            ),
                            const SizedBox(
                              width: 3,
                            ),
                            const Text('DEF',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 12,
                                )),
                            const SizedBox(
                              width: 25,
                            )
                          ] else if (playerStats.position == 'Goalkeeper') ...[
                            const CircleAvatar(
                              backgroundColor:
                                  Color.fromARGB(255, 206, 172, 24),
                              radius: 5,
                            ),
                            const SizedBox(
                              width: 3,
                            ),
                            const Text('GK',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 12,
                                )),
                            const SizedBox(
                              width: 25,
                            )
                          ]
                        ],
                      ),
                      Row(
                        children: [
                          const SizedBox(width: 85),
                          GestureDetector(
                            onTap: () {
                              _navigateToTeamDetails(
                                  context, widget.player.teamid);
                            },
                            child: Row(
                              children: [
                                CircleAvatar(
                                  backgroundColor: Colors.transparent,
                                  radius: 14,
                                  backgroundImage: CachedNetworkImageProvider(
                                      playerStats.teampic), // Use AssetImage
                                ),
                                const SizedBox(
                                    width:
                                        5), // Add some space between the picture and the name
                                Text(
                                  playerStats.teamName,
                                  style: const TextStyle(
                                      color: Colors.white, fontSize: 15),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                bottom: TabBar(
                  controller: _tabController,
                  labelColor:
                      Colors.white, // Set selected tab label color to white
                  unselectedLabelColor: Colors.white.withOpacity(
                      0.7), // Optional: Set unselected tab label color to slightly transparent white
                  tabs: const [
                    Tab(text: 'Profile'),
                    Tab(text: 'Transfers'),
                    Tab(text: 'Trophies'),
                  ],
                ),
              ),
            ),
            body: TabBarView(
              controller: _tabController,
              children: [
                //const TableLeags(
                //leageId: 104,
                //), // Your standings content
                //Mainprofile(widget.player),
                _playerinfotab(),
                _buildTransfersTab(),
                _buildTrophiesTab(), // Your statistics content
              ],
            ),
          );
        } else {
          return const Center(child: Text('No data available'));
        }
      },
    );
  }

  Widget _buildTrophiesTab() {
    int playerId = widget
        .player.id; // Assuming player ID is available from the Player object

    return FutureBuilder<List<Trophy>>(
      future: SoccerApi1().fetchTrophies(player: playerId),
      builder: (BuildContext context, AsyncSnapshot<List<Trophy>> snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        } else if (snapshot.hasError) {
          return Text("Error: ${snapshot.error}");
        } else if (snapshot.hasData && snapshot.data!.isNotEmpty) {
          return ListView.builder(
            itemCount: snapshot.data!.length,
            itemBuilder: (context, index) {
              Trophy trophy = snapshot.data![index];
              return ListTile(
                leading: Icon(Icons.emoji_events,
                    color: Colors.amber, size: 40), // Trophy icon
                title: Text(trophy.league),
                subtitle: Text(
                    '${trophy.country}, ${trophy.season} - ${trophy.place}'),
                // Optional navigation indicator
              );
            },
          );
        } else {
          return const Center(child: Text('No trophies found'));
        }
      },
    );
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  Widget _buildplayerinfo() {
    int playerid = widget.player.id;
    int season = 2023;
    int teamid = widget.player.teamid;

    return FutureBuilder<List<dynamic>>(
      future: Future.wait([
        //SoccerApi2().fetchTeamStatistics(teamId: teamId, league: leagueId, season: season),
        SoccerApi2().fetchPlayerStatistics(
            playerid: playerid, season: season, teamid: teamid),
      ]),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        } else if (snapshot.hasError) {
          return Center(child: Text('Error: ${snapshot.error}'));
        } else if (snapshot.hasData) {
          //TeamStatistics teamStats = snapshot.data![0];
          Player playerStats = snapshot.data![0];
          return Container(
            margin: const EdgeInsets.all(10),
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(12),
              boxShadow: [
                BoxShadow(
                  color: Colors.grey.withOpacity(0.5),
                  spreadRadius: 5,
                  blurRadius: 7,
                  offset: const Offset(0, 3),
                ),
              ],
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    _buildInfoItem(
                      label: "Height",
                      value: playerStats.height.toString(),
                    ),
                    _buildInfoItem(
                      label: "Age",
                      value: playerStats.age.toString(),
                    ),
                    _buildInfoItem(
                      label: "Nationality",
                      value: playerStats.nationality.toString(),
                ),]
                    )
                    ,Row(
                  
                  children: [
                    _buildInfoItem(
                      label: "Position",
                      value: playerStats.position.toString(),
                    ),
                    SizedBox(width: 50,),
                    Icon(
                      playerStats.position == 'Goalkeeper'
                          ? Icons.sports_mma_sharp
                          : (playerStats.position == 'Defender'
                              ? Icons.sports_kabaddi
                              : (playerStats.position == 'Midfielder'
                                  ? Icons.directions_run
                                  : Icons.sports_martial_arts_sharp)),
                      size: 24,
                      color: Theme.of(context).primaryColor,
                    ),
                    SizedBox(width: 50,),
                    _buildInfoItem(
                      label: "Weight",
                      value: playerStats.weight.toString(),
                    ),
                  ],
                ),
                  ],
        
              
            ),
          );
        } else {
          return const Center(child: Text('No data available'));
        }
      },
    );
  }

  Widget _buildInfoItem({
    required String label,
    required String value,
    Color? color,
  }) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.all(2.0),
        decoration: const BoxDecoration(
            //border: Border.all(color: Colors.grey),
            //borderRadius: BorderRadius.circular(8.0),
            ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              value,
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: color,
              ),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
            const SizedBox(height: 4),
            Text(
              label,
              style: const TextStyle(
                fontSize: 13,
                fontWeight: FontWeight.w400,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildplayerstats() {
    int playerid = widget.player.id;
    int season = 2023;
    int teamid = widget.player.teamid;

    return FutureBuilder<List<dynamic>>(
      future: Future.wait([
        //SoccerApi2().fetchTeamStatistics(teamId: teamId, league: leagueId, season: season),
        SoccerApi2().fetchPlayerStatistics(
            playerid: playerid, season: season, teamid: teamid),
      ]),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        } else if (snapshot.hasError) {
          return Center(child: Text('Error: ${snapshot.error}'));
        } else if (snapshot.hasData) {
          //TeamStatistics teamStats = snapshot.data![0];
          Player playerStats = snapshot.data![0];

          return Container(
            margin: const EdgeInsets.all(10),
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(12),
              boxShadow: [
                BoxShadow(
                  color: Colors.grey.withOpacity(0.5),
                  spreadRadius: 5,
                  blurRadius: 7,
                  offset: const Offset(0, 3),
                ),
              ],
            ),
            child: Column(
              children: [
                Row(
                  children: [
                    const SizedBox(
                      width: 15,
                    ),
                    Column(children: [
                      Row(
                        children: [
                          Text(
                            playerStats.goals.toString(),
                            style: const TextStyle(
                                fontSize: 16, fontWeight: FontWeight.bold),
                          )
                        ],
                      ),
                      const Row(
                        children: [
                          Text(
                            "Goals",
                            style: TextStyle(
                                fontSize: 13, fontWeight: FontWeight.w400),
                          )
                        ],
                      ),
                    ]),
                    const Spacer(),
                    Column(children: [
                      Row(
                        children: [
                          Text(
                            playerStats.assists.toString(),
                            style: const TextStyle(
                                fontSize: 16, fontWeight: FontWeight.bold),
                          )
                        ],
                      ),
                      const Row(
                        children: [
                          Text(
                            // ignore: unnecessary_string_interpolations
                            'Assists',
                            style: TextStyle(
                                fontSize: 13, fontWeight: FontWeight.w400),
                          )
                        ],
                      ),
                    ]),
                    const Spacer(),
                    Column(children: [
                      Row(
                        children: [
                          if (double.parse(playerStats.rating ?? '0.0') == 0.0)
                            Text(
                              playerStats.rating!.toString(),
                              style: const TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.bold,
                              ),
                            )
                          else if (double.parse(playerStats.rating ?? '0.0') >=
                              9.0)
                            Container(
                                decoration: BoxDecoration(
                                    color: Colors.blue,
                                    borderRadius: BorderRadius.circular(4)),
                                child: Row(
                                  children: [
                                    const SizedBox(
                                      width: 3,
                                    ),
                                    Text(
                                      playerStats.rating!.substring(0, 5),
                                      style: const TextStyle(
                                        fontSize: 14,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    const SizedBox(
                                      width: 3,
                                    ),
                                  ],
                                ))
                          else if (double.parse(playerStats.rating ?? '0.0') <
                              7.0)
                            Container(
                                decoration: BoxDecoration(
                                    color: Colors.yellow.shade600,
                                    borderRadius: BorderRadius.circular(4)),
                                child: Row(
                                  children: [
                                    const SizedBox(
                                      width: 3,
                                    ),
                                    Text(
                                      playerStats.rating!.substring(0, 5),
                                      style: const TextStyle(
                                        fontSize: 14,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    const SizedBox(
                                      width: 3,
                                    ),
                                  ],
                                ))
                          else
                            Container(
                                decoration: BoxDecoration(
                                    color: Colors.green.shade600,
                                    borderRadius: BorderRadius.circular(4)),
                                child: Row(
                                  children: [
                                    const SizedBox(
                                      width: 3,
                                    ),
                                    Text(
                                      playerStats.rating!.substring(0, 5),
                                      style: const TextStyle(
                                        fontSize: 14,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    const SizedBox(
                                      width: 3,
                                    ),
                                  ],
                                ))
                        ],
                      ),
                      const Row(
                        children: [
                          Text(
                            "Rating",
                            style: TextStyle(
                                fontSize: 13, fontWeight: FontWeight.w400),
                          )
                        ],
                      ),
                    ]),
                    const SizedBox(
                      width: 15,
                    ),
                  ],
                ),
                const SizedBox(
                  height: 15,
                ),
                Row(
                  children: [
                    const SizedBox(
                      width: 7,
                    ),
                    Column(children: [
                      Row(
                        children: [
                          Text(
                            playerStats.matches.toString(),
                            style: const TextStyle(
                                fontSize: 16, fontWeight: FontWeight.bold),
                          )
                        ],
                      ),
                      const Row(
                        children: [
                          Text(
                            "Matches",
                            style: TextStyle(
                                fontSize: 13, fontWeight: FontWeight.w400),
                          )
                        ],
                      ),
                    ]),
                    const Spacer(),
                    const SizedBox(
                      width: 4,
                    ),
                    Column(children: [
                      Row(
                        children: [
                          Text(
                            playerStats.yellowcards.toString(),
                            style: const TextStyle(
                                fontSize: 16, fontWeight: FontWeight.bold),
                          )
                        ],
                      ),
                      const Row(
                        children: [
                          Text(
                            "Y.cards",
                            style: TextStyle(
                                fontSize: 13, fontWeight: FontWeight.w400),
                          )
                        ],
                      ),
                    ]),
                    const Spacer(),
                    Column(children: [
                      Row(
                        children: [
                          Text(
                            playerStats.minutesplayed.toString(),
                            style: const TextStyle(
                                fontSize: 16, fontWeight: FontWeight.bold),
                          )
                        ],
                      ),
                      const Row(
                        children: [
                          Text(
                            "Min. played",
                            style: TextStyle(
                                fontSize: 13, fontWeight: FontWeight.w400),
                          )
                        ],
                      ),
                    ]),
                  ],
                ),
              ],
            ),
          );
        } else {
          return const Center(child: Text('No data available'));
        }
      },
    );
  }

  Widget _buildTransfersTab() {
    int playerid = widget.player.id;

    return FutureBuilder<List<dynamic>>(
      future: Future.wait([
        //SoccerApi2().fetchTeamStatistics(teamId: teamId, league: leagueId, season: season),
        SoccerApi8().fetchPlayerTransfers(PlayerId: playerid),
      ]),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(child: CircularProgressIndicator());
        } else if (snapshot.hasError) {
          return Center(
              child: Text("This player doesn't have any transfers yet"));
          //return Center(child: Text('Error: ${snapshot.error}'));
        } else if (snapshot.hasData) {
          //TeamStatistics teamStats = snapshot.data![0];
          Transferp ptransfer = snapshot.data![0];
          return ListView.builder(
            itemCount: ptransfer.transfers.length,
            itemBuilder: (context, index) {
              final transfer = ptransfer.transfers[index];
              return ListTile(
                title: Text(
                    'Transfer Date: ${DateFormat('MMM d, yyyy').format(DateTime.parse(transfer.date))}'),
                subtitle: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('From: ${transfer.outTeam.name}'),
                    Text('To: ${transfer.inTeam.name}'),
                    Text('Type: ${transfer.type}'),
                  ],
                ),
                leading: CircleAvatar(
                  backgroundImage:
                      NetworkImage(transfer.outTeam.logo.toString()),
                ),
                trailing: CircleAvatar(
                  backgroundImage:
                      NetworkImage(transfer.inTeam.logo.toString()),
                ),
              );
            },
          );
        } else {
          return Center(child: Text('No data available'));
        }
      },
    );
  }

  @override
  Widget _playerinfotab() {
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          children: [
            const SizedBox(height: 15),
            const Align(
              alignment: Alignment.center,
              child: Text(
                'Player Information',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
            ),
            _buildplayerinfo(), // Use the received player data
            const SizedBox(height: 10),
            const Align(
              alignment: Alignment.center,
              child: Text(
                'Player Stats',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
            ),
            _buildplayerstats(), // Use the received player stats data
          ],
        ),
      ),
    );
  }
}
