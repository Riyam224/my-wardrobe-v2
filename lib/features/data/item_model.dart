class ItemModel {
  final int? id;
  final String name;
  final String color;
  final String type;
  final String imagePath;
  final bool isPicked;

  ItemModel({
    this.id,
    required this.name,
    required this.color,
    required this.type,
    required this.imagePath,
    required this.isPicked,
  });

  Map<String, dynamic> toMap() => {
    'id': id,
    'name': name,
    'color': color,
    'type': type,
    'imagePath': imagePath,
    'isPicked': isPicked ? 1 : 0,
  };

  factory ItemModel.fromMap(Map<String, dynamic> map) => ItemModel(
    id: map['id'],
    name: map['name'],
    color: map['color'],
    type: map['type'],
    imagePath: map['imagePath'],
    isPicked: map['isPicked'] == 1,
  );
}
