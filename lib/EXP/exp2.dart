import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

void main() => runApp(LocationFinderApp());

class LocationFinderApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Location Finder',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: LocationFinderPage(),
    );
  }
}

class LocationFinderPage extends StatefulWidget {
  @override
  _LocationFinderPageState createState() => _LocationFinderPageState();
}

class _LocationFinderPageState extends State<LocationFinderPage> {
  final TextEditingController _locationController = TextEditingController();
  String _coordinates = '';
  bool _isLoading = false;
  String _errorMessage = '';

  @override
  void dispose() {
    _locationController.dispose();
    super.dispose();
  }

  Future<void> _fetchCoordinates() async {
    final String location = _locationController.text.trim();

    if (location.isEmpty) {
      setState(() {
        _errorMessage = 'Please enter a location';
      });
      return;
    }

    setState(() {
      _isLoading = true;
      _errorMessage = '';
    });

    final String apiKey = '7863f3723b1e47d99efbb3fafff86a73';
    final String url = 'https://api.opencagedata.com/geocode/v1/json?q=$location&key=$apiKey';

    try {
      final response = await http.get(Uri.parse(url));

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        final results = data['results'];
        if (results != null && results.isNotEmpty) {
          final double latitude = results[0]['geometry']['lat'];
          final double longitude = results[0]['geometry']['lng'];
          setState(() {
            _coordinates = 'Latitude: $latitude, Longitude: $longitude';
            _isLoading = false;
          });
        } else {
          setState(() {
            _errorMessage = 'No results found';
            _isLoading = false;
          });
        }
      } else {
        setState(() {
          _errorMessage = 'Failed to fetch coordinates';
          _isLoading = false;
        });
      }
    } catch (e) {
      setState(() {
        _errorMessage = 'Error: $e';
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Location Finder'),
        backgroundColor: Colors.blueAccent,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: <Widget>[
            TextField(
              controller: _locationController,
              decoration: InputDecoration(
                labelText: 'Enter Location',
                errorText: _errorMessage.isNotEmpty ? _errorMessage : null,
              ),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: _isLoading ? null : _fetchCoordinates,
              child: _isLoading
                  ? CircularProgressIndicator()
                  : Text('Find Coordinates'),
            ),
            SizedBox(height: 20),
            Text(
              _coordinates,
              style: TextStyle(fontSize: 24),
            ),
          ],
        ),
      ),
    );
  }
}
