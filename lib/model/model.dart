import 'dart:convert';

class Model {
  final String name;
  final String email;
  Model({
    required this.name,
    required this.email,
  });

  Model copyWith({
    String? name,
    String? email,
  }) {
    return Model(
      name: name ?? this.name,
      email: email ?? this.email,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'email': email,
    };
  }

  factory Model.fromMap(Map<String, dynamic> map) {
    return Model(
      name: map['name'],
      email: map['email'],
    );
  }

  String toJson() => json.encode(toMap());

  factory Model.fromJson(String source) => Model.fromMap(json.decode(source));

  @override
  String toString() => 'Model(name: $name, email: $email)';

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is Model && other.name == name && other.email == email;
  }

  @override
  int get hashCode => name.hashCode ^ email.hashCode;
}
