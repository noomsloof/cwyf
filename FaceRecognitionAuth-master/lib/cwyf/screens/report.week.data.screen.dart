import 'package:date_format/date_format.dart';
import 'package:face_net_authentication/cwyf/models/check-name.model.dart';
import 'package:face_net_authentication/cwyf/models/student.model.dart';
import 'package:face_net_authentication/cwyf/services/check-name.service.dart';
import 'package:face_net_authentication/cwyf/services/student.service.dart';
import 'package:flutter/material.dart';

class ReportWeekDataScreen extends StatefulWidget {
  static const routeName = '/report-week-data';

  var name, code, idstudent;
  ReportWeekDataScreen({Key? key, this.idstudent, this.name, this.code})
      : super(key: key);

  @override
  _ReportWeekDataScreenState createState() => _ReportWeekDataScreenState();
}

class _ReportWeekDataScreenState extends State<ReportWeekDataScreen> {
  StudentModel _student = StudentModel();
  StudentService studentservice = StudentService();
  CheckNameService checknameservice = CheckNameService();

  bool _isLoad = true;

  late List<CheckNameModel> checklist;

  Future checkAllArea() async {
    checklist = await CheckNameService().findAll("${widget.idstudent}");
  }

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoad == true) {
      StudentService()
          .findOne('${widget.idstudent}')
          .then((value) => setState(() {
                _student = value;
              }));

      checkAllArea();
      Future.delayed(const Duration(milliseconds: 500), () {
        _isLoad = false;
      });
    }
    return Scaffold(
      body: _isLoad == true
          ? const Center(child: CircularProgressIndicator())
          : Container(
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    SizedBox(
                      height: 10,
                    ),
                    Row(
                      children: [
                        IconButton(
                            onPressed: () {
                              Navigator.pop(context);
                            },
                            icon: Icon(Icons.arrow_back_ios_new)),
                      ],
                    ),

                    Card(
                      elevation: 5,
                      margin: EdgeInsets.only(
                        left: 40,
                        right: 40,
                        bottom: 20,
                      ),
                      child: Padding(
                          padding: EdgeInsets.all(15.0),
                          child: Column(
                            children: [
                              Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Text('${_student.code}'),
                                  SizedBox(width: 20),
                                  Text('${_student.name}'),
                                  SizedBox(width: 20),
                                ],
                              ),
                              SizedBox(
                                height: 10,
                              ),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Text('มาทั้งหมด : ${_come()} วัน',
                                      style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          color: Colors.green)),
                                  SizedBox(width: 20),
                                  Text('ขาดทั้งหมด : ${_notcome()} วัน',
                                      style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          color: Colors.red)),
                                  SizedBox(width: 20),
                                ],
                              ),
                            ],
                          )),
                    ),

                    DataTable(
                        columns: const <DataColumn>[
                          DataColumn(
                            label: Text(
                              'วันที่',
                              style: TextStyle(
                                fontStyle: FontStyle.italic,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                          DataColumn(
                            label: Text(
                              'สถานะ',
                              style: TextStyle(
                                fontStyle: FontStyle.italic,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ],
                        rows: checklist
                            .map<DataRow>((element) => rowData(element))
                            .toList()),

                    // rows: checklist
                    //     .map<DataRow>((element) => DataRow(cells: [
                    //           DataCell(Text('${element.date}')),
                    //           DataCell(Text('${element.status}')),
                    //         ]))
                    //     .toList()),

                    // Container(
                    //   width: MediaQuery.of(context).size.width,
                    //   height: MediaQuery.of(context).size.height - 260,
                    //   child: buildFutureBuilder(context),
                    // ),
                  ],
                ),
              ),
            ),
    );
  }

  String _come() {
    return checklist.length.toString();
  }

  String _notcome() {
    int come = checklist.length;
    int all = 85;
    int result = all-come;
    return result.toString();
  }

  DataRow rowData(var element) {
    var date =
        formatDate(DateTime.parse(element.date), [dd, ' - ', MM, ' - ', yyyy]);
    if (element.status == 1) {
      return DataRow(cells: [
        DataCell(Text('${date}')),
        DataCell(Row(
          children: [
            Icon(Icons.check, color: Colors.green),
            Text(
              'มา',
              style: TextStyle(fontWeight: FontWeight.bold),
            )
          ],
        )),
      ]);
    } else {
      return DataRow(cells: [
        DataCell(Text('${date}')),
        DataCell(Row(
          children: [
            Icon(
              Icons.close,
              color: Colors.red,
            ),
            Text(
              'ไม่มา',
              style: TextStyle(fontWeight: FontWeight.bold),
            )
          ],
        )),
      ]);
    }
  }

  // Widget buildFutureBuilder(BuildContext context) {
  //   return FutureBuilder(
  //     future: CheckNameService().findAll("${widget.idstudent}"),
  //     builder: (context, AsyncSnapshot snapshot) {
  //       if (snapshot.hasData) {
  //         return this.buildGridViewItems(snapshot.data);
  //       } else {
  //         return Container(
  //             height: MediaQuery.of(context).size.height,
  //             child: Center(child: CircularProgressIndicator()));
  //       }
  //     },
  //   );
  // }

  // Widget buildGridViewItems(List<CheckNameModel> model) {
  //   if (model.length > 0) {
  //     return ListView.builder(
  //       controller: _scrollController,
  //       primary: false,
  //       itemCount: model.length,
  //       itemBuilder: (context, int index) => listDataItems(
  //         model[index].idcheckname,
  //         model[index].date,
  //         model[index].status,
  //       ),
  //     );
  //   } else {
  //     return Center(
  //         child: Text(
  //       "ไม่พบข้อมูล",
  //       style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
  //     ));
  //   }
  // }

  // Widget listDataItems(String? idcheckname, String? date, int? status) {
  //   return Card(
  //     elevation: 5,
  //     margin: EdgeInsets.all(10),
  //     child: ListTile(
  //       onTap: () {},
  //       title: Text('${date} ${idcheckname}'),
  //       subtitle: Text('${status}'),
  //     ),
  //   );
  // }

}
