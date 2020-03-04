class Mifa {
  final String id;
  final String name;

  Mifa({
    this.name,
    this.id = '',
  });

  factory Mifa.fromMap(Map<String, dynamic> data, String mifaId) {
    if (data == null) {
      return null;
    }

    final String name = data['name'];

    return Mifa(
      name: name,
      id: mifaId,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'id': id,
    };
  }
}
