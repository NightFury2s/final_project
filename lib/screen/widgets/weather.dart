import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:geolocator/geolocator.dart';

class WeatherWidget extends StatefulWidget {
  @override
  _WeatherWidgetState createState() => _WeatherWidgetState();
}

class _WeatherWidgetState extends State<WeatherWidget> {
  late String _weatherCondition = '';

  @override
  void initState() {
    super.initState();
    _fetchWeatherData();
  }

  Future<void> _fetchWeatherData() async {
    // Lấy vị trí hiện tại của người dùng
    Position position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high);

    final apiKey = "32579295bbb55fca1f778c98c988c27a";
    final apiUrl =
        "http://api.openweathermap.org/data/2.5/weather?lat=${position.latitude}&lon=${position.longitude}&appid=$apiKey&units=metric";

    final response = await http.get(Uri.parse(apiUrl));

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      setState(() {
        _weatherCondition = _getWeatherDescription(data['weather'][0]['main']);
      });
    } else {
      setState(() {
        _weatherCondition = 'N/A';
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      height: 70,
      alignment: Alignment.centerLeft,
      padding: EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            blurRadius: 10,
            spreadRadius: 5,
            color: Colors.black.withOpacity(.1),
          ),
        ],
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(35),
          bottomLeft: Radius.circular(35),
        ),
      ),
      child: Row(
        children: [
          Container(
            width: 50,
            height: 50,
            decoration: BoxDecoration(
              color: Colors.grey.withOpacity(.1),
              shape: BoxShape.circle,
            ),
            child: Icon(
              _getWeatherIcon(),
              size: 30,
              color: Colors.grey,
            ),
          ),
          SizedBox(width: 10),
          Text(
            "Thời tiết hiện tại: $_weatherCondition",
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }

  IconData _getWeatherIcon() {
    switch (_weatherCondition.toLowerCase()) {
      case 'nắng':
        return Icons.wb_sunny;
      case 'mây':
        return Icons.cloud;
      case 'mưa':
        return Icons.beach_access;
      default:
        return Icons.wb_sunny;
    }
  }

  String _getWeatherDescription(String weatherMain) {
    switch (weatherMain.toLowerCase()) {
      case 'clear':
        return 'Nắng';
      case 'clouds':
        return 'Mây';
      case 'rain':
        return 'Mưa';
      default:
        return 'Không rõ';
    }
  }
}
