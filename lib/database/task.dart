class Task {
  int id;
  String name;
  String description;
  String dueDate;
  bool status;
  String category;

  Task({
    required this.id,
    required this.name,
    required this.description,
    required this.dueDate,
    required this.status,
    required this.category,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'description': description,
      'dueDate': dueDate,
      'status': status ? 1 : 0,
      'category': category,
    };
  }

  factory Task.fromMap(Map<String, dynamic> map) {
    return Task(
      id: map['id'],
      name: map['name'],
      description: map['description'],
      dueDate: map['dueDate'],
      status: map['status'] == 1,
      category: map['category'],
    );
  }

  Task copyWith({
    int? id,
    String? name,
    String? description,
    String? dueDate,
    bool? status,
    String? category,
  }) {
    return Task(
      id: id ?? this.id,
      name: name ?? this.name,
      description: description ?? this.description,
      dueDate: dueDate ?? this.dueDate,
      status: status ?? this.status,
      category: category ?? this.category,
    );
  }
}
