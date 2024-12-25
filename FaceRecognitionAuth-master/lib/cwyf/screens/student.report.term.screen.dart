
import 'package:face_net_authentication/cwyf/models/check-name.model.dart';
import 'package:face_net_authentication/cwyf/services/check-name.service.dart';
import 'package:flutter/material.dart';
import 'package:scroll_app_bar/scroll_app_bar.dart';

class StudentReportTermScreen extends StatefulWidget {
  static const routeName = '/student-report-term';
  var idstudent, code, name;
  StudentReportTermScreen({ Key? key, this.idstudent, this.code, this.name }) : super(key: key);

  @override
  _StudentReportTermScreenState createState() => _StudentReportTermScreenState();
}

class _StudentReportTermScreenState extends State<StudentReportTermScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(appBar: ScrollAppBar(
        controller: ScrollController(), // Note the controller here
        title: Text(
          "ตรวจสอบผลการเช็คชื่อ",
          style: TextStyle(color: Colors.white),
        ),
        backgroundColor: Colors.red[500],
      ),
      body:Column(
        children: [
          SizedBox(height: 20,),
          Card(
          elevation: 5,
          margin: EdgeInsets.all(10),
          child: Padding(
            padding: EdgeInsets.all(10),
            child: DataTable(
              columnSpacing: 30,
              columns: const <DataColumn>[
                DataColumn(
                  label: Text(
                    'รหัส',
                    style: TextStyle(
                      fontStyle: FontStyle.italic,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                DataColumn(
                  label: Text(
                    'ชื่อ',
                    style: TextStyle(
                      fontStyle: FontStyle.italic,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                DataColumn(
                  label: Text(
                    '%',
                    style: TextStyle(
                      fontStyle: FontStyle.italic,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                DataColumn(
                  label: Text(
                    'ผลสรุป',
                    style: TextStyle(
                      fontStyle: FontStyle.italic,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
              rows: <DataRow>[
                DataRow(
                  cells: <DataCell>[
                    DataCell(Text('${widget.code}')),
                    DataCell(Text('${widget.name}')),
                    DataCell(_persent('${widget.idstudent}')),
                    DataCell(_statusResult('${widget.idstudent}')),
                  ],
                ),
              ],
            ),
          ),
    ),
        ],
      ));
  }

  Widget _persent(String idstudent) {
    return buildCheckData(context, idstudent);
  }

  Widget buildCheckData(BuildContext context, String idstudent) {
    return FutureBuilder(
      future: CheckNameService().findAll(idstudent),
      builder: (context, AsyncSnapshot snapshot) {
        if (snapshot.hasData) {
          return this.buildCheckItems(snapshot.data);
        } else {
          return Container(
              height: MediaQuery.of(context).size.height,
              child: Center(child: CircularProgressIndicator()));
        }
      },
    );
  }

  Widget buildCheckItems(List<CheckNameModel> model) {
    if (model.length > 0) {
      int come = model.length;
      int all = 85;
      int result = ((100 * come) ~/ all);
      if(result >= 80){
        return Text(result.toString(), style: TextStyle(fontWeight: FontWeight.bold, color: Colors.green));
      }else{
        return Text(result.toString(), style: TextStyle(fontWeight: FontWeight.bold, color: Colors.red));
      }
      
    } else {
      return Text("0", style: TextStyle(fontWeight: FontWeight.bold, color: Colors.red));
    }
  }

  Widget _statusResult(String idstudent){
    return buildStatuskData(context, idstudent);
  }

    Widget buildStatuskData(BuildContext context, String idstudent) {
    return FutureBuilder(
      future: CheckNameService().findAll(idstudent),
      builder: (context, AsyncSnapshot snapshot) {
        if (snapshot.hasData) {
          return this.buildStatusItems(snapshot.data);
        } else {
          return Container(
              height: MediaQuery.of(context).size.height,
              child: Center(child: CircularProgressIndicator()));
        }
      },
    );
  }

  Widget buildStatusItems(List<CheckNameModel> model) {
    if (model.length > 0) {
      int come = model.length;
      int all = 85;
      int result = ((100 * come) ~/ all);
      if(result >= 80){
        return Text("ผ่าน", style: TextStyle(fontWeight: FontWeight.bold, color: Colors.green));
      }else{
        return Text("ไม่ผ่าน", style: TextStyle(fontWeight: FontWeight.bold, color: Colors.red));
      }
    } else {
      return Text("ไม่ผ่าน", style: TextStyle(fontWeight: FontWeight.bold, color: Colors.red));
    }
  }
}