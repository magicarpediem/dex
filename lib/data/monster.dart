class Monster {
  final int _id;
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
}
