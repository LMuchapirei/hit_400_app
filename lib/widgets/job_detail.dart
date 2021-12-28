import 'package:flutter/material.dart';
import 'package:hit_400_app/core/services/job_service.dart';
import 'package:hit_400_app/screens/PostJobPage.dart';
import 'package:hit_400_app/utils/coreutils.dart';
import 'package:hit_400_app/widgets/webviewContainer.dart';
import 'package:provider/provider.dart';

class JobDetail extends StatefulWidget {
  final IndeedJob job;
  JobDetail({@required this.job});
  @override
  _JobDetailState createState() => _JobDetailState();
}

class _JobDetailState extends State<JobDetail> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Column(
      children: [
        Flexible(
          flex: 9,
          child: CustomScrollView(
            slivers: [
              SliverAppBar(
                leading: IconButton(
                  icon: Icon(Icons.arrow_back_ios),
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                ),
                backgroundColor: Colors.cyan,
                title: Text('Job Details'),
              ),
              SliverToBoxAdapter(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      widget.job.company,
                      style: TextStyle(
                        fontSize: 20,
                      ),
                    ),
                    Text(
                      widget.job.title,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                        fontSize: 18,
                      ),
                    ),
                    // Text(
                    //   widget.job.Type,
                    //   style: TextStyle(fontSize: 16),
                    // ),
                    Text(widget.job.url),
                    // Text(widget.job.location),
                    // //Text(widget.job.HowToApply),
                    Text(widget.job.details)
                    //     .replaceAll("<p>", "")
                    //     .replaceAll("</p>", "")
                    //     .replaceAll("<ul>", "")
                    //     .replaceAll("</ul>", "")
                    //     .replaceAll("<li>", "")
                    //     .replaceAll("</li>", "")
                    //     .replaceAll("<strong>", "")
                    //     .replaceAll("</strong>", ""))
                  ],
                ),
              )
            ],
          ),
        ),
        Flexible(
            flex: 1,
            child: Container(
                height: double.infinity,
                decoration: BoxDecoration(
                  color: Colors.grey.shade50,
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    TextButton(
                        onPressed: () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) =>
                                      WebViewContainer(widget.job.url)));
                        },
                        child: Text('Apply')),
                    // TextButton(onPressed: () {}, child: Text('Watch'))
                  ],
                )))
      ],
    ));
  }
}

class LocalPostJobDetails extends StatefulWidget {
  const LocalPostJobDetails({Key key, @required this.job}) : super(key: key);
  final LocalPosting job;

  @override
  _LocalPostJobDetailsState createState() => _LocalPostJobDetailsState();
}

class _LocalPostJobDetailsState extends State<LocalPostJobDetails> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Column(
      children: [
        Flexible(
          flex: 9,
          child: CustomScrollView(
            slivers: [
              SliverAppBar(
                leading: IconButton(
                  icon: Icon(Icons.arrow_back_ios),
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                ),
                backgroundColor: Colors.cyan,
                title: Text('Job Details'),
              ),
              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text('Job Title'),
                          Text(
                            widget.job.jobTitle.substring(0, 30),
                            overflow: TextOverflow.clip,
                            style: TextStyle(
                              fontSize: 16,
                            ),
                          ),
                        ],
                      ),
                      // Text(
                      //   widget.job.Type,
                      //   style: TextStyle(fontSize: 16),
                      // ),
                      Row(
                        children: [
                          Text('Company Name', style: TextStyle(fontSize: 14)),
                          SizedBox(
                            width: 20,
                          ),
                          Text(widget.job.companyName,
                              style: TextStyle(fontSize: 18),
                              overflow: TextOverflow.ellipsis),
                        ],
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      // Text(widget.job.location),
                      // //Text(widget.job.HowToApply),
                      Text(
                        'Description',
                        style: TextStyle(fontSize: 18),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Text(
                          widget.job.jobDescription,
                        ),
                      )
                      //     .replaceAll("<p>", "")
                      //     .replaceAll("</p>", "")
                      //     .replaceAll("<ul>", "")
                      //     .replaceAll("</ul>", "")
                      //     .replaceAll("<li>", "")
                      //     .replaceAll("</li>", "")
                      //     .replaceAll("<strong>", "")
                      //     .replaceAll("</strong>", ""))
                    ],
                  ),
                ),
              )
            ],
          ),
        ),
        Flexible(
            flex: 1,
            child: Container(
                height: double.infinity,
                decoration: BoxDecoration(
                  color: Colors.grey.shade50,
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    TextButton(
                        onPressed: () {
                          // context.read<JobService>().sendApplication();
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => WebViewContainer(
                                      widget.job.jobCompanyUrl)));
                        },
                        child: Text('Apply')),
                    // TextButton(onPressed: () {}, child: Text('Watch'))
                  ],
                )))
      ],
    ));
  }
}
