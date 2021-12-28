import 'dart:convert';
import 'package:file_picker/file_picker.dart';
import 'package:hit_400_app/screens/PostJobPage.dart';
import 'package:hit_400_app/widgets/job_detail.dart';
import 'package:provider/provider.dart';
import 'package:flutter/material.dart';
import 'package:hit_400_app/core/services/notifiers.dart';
import 'package:hit_400_app/widgets/search.dart';
import 'package:settings_ui/settings_ui.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../utils/constants.dart' show resumeApi;
import "../utils/coreutils.dart" show IndeedJob;
import 'package:firebase_core/firebase_core.dart';

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, @required this.title}) : super(key: key);
  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  final Future<FirebaseApp> _initialization = Firebase.initializeApp();
  SharedPreferences prefs;
  @override
  void initState() {
    super.initState();
  }

  // ignore: missing_return
  String timeOfDayWord() {
    var list = ["Morning", "Afternoon", "Evening", "Night"];
    var hourOfDay = DateTime.now().hour;
    if (hourOfDay > 5 && hourOfDay < 12) {
      return list[0];
    } else if (hourOfDay > 12 && hourOfDay < 17) {
      return list[1];
    } else if (hourOfDay > 17 && hourOfDay < 21) {
      return list[2];
    } else if (hourOfDay > 21) {
      return list[3];
    }
    return list[1];
  }

  @override
  Widget build(BuildContext context) {
    //parts of the recommendation logic
    SharedPreferences.getInstance().then((prefs) {
      var skillsExtracted = prefs.getString('SkillsExtracted');
      Api api = Api();
      // print('The skills extracted $skillsExtracted');
      // var jsonSkills =
      //     List<String>.from(json.decode(skillsExtracted)['Extracted_Skills']);
      // // print(jsonSkills);

      var jobs = context.read<JobService>().jobs;
      api.getSimilarKeywords('python').then((value) {
        value.forEach((keyword) {
          //for each key word get jobs that link to it
          // print(keyword);
        });
      });
    });
    var localJobs = context.read<JobService>().localRecoPostings;
    var str = context.read<JobService>().user.displayName;
    print(str);
    localJobs.forEach((element) {
      print('This is a localPostng $element');
    });
    return Container(
        width: 400,
        height: 1200,
        child: Scaffold(
          floatingActionButton: FloatingActionButton(
              backgroundColor: Colors.cyan,
              onPressed: () {
                context.read<JobService>().refreshJobs();
              },
              child: Icon(
                Icons.refresh,
              )),
          drawer: Drawer(
            child: SingleChildScrollView(
              scrollDirection: Axis.vertical,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  UserAccountsDrawerHeader(
                      currentAccountPicture: CircleAvatar(
                        child: FlutterLogo(
                          size: 60,
                        ),
                      ),
                      accountName: Text('Linval M'),
                      accountEmail: Text('linvle2@gmail.com')),
                  ListTile(
                    leading: Icon(Icons.home),
                    onTap: () {
                      _initialization.then((value) => print(value.name));
                    },
                    title: Text(
                      'Home',
                      style:
                          TextStyle(fontSize: 14, fontWeight: FontWeight.w700),
                    ),
                  ),
                  ListTile(
                    leading: Icon(Icons.upload),
                    onTap: () {
                      print('Pressed upload');
                      Navigator.of(context).pushNamed('/postJob');
                    },
                    title: Text(
                      'Post Job',
                      style:
                          TextStyle(fontSize: 14, fontWeight: FontWeight.w700),
                    ),
                  ),
                  ListTile(
                    leading: Icon(Icons.replay_outlined),
                    onTap: () {
                      context.read<JobService>().populateJob();
                    },
                    title: Text(
                      'Populate Jobs Via Scrapper',
                      style:
                          TextStyle(fontSize: 14, fontWeight: FontWeight.w700),
                    ),
                  ),
                  ListTile(
                    leading: Icon(Icons.storage),
                    onTap: () async {
                      FilePickerResult result =
                          await FilePicker.platform.pickFiles();
                      print(result.files[0].path);
                      if (result != null) {
                        // File file = File(result.files.single.path);
                        var temp = "";
                        var userID =
                            context.read<JobService>().user.displayName;
                        if (userID == null) {
                          temp = "Annonymous user";
                        }
                        context.read<JobService>().sendResume(
                            result.files.single.path,
                            resumeApi,
                            temp.isEmpty ? userID : temp);
                      } else {
                        //show unexpected error try again
                      }
                    },
                    title: Text(
                      'Upload Resume',
                      style:
                          TextStyle(fontSize: 14, fontWeight: FontWeight.w700),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(left: 18.0, top: 12),
                    child: Text('Application Preferences'),
                  ),
                  ListTile(
                    leading: Icon(Icons.info),
                    onTap: () async {
                      try {
                        var res =
                            await context.read<JobService>().fetchLocalJobs();
                        print(res);
                      } catch (exp) {
                        print(exp);
                      }
                    },
                    title: Text(
                      'Test Load jobs',
                      style:
                          TextStyle(fontSize: 14, fontWeight: FontWeight.w700),
                    ),
                  ),
                  ListTile(
                      title: Container(
                    height: 300,
                    child: FutureBuilder<SharedPreferences>(
                        future: SharedPreferences.getInstance(),
                        builder: (context, snapshot) => SettingsList(
                              sections: List<String>.from(json.decode(snapshot
                                          .data
                                          .getString('SkillsExtracted'))[
                                      'Extracted_Skills'])
                                  .map((e) => SettingsSection(
                                          title: 'Skills Extracted',
                                          tiles: [
                                            SettingsTile.switchTile(
                                              title: '$e',
                                              leading: Icon(Icons.code),
                                              switchValue: true,
                                              onToggle: (bool value) {},
                                            )
                                          ]))
                                  .toList(),
                            )),
                  ))
                ],
              ),
            ),
          ),
          body: DefaultTabController(
            length: 3,
            child: NestedScrollView(
              headerSliverBuilder: (context, innBoxIsScrolled) {
                return <Widget>[
                  SliverAppBar(
                      backgroundColor: Colors.transparent,
                      actions: [
                        IconButton(
                          onPressed: () {
                            var res = showSearch(
                                context: context, delegate: Search());
                            print(res);
                          },
                          icon: Icon(Icons.search),
                        )
                      ],
                      pinned: true,
                      floating: false,
                      expandedHeight: 250,
                      automaticallyImplyLeading: true,
                      flexibleSpace: FlexibleSpaceBar(
                        background: Flex(
                          direction: Axis.vertical,
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            Expanded(
                                child: Stack(
                              children: [
                                // background container
                                _BackLay(),
                                //Greeting container
                                _BackLayB(
                                  brandName:
                                      "Good ${timeOfDayWord()} We wanna get you hired",
                                )
                              ],
                            )),
                            // Container(height: 30, color: Colors.white)
                          ],
                        ),
                      )),
                  SliverPersistentHeader(
                      pinned: true,
                      delegate: _SliverAppBarDelegate(
                          minHeight: 40,
                          maxHeight: 60,
                          child: Center(
                            child: TabBar(
                                labelColor: Colors.black,
                                unselectedLabelColor: Colors.grey,
                                indicatorColor: Colors.transparent,
                                // isScrollable: true,
                                tabs: [
                                  Tab(
                                    child: Align(
                                      alignment: Alignment.center,
                                      child: Container(
                                        decoration: BoxDecoration(
                                            borderRadius:
                                                BorderRadius.horizontal(
                                                    left: Radius.circular(20),
                                                    right: Radius.circular(20)),
                                            color: Colors.white,
                                            boxShadow: [
                                              BoxShadow(
                                                  color: Colors.black54,
                                                  blurRadius: 2)
                                            ]),
                                        child: Padding(
                                          padding: EdgeInsets.only(
                                              right: 16,
                                              left: 16,
                                              top: 12,
                                              bottom: 12),
                                          child: Text("All Jobs"),
                                        ),
                                      ),
                                    ),
                                  ),
                                  Tab(
                                    child: Align(
                                      alignment: Alignment.center,
                                      child: Container(
                                        decoration: BoxDecoration(
                                            borderRadius:
                                                BorderRadius.horizontal(
                                                    left: Radius.circular(20),
                                                    right: Radius.circular(20)),
                                            color: Colors.white,
                                            boxShadow: [
                                              BoxShadow(
                                                  color: Colors.black54,
                                                  blurRadius: 2)
                                            ]),
                                        child: Padding(
                                          padding: EdgeInsets.only(
                                              right: 16,
                                              left: 16,
                                              top: 12,
                                              bottom: 12),
                                          child: Text("For You"),
                                        ),
                                      ),
                                    ),
                                  ),
                                  Tab(
                                    child: Align(
                                      alignment: Alignment.center,
                                      child: Container(
                                        decoration: BoxDecoration(
                                            borderRadius:
                                                BorderRadius.horizontal(
                                                    left: Radius.circular(20),
                                                    right: Radius.circular(20)),
                                            color: Colors.white,
                                            boxShadow: [
                                              BoxShadow(
                                                  color: Colors.black54,
                                                  blurRadius: 2)
                                            ]),
                                        child: Padding(
                                          padding: EdgeInsets.only(
                                              right: 16,
                                              left: 16,
                                              top: 12,
                                              bottom: 12),
                                          child: Text("Local"),
                                        ),
                                      ),
                                    ),
                                  ),
                                  //   Tab(
                                  //     child: Align(
                                  //       alignment: Alignment.center,
                                  //       child: Container(
                                  //         decoration: BoxDecoration(
                                  //             borderRadius:
                                  //                 BorderRadius.horizontal(
                                  //                     left: Radius.circular(20),
                                  //                     right: Radius.circular(20)),
                                  //             color: Colors.white,
                                  //             boxShadow: [
                                  //               BoxShadow(
                                  //                   color: Colors.black54,
                                  //                   blurRadius: 2)
                                  //             ]),
                                  //         child: Padding(
                                  //           padding: EdgeInsets.only(
                                  //               right: 16,
                                  //               left: 16,
                                  //               top: 12,
                                  //               bottom: 12),
                                  //           child: Text("IndeedRec"),
                                  //         ),
                                  //       ),
                                  //     ),
                                  //   ),
                                ]),
                          )))
                ];
              },
              body: TabBarView(children: [
                _All(jobs: context.watch<JobService>().jobs),
                _ForYou(jobs: context.watch<JobService>().localRecoPostings),
                _LocalPosts(
                    localJobs: context.watch<JobService>().localPosting),
                // _All(
                //   jobs: context.watch<JobService>().indeedRecoPostings,
                // )
              ]),
            ),
          ),
        ));
  }
}

class _SliverAppBarDelegate extends SliverPersistentHeaderDelegate {
  final double minHeight;
  final double maxHeight;
  final Widget child;

  _SliverAppBarDelegate(
      {@required this.minHeight,
      @required this.maxHeight,
      @required this.child});

  @override
  Widget build(
      BuildContext context, double shrinkOffset, bool overlapsContent) {
    return SizedBox.expand(
      child: child,
    );
  }

  @override
  double get maxExtent => maxHeight;

  @override
  double get minExtent => minHeight;

  @override
  bool shouldRebuild(_SliverAppBarDelegate oldDelegate) {
    return maxHeight != oldDelegate.maxHeight ||
        minHeight != oldDelegate.minHeight ||
        child != oldDelegate.child;
  }
}

var colors = [Colors.white10, Colors.teal[50]];

class _All extends StatelessWidget {
  final List<IndeedJob> jobs;
  _All({@required this.jobs});
  @override
  Widget build(BuildContext context) {
    if (jobs == null) {
      return CircularProgressIndicator();
    }
    return Container(
      color: Colors.transparent,
      child: ListView.builder(
        itemCount: jobs.length,
        padding: EdgeInsets.only(bottom: 5),
        itemBuilder: (context, index) {
          return jobs.isEmpty
              ? Text("No jobs")
              : ListTile(
                  tileColor: index % 2 == 0 ? colors[0] : colors[1],
                  leading: CircleAvatar(
                    backgroundColor: Colors.amberAccent,
                    radius: 18,
                  ),
                  onTap: () {
                    Navigator.of(context).push(MaterialPageRoute(
                        builder: (context) => JobDetail(
                              job: jobs[index],
                            )));
                  },
                  title: Text(jobs[index].title),
                  // subtitle: Text('A creative dev using typescript/NodeJS wanted'),
                  //subtitle: _JobSubtitle(),
                  // trailing:Text(jobs[index].Created_At)
                  // ,
                );
        },
      ),
    );
  }
}

// ignore: unused_element
class _JobSubtitle extends StatelessWidget {
  final IndeedJob job;

  _JobSubtitle({@required this.job});
  @override
  Widget build(BuildContext context) {
    return Container(
      height: 120,
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(5.0),
            child: Row(children: [
              //	Text(job.Company==null?'Nix':job.Company),
              SizedBox(
                width: 15,
              ),
              // Text(job.Location)
            ]),
          ),
          Padding(
            padding: const EdgeInsets.all(5.0),
            child: Row(children: [
              Text("Stack"),
              SizedBox(
                width: 15,
              ),
              for (int i = 0; i <= 2; i++)
                Padding(
                  padding: const EdgeInsets.only(right: 5.0),
                  child: Chip(
                    elevation: 4,
                    backgroundColor: Colors.grey[100],
                    label: Text("Java"),
                  ),
                )
            ]),
          ),
          Padding(
            padding: const EdgeInsets.all(5.0),
            child: Row(children: [
              TextButton(
                onPressed: () {},
                child: Text("Apply"),
              ),
              TextButton(
                onPressed: () {},
                child: Text("WishList"),
              )
            ]),
          )
        ],
      ),
    );
  }
}

class _ForYou extends StatelessWidget {
  final List<LocalPosting> jobs;

  const _ForYou({Key key, @required this.jobs}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    if (jobs == null) {
      return Center(
        child: CircularProgressIndicator(),
      );
    }
    return ListView.builder(
      //ignore : undefined_getter
      itemCount: jobs.length,
      padding: EdgeInsets.only(bottom: 5),
      itemBuilder: (context, index) {
        LocalPosting currentJob = jobs[index];
        return ListTile(
          tileColor: index % 2 == 0 ? colors[0] : colors[1],
          leading: CircleAvatar(
            backgroundColor: Colors.amberAccent,
            radius: 18,
          ),
          title: Text(currentJob.jobTitle),
          // subtitle: Text('A creative dev using typescript/NodeJS wanted'),
          //subtitle: _JobSubtitle(),
          // trailing: Text(currentJob.Created_At),
        );
      },
    );
  }
}



class _LocalPosts extends StatelessWidget {
  final List<LocalPosting> localJobs;

  _LocalPosts({Key key, @required this.localJobs}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    // var currentJobs = _api.getLocalPosts();
    // return FutureBuilder(
    //     future: _api.getLocalPosts(),
    //     builder: (context, jobsSnap) {
    //       if (jobsSnap.connectionState == ConnectionState.none &&
    //           jobsSnap.hasData == null) {
    //         return Center(child: Text("Couldnot find anything;"));
    //       }
    //       if (jobsSnap.connectionState == ConnectionState.waiting) {
    //         return Center(child: CircularProgressIndicator());
    //       }
    return ListView.builder(
      itemCount: localJobs.length,
      padding: EdgeInsets.only(bottom: 5),
      itemBuilder: (context, index) {
        LocalPosting currentJob = localJobs[index];
        return ListTile(
          tileColor: index % 2 == 0 ? colors[0] : colors[1],
          leading: CircleAvatar(
            backgroundColor: Colors.amberAccent,
            radius: 18,
          ),
          title: Text(currentJob.jobTitle),
          onTap: () {
            Navigator.of(context).push(MaterialPageRoute(
                builder: (_) => LocalPostJobDetails(
                      job: currentJob,
                    )));
          },
          // subtitle: Text('A creative dev using typescript/NodeJS wanted'),
          //subtitle: _JobSubtitle(),
          // trailing: Text(currentJob.Created_At),
        );
      },
    );
    // });
  }
}

class _BackLay extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      height: 350,
      color: Color(0xFF38BEC9),
      // put some image and a marketing thing in the background
    );
  }
}

class _BackLayB extends StatelessWidget {
  final String brandName;

  const _BackLayB({Key key, @required this.brandName}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      height: 350,
      color: Color(0xFF38BEC9),
      child: Center(
        // put the brand log in
        child: Text(
          brandName,
          style: TextStyle(color: Colors.white, fontSize: 25),
        ),
      ),
    );
  }
}
