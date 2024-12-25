import 'package:face_net_authentication/cwyf/models/student.model.dart';
import 'package:face_net_authentication/cwyf/services/student.service.dart';
import 'package:face_net_authentication/cwyf/widgets/toast.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:form_field_validator/form_field_validator.dart';

class AddStudentScreen extends StatefulWidget {
  static const routeName = '/add-student';

  const AddStudentScreen({Key? key}) : super(key: key);

  @override
  _AddStudentScreenState createState() => _AddStudentScreenState();
}

class _AddStudentScreenState extends State<AddStudentScreen> {
  final _formKey = GlobalKey<FormState>();

  final TextEditingController _codeController = TextEditingController();
  final TextEditingController _nameController = TextEditingController();

  final StudentModel _student = StudentModel();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('เพิ่มนักเรียน/นักศึกษา',
            style: TextStyle(color: Colors.white)),
        backgroundColor: Colors.red[500],
      ),
      body: Container(
          padding: EdgeInsets.all(50),
          child: SingleChildScrollView(
            child: _buildFormAdd(),
          )),
    );
  }

  Widget _buildFormAdd() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Form(
            key: _formKey,
            child: Column(
              children: [
                SizedBox(
                  height: 30,
                ),
                _codeInput(),
                SizedBox(
                  height: 30,
                ),
                _nameInput(),
                SizedBox(
                  height: 50,
                ),
                _addButton(),
              ],
            )),
      ],
    );
  }

  Widget _codeInput() {
    return Column(
      children: [
        Text('รหัสนักศึกษา'),
        TextFormField(
          controller: _codeController,
          validator: MultiValidator([
            RequiredValidator(errorText: "กรุณาป้อนรหัสนักศึกษา"),
            MinLengthValidator(10,
                errorText: "รหัสนักศึกษาต้องมีความยาว มากกว่า 10 หลัก"),
            MaxLengthValidator(11,
                errorText: "รหัสนักศึกษาต้องมีความยาว น้อยกว่า 11 หลัก"),
          ]),
          onSaved: (value) => _student.code = value,
          keyboardType: TextInputType.number,
        ),
      ],
    );
  }

  Widget _nameInput() {
    return Column(
      children: [
        Text('ชื่อ-นามสกุล'),
        TextFormField(
          controller: _nameController,
          validator: RequiredValidator(errorText: "กรุณาป้อนชื่อ-นามสกุล"),
          onSaved: (value) => _student.name = value,
        ),
      ],
    );
  }

  Widget _addButton() {
    return Column(
      children: [
        SizedBox(
          width: double.infinity,
          child: ElevatedButton(
            onPressed: () => onAdd(),
            child: Text('บันทึก'),
          ),
        ),
      ],
    );
  }

  void onAdd() {
    FToast fToast;
    fToast = FToast();
    fToast.init(context);

    _formKey.currentState!.save();
    if (_formKey.currentState!.validate()) {
      StudentService().addStudent(_student).then((res) {
        print(res.statusCode);
        if (res.statusCode == 201) {
          // Navigator.of(context).pushReplacementNamed(MenubarScreen.routeName);
          ToastClass().ShowToast('เพิ่มนักเรียนสำเร็จ');
        } else {
          ToastClass().ShowToast('รหัสนักศึกษาซ้ำ');
        }
      }).catchError((error) {
        print(error);
        ToastClass().ShowToast('เพิ่มนักเรียนไม่สำเร็จ');
      });
    }
  }
}
