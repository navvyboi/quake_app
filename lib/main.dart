import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:async';
import 'dart:convert';
import 'package:intl/intl.dart';

void main() async {
  Map _data = await getAPI();
  List _features = _data['features'];

  runApp(MaterialApp(
      title: "Quake App",
      home: Scaffold(
        appBar: AppBar(
          title: Text("Quake App"),
          backgroundColor: Colors.red,
        ),
        body: Container(
            child: Center(
                child: ListView.builder(
          padding: EdgeInsets.all(8.0),
          itemCount: _features.length,
          itemBuilder: (BuildContext context, int position) {
            return Column(
              children: <Widget>[
                Divider(height: 5.0),
                ListTile(
                  title: Text(
                    "${getTime(
                                _features[position]['properties']['time'])}",
                    style: TextStyle(
                        fontWeight: FontWeight.w600,
                        color: Colors.orangeAccent,
                        fontSize: 18.0),
                  ),
                  subtitle: Text(
                    _features[position]['properties']['place'],
                    style: TextStyle(
                        fontStyle: FontStyle.italic,
                        fontSize: 15.0,
                        color: Colors.black),
                  ),
                  leading: CircleAvatar(
                    backgroundColor: _features[position]['properties']['mag'] > 2 ? Colors.red : Colors.green,
                    child: Text(
                      "${_features[position]['properties']['mag']}",
                      style: TextStyle(
                          color: Colors.white, fontWeight: FontWeight.w600),
                    ),
                  ),
                  onTap: () => onTapQuake(
                      context, _features[position]['properties']['title']),
                )
              ],
            );
          },
        ))),
      )));
}

Future<Map> getAPI() async {
  String apiURL =
      "https://earthquake.usgs.gov/earthquakes/feed/v1.0/summary/all_day.geojson";
  http.Response response = await http.get(apiURL);
  return json.decode(response.body);
}

void onTapQuake(BuildContext context, String message) {
  var alert = AlertDialog(
    title: Text("Quake Info"),
    content: Text(message),
    actions: <Widget>[
      FlatButton(
        child: Text("Done"),
        onPressed: () {
          Navigator.pop(context);
        },
      )
    ],
  );
  showDialog(context: context, builder: (context) => alert);
}

String getTime(int milliseconds) {
  DateTime date = new DateTime.fromMillisecondsSinceEpoch(milliseconds);
  DateFormat format = new DateFormat.yMMMd();
  DateFormat formatT = new DateFormat.jm();
  String dateString = format.format(date);
  String timeString = formatT.format(date);
  return dateString + " " + timeString;
}
