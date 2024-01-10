class Event {
  final String creator;
  final String name;
  final DateTime startTime;
  final DateTime endTime;
  final String location;
  bool isParticipating;
  List<String> participants;

  Event({
    required this.creator,
    required this.name,
    required this.startTime,
    required this.endTime,
    required this.location,
    required this.isParticipating,
    required this.participants,
  });

  Map<String, dynamic> toJson() {
    return {
      'creator': creator,
      'name': name,
      'startTime': startTime.toIso8601String(),
      'endTime': endTime.toIso8601String(),
      'location': location,
      'isParticipating': isParticipating,
      'participants': participants,
    };
  }

  factory Event.fromJson(Map<String, dynamic> json) {
    return Event(
      creator: json['creator'],
      name: json['name'],
      startTime: DateTime.parse(json['startTime']),
      endTime: DateTime.parse(json['endTime']),
      location: json['location'],
      isParticipating: json['isParticipating'],
      participants: List<String>.from(json['participants']),
    );
  }
}
