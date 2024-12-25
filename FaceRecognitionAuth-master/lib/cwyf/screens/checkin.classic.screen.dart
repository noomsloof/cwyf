import 'package:flutter/material.dart';

import 'checkin.classic.checkin.screen.dart';

class CheckinClassicScreen extends StatefulWidget {
  static const routeName = '/checkin-classic';

  const CheckinClassicScreen({ Key? key }) : super(key: key);

  @override
  _CheckinClassicScreenState createState() => _CheckinClassicScreenState();
}

class _CheckinClassicScreenState extends State<CheckinClassicScreen> {

  DateTime selectedDate = DateTime.now();
  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
        context: context,
        initialDate: selectedDate,
        firstDate: DateTime(2015, 8),
        lastDate: DateTime(2101));
    if (picked != null && picked != selectedDate)
      setState(() {
        selectedDate = picked;
      });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('เช็คชื่อ', style: TextStyle(color: Colors.white)),
        backgroundColor: Colors.red[500],
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Card(
            margin: EdgeInsets.only(left: 30, right: 30),
            elevation: 5,
            child: Column(
              children: [
                Container(
                  margin: EdgeInsets.all(10),
                  alignment: Alignment.topLeft,
                  child: Text('เลือกวันที่ : '),
                  ),
                SizedBox(height: 25,),
                InkWell(
                  onTap: () => _selectDate(context),
                  child: ListTile(
                    title: Text(
                      "${selectedDate.toLocal()}".split(' ')[0],
                      textAlign: TextAlign.center,style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                    ),
                  ),
                ),
                Container(
                  alignment: Alignment.bottomRight,
                  margin: EdgeInsets.all(10),
                  child: ElevatedButton(
                    child: Icon(Icons.arrow_forward),
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => CheckinClassicCheckinScreen(
                                  dateforcheck:
                                      "${selectedDate.toLocal()}".split(' ')[0],
                                )),
                      );
                    },
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}