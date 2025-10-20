import 'package:equatable/equatable.dart';

class Episode extends Equatable {
  final String uuid;
  final String title;
  final String description;
  final String podcastUuid;
  final String? audioPath;
  final String? duration;
  final DateTime? createdAt;
  final DateTime? updatedAt;

  const Episode({
    required this.uuid,
    required this.title,
    required this.description,
    required this.podcastUuid,
    this.audioPath,
    this.duration,
    this.createdAt,
    this.updatedAt,
  });

  factory Episode.fromJson(Map<String, dynamic> json) {
    // Extraire le podcast_uuid depuis l'objet podcast ou directement
    String extractPodcastUuid() {
      if (json['podcast'] != null && json['podcast'] is Map) {
        return json['podcast']['uuid'] ?? '';
      }
      return json['podcast_uuid'] ?? json['podcastUuid'] ?? '';
    }

    return Episode(
      uuid: json['uuid'] ?? '',
      title: json['title'] ?? json['libelle'] ?? '',
      description: json['description'] ?? '',
      podcastUuid: extractPodcastUuid(),
      // Gérer différents noms de champs pour l'audio: audioPath, audioFileUuid, audio_file_uuid
      audioPath: json['audioPath'] ?? json['audioFileUuid'] ?? json['audio_file_uuid'],
      duration: json['duration']?.toString(),
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
      'title': title,
      'description': description,
      'podcast_uuid': podcastUuid,
      'audioPath': audioPath,
      'duration': duration,
      'createdAt': createdAt?.toIso8601String(),
      'updatedAt': updatedAt?.toIso8601String(),
    };
  }

  @override
  List<Object?> get props => [uuid, title, description, podcastUuid, audioPath, duration, createdAt, updatedAt];
}
