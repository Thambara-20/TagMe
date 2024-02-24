// ignore_for_file: file_names

String formatDateTime(DateTime dateTime) {
  String twoDigits(int n) {
    return n.toString().padLeft(2, '0');
  }

  return '${twoDigits(dateTime.day)}/${twoDigits(dateTime.month)}/${dateTime.year} ${twoDigits(dateTime.hour)}:${twoDigits(dateTime.minute)}';
}
