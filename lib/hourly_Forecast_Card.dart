import 'package:flutter/material.dart';

class HourlyForecastCard extends StatelessWidget {
  final String time;
  final IconData icon;
  final String temp;
  const HourlyForecastCard(
      {super.key, required this.time, required this.icon, required this.temp});

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 10,
      child: Container(
        width: 100,
        padding: const EdgeInsets.all(8.0),
        decoration: BoxDecoration(borderRadius: BorderRadius.circular(16)),
        child: Column(
          children: [
            Text(
              time,
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            const SizedBox(
              height: 10,
            ),
            Icon(
              icon,
              size: 30,
            ),
            const SizedBox(
              height: 10,
            ),
            Text(
              temp,
            ),
          ],
        ),
      ),
    );
  }
}
