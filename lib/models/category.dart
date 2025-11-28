import 'package:equatable/equatable.dart';

class Category extends Equatable {
  final String uuid;
  final String libelle;
  final String description;
  final String? imagePath;
  final DateTime? createdAt;
  final DateTime? updatedAt;

  const Category({
    required this.uuid,
    required this.libelle,
    required this.description,
    this.imagePath,
    this.createdAt,
    this.updatedAt,
  });

  factory Category.fromJson(Map<String, dynamic> json) {
    return Category(
      uuid: json['uuid'] ?? '',
      libelle: json['libelle'] ?? '',
      description: json['description'] ?? '',
      imagePath: json['imagePath'],
      createdAt: json['createdAt'] != null
          ? DateTime.parse(json['createdAt'])
          : null,
      updatedAt: json['updatedAt'] != null
          ? DateTime.parse(json['updatedAt'])
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'uuid': uuid,
      'libelle': libelle,
      'description': description,
      'imagePath': imagePath,
      'createdAt': createdAt?.toIso8601String(),
      'updatedAt': updatedAt?.toIso8601String(),
    };
  }

  @override
  List<Object?> get props => [uuid, libelle, description, imagePath, createdAt, updatedAt];
}
