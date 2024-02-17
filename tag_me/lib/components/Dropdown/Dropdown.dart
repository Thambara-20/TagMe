// ignore_for_file: file_names

import 'package:flutter/material.dart';

class DistrictDropdown extends StatelessWidget {
  final String selectedDistrict;
  final Function(String?) onChanged;
  final List<String> districts;

  const DistrictDropdown({super.key, 
    required this.selectedDistrict,
    required this.onChanged,
    required this.districts,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10.0),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(15.0),
        border: Border.all(
          color: Colors.grey,
          style: BorderStyle.solid,
          width: 0.80,
        ),
      ),
      child: DropdownButtonHideUnderline(
        child: DropdownButton<String>(
          value: selectedDistrict,
          icon: const Icon(Icons.arrow_drop_down),
          iconSize: 24,
          elevation: 16,
          style: const TextStyle(color: Colors.deepPurple),
          onChanged: onChanged,
          items: districts.map<DropdownMenuItem<String>>((String district) {
            return DropdownMenuItem<String>(
              value: district,
              child: Text(
                district,
                style: const TextStyle(
                  color: Color.fromARGB(255, 147, 147, 147),
                ),
              ),
            );
          }).toList(),
        ),
      ),
    );
  }
}
