final String tableUser = "user";

class UserFields {
  static final List<String> values = [id, name, email, typeId];
  static final String id = "_id";
  static final String name = "name";
  static final String email = "email";
  static final String typeId = "typeId";
  static final String picture = "picture";
}

class User {
  final int? id;
  final String? name;
  final String? email;
  final String? typeId;
  final String? picture;

  const User({
    this.id,
    required this.name,
    required this.email,
    required this.typeId,
    this.picture,
  });

  Map<String, Object?> toJson() => {
        UserFields.id: id,
        UserFields.name: name,
        UserFields.email: email,
        UserFields.typeId: typeId,
        UserFields.picture: picture,
      };

  User copy({
    int? id,
    String? name,
    String? email,
    String? domain,
    String? typeId,
    String? picture,
  }) =>
      User(
        id: id ?? this.id,
        name: name ?? this.name,
        email: email ?? this.email,
        typeId: typeId ?? this.typeId,
        picture: picture ?? this.picture,
      );

  static User fromJson(Map<String, Object?> json) => User(
        id: json[UserFields.id] as int?,
        name: json[UserFields.name] as String?,
        email: json[UserFields.email] as String?,
        typeId: json[UserFields.typeId] as String?,
        picture: json[UserFields.picture] as String?,
      );
}
