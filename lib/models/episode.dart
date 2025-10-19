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
    return Episode(
      uuid: json['uuid'] ?? '',
      title: json['title'] ?? '',
      description: json['description'] ?? '',
      podcastUuid: json['podcast_uuid'] ?? json['podcastUuid'] ?? '',
      audioPath: json['audioPath'],
      duration: json['duration'],
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
