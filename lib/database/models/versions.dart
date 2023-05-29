import 'dart:convert';

class Version {
  Version({
    required this.id,
    required this.version,
    required this.changes,
  });

  int id;
  int version;
  String changes;

  factory Version.fromRawJson(String str) =>
      Version.fromJson(json.decode(str));

  factory Version.fromJson(Map<String, dynamic> json) => Version(
      id: json['id'],
      version: json['version'],
      changes: json['changes']);

  Map<String, dynamic> toJson() => {
    'id': '$id',
    'version': '$version',
    'changes': changes
  };
}
