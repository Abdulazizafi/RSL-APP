import 'package:flutter/material.dart';
import 'package:football_app/api/api_manager.dart';
import 'package:football_app/api/soccermodel.dart';
import 'package:football_app/constants.dart';
import 'package:football_app/widgets/matchW.dart';
import 'dart:async';
import 'package:iconsax/iconsax.dart';

class AllMatchesScreen extends StatefulWidget {
  @override
  _AllMatchesScreenState createState() => _AllMatchesScreenState();
}

class _AllMatchesScreenState extends State<AllMatchesScreen> {
  List<SoccerMatch> _allOrFilteredMatches = [];

  Future<void> _updateMatches() async {
    try {
      List<SoccerMatch> matches = await SoccerApi().getAllMatches();
      // Apply filter if a date is selected
      if (selectedDate != null) {
        _allOrFilteredMatches = matches.where((match) {
          // Assuming match.fixture.date is a string in ISO8601 format
          DateTime matchDate = DateTime.parse(match.fixture.date);
          return matchDate.year == selectedDate!.year &&
              matchDate.month == selectedDate!.month &&
              matchDate.day == selectedDate!.day;
        }).toList();
      } else {
        _allOrFilteredMatches = matches;
      }
      _matchesStreamController.sink.add(_allOrFilteredMatches);
    } catch (e) {
      _matchesStreamController.sink.addError(e);
    }
  }

  DateTime? selectedDate;
  Future<void> pickDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: selectedDate ?? DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2101),
    );
    if (picked != null && picked != selectedDate) {
      setState(() {
        selectedDate = picked;
      });
      _updateMatches();
    }
  }

  void _navigateToAllMatches() {
    Navigator.of(context)
        .push(MaterialPageRoute(builder: (context) => AllMatchesScreen()));
  }

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
    Timer.periodic(Duration(seconds: 5), (timer) {
      _updateMatches();
    });
  }

  Widget pageBody(List<SoccerMatch> allmatches) {
    if (allmatches.isEmpty) {
      return Center(child: Text("No matches available"));
    }
    allmatches.sort((a, b) => b.fixture.date.compareTo(a.fixture.date));
    return Column(
      children: [
        Expanded(
          flex: 5,
          child: Container(
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
                      itemCount: allmatches.length,
                      itemBuilder: (context, index) {
                        // حساب الفهرس المعاكس
                        return matchW(allmatches[index],
                            context); // استخدام الفهرس المعاكس للوصول إلى العنصر
                      },
                    ),
                  )
                ],
              ),
            ),
          ),
        )
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Image.asset(
              "assets/images/file_0bfae61b-c268-48f2-9476-268a438e946c.png", // Replace with your actual logo asset
              height: 60,
              width: 60,
            ),
            const SizedBox(width: 8),
            const Text('FIXTURES', style: TextStyle(color: Colors.white)),
          ],
        ),
        actions: [
          IconButton(
            onPressed: () => pickDate(context),
            icon: const Icon(Iconsax.calendar),
            color: Colors.white,
          ),
        ],
        backgroundColor: kprimaryColor,
        elevation: 1,
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: StreamBuilder<List<SoccerMatch>>(
        stream: _matchesStreamController.stream,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text("Error: ${snapshot.error}"));
          } else if (snapshot.hasData && snapshot.data != null) {
            return pageBody(snapshot.data!); // Non-null assertion used
          } else {
            return Center(child: Text("No matches available"));
          }
        },
      ),
    );
  }

  @override
  void dispose() {
    _matchesStreamController.close();
    super.dispose();
  }
}
