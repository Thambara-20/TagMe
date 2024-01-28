class Event {
  String id;
  final String creator;
  final String name;
  late DateTime startTime;
  late DateTime endTime;
  late String location;
  List<double> geoPoint;
  Map<String, double> coordinates;
  bool isParticipating;
  List<String> participants;

  Event({
    required this.id,
    required this.creator,
    required this.name,
    required this.startTime,
    required this.endTime,
    required this.location,
    required this.isParticipating,
    required this.geoPoint,
    required this.coordinates,
    required this.participants,
  });

  Map<String, dynamic> toJson() {
    return {
      "id": id,
      'creator': creator,
      'name': name,
      'startTime': startTime.toIso8601String(),
      'endTime': endTime.toIso8601String(),
      'location': location,
      'geoPoint': geoPoint,
      'coordinates': coordinates, // Include the coordinates field
      'isParticipating': isParticipating,
      'participants': participants,
    };
  }

  factory Event.fromJson(Map<String, dynamic> json) {
    return Event(
      id: json['id'],
      creator: json['creator'],
      name: json['name'],
      startTime: DateTime.parse(json['startTime']),
      endTime: DateTime.parse(json['endTime']),
      location: json['location'],
      isParticipating: json['isParticipating'],
      geoPoint: List<double>.from(json['geoPoint']),
      coordinates: Map<String, double>.from(json['coordinates']),
      participants: List<String>.from(json['participants']),
    );
  }
}
