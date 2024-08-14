class SoccerMatch {
  Fixture fixture;
  Team home;
  Team away;
  Goal goal;

  SoccerMatch(this.fixture, this.home, this.away, this.goal);

  factory SoccerMatch.fromJson(Map<String, dynamic> json) {
    return SoccerMatch(
      Fixture.fromJson(json['fixture']),
      Team.fromJson(json['teams']['home']),
      Team.fromJson(json['teams']['away']),
      Goal.fromJson(json['goals']),
    );
  }
}

class Fixture {
  int id;
  String date;
  Status status;
  Venue venue;
  String timezone;

  Fixture(this.id, this.date, this.status, this.venue, this.timezone);

  factory Fixture.fromJson(Map<String, dynamic> json) {
    return Fixture(json['id'], json['date'], Status.fromJson(json['status']),
        Venue.fromJson(json['venue']), json['timezone']);
  }
}

class Venue {
  String name;
  Venue(this.name);
  factory Venue.fromJson(Map<String, dynamic> json) {
    return Venue(json['name']);
  }
}

class Status {
  int elapsedTime;
  String long;
  String short;
  Status(this.elapsedTime, this.long, this.short);

  factory Status.fromJson(Map<String, dynamic> json) {
    return Status(
      json['elapsed'] ?? 0,
      json['long'],
      json['short'],
    );
  }
}

class Team {
  int id;
  String name;
  String logoUrl;
  bool winner;

  Team(this.id, this.name, this.logoUrl, this.winner);

  factory Team.fromJson(Map<String, dynamic> json) {
    return Team(
      json['id'],
      json['name'],
      json['logo'],
      json['winner'] ?? false,
    );
  }
}

class Goal {
  int home;
  int away;

  Goal(this.home, this.away);

  factory Goal.fromJson(Map<String, dynamic> json) {
    return Goal(
      json['home'] ?? 0,
      json['away'] ?? 0,
    );
  }
}
