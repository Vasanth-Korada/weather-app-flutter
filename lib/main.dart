import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:http/http.dart' as http;
import 'package:weather_app/models/weather_response.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Weather App',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
        textTheme: GoogleFonts.nunitoSansTextTheme(Theme.of(context).textTheme),
      ),
      home: const WeatherApp(),
    );
  }
}

class WeatherApp extends StatefulWidget {
  const WeatherApp({super.key});

  @override
  State<WeatherApp> createState() => _WeatherAppState();
}

class _WeatherAppState extends State<WeatherApp> {
  final TextEditingController cityNameController = TextEditingController();
  WeatherModel? weatherApiResponse;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          image: DecorationImage(
            image: const AssetImage("assets/images/weather_app_bg.jpeg"),
            fit: BoxFit.cover,
            filterQuality: FilterQuality.high,
            colorFilter: ColorFilter.mode(
              Colors.black.withOpacity(0.7),
              BlendMode.overlay,
            ),
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                decoration: BoxDecoration(
                  color: Colors.yellow.shade100,
                  borderRadius: const BorderRadius.all(Radius.circular(12)),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    children: [
                      TextFormField(
                        controller: cityNameController,
                        decoration: const InputDecoration(
                          label: Text("Enter City Name"),
                          hintText: "E.g: Visakhapatnam",
                          border: OutlineInputBorder(),
                        ),
                      ),
                      const SizedBox(height: 20),
                      OutlinedButton(
                        style: ButtonStyle(backgroundColor: MaterialStateProperty.all<Color>(Colors.indigo)),
                        onPressed: () async {
                          http.Response response = await http.get(
                            Uri.parse(
                              "https://api.openweathermap.org/data/2.5/weather?q=${cityNameController.text}&appid=4fd7b672bc4f3bd0163e374f22819db4&units=metric",
                            ),
                          );
                          setState(() {
                            weatherApiResponse = weatherModelFromJson(response.body);
                          });
                        },
                        child: const Text(
                          "Get Weather",
                          style: TextStyle(color: Colors.white),
                        ),
                      ),
                      const SizedBox(height: 20),
                      if (weatherApiResponse != null) ...[
                        Text(
                          "Temperature at ${cityNameController.text} is ${weatherApiResponse?.main?.temp ?? "NA"}\u2103",
                        )
                      ],
                    ],
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
