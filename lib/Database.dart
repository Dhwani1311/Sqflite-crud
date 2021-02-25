
import 'package:flutter_app_sqflite/EmpModel.dart';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';

class UserDatabase {

  static Database _db;
  Future<Database> get database async {
    if (_db != null) return _db;
    _db = await createDatabase();
    return _db;
  }

  createDatabase() async {
    String databasesPath = await getDatabasesPath();
    String dbPath = join(databasesPath, 'Employee.db');

    var database = await openDatabase(
        dbPath, version: 1, onCreate: createTable);
    return database;
  }

  void createTable(Database database, int version) async {
    await database.execute('''CREATE TABLE emp (id INTEGER PRIMARY KEY AUTOINCREMENT, name TEXT, department TEXT, salary INTEGER)''');
  }

  Future<int> insertEmp(Employee emp) async {
    var dbEmp = await database;
    // var resultOne = await dbEmp.insert('emp', {'name':  emp.name,'department':  emp.department,'salary':  emp.salary});
    // return resultOne;
    var result = await dbEmp.rawInsert(
        'INSERT INTO emp(name, department, salary) VALUES ("${emp.name}", "${emp.department}", "${emp.salary}")');
    return result;
  }

   Future<List<Employee>> getEmp() async {
     var dbEmp = await database;
     List<Map> maps = await dbEmp.query('emp');
     List<Employee> emp = [];
     if (maps.length > 0) {
       for (int i = 0; i < maps.length; i++) {
         emp.add(Employee.fromMap(maps[i]));
       }
     }
     return emp;
   }

   Future<int> updateEmp(Employee emp,int id) async {
     var dbEmp = await database;
     var result = await dbEmp.rawUpdate( 'UPDATE emp SET name = ?, department = ? , salary = ?  WHERE id = ? ',[emp.name,emp.department,emp.salary,id]);
     //print(result);
     return result;

  }
  //
  // Future<Employee> getSpecifyRecord(String value) async{
  //   var dbEmp = await database;
  //   var list = await dbEmp.rawQuery('SELECT * FROM emp WHERE name IN (?)', [value]);
  //   return Employee.fromMap(list[0]);
  // }

  Future<int> deleteEmp(int id) async {
    var dbEmp = await database;
    var result = await dbEmp.rawDelete('DELETE FROM emp WHERE id = $id');
    return result;
    
  }

   Future close() async {
     var result = await database;
     result.close();
   }
}

