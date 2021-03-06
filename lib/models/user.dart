class User {
  final String name;
  final String mifaId;

  User({
    this.name,
    this.mifaId = '',
  });

  factory User.fromMap(Map<String, dynamic> data, String uid) {
    if (data == null) {
      return null;
    }

    final String name = data['name'];
    final String mifaId = data['mifaId'];

    return User(
      name: name,
      mifaId: mifaId,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'mifaId': mifaId,
    };
  }
}
