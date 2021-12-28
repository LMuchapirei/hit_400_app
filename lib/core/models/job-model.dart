// // import 'package:hive_flutter/hive_flutter.dart';
// import 'package:hive/hive.dart';

// @HiveType(typeId:0)
// class Job extends HiveObject{

// // ignore: non_constant_identifier_names
// @HiveField(0)
// final String ID;
// // ignore: non_constant_identifier_names
// @HiveField(1)
// final String Type;
// // ignore: non_constant_identifier_names
// @HiveField(2)
// final String Url;
// // ignore: non_constant_identifier_names
// @HiveField(3)
// final String Created_At;
// // ignore: non_constant_identifier_names
// @HiveField(4)
// final String Company;
// // ignore: non_constant_identifier_names
// @HiveField(5)
// final String CompanyUrl;
// // ignore: non_constant_identifier_names
// @HiveField(6)
// final String Location;
// // ignore: non_constant_identifier_names
// @HiveField(7)
// final String Title;
// // ignore: non_constant_identifier_names
// @HiveField(8)
// final String Description;
// // ignore: non_constant_identifier_names
// @HiveField(9)
// final String HowToApply;
// // ignore: non_constant_identifier_names
// @HiveField(10)
// final String CompanyLog;

// // ignore: non_constant_identifier_names
// Job({this.Description, this.HowToApply, this.CompanyLog, this.ID,this.Type,this.Url,this.Created_At,this.Company,this.CompanyUrl,this.Location,this.Title});

// Job.fromJson(Map<String,dynamic> json)
// :ID=json["id"],
// Type=json["type"],
// Url=json["url"],
// Created_At=json["created_at"],
// Company=json["company"],
// CompanyUrl=json["company_url"],
// Location=json["location"],
// Title=json["title"],
// Description=json["description"],
// HowToApply=json["how_to_apply"],
// CompanyLog=json["company_logo"];

// }

// // class Job{

// // // ignore: non_constant_identifier_names
// // final String ID;
// // // ignore: non_constant_identifier_names
// // final String Type;
// // // ignore: non_constant_identifier_names
// // final String Url;
// // // ignore: non_constant_identifier_names
// // final String Created_At;
// // // ignore: non_constant_identifier_names
// // final String Company;
// // // ignore: non_constant_identifier_names
// // final String CompanyUrl;
// // // ignore: non_constant_identifier_names
// // final String Location;
// // // ignore: non_constant_identifier_names
// // final String Title;
// // // ignore: non_constant_identifier_names
// // final String Description;
// // // ignore: non_constant_identifier_names
// // final String HowToApply;
// // // ignore: non_constant_identifier_names
// // final String CompanyLog;

// // // ignore: non_constant_identifier_names
// // const Job({this.Description, this.HowToApply, this.CompanyLog, this.ID,this.Type,this.Url,this.Created_At,this.Company,this.CompanyUrl,this.Location,this.Title});

// // Job.fromJson(Map<String,dynamic> json)
// // :ID=json["id"],
// // Type=json["type"],
// // Url=json["url"],
// // Created_At=json["created_at"],
// // Company=json["company"],
// // CompanyUrl=json["company_url"],
// // Location=json["location"],
// // Title=json["title"],
// // Description=json["description"],
// // HowToApply=json["how_to_apply"],
// // CompanyLog=json["company_logo"];

// // }

import 'package:flutter/material.dart';

class Job {
  final String id;
  final String title;
  final String company;
  final String salary;
  final String summary;

  const Job(
      {@required this.company,
      @required this.id,
      @required this.salary,
      @required this.summary,
      @required this.title});

  Job.fromJson(Map<String, dynamic> json)
      : id = json["id"],
        title = json["title"],
        company = json["company"],
        salary = json["salary"],
        summary = json["summar"];
}

class Skill {
  final String skillTitle;
  const Skill({@required this.skillTitle});
}
