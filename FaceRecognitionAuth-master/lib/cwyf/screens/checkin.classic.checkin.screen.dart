import 'package:face_net_authentication/cwyf/models/check-name.model.dart';
import 'package:face_net_authentication/cwyf/models/student.model.dart';
import 'package:face_net_authentication/cwyf/services/check-name.service.dart';
import 'package:face_net_authentication/cwyf/services/student.service.dart';
import 'package:face_net_authentication/cwyf/widgets/toast.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

import 'menubar.screen.dart';

class CheckinClassicCheckinScreen extends StatefulWidget {
  static const routeName = '/checkin-classic-checkin';

  var dateforcheck;
  CheckinClassicCheckinScreen({Key? key, this.dateforcheck}) : super(key: key);

  @override
  _CheckinClassicCheckinScreenState createState() =>
      _CheckinClassicCheckinScreenState();
}

class _CheckinClassicCheckinScreenState
    extends State<CheckinClassicCheckinScreen> {
  final _formKey = GlobalKey<FormState>();
  final ScrollController _scrollController = ScrollController();

  // final TextEditingController _dateController = TextEditingController();
  // final TextEditingController _statusController = TextEditingController();

  final CheckNameModel _checkname = CheckNameModel();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('เช็คชื่อ', style: TextStyle(color: Colors.white)),
        backgroundColor: Colors.red[500],
      ),
      body: SingleChildScrollView(
        child: Container(
          child: Column(
            children: [
              Form(
                  key: _formKey,
                  child: Column(
                    children: [
                      _datebox(),
                      Container(
                        width: MediaQuery.of(context).size.width,
                        height: MediaQuery.of(context).size.height - 260,
                        child: buildFutureBuilder(context),
                      ),
                    ],
                  ))
            ],
          ),
        ),
      ),
    );
  }

  Widget _datebox() {
    return Card(
      elevation: 5,
      margin: EdgeInsets.all(10),
      child: ListTile(
        title: Text("วันที่ : ${widget.dateforcheck}", style: TextStyle(fontWeight: FontWeight.bold),),
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
    return Column(
      children: [
        Card(
          elevation: 5,
          margin: EdgeInsets.all(10),
          child: ListTile(
            title: Text('${name}'),
            subtitle: Text('${code}'),
            trailing: _checkButton("${idstudent}", "${name}"),
          ),
        ),
      ],
    );
  }

  Widget _checkButton(String idstudent, String name) {
    return Column(
      children: [
        SizedBox(
          child: ElevatedButton(
            onPressed: () => onAdd("${idstudent}", "${name}"),
            child: Icon(Icons.check),
          ),
        ),
      ],
    );
  }

  void onAdd(String idstudent, String name) {
    _checkname.date = widget.dateforcheck;
    _checkname.status = 1;

    FToast fToast;
    fToast = FToast();
    fToast.init(context);
    // ToastClass().ShowToast('${idstudent}');

    _formKey.currentState!.save();
    if (_formKey.currentState!.validate()) {
      CheckNameService().addCheckName(_checkname, idstudent).then((res) {
        // print(res);
        print(res.statusCode);
        if (res.statusCode == 201) {
          ToastClass().ShowToast('${name} มา');
        } else {
          ToastClass().ShowToast('บันทึกไม่สำเร็จ 1');
        }
      }).catchError((error) {
        print(error);
        ToastClass().ShowToast('บันทึกไม่สำเร็จ 2');
      });
    }
  }
}
