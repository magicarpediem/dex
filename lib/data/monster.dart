class Monster {
  final int _id;
  final Map<String, dynamic> _nameMap;
  final String _enName;
  final List<dynamic> _types;

  Monster.fromJson(Map<String, dynamic> jsonElement)
      : _id = jsonElement['id'],
        _nameMap = jsonElement['name'],
        _enName = jsonElement['name']['english'],
        _types = jsonElement['type'];

  List<dynamic> get types => _types;

  String get enName => _enName;

  Map<String, dynamic> get nameMap => _nameMap;

  int get id => _id;
}
