import 'package:face_net_authentication/cwyf/models/check-name.model.dart';
import 'package:face_net_authentication/cwyf/models/student.model.dart';
import 'package:face_net_authentication/cwyf/services/check-name.service.dart';
import 'package:face_net_authentication/cwyf/services/student.service.dart';
import 'package:flutter/material.dart';

class ReportTermScreen extends StatefulWidget {
  static const routeName = '/report-term';

  const ReportTermScreen({Key? key}) : super(key: key);

  @override
  _ReportTermScreenState createState() => _ReportTermScreenState();
}

class _ReportTermScreenState extends State<ReportTermScreen> {
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    StudentService().findAll().then((value) => {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        child: Container(
          child: SingleChildScrollView(
            child: Column(
              children: [
                SizedBox(
                  height: 20,
                ),
                Container(
                  child: Text(
                    'สรุปผลท้ายเทอม',
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                ),
                SizedBox(
                  height: 20,
                ),
                Container(
                  width: MediaQuery.of(context).size.width,
                  height: MediaQuery.of(context).size.height - 260,
                  child: buildFutureBuilder(context),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget buildFutureBuilder(BuildContext context) {
    return FutureBuilder(
      future: StudentService().findAll(),
      builder: (context, AsyncSnapshot snapshot) {
        if (snapshot.hasData) {
          return this.buildGridViewItems(snapshot.data);
        } else {
          return Container(
              height: MediaQuery.of(context).size.height,
              child: Center(child: CircularProgressIndicator()));
        }
      },
    );
  }

  Widget buildGridViewItems(List<StudentModel> model) {
    if (model.length > 0) {
      return ListView.builder(
        controller: _scrollController,
        primary: false,
        itemCount: model.length,
        itemBuilder: (context, int index) => listDataItems(
          model[index].idstudent,
          model[index].code,
          model[index].name,
        ),
      );
    } else {
      return Center(
          child: Text(
        "ไม่พบข้อมูล",
        style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
      ));
    }
  }

  Widget listDataItems(String? idstudent, String? code, String? name) {
    return Card(
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
                DataCell(Text('${code}')),
                DataCell(Text('${name}')),
                DataCell(_persent('${idstudent}')),
                DataCell(_statusResult('${idstudent}')),
              ],
            ),
          ],
        ),
      ),
    );
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
