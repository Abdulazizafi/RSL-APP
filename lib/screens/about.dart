import 'package:flutter/material.dart';
import 'package:football_app/constants.dart';

void main() {
  runApp(MaterialApp(
    home: SPLPage(),
  ));
}

class SPLPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Image.asset(
              "assets/images/file_0bfae61b-c268-48f2-9476-268a438e946c.png",
              height: 60,
              width: 60,
            ),
            Text(
              'Saudi Pro League Info',
              style: TextStyle(color: Colors.white),
            ),
          ],
        ),
        backgroundColor: kprimaryColor,
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            buildSectionTitle(context, "Overview"),
            buildSectionText(
                "The Saudi Pro League was established in 2008 under the name of the Saudi Professional League Authority and operates under the Saudi Arabian Football Federation. It has full administrative and financial independence and holds all commercial rights to the league competitions in its excellent category."),
            SizedBox(height: 20),
            buildSectionTitle(context, "Chairmen of the Board"),
            buildSectionText(
                "• Prince Nawaf Bin Faisal (Aug 2008 - Feb 2012)\n• Mr. Mohamed Al-Nuwaiser (Feb 2012 - Jan 2016)\n• Mr. Yasser Al-Mashel (Jan 2016 - Oct 2017)\n• Mr. Adel Ezzat (Dec 2017 - Mar 2018)\n• Mr. Musalli Al-Muammar (Mar 2018 - Jan 2020)\n• Eng. Abdulaziz Al Afaleq (Since Sep 2020)"),
            SizedBox(height: 20),
            buildSectionTitle(context, "Executive Directors"),
            buildSectionText(
                "• Mr. Mohamed Al-Nuweiser (Aug 2008 - Feb 2012)\n• Mr. Yasser Al-Mashal (Jul 2013 - Jan 2016)\n• Mr. Saad Al-Lathith (Jun 2016 - Jan 2017)\n• Mr. Abdulaziz Al-Hamidi (Since Jan 2017)"),
            SizedBox(height: 20),
            buildSectionTitle(context, "Main Roles and Competences"),
            buildSectionText(
                "The SPL is tasked with organizing, managing, and marketing the Professional League. It creates, publishes, and modifies operational rules and represents member clubs. It provides consultancy, assigns match commissioners, negotiates commercial contracts, manages media services, distributes financial allocations, develops social responsibility activities, and cooperates with local and international football bodies."),
            SizedBox(height: 20),
            buildSectionTitle(context, "Mission & Vision"),
            buildSectionText(
                "The SPL aims to be among the top ten leagues in the world, technically, commercially, and financially. It focuses on supporting clubs in finding sponsors and developing their business plans, as well as developing electronic and social media materials, and preserving the commercial rights of clubs."),
          ],
        ),
      ),
    );
  }

  Widget buildSectionTitle(BuildContext context, String text) {
    return Text(text, style: Theme.of(context).textTheme.headline6);
  }

  Widget buildSectionText(String text) {
    return Text(text, style: TextStyle(fontSize: 16, height: 1.5));
  }
}
