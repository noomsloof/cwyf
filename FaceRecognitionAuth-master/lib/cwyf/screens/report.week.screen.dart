import 'package:face_net_authentication/cwyf/models/student.model.dart';
import 'package:face_net_authentication/cwyf/screens/report.week.data.screen.dart';
import 'package:face_net_authentication/cwyf/services/student.service.dart';
import 'package:flutter/material.dart';

class ReportWeekScreen extends StatefulWidget {
  static const routeName = '/report-week';

  const ReportWeekScreen({Key? key}) : super(key: key);

  @override
  _ReportWeekScreenState createState() => _ReportWeekScreenState();
}

class _ReportWeekScreenState extends State<ReportWeekScreen> {
  StudentModel _student = StudentModel();
  final ScrollController _scrollController = ScrollController();


  @override
  void initState() {
    super.initState();
    StudentService().findAll().then((value) => {});
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Column(
        children: [
          SizedBox(height: 25),
          Text(
            'สรุปผลรายสัปดาห์',
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          ),
          SizedBox(height: 25),
          Column(
            children: [
              Container(
                width: MediaQuery.of(context).size.width,
                height: MediaQuery.of(context).size.height - 260,
                child: buildFutureBuilder(context),
              ),
            ],
          ),
        ],
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
      child: ListTile(
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => ReportWeekDataScreen(
                      idstudent: idstudent,
                      name: name,
                      code: code,
                    )),
          );
        },
        title: Text('${name}'),
        subtitle: Text('${code}'),
      ),
    );
  }
}
