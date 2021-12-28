// import 'dart:convert';

// import 'package:http/http.dart' as http;
// // import 'package:flutter/material.dart';

// void main(List<String> args) async{
//   var url =
//       Uri.http("localhost:8081", '/allJobDesc', {'q': '{http}','description':"python","pages":"2"},);

//   // Await the http get response, then decode the json-formatted response.
//   var response = await http.get(url);
//   print(response);
//   if (response.statusCode == 200) {
//     // print(response.body);
//   }
//   var parsedList=json.decode(response.body);
//   List<Job> jobList=List<Job>.from(parsedList.map((i)=>Job.fromJson(i)));
//   print(jobList[0].Company);
//   print(jobList.length);
//   jobList.forEach((j){
//       print(j.ID);
//       print(j.Type);
//       print(j.Company);
//       print(j.Url);
//       print(j.Location);
//       print(j.Title);
//       print("\n");

//   });
// }

// class Job{

// // ignore: non_constant_identifier_names
// final String ID;
// // ignore: non_constant_identifier_names
// final String Type;
// // ignore: non_constant_identifier_names
// final String Url;
// // ignore: non_constant_identifier_names
// final String Created_At;
// // ignore: non_constant_identifier_names
// final String Company;
// // ignore: non_constant_identifier_names
// final String CompanyUrl;
// // ignore: non_constant_identifier_names
// final String Location;
// // ignore: non_constant_identifier_names
// final String Title;
// // ignore: non_constant_identifier_names
// final String Description;
// // ignore: non_constant_identifier_names
// final String HowToApply;
// // ignore: non_constant_identifier_names
// final String CompanyLog;

// // ignore: non_constant_identifier_names
// const Job({this.Description, this.HowToApply, this.CompanyLog, this.ID,this.Type,this.Url,this.Created_At,this.Company,this.CompanyUrl,this.Location,this.Title});

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
