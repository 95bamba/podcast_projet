import 'package:equatable/equatable.dart';

class Podcast extends Equatable {
  final String uuid;
  final String libelle;
  final String description;
  final String categoryUuid;
  final String? imagePath;
  final String? audioFileUuid;  // UUID du fichier audio dans GED
  final DateTime? createdAt;
  final DateTime? updatedAt;

  const Podcast({
    required this.uuid,
    required this.libelle,
    required this.description,
    required this.categoryUuid,
    this.imagePath,
    this.audioFileUuid,
    this.createdAt,
    this.updatedAt,
  });

  factory Podcast.fromJson(Map<String, dynamic> json) {
    // Extraire le category_uuid depuis l'objet category ou directement
    String extractCategoryUuid() {
      if (json['category'] != null && json['category'] is Map) {
        return json['category']['uuid'] ?? '';
      }
      return json['category_uuid'] ?? json['categoryUuid'] ?? '';
    }

    return Podcast(
      uuid: json['uuid'] ?? '',
      libelle: json['libelle'] ?? '',
      description: json['description'] ?? '',
      categoryUuid: extractCategoryUuid(),
      imagePath: json['coverImgPath'] ?? json['imagePath'],
      audioFileUuid: json['audioFileUuid'] ?? json['audio_file_uuid'],
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
      'category_uuid': categoryUuid,
      'imagePath': imagePath,
      'audioFileUuid': audioFileUuid,
      'createdAt': createdAt?.toIso8601String(),
      'updatedAt': updatedAt?.toIso8601String(),
    };
  }

  @override
  List<Object?> get props => [uuid, libelle, description, categoryUuid, imagePath, audioFileUuid, createdAt, updatedAt];
}
