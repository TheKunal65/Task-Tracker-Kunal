class Task {
  final int id; // Use int for ID as it's INTEGER in the database
  final String name;
  final String description;
  final String dueDate;
  final bool status;
  final String category;

  Task({
    required this.id,
    required this.name,
    required this.description,
    required this.dueDate,
    required this.status,
    required this.category,
  });

  // Convert a Task into a Map.
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'description': description,
      'dueDate': dueDate,
      'status': status ? 1 : 0, // Convert boolean to integer
      'category': category,
    };
  }

  // Extract a Task object from a Map.
  factory Task.fromMap(Map<String, dynamic> map) {
    return Task(
      id: map['id'],
      name: map['name'],
      description: map['description'],
      dueDate: map['dueDate'],
      status: map['status'] == 1, // Convert integer to boolean
      category: map['category'],
    );
  }

  // Copy with updated fields.
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
