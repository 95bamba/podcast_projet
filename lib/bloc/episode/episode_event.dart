import 'dart:io';
import 'package:equatable/equatable.dart';

abstract class EpisodeEvent extends Equatable {
  const EpisodeEvent();

  @override
  List<Object?> get props => [];
}

class EpisodeLoadByPodcastRequested extends EpisodeEvent {
  final String podcastUuid;

  const EpisodeLoadByPodcastRequested(this.podcastUuid);

  @override
  List<Object?> get props => [podcastUuid];
}

class EpisodeLoadByIdRequested extends EpisodeEvent {
  final String episodeUuid;

  const EpisodeLoadByIdRequested(this.episodeUuid);

  @override
  List<Object?> get props => [episodeUuid];
}

class EpisodeCreateRequested extends EpisodeEvent {
  final String libelle;
  final String description;
  final String podcastUuid;
  final File audioFile;

  const EpisodeCreateRequested({
    required this.libelle,
    required this.description,
    required this.podcastUuid,
    required this.audioFile,
  });

  @override
  List<Object?> get props => [libelle, description, podcastUuid, audioFile];
}
