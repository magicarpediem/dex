class Monster {
  final int _id;
  int formId = -1;
  final String _name;
  final List<dynamic> _types;
  final List<dynamic> _forms;
  final int _hexColor;
  final String _description;

  Monster.fromJson(Map<String, dynamic> jsonElement)
      : _id = jsonElement['id'],
        _name = jsonElement['name'],
        _types = jsonElement['types'],
        _forms = jsonElement['forms'],
        _hexColor = int.parse("0x${jsonElement['color']}"),
        _description = jsonElement['description'];

  List<dynamic> get types => _types;

  String get name => _name;

  int get id => _id;

  String get description => _description;

  int get hexColor => _hexColor;

  List<dynamic> get forms => _forms;

  @override
  String toString() {
    return 'Monster{_id: $_id, _name: $_name, _types: $_types, _forms: $_forms, _hexColor: $_hexColor, _description: $_description}';
  }
}
