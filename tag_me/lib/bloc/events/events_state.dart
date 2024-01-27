import 'package:tag_me/utilities/event.dart';

class EventsState {
  final List<Event> events;
  final bool isLoading;

  EventsState({required this.events, required this.isLoading});

  EventsState copyWith({List<Event>? events, bool? isLoading}) {
    return EventsState(
      events: events ?? this.events,
      isLoading: isLoading ?? this.isLoading,
    );
  }
}
