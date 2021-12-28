import 'dart:collection';
import 'dart:convert';
import 'dart:io';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:hit_400_app/core/services/job_service.dart';
import 'package:hit_400_app/screens/PostJobPage.dart';
import 'package:hit_400_app/utils/constants.dart';
import 'package:hit_400_app/utils/coreutils.dart';
import 'package:mailer/mailer.dart';
import 'package:mailer/smtp_server/gmail.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:provider/provider.dart';

void main() {
  test('Fetch Local Jobs', () async {
    final jobservice = JobService();
    var res = await jobservice.fetchLocalJobs();
    if (res.isNotEmpty) {
      expect(jobservice.localPosting.length > 0, true);
    }
  });

  test('Fetch Scrapped Jobs', () async {
    final jobservice = JobService();
    var res = await jobservice.fetchJobs();
    if (res.isNotEmpty) {
      expect(jobservice.localPosting.length > 0, true);
    }
  });

  test('Test Api service m1 fetchAllJobs', () async {
    final api = Api();
    var res = await api.fetchAllJobs();
    if (res.isNotEmpty) {
      expect(res.length > 0, true);
    }
  });

  test('Test APi Service m2 fetchAllJobs', () async {
    final api = Api();
    var res = await api.getLocalPosts();
    if (res.isNotEmpty) {
      expect(res.length > 0, true);
    }
  });

  test('Test API Service m3 getKeywords similar', () async {
    final api = Api();
    var res = await api.getSimilarKeywords('Java');
    if (res.isNotEmpty) {
      expect(res.length > 0, true);
    }
  });
}

class JobService with ChangeNotifier {
  Api _api = Api();
  String _accessToken = "";
  User _user;
  String get accessToken => _accessToken;
  User get user => _user;
  set setUser(User user) {
    _user = user;
  }

  set setAccessToken(String token) {
    _accessToken = token;
  }

  List<IndeedJob> _jobs = [];

  List<LocalPosting> _localPostings = [];
  UnmodifiableListView<IndeedJob> get jobs =>
      UnmodifiableListView<IndeedJob>(_jobs);
  UnmodifiableListView<LocalPosting> get localPosting =>
      UnmodifiableListView(_localPostings);
  bool isLoading = true;
  bool failedToLoad = false;
  JobService() {
    _api.fetchAllJobs().then((jobs) {
      _jobs = jobs;
      isLoading = false;
      notifyListeners();
    }).catchError((err) {
      failedToLoad = true;
      notifyListeners();
    });
    fetchLocalJobs();
  }

  void refreshJobs() {
    isLoading = true;
    _api.fetchAllJobs().then((jobs) {
      _jobs = jobs;
      isLoading = false;
      notifyListeners();
    }).catchError((err) {
      failedToLoad = true;
      notifyListeners();
    });
  }

  void postJob(LocalPosting post) {
    _api.postLocalJob(post);
  }

  Future<List<LocalPosting>> fetchLocalJobs() async {
    var localJobs = await _api.getLocalPosts();
    _localPostings = localJobs;
    notifyListeners();
    return localJobs;
  }

  Future<List<IndeedJob>> fetchJobs() async {
    var jobsRes = await _api.fetchAllJobs();
    _jobs = jobsRes;
    notifyListeners();
    return jobsRes;
  }

  void sendApplication() {
    _api.sendMail(_user, _accessToken);
  }
}

class Api {
  Future<List<IndeedJob>> fetchAllJobs() async {
    final response = await http.get(Uri.parse('http://localhost:5000/jobsRaw'));
    if (response.statusCode == 201) {
      var parsedList =
          List<Map<String, dynamic>>.from(json.decode(response.body)['jobs']);
      var newList = parsedList.map((job) => IndeedJob.fromJson(job)).toList();
      return newList;
    } else {
      throw Exception('Failed to load Jobs');
    }
  }

  Future<List<String>> getSimilarKeywords(String keyword) async {
    final url = 'http://localhost:5000/recommendationsKeys' + "/$keyword";
    final response = await http.get(Uri.parse(url));
    var parsedList = List<String>.from(json.decode(response.body)['keywords']);
    return parsedList;
  }

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

  void postLocalJob(LocalPosting post) async {
    var uri = Uri.parse(putJobApi);
    final response = await http.put(uri, body: post.toJson());
    if (response.statusCode == 201) {
      print('Created successfuly');
      print(response.body);
    } else {
      print('Something bad happended');
    }
  }

  Future<List<LocalPosting>> getLocalPosts() async {
    var url = Uri.parse('http://localhost:5000/localPost');
    final response = await http.get(url);
    var parseList = List<Map<String, dynamic>>.from(json.decode(response.body));
    var newList = parseList.map((e) => LocalPosting.fromJson(e)).toList();
    return newList;
  }

  void sendMail(User user, String accessToken) async {
    final smtpServer = gmailSaslXoauth2(user.email, accessToken);
    final message = Message()
      ..from = Address(user.email, 'Your name')
      ..recipients.add('destination@example.com')
      ..ccRecipients.addAll(['destCc1@example.com', 'destCc2@example.com'])
      ..bccRecipients.add(Address('bccAddress@example.com'))
      ..subject = 'Test Dart Mailer library :: 😀 :: ${DateTime.now()}'
      ..text = 'This is the plain text.\nThis is line 2 of the text part.'
      ..html = "<h1>Test</h1>\n<p>Hey Here's some HTML content</p>";
    try {
      final sendReport = await send(message, smtpServer);
      print('Message sent: ${sendReport.toString()}');
    } on MailerException catch (e) {
      print('Message not sent');
      for (var p in e.problems) {
        print('Problem: ${p.code}: ${p.msg}');
      }
    }
  }
}
