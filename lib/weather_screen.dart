import 'dart:convert';
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:weather_app/secrets.dart';

import 'AddittionalInfoColumn.dart';
import 'hourly_Forecast_Card.dart';
import 'package:http/http.dart' as http;

class WeatherScreen extends StatefulWidget {
  const WeatherScreen({super.key});

  @override
  State<WeatherScreen> createState() => _WeatherScreenState();
}

class _WeatherScreenState extends State<WeatherScreen> {
//It should be asynchronous
  Future<Map<String, dynamic>> getCurrentWeather() async {
    try {
      String cityName = 'Delhi';
      final res = await http.get(
        Uri.parse(
            'https://api.openweathermap.org/data/2.5/forecast?q=$cityName&APPID=$openWeatherAPIKey'),
      );
      final data = jsonDecode(res.body);
      if (data['cod'] != '200') {
        throw "An unexpected error occurred";
      }
      return data;
    } catch (e) {
      throw e.toString;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "Weather App",
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
        actions: [
          IconButton(
            onPressed: () {
              setState(() {});
            },
            icon: const Icon(Icons.refresh),
          ),
        ],
      ),
      body: FutureBuilder(
        future: getCurrentWeather(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }
          if (snapshot.hasError) {
            return Text(snapshot.error.toString());
          }

          final data = snapshot.data!;
          final currentWeather = data['list'][0];
          final currentTemp = currentWeather['main']['temp'];
          final currentSky = currentWeather['weather'][0]['main'];
          final currentPressure = currentWeather['main']['pressure'];
          final currentHumidity = currentWeather['main']['humidity'];
          final currentSpeed = currentWeather['wind']['speed'];
          return Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                //mainCard
                SizedBox(
                  width: double.infinity,
                  child: Card(
                    elevation: 10,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16)),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(16),
                      child: BackdropFilter(
                        filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
                        child: Padding(
                          padding: const EdgeInsets.all(16.0),
                          child: Column(
                            children: [
                              Text(
                                "$currentTemp K",
                                style: const TextStyle(
                                    fontSize: 32, fontWeight: FontWeight.bold),
                              ),
                              const SizedBox(height: 16),
                              Icon(
                                currentSky == 'Clouds' || currentSky == 'Rain'
                                    ? Icons.cloud
                                    : Icons.sunny,
                                size: 54,
                              ),
                              const SizedBox(
                                height: 16,
                              ),
                              Text(
                                currentSky,
                                style: const TextStyle(
                                  fontSize: 20,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
                const SizedBox(
                  height: 20,
                ),
                const Text(
                  "Weather Forecast",
                  style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                ),
                const SizedBox(
                  height: 16,
                ),
                // SingleChildScrollView(
                //   scrollDirection: Axis.horizontal,
                //   child: Row(
                //     children: [
                //       for (int i = 0; i < 5; i++)
                //         HourlyForecastCard(
                //             time: data['list'][i + 1]['dt'].toString(),
                //             icon: data['list'][i + 1]['weather'][0]['main'] ==
                //                         'Clouds' ||
                //                     data['list'][i + 1]['weather'][0]['main'] ==
                //                         'Rain'
                //                 ? Icons.cloud
                //                 : Icons.sunny,
                //             temp:
                //                 data['list'][i + 1]['main']['temp'].toString()),
                //     ],
                //   ),
                // ),
                SizedBox(
                  height: 120,
                  child: ListView.builder(
                    itemCount: 10,
                    scrollDirection: Axis.horizontal,
                    itemBuilder: (context, index) {
                      final hourlyForecast = data['list'][index + 1];
                      final hourlyWeather =
                          data['list'][index + 1]['weather'][0]['main'];
                      final hourlyTemp = hourlyForecast['main']['temp'];
                      final hourlyTime = hourlyForecast['dt'];
                      final time = DateTime.parse(hourlyForecast['dt_txt']);
                      return HourlyForecastCard(
                          time: DateFormat.j().format(time),
                          icon: hourlyWeather == 'Clouds' ||
                                  hourlyWeather == 'Rain'
                              ? Icons.cloud
                              : Icons.sunny,
                          temp: hourlyTemp.toString());
                    },
                  ),
                ),
                const SizedBox(
                  height: 20,
                ),
                const Text(
                  "Additional Information",
                  style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                ),
                const SizedBox(
                  height: 16,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    AdditionInfoColumn(
                        icon: Icons.water_drop,
                        label: "Humidity",
                        value: currentHumidity.toString()),
                    AdditionInfoColumn(
                        icon: Icons.air,
                        label: "Wind Speed",
                        value: currentSpeed.toString()),
                    AdditionInfoColumn(
                        icon: Icons.beach_access,
                        label: "Pressure",
                        value: currentPressure.toString()),
                  ],
                ),
                //additional forecast card
              ],
            ),
          );
        },
      ),
    );
  }
}
