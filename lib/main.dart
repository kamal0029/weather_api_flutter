import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Weather app',
      theme: ThemeData(
        primarySwatch: Colors.red,
      ),
      home: const MyHomePage(title: 'Weather home'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});
  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  final TextEditingController inputcity = new TextEditingController();
  final _formkey = new GlobalKey<FormState>();
  var _inputCity = "";

  var city;
  var state;
  var country;
  var temperature;
  var weather_report;
  var humidity;
  var wind_speed;

  Future getweather() async {
    var URL =
        "http://api.weatherapi.com/v1/current.json?key=8868e7d431964dd89a265801230604&q=+" +
            _inputCity +
            "&aqi=no";
    http.Response response = await http.get(Uri.parse(URL));
    var result = jsonDecode(response.body);

    setState(() {
      this.city = result['location']['name'];
      this.state = result['location']['region'];
      this.country = result['location']['country'];
      this.temperature = result['current']['temp_c'];
      this.weather_report = result['current']['condition']['text'];
      this.humidity = result['current']['humidity'];
      this.wind_speed = result['current']['wind_kph'];
    });
  }

  

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    setState(() {
      _inputCity = "hosur";
    });
    this.getweather();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text("Weather Details Application"),
          backgroundColor: Colors.red,
          centerTitle: true,
        ),
        body: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              height: MediaQuery.of(context).size.height / 4,
              width: MediaQuery.of(context).size.width,
              decoration: new BoxDecoration(
                  image: new DecorationImage(
                      image: new AssetImage("assets/w.jpg"), fit: BoxFit.cover)),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Padding(
                    padding: EdgeInsets.only(top: 20),
                    child: Text(
                      this.city.toString(),
                      style:
                          TextStyle(fontSize: 25, fontWeight: FontWeight.w500),
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.only(bottom: 20),
                    child: Text(
                      this.state.toString() + "," + this.country.toString(),
                      style:
                          TextStyle(fontSize: 15, fontWeight: FontWeight.w500),
                    ),
                  )
                ],
              ),
            ),
            Expanded(
                child: Padding(
              padding: EdgeInsets.all(20),
              child: ListView(
                children: [
                  ListTile(
                    leading: Image.asset('assets/tempe.png'),
                    title: Text("Temperature"),
                    trailing: Text(this.temperature.toString() + "\u00B0C"),
                  ),
                  ListTile(
                    leading: Image.asset(
                      'assets/wil.png',
                      height: 30,
                    ),
                    title: Text("Weather"),
                    trailing: Text(this.weather_report.toString()),
                  ),
                  ListTile(
                    leading: Image.asset('assets/hum.png', height: 30),
                    title: Text("Humidity"),
                    trailing: Text(this.humidity.toString() + "%"),
                  ),
                  ListTile(
                    leading: Image.asset('assets/windd.jpg', height: 30),
                    title: Text("Wind Speed"),
                    trailing: Text(this.wind_speed.toString() + "kph"),
                  ),
                ],
              ),
            )),
            Padding(
              padding: EdgeInsets.all(20),
              child: Form(
                key: _formkey,
                child: TextFormField(
                  controller: inputcity,
                  decoration: const InputDecoration(
                      hintText: "city",
                      labelText: "city",
                      border: OutlineInputBorder()),
                  validator: (val) {
                    if (val!.length == 0) {
                      return "Enter valid city";
                    }
                  },
                ),
              ),
            ),
            SizedBox(
              height: 40.0,
            ),
            ElevatedButton(
                onPressed: () {
                  if (!_formkey.currentState!.validate()) {
                    return;
                  }
                  var input = inputcity.text;
                  setState(() {
                    _inputCity = input.toString();
                  });
                  getweather();
                },
                style: OutlinedButton.styleFrom(

                    padding: const EdgeInsets.fromLTRB(20, 20, 20, 20)),

                child: Text("Find weather")),
            SizedBox(
              height: 60.0,
            ),
          ],
        ));
  }
}
