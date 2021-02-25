//import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_app_sqflite/Database.dart';
import 'package:flutter_app_sqflite/EmpModel.dart';
import 'package:sqflite/sqflite.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key }) : super(key: key);

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _deptController = TextEditingController();
  final TextEditingController _salaryController = TextEditingController();

  Future<List<Employee>> emp;
  int empIdForUpdate;
  bool isUpdate = false;
  UserDatabase userDatabase;

  @override
  void initState() {
    super.initState();
    userDatabase = UserDatabase();
    empList();
  }

  empList() {
    setState(() {
      emp = userDatabase.getEmp();
    });
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Center(child: Text("SQFLITE")),
      ),
      body: Center(
        child: Form(
          key: _formKey,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Padding(
                padding: EdgeInsets.all(10.0),
                child: TextFormField(
                  textAlign: TextAlign.center,
                  controller: _nameController,
                  decoration: InputDecoration(
                      labelText: "Name",
                      hintText: "Enter your Name",
                      border: OutlineInputBorder(
                          borderRadius:
                          BorderRadius.all(Radius.circular(30.0)))),
                  validator: (value) {
                    if (value.isEmpty) {
                      return 'Please enter some text';
                    }
                    return null;
                  },
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(10.0),
                child: TextFormField(
                  textAlign: TextAlign.center,
                  controller: _deptController,
                  decoration: InputDecoration(
                      labelText: "Department",
                      hintText: "Enter Department",
                      border: OutlineInputBorder(
                          borderRadius:
                          BorderRadius.all(Radius.circular(30.0)))),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(10.0),
                child: TextFormField(
                  textAlign: TextAlign.center,
                  controller: _salaryController,
                  keyboardType: TextInputType.number,
                  decoration: InputDecoration(
                      labelText: "Salary",
                      hintText: "Enter salary",
                      border: OutlineInputBorder(
                          borderRadius:
                          BorderRadius.all(Radius.circular(30.0)))),
                ),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  RaisedButton(
                    color: Colors.lightBlueAccent,
                    child: Text(
                      (isUpdate ? 'UPDATE' : 'ADD'),
                      style: TextStyle(color: Colors.white),
                    ),
                    onPressed: () {
                      if (isUpdate) {
                        if (_formKey.currentState.validate()) {
                          _formKey.currentState.save();
                          userDatabase
                              .updateEmp(Employee(department: _deptController.text,name: _nameController.text,salary: int.parse(_salaryController.text)),empIdForUpdate)
                              .then((data) {
                            setState(() {
                              empIdForUpdate = null;
                              _nameController.text = '';
                              _deptController.text = '';
                              _salaryController.text = '';
                              isUpdate = false;
                            });
                          });
                        }
                      } else {
                        if (_formKey.currentState.validate()) {
                          _formKey.currentState.save();
                          userDatabase.insertEmp(Employee(department: _deptController.text,name: _nameController.text,salary: int.parse(_salaryController.text)));
                        }
                      }
                      _nameController.text = '';
                      _deptController.text = '';
                      _salaryController.text = '';
                      empList();
                    },
                  ),
                  isUpdate ? Padding(
                    padding: const EdgeInsets.only(left: 8.0),
                    child: RaisedButton(
                      color: Colors.lightBlueAccent,
                      child: Text(
                        ('Cancel'),
                        style: TextStyle(color: Colors.white),
                      ),
                      onPressed: () {
                        empIdForUpdate = null;
                        isUpdate = false;
                        _nameController.text = '';
                        _deptController.text = '';
                        _salaryController.text = '';
                        setState(() {

                        });
                      },
                    ),
                  ) : SizedBox()
                ],
              ),
              const Divider(
                height: 5.0,
              ),
              Expanded(
                child: FutureBuilder(
                  future: emp,
                  builder: (context, snapshot) {
                    if (snapshot.hasData) {
                      return generateList(snapshot.data);
                    }
                    if (snapshot.data == null || snapshot.data.length == 0) {
                      return Text('No Data Found');
                    }
                    return CircularProgressIndicator();
                  },
                ),
              ),
            ],
          ),
        ),
      ),);
  }

  SingleChildScrollView generateList(List<Employee> emp) {

    return SingleChildScrollView(
      //scrollDirection: Axis.vertical,
      scrollDirection: Axis.horizontal,
      child: SizedBox(
        width: MediaQuery.of(context).size.width,
        child: DataTable(
          columns: [
            DataColumn(
              label: Text('NAME'),
            ),
            // DataColumn(
            //   label: Text('Dept'),
            // ),
            // DataColumn(
            //   label: Text('Salary'),
            // ),
            DataColumn(
              label: Text('DELETE'),
            )
          ],
          rows: emp
              .map(
                (emp) => DataRow(
              cells: [
                DataCell(
                  Text(emp.name),
                  onTap: () {
                    setState(() {
                      isUpdate = true;
                      empIdForUpdate = emp.id;
                    });
                    _nameController.text = emp.name;
                    _deptController.text = emp.department;
                    _salaryController.text = emp.salary.toString();
                  },
                ),
                // DataCell(
                //   Text(emp.department),
                //   onTap: () {
                //     setState(() {
                //       isUpdate = true;
                //       empIdForUpdate = emp.id;
                //     });
                //     _nameController.text = emp.name;
                //     _deptController.text = emp.department;
                //     _salaryController.text = emp.salary.toString();
                //   },
                // ),
                // DataCell(
                //   Text(emp.salary.toString()),
                //   onTap: () {
                //     setState(() {
                //       isUpdate = true;
                //       empIdForUpdate = emp.id;
                //     });
                //     _nameController.text = emp.name;
                //     _deptController.text = emp.department;
                //     _salaryController.text = emp.salary.toString();
                //   },
                // ),
                DataCell(
                  IconButton(
                    icon: Icon(Icons.delete),
                    onPressed: () {
                      userDatabase.deleteEmp(emp.id);
                      empList();
                    },
                  ),
                )
              ],
            ),
          ).toList(),
        ),
      ),
    );
  }
}
