import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:hit_400_app/core/models/models.dart';
import 'package:hit_400_app/core/services/notifiers.dart';
import 'package:hit_400_app/utils/coreutils.dart';

import 'job_detail.dart';

class Search extends SearchDelegate {
  @override
  List<Widget> buildActions(BuildContext context) {
    return <Widget>[
      IconButton(
        icon: Icon(Icons.close),
        onPressed: () {
          query = "";
        },
      )
    ];
  }

  @override
  Widget buildLeading(BuildContext context) {
    return IconButton(
        icon: Icon(Icons.arrow_back),
        onPressed: () {
          Navigator.pop(context);
        });
  }

  Job selectedResult;
  @override
  Widget buildResults(BuildContext context) {
    // ping the api to get a result by searching jobs based on text search
    Api api = Api();
    // List<Job> suggestedJobs=[];
    if (query.isEmpty) {
      return Center(child: Text("Nothing to show sofar"));
    } else {
      return FutureBuilder(
          future: api.fetchAllJobs(),
          builder: (context, jobsSnapShot) {
            if (jobsSnapShot.connectionState == ConnectionState.none &&
                jobsSnapShot.hasData == null) {
              return Center(child: Text("Couldnot find anything;"));
            }
            if (jobsSnapShot.connectionState == ConnectionState.waiting) {
              return Center(child: CircularProgressIndicator());
            }
            var buildJobs = jobsSnapShot.data
                .where((job) =>
                    job.Description.toLowerCase()
                        .contains(query.toLowerCase()) ||
                    job.Type.toLowerCase().contains(query.toLowerCase()))
                .toList();
            return ListView.builder(
              itemCount: buildJobs.length,
              padding: EdgeInsets.only(bottom: 5),
              itemBuilder: (context, index) {
                IndeedJob currentJob = buildJobs[index];
                // print(currentJob.Created_At.length);
                // var day=currentJob.Created_At.substring(0,3);
                // var dayOfMonth=int.parse(currentJob.Created_At.substring(8,10));
                // print(dayOfMonth);
                // var month=currentJob.Created_At.substring(4,7);
                // var year=currentJob.Created_At.substring(24);
                // var currDate=DateTime.now().day;
                // var dateTitle="Created ${currDate-dayOfMonth} days ago";
                return Slidable(
                    actions: [
                      IconSlideAction(
                        caption: 'Apply Now',
                        color: Colors.blue,
                        icon: Icons.send_rounded,
                        onTap: () {},
                      ),
                      IconSlideAction(
                        caption: 'Watch',
                        color: Colors.blue,
                        icon: Icons.watch,
                        onTap: () {},
                      ),
                    ],
                    actionPane: SlidableDrawerActionPane(),
                    actionExtentRatio: 0.25,
                    child: ListTile(
                      // tileColor: index%2==0?colors[0]:colors[1],
                      leading: CircleAvatar(
                        backgroundColor: Colors.amberAccent,
                        radius: 18,
                      ),
                      // title: Text(currentJob.Title),
                      // subtitle: Text('A creative dev using typescript/NodeJS wanted'),
                      //subtitle: _JobSubtitle(),
                      // trailing: Text(dateTitle),
                      onTap: () {
                        close(context, currentJob);
                      },
                    ));
              },
            );
          });
    }
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    // ping the api to get a result by searching jobs based on text search
    Api api = Api();
    // List<Job> suggestedJobs=[];
    if (query.isEmpty) {
      return Center(child: Text("Nothing to show sofar"));
    } else {
      return FutureBuilder(
          future: api.fetchAllJobs(),
          builder: (context, jobsSnapShot) {
            if (jobsSnapShot.connectionState == ConnectionState.none &&
                jobsSnapShot.hasData == null) {
              return Center(child: Text("Couldnot find anything;"));
            }
            if (jobsSnapShot.connectionState == ConnectionState.waiting) {
              return Center(child: CircularProgressIndicator());
            }
            var buildJobs = jobsSnapShot.data
                .where((job) =>
                    job.details.toLowerCase().contains(query.toLowerCase()) ||
                    job.summary.toLowerCase().contains(query.toLowerCase()))
                .toList();
            return ListView.builder(
              itemCount: buildJobs.length,
              padding: EdgeInsets.only(bottom: 5),
              itemBuilder: (context, index) {
                IndeedJob currentJob = buildJobs[index];
                // print(currentJob.Created_At.length);
                // var day=currentJob.Created_At.substring(0,3);
                // var dayOfMonth=int.parse(currentJob.Created_At.substring(8,10));
                // print(dayOfMonth);
                // var month=currentJob.Created_At.substring(4,7);
                // var year=currentJob.Created_At.substring(24);
                // var currDate=DateTime.now().day;
                // var dateTitle="Created ${currDate-dayOfMonth} days ago";
                return Slidable(
                    actions: [
                      IconSlideAction(
                        caption: 'Apply Now',
                        color: Colors.blue,
                        icon: Icons.send_rounded,
                        onTap: () {},
                      ),
                      IconSlideAction(
                        caption: 'Watch',
                        color: Colors.blue,
                        icon: Icons.watch,
                        onTap: () {},
                      ),
                    ],
                    actionPane: SlidableDrawerActionPane(),
                    actionExtentRatio: 0.25,
                    child: ListTile(
                      // tileColor: index%2==0?colors[0]:colors[1],
                      leading: CircleAvatar(
                        backgroundColor: Colors.amberAccent,
                        radius: 18,
                      ),
                      title: Text(currentJob.title),
                      // subtitle: Text('A creative dev using typescript/NodeJS wanted'),
                      //subtitle: _JobSubtitle(),
                      // trailing: Text(dateTitle),
                      onTap: () {
                        // showResults(context);
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => JobDetail(
                                      job: currentJob,
                                    )));
                      },
                    ));
              },
            );
          });
    }
  }
}
