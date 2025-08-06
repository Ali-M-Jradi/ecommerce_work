class Parameter {
  String key;
  String value;
  String description;

  Parameter({required this.key, required this.value, this.description = ''});

  factory Parameter.fromMap(Map<String, dynamic> map) => Parameter(
        key: map['key'] as String,
        value: map['value'] as String,
        description: (map.containsKey('description') && map['description'] != null) ? map['description'] as String : '',
      );

  Map<String, dynamic> toMap() => {
        'key': key,
        'value': value,
        'description': description,
      };

  Parameter copyWith({String? key, String? value, String? description}) {
    return Parameter(
      key: key ?? this.key,
      value: value ?? this.value,
      description: description ?? this.description,
    );
  }
}
