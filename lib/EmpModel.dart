
class Employee {
  int id;
  String name;
  String department;
  int salary;

  Employee( {
    this.id,
    this.name,
    this.department,
    this.salary,
  });

  factory Employee.fromMap(Map<String,dynamic> map) => new Employee(
    id: map["id"],
    name: map["name"],
    department: map["department"],
    salary: map["salary"],
  );

  Map toMap() {
    var map = new Map();
    if (id != null) {
      map['id'] = id;
    }
    map['name'] = name;
    map['department'] = department;
    map['salary'] = salary;

    return map;
  }

}

