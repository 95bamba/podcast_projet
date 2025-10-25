import 'package:equatable/equatable.dart';
import 'package:podcast/models/episode.dart';

class Favorite extends Equatable {
  final String uuid;
  final String userLogin;
  final String episodeUuid;
  final Episode? episode; // Episode complet si fourni par l'API
  final DateTime? createdAt;
  final DateTime? updatedAt;

  const Favorite({
    required this.uuid,
    required this.userLogin,
    required this.episodeUuid,
    this.episode,
    this.createdAt,
    this.updatedAt,
  });

  factory Favorite.fromJson(Map<String, dynamic> json) {
    return Favorite(
      uuid: json['uuid'] ?? '',
      userLogin: json['user_login'] ?? json['userLogin'] ?? '',
      episodeUuid: json['episode_uuid'] ?? json['episodeUuid'] ?? '',
      episode: json['episode'] != null && json['episode'] is Map
          ? Episode.fromJson(json['episode'])
          : null,
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
      'user_login': userLogin,
      'episode_uuid': episodeUuid,
      if (episode != null) 'episode': episode!.toJson(),
      'createdAt': createdAt?.toIso8601String(),
      'updatedAt': updatedAt?.toIso8601String(),
    };
  }

  @override
  List<Object?> get props => [uuid, userLogin, episodeUuid, episode, createdAt, updatedAt];
}
