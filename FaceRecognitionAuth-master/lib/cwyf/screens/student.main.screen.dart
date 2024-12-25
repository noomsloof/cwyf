
import 'package:face_net_authentication/cwyf/models/student.model.dart';
import 'package:face_net_authentication/cwyf/screens/student.report.term.screen.dart';
import 'package:face_net_authentication/cwyf/screens/student.report.week.screen.dart';
import 'package:face_net_authentication/cwyf/services/student.service.dart';
import 'package:flutter/material.dart';
import 'package:scroll_app_bar/scroll_app_bar.dart';

class StudentMainScreen extends StatefulWidget {
  static const routeName = '/studentmain';
  var code;
  StudentMainScreen({Key? key, this.code}) : super(key: key);

  @override
  _StudentMainScreenState createState() => _StudentMainScreenState();
}

class _StudentMainScreenState extends State<StudentMainScreen> {
  // StudentModel _student = StudentModel();
  // final ScrollController _scrollController = ScrollController();

  bool _isLoad = true;

  late List<StudentModel> studentList;
  late String code, name, idstudent;


  Future studentAllArea() async {
    studentList = await StudentService().findAll();
    getAllstudent();
  }

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoad == true) {
      StudentService().findAll().then((value) => setState(() {}));
      studentAllArea();
      Future.delayed(const Duration(milliseconds: 500), () {
        if(code == null){
          _isLoad = true;
        }else{
          _isLoad = false;
        }
      });
    }
    

    return Scaffold(
      appBar: ScrollAppBar(
        controller: ScrollController(), // Note the controller here
        title: Text(
          "ตรวจสอบผลการเช็คชื่อ",
          style: TextStyle(color: Colors.white),
        ),
        backgroundColor: Colors.red[500],
      ),
      body: _isLoad == true
          ? const Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
        child: Container(
            child: Column(
          children: [
            Card(
              elevation: 5,
              margin: EdgeInsets.all(50),
              child: ListTile(
                title: Padding(
                  padding: EdgeInsets.symmetric(vertical: 20),
                  child: Column(
                    children: [
                      Text("รหัส: ${code}"),
                      SizedBox(
                        height: 10,
                      ),
                      Text("ชื่อ: ${name}"),
                    ],
                  ),
                ),
              ),
            ),
            Card(
              elevation: 5,
              margin: EdgeInsets.all(10),
              child: InkWell(
                splashColor: Colors.grey.withAlpha(30),
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => StudentReportWeekScreen(
                              idstudent: idstudent,
                            )),
                  );
                },
                child: ListTile(
                  title: Text('เช็คผลรายวัน'),
                  trailing: Icon(Icons.calendar_today),
                ),
              ),
            ),
            Card(
              elevation: 5,
              margin: EdgeInsets.all(10),
              child: InkWell(
                splashColor: Colors.grey.withAlpha(30),
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => StudentReportTermScreen(
                              idstudent: idstudent,
                              code: code,
                              name: name,
                            )),
                  );
                },
                child: ListTile(
                  title: Text('สรุปผล'),
                  trailing: Icon(Icons.pie_chart_rounded),
                ),
              ),
            ),
          ],
        )),
      ),
    );
  }

  void getAllstudent() {
    studentList
        .map((element) => {print(element.idstudent), justOneStudent(element)})
        .toList();
  }

  void justOneStudent(var data) {
    if (data.code == "${widget.code}") {
      code = data.code;
      name = data.name;
      idstudent = data.idstudent;
    }
  }
}
