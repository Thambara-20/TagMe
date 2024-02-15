// ignore_for_file: file_names

import 'package:flutter/material.dart';
import 'package:flutter_countdown_timer/flutter_countdown_timer.dart';
import 'package:logger/logger.dart';
import 'package:tag_me/EventsPage/AddEventPage/AddEventPage.dart';
import 'package:tag_me/components/Dropdown/DropDown.dart';
import 'package:tag_me/constants/constants.dart';
import 'package:tag_me/models/user.dart';
import 'package:tag_me/utilities/cache.dart';
import 'package:tag_me/models/event.dart';
import 'package:tag_me/utilities/dateConvert.dart';

class EventsPage extends StatefulWidget {
  const EventsPage({Key? key}) : super(key: key);

  static const String routeName = '/EventsPage';

  @override
  // ignore: library_private_types_in_public_api
  _EventsPageState createState() => _EventsPageState();
}

class _EventsPageState extends State<EventsPage> {
  List<Event> events = [];
  List<Event> ongoingEvents = [];
  List<Event> upcomingEvents = [];
  List<Event> finishedEvents = [];
  bool isLoading = true;
  late AppUser appUser;
  late bool isAdmin = false;
  late String selectedCategory;
  late String selectedDistrict;
  List<String> districts = [];
  late bool isCreater = false;

  @override
  initState() {
    super.initState();
    selectedCategory = 'Ongoing';
    appUser = AppUser(uid: '', email: '', isAdmin: false);
    selectedDistrict = '';
    _loadData();
    _getUserInfo();
    _listenToEvents();
  }

  void _loadData() {
    loadDistrictsFromCache().then((loadedDistricts) {
      setState(() {
        districts = loadedDistricts;
        selectedDistrict = districts[0];
      });
    });
  }

  void _listenToEvents() {
    loadEventsFromCache().then((loadedEvents) {
      if (mounted) {
        setState(() {
          events = loadedEvents
              .where((event) => event.district == selectedDistrict)
              .toList();
          _categorizeEvents();
          isLoading = false;
        });
      }
    }).catchError(
      (error) {
        Logger().e('Error loading events: $error');
      },
    );
  }

  void _getUserInfo() {
    getLoggedInUserInfo().then((loggedInUser) {
      setState(() {
        isAdmin = loggedInUser.isAdmin;
        appUser = loggedInUser;
      });
    });
  }

  void _categorizeEvents() {
    final now = DateTime.now();
    ongoingEvents = events
        .where((event) =>
            event.startTime.isBefore(now) && event.endTime.isAfter(now))
        .toList();

    upcomingEvents =
        events.where((event) => event.startTime.isAfter(now)).toList();

    finishedEvents =
        events.where((event) => event.endTime.isBefore(now)).toList();
  }

  List<Event> getSelectedCategoryEvents() {
    switch (selectedCategory) {
      case 'Ongoing':
        return ongoingEvents;
      case 'Upcoming':
        return upcomingEvents;
      case 'Finished':
        return finishedEvents;
      default:
        return [];
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: RefreshIndicator(
        onRefresh: _refresh,
        child: Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              colors: [
                keventPageBackgroundColorI,
                keventPageBackgroundColorII,
              ],
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
            ),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Padding(
                padding: EdgeInsets.only(
                    top: MediaQuery.of(context).size.height * 0.0,
                    right: MediaQuery.of(context).size.width * 0.05,
                    bottom: MediaQuery.of(context).size.height * 0.01),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Expanded(
                      child: Padding(
                        padding: EdgeInsets.all(
                            MediaQuery.of(context).size.width * 0.02),
                        child: const Text('Select the district: ',
                            textAlign: TextAlign.right,
                            style: knormalTextGreyStyle),
                      ),
                    ),
                    DistrictDropdown(
                      selectedDistrict: selectedDistrict,
                      onChanged: (String? newValue) {
                        if (newValue != null) {
                          setState(() {
                            selectedDistrict = newValue;
                          });
                          _refresh();
                        }
                      },
                      districts: districts,
                    ),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(
                    top: 8.0, bottom: 8.0, left: 16.0, right: 16.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    _buildNavigationBarItem('Ongoing'),
                    _buildNavigationBarItem('Upcoming'),
                    _buildNavigationBarItem('Finished'),
                  ],
                ),
              ),
              Expanded(
                child: isLoading
                    ? const Center(
                        child: Text('No events available.',
                            style: keventPageSmallTextStyle),
                      )
                    : ListView.builder(
                        itemCount: getSelectedCategoryEvents().length,
                        itemBuilder: (context, index) {
                          return _buildEventListItem(
                              getSelectedCategoryEvents()[index]);
                        },
                      ),
              ),
            ],
          ),
        ),
      ),
      floatingActionButton: isAdmin
          ? FloatingActionButton(
              onPressed: () {
                _onCreateEvent(context);
              },
              backgroundColor: kAddButtonColor,
              child: const Icon(Icons.add),
            )
          : null,
    );
  }

  Widget _buildNavigationBarItem(String category) {
    return Expanded(
      child: GestureDetector(
        onTap: () {
          setState(() {
            selectedCategory = category;
          });
        },
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
          decoration: BoxDecoration(
            color: selectedCategory == category
                ? keventPageNavbarColorII
                : keventPageNavbarColorIII,
            borderRadius: BorderRadius.circular(10.0),
          ),
          child: Text(
            category,
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: MediaQuery.of(context).size.width * 0.035,
              color: selectedCategory == category
                  ? keventPageNavbarColorI
                  : keventPageNavbarColorII,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildEventListItem(Event event) {
    bool isCreater = event.creator == appUser.uid;
    bool isEventOngoing = DateTime.now().isAfter(event.startTime) &&
        DateTime.now().isBefore(event.endTime);
    bool isEventUpcoming = DateTime.now().isBefore(event.startTime);

    String eventStatus =
        isEventOngoing ? 'Ongoing..' : (isEventUpcoming ? 'Upcoming' : '');

    return Card(
      margin: const EdgeInsets.all(10.0),
      color: keventCardColor,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(15.0),
        side: const BorderSide(
          color: keventCardBorderColor,
          width: 0.5,
        ),
      ),
      child: Container(
        decoration: BoxDecoration(
          color: keventCardColor,
          borderRadius: BorderRadius.circular(15.0),
          boxShadow: [
            BoxShadow(
              color: keventPageBackgroundColorI.withOpacity(0.3),
              spreadRadius: 2,
              blurRadius: 5,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: ExpansionTile(
          title: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Flexible(
                child: Text(
                  'Project: ${event.name}',
                  style: const TextStyle(
                      fontSize: 20.0, fontWeight: FontWeight.bold),
                ),
              ),
              if (isEventOngoing || isEventUpcoming)
                Row(
                  children: [
                    Icon(
                      isEventOngoing
                          ? Icons.access_time
                          : Icons.pending_actions,
                      color: isEventOngoing
                          ? keventOngoingButtonColor
                          : keventUpcomingButtonColor,
                    ),
                    const SizedBox(width: 4.0),
                    Text(
                      eventStatus,
                      style: TextStyle(
                        fontSize: 12.0,
                        color: isEventOngoing
                            ? keventOngoingButtonColor
                            : keventUpcomingButtonColor,
                      ),
                    ),
                  ],
                ),
            ],
          ),
          subtitle: Text(
            'Starts At: ${formatDateTime(event.startTime)}',
            style: const TextStyle(fontSize: 16.0),
          ),
          children: [
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Center(
                    child: Text(
                      'End Time: ${formatDateTime(event.endTime)}',
                      style: const TextStyle(fontSize: 16.0),
                    ),
                  ),
                  Center(
                    child: Text(
                      'Location: ${event.location}',
                      style: const TextStyle(fontSize: 16.0),
                    ),
                  ),
                  const SizedBox(height: 2.0),
                  Center(
                    child: CountdownTimer(
                        endTime: event.startTime.millisecondsSinceEpoch,
                        textStyle: kcountDownTextStyle),
                  ),
                  const SizedBox(height: 16.0),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      if (isAdmin && isCreater)
                        ElevatedButton(
                          style: ButtonStyle(
                            backgroundColor: MaterialStateProperty.all<Color>(
                                keventCardUpdateButtonColor),
                          ),
                          onPressed: () {
                            _onEventTapped(context, event);
                          },
                          child: const Text('Update',
                              style: knormalTextWhiteStyle),
                        ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _onEventTapped(BuildContext context, Event event) async {
    await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => AddEventForm(
          selectedEvent: event,
        ),
      ),
    );
  }

  void _onCreateEvent(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => const AddEventForm(),
      ),
    );
    saveEventsToCache(events);
  }

  Future<void> _refresh() async {
    await Future.delayed(const Duration(seconds: 1));

    loadEventsFromCache().then((loadedEvents) {
      setState(() {
        events = loadedEvents;
      });
      _listenToEvents();
    });
  }
}
