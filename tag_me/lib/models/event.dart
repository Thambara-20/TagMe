class Event {
  String id;
  final String creator;
  final String name;
  late String district;
  late DateTime startTime;
  late DateTime endTime;
  late String location;
  List<double> geoPoint;
  Map<String, double> coordinates;
  bool isParticipating;
  List<String> participants;
  late bool isOnline;

  Event({
    required this.id,
    required this.creator,
    required this.name,
    required this.district,
    required this.startTime,
    required this.endTime,
    required this.location,
    required this.isParticipating,
    required this.geoPoint,
    required this.coordinates,
    required this.participants,
    required this.isOnline,
  });

  Map<String, dynamic> toJson() {
    return {
      "id": id,
      'creator': creator,
      'name': name,
      'district': district,
      'startTime': startTime.toIso8601String(),
      'endTime': endTime.toIso8601String(),
      'location': location,
      'geoPoint': geoPoint,
      'coordinates': coordinates, // Include the coordinates field
      'isParticipating': isParticipating,
      'participants': participants,
      'isOnline': isOnline,
    };
  }

  factory Event.fromJson(Map<String, dynamic> json) {
    return Event(
      id: json['id'],
      creator: json['creator'],
      name: json['name'],
      district: json['district'],
      startTime: DateTime.parse(json['startTime']),
      endTime: DateTime.parse(json['endTime']),
      location: json['location'],
      isParticipating: json['isParticipating'],
      geoPoint: List<double>.from(json['geoPoint']),
      coordinates: Map<String, double>.from(json['coordinates']),
      participants: List<String>.from(json['participants']),
      isOnline: json['isOnline'],
    );
  }
}
