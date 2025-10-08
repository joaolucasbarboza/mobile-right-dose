import 'package:intl/intl.dart';

class Medicine {
  int id;
  String name;
  String description;
  DateTime createdAt;
  DateTime? updatedAt;

  Medicine({
    required this.id,
    required this.name,
    required this.description,
    required this.createdAt,
    this.updatedAt,
  });

  static final _dateFormat = DateFormat('dd-MM-yyyy HH:mm:ss');

  factory Medicine.fromMap(Map<String, dynamic> map) {
    return Medicine(
      id: map['id'],
      name: map['name'],
      description: map['description'],
      createdAt: _dateFormat.parse(map['createdAt']),
      updatedAt: _dateFormat.parse(map['updatedAt']) 
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'medicine_id': id,
      'name': name,
      'description': description,
    };
  }
}
