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
