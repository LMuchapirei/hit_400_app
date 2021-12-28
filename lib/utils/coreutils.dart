import 'dart:convert';
import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

void sendResume(String filename, String url) async {
  var request = http.MultipartRequest(
    'POST',
    Uri.parse(url),
  );

  request.files.add(http.MultipartFile('resumefile',
      File(filename).readAsBytes().asStream(), File(filename).lengthSync(),
      filename: filename.split("/").last));
  var res = await request.send();
  var respStr = await res.stream.bytesToString();
  print('This is the status code ${jsonDecode(respStr)}');
  final prefs = await SharedPreferences.getInstance();
  if (prefs.getString('SkillsExtracted') == respStr) {
    print('Already saved these skills use new resume with new skills');
  } else {
    prefs.setString('SkillsExtracted', respStr);
  }
}

Future testGetJobs(String url) async {
  final response = await http.get(Uri.parse(url));
  print('Response status code is ${response.statusCode}');
  if (response.statusCode == 201) {
    // return IndeedJob.fromJson(jsonDecode(response.body));
    //  var parsedList = json.decode(response.body);
    // List<Job> jobList = List<Job>.from(parsedList.map((i) => Job.fromJson(i)));
    var parsedList =
        List<Map<String, dynamic>>.from(json.decode(response.body)['jobs']);
    // List<IndeedJob> joblist =
    //     List<IndeedJob>.from(parsedList.map((i) => IndeedJob.fromJson(i)));
    // joblist.forEach((element) {
    //   print(element);
    // });
    var newList = parsedList.map((job) => IndeedJob.fromJson(job)).toList();
    print(newList[0]);
    return newList;
  } else {
    throw Exception('Failed to load Jobs');
  }
}

class IndeedJobList {
  IndeedJobList({@required this.indeedJobs});
  final List<IndeedJob> indeedJobs;

  factory IndeedJobList.fromJson(Map<String, dynamic> json) {
    return IndeedJobList(indeedJobs: json['jobs']);
  }
}

class IndeedJob {
  final String title;
  final String location;
  final String summary;
  final String salary;
  final String url;
  final String details;
  final String company;

  const IndeedJob(
      {@required this.company,
      @required this.details,
      @required this.location,
      @required this.salary,
      @required this.summary,
      @required this.title,
      @required this.url});
  factory IndeedJob.fromJson(Map<String, dynamic> json) {
    return IndeedJob(
        company: json['company'],
        details: json['details'],
        location: json['location'],
        salary: json['salary'],
        summary: json['summary'],
        title: json['title'],
        url: json['url']);
  }
}
