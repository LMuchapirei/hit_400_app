import 'package:flutter/material.dart';
import 'package:hit_400_app/core/services/job_service.dart';
import 'package:provider/provider.dart';

class PostJobPage extends StatefulWidget {
  PostJobPage({key}) : super(key: key);

  @override
  _PostJobPageState createState() => _PostJobPageState();
}

class _PostJobPageState extends State<PostJobPage> {
  var _currentStep = 0;
  var _formKeys = [
    GlobalKey<FormState>(),
    GlobalKey<FormState>(),
    GlobalKey<FormState>()
  ];
  var _jobData = Map<String, String>();

  bool isEmail(String string) {
    // Null or empty string is invalid
    if (string == null || string.isEmpty) {
      return false;
    }

    const pattern = r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$';
    final regExp = RegExp(pattern);

    if (regExp.hasMatch(string)) {
      return false;
    }
    return true;
  }

  @override
  Widget build(BuildContext context) {
    List<Step> _steps = [
      Step(
        title: Text('Job Main Details'),
        content: Form(
          key: _formKeys[0],
          child: Column(
            children: [
              TextFormField(
                decoration: InputDecoration(labelText: 'Job Title'),
                // ignore: missing_return
                validator: (value) {
                  if (value.isEmpty || value.length < 3) {
                    return 'Please enter valid Job Title';
                  }
                },
                onSaved: (value) {
                  _jobData["jobTitle"] = value;
                },
              ),
              TextFormField(
                decoration: InputDecoration(labelText: 'Company Name'),
                // ignore: missing_return
                validator: (value) {
                  if (value.isEmpty || value.length < 3) {
                    return 'Please enter valid Company Name';
                  }
                },
                onSaved: (value) {
                  _jobData["companyName"] = value;
                },
              )
            ],
          ),
        ),
        isActive: true,
        state: StepState.indexed,
      ),
      Step(
          title: Text('Job Summary'),
          content: Form(
            key: _formKeys[1],
            child: Column(
              children: [
                TextFormField(
                  decoration: InputDecoration(labelText: 'Job Location'),
                  // ignore: missing_return
                  validator: (value) {
                    if (value.isEmpty || value.length < 3) {
                      return 'Please enter valid Job Location';
                    }
                  },
                  onSaved: (value) {
                    _jobData["jobLocation"] = value;
                  },
                ),
                TextFormField(
                  decoration: InputDecoration(labelText: 'Job Type'),
                  // ignore: missing_return
                  validator: (value) {
                    if (value.isEmpty || value.length < 3) {
                      return 'Please enter valid Job Type';
                    }
                  },
                  onSaved: (value) {
                    _jobData["jobType"] = value;
                  },
                ),
                TextFormField(
                  decoration: InputDecoration(labelText: 'Summary'),
                  // ignore: missing_return
                  validator: (value) {
                    if (value.isEmpty || value.length < 3) {
                      return 'Please enter Valid description';
                    }
                  },
                  onSaved: (value) {
                    _jobData["jobSummary"] = value;
                  },
                ),
                TextFormField(
                  decoration: InputDecoration(labelText: 'Salary'),
                  // ignore: missing_return
                  validator: (value) {
                    if (value.isEmpty || value.length < 3) {
                      return 'Please enter valid Salary';
                    }
                  },
                  onSaved: (value) {
                    _jobData["jobSalary"] = value;
                  },
                )
              ],
            ),
          ),
          isActive: true,
          state: StepState.indexed),
      Step(
          title: Text('Application Details'),
          content: Form(
            key: _formKeys[2],
            child: Column(
              children: [
                TextFormField(
                  decoration: InputDecoration(labelText: 'Email To'),
                  keyboardType: TextInputType.emailAddress,
                  // ignore: missing_return
                  validator: (value) {
                    if (isEmail(value)) {
                      return 'Please enter valid Email Address';
                    }
                  },
                  onSaved: (value) {
                    _jobData["jobEmail"] = value;
                  },
                ),
                TextFormField(
                  decoration: InputDecoration(labelText: 'Company Url'),
                  // ignore: missing_return
                  validator: (value) {
                    if (value.isEmpty || value.length < 3) {
                      return 'Please enter valid Company Url';
                    }
                  },
                  onSaved: (value) {
                    _jobData["jobCompanyUrl"] = value;
                  },
                ),
                TextFormField(
                  decoration:
                      InputDecoration(labelText: 'Application Description'),
                  validator: (value) {
                    if (value.isEmpty || value.length < 3) {
                      return 'Please enter valid Description';
                    }
                  },
                  onSaved: (value) {
                    _jobData["jobDescription"] = value;
                  },
                ),
              ],
            ),
          ),
          isActive: true,
          state: StepState.indexed),
      Step(
          title: Text('Upload'),
          content: _UploadJob(
            localPosting: LocalPosting.fromJson(_jobData),
          ),
          state: StepState.complete,
          isActive: true)
    ];
    return Scaffold(
        appBar: AppBar(
          title: Text('Post Job.'),
        ),
        body: Container(
          height: MediaQuery.of(context).size.height,
          width: double.infinity,
          child: Stepper(
            steps: _steps,
            currentStep: this._currentStep,
            type: StepperType.vertical,
            onStepTapped: (step) {
              setState(() {
                _currentStep = step;
              });
            },
            onStepContinue: () {
              //validate current state and move foward
              switch (_currentStep) {
                case 0:
                  if (_formKeys[0].currentState.validate()) {
                    setState(() {
                      _currentStep += 1;
                    });
                  }

                  break;
                case 1:
                  if (_formKeys[1].currentState.validate()) {
                    setState(() {
                      _currentStep += 1;
                    });
                  }

                  break;
                case 2:
                  if (_formKeys[2].currentState.validate()) {
                    setState(() {
                      _currentStep += 1;
                    });
                    _formKeys.forEach((formKey) {
                      formKey.currentState.save();
                    });
                  }
                  break;
                case 3:
                  // post job and navigate out of
                  context
                      .read<JobService>()
                      .postJob(LocalPosting.fromJson(_jobData));
                  Navigator.of(context).pop();
                  break;

                default:
                  setState(() {
                    _currentStep = 0;
                  });
                  break;
              }
            },
            onStepCancel: () {
              if (_currentStep > 0) {
                setState(() {
                  _currentStep = _currentStep - 1;
                });
              } else {
                setState(() {
                  _currentStep = 0;
                });
              }
            },
          ),
        ));
  }
}

class _UploadJob extends StatelessWidget {
  final LocalPosting localPosting;
  const _UploadJob({Key key, @required this.localPosting}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Column(
        children: [
          Row(
            children: [
              Text(
                "Compnay Name",
              ),
              Text(localPosting.companyName)
            ],
          ),
          SizedBox(height: 20),
          Row(
            children: [Text("Job Title"), Text(localPosting.jobTitle)],
          ),
          SizedBox(height: 20),
          Row(
            children: [Text("Job Location"), Text(localPosting.jobLocation)],
          ),
          SizedBox(height: 20),
          Row(
            children: [Text("Job Type"), Text(localPosting.jobType)],
          ),
          SizedBox(height: 20),
          Row(
            children: [Text("Summary"), Text(localPosting.jobSummary)],
          ),
          SizedBox(height: 20),
          Row(
            children: [Text("Expected Salary"), Text(localPosting.jobSalary)],
          ),
          SizedBox(height: 20),
          Row(
            children: [Text("Email To"), Text(localPosting.jobEmail)],
          ),
          SizedBox(height: 20),
          Row(
            children: [
              Text("Compnay Website"),
              Text(localPosting.jobCompanyUrl)
            ],
          ),
          SizedBox(height: 20),
          Row(
            children: [
              Text("Detail Job Descrption"),
              Text(localPosting.jobDescription)
            ],
          ),
        ],
      ),
    );
  }
}

class LocalPosting {
  final String jobTitle;
  final String companyName;
  final String jobLocation;
  final String jobType;
  final String jobSummary;
  final String jobSalary;
  final String jobEmail;
  final String jobCompanyUrl;
  final String jobDescription;

  LocalPosting(
      {@required this.jobTitle,
      @required this.companyName,
      @required this.jobLocation,
      @required this.jobType,
      @required this.jobSummary,
      @required this.jobSalary,
      @required this.jobEmail,
      @required this.jobCompanyUrl,
      @required this.jobDescription});

  factory LocalPosting.fromJson(Map<String, dynamic> _jobData) {
    return LocalPosting(
        jobTitle: _jobData["jobTitle"],
        companyName: _jobData["companyName"],
        jobLocation: _jobData["jobLocation"],
        jobType: _jobData["jobType"],
        jobSummary: _jobData["jobSummary"],
        jobSalary: _jobData["jobSalary"],
        jobEmail: _jobData["jobEmail"],
        jobCompanyUrl: _jobData["jobCompanyUrl"],
        jobDescription: _jobData["jobDescription"]);
  }
  Map<String, dynamic> toJson() => {
        "jobTitle": jobTitle,
        "companyName": companyName,
        "jobLocation": jobLocation,
        "jobType": jobType,
        "jobSummary": jobSummary,
        "jobSalary": jobSalary,
        "jobEmail": jobEmail,
        "jobCompanyUrl": jobCompanyUrl,
        "jobDescription": jobDescription
      };
}
