class EventResponse {
  List<Event> events;

  EventResponse({required this.events});

  factory EventResponse.fromJson(Map<String, dynamic> json) {
    return EventResponse(
      events: List<Event>.from(json['response'].map((x) => Event.fromJson(x))),
    );
  }
}

class Event {
  Time time;
  TeamE team;
  PlayerEvent player;
  PlayerEvent? assist;
  String type;
  String detail;
  String? comments;

  Event({
    required this.time,
    required this.team,
    required this.player,
    this.assist,
    required this.type,
    required this.detail,
    this.comments,
  });

  factory Event.fromJson(Map<String, dynamic> json) {
    return Event(
      time: Time.fromJson(json['time']),
      team: TeamE.fromJson(json['team']),
      player: PlayerEvent.fromJson(json['player']),
      assist:
          json['assist'] != null ? PlayerEvent.fromJson(json['assist']) : null,
      type: json['type'],
      detail: json['detail'],
      comments: json['comments'],
    );
  }
}

class Time {
  int elapsed;
  int? extra; // This can be null

  Time({required this.elapsed, this.extra});

  factory Time.fromJson(Map<String, dynamic> json) {
    return Time(
      elapsed: json['elapsed'] ?? 0, // Provide default value if null
      extra: json['extra'],
    );
  }
}

class TeamE {
  int id;
  String name;
  String logo;

  TeamE({
    required this.id,
    required this.name,
    required this.logo,
  });

  factory TeamE.fromJson(Map<String, dynamic> json) {
    return TeamE(
      id: json['id'] ?? 0, // Provide default value if null
      name: json['name'] ?? '', // Provide default empty string if null
      logo: json['logo'] ?? '', // Provide default empty string if null
    );
  }
}

class PlayerEvent {
  int id;
  String name;

  PlayerEvent({
    required this.id,
    required this.name,
  });

  factory PlayerEvent.fromJson(Map<String, dynamic> json) {
    return PlayerEvent(
      id: json['id'] ?? 0, // Provide default value if null
      name: json['name'] ?? '', // Provide default empty string if null
    );
  }
}
