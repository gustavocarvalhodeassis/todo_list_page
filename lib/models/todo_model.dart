class TodoModel {
  final String description;
  final DateTime date;

  TodoModel(this.description, this.date);

  Map<String, dynamic> toJson() {
    return {
      'description': description,
      'date': date.toIso8601String(),
    };
  }

  TodoModel.fromJson(Map<String, dynamic> json)
      : description = json['description'],
        date = DateTime.parse(json['date']);
}
