// ignore_for_file: file_names, library_private_types_in_public_api

import 'package:flutter/material.dart';
import 'package:tag_me/constants/constants.dart';
import 'package:tag_me/utilities/userServices.dart';

class ParticipantsPage extends StatefulWidget {
  final List<String> participants;
  final String project;

  const ParticipantsPage(
      {Key? key, required this.participants, required this.project})
      : super(key: key);

  @override
  _ParticipantsPageState createState() => _ParticipantsPageState();
}

class _ParticipantsPageState extends State<ParticipantsPage> {
  late List<Map<String, dynamic>> participantsInfo;

  @override
  void initState() {
    super.initState();
    participantsInfo = [];
    _loadParticipantsInfo();
  }

  Future<void> _loadParticipantsInfo() async {
    List<Future<Map<String, dynamic>>> futures = [];

    for (String uid in widget.participants) {
      futures.add(getParticipantsInfo(uid));
    }

    participantsInfo = await Future.wait(futures);

    // Ensure the widget rebuilds after fetching data
    if (mounted) {
      setState(() {});
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Participants'),
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.all(10.0),
              child: Text('Project: ${widget.project}',
                  style: knormalTextBlueStyle),
            ),
            PaginatedDataTable(
              rowsPerPage: 10,
              columnSpacing: 10,
              columns: const [
                DataColumn(label: Text('Id')),
                DataColumn(label: Text('Name')),
                DataColumn(label: Text('Role')),
                DataColumn(label: Text('Designation')),
                DataColumn(label: Text('District')),
                DataColumn(label: Text('Club'))
              ],
              source: _ParticipantDataSource(participantsInfo),
            ),
          ],
        ),
      ),
    );
  }
}

class _ParticipantDataSource extends DataTableSource {
  final List<Map<String, dynamic>> participantsInfo;

  _ParticipantDataSource(this.participantsInfo);

  String truncate(String uid) {
    const maxLength = 5;

    if (uid.length <= maxLength) {
      return uid;
    } else {
      return '${uid.substring(0, maxLength)}...';
    }
  }

  @override
  DataRow? getRow(int index) {
    if (index >= participantsInfo.length) {
      return null;
    }

    Map<String, dynamic> participant = participantsInfo[index];

    return DataRow(cells: [
      DataCell(Text(index.toString())),
      DataCell(Text(truncate(participant['name']))),
      DataCell(Text(participant['role'])),
      DataCell(Text(participant['designation'] == ''
          ? 'N/A'
          : participant['designation'])),
      DataCell(Text(participant['district'])),
      DataCell(Text(participant['userClub'])),
    ]);
  }

  @override
  int get rowCount => participantsInfo.length;

  @override
  bool get isRowCountApproximate => false;

  @override
  int get selectedRowCount => 0;
}
