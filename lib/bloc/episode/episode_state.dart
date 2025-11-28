import 'package:equatable/equatable.dart';
import 'package:podcast/models/episode.dart';

abstract class EpisodeState extends Equatable {
  const EpisodeState();

  @override
  List<Object?> get props => [];
}

class EpisodeInitial extends EpisodeState {}

class EpisodeLoading extends EpisodeState {}

class EpisodeLoaded extends EpisodeState {
  final List<Episode> episodes;

  const EpisodeLoaded(this.episodes);

  @override
  List<Object?> get props => [episodes];
}

class EpisodeSingleLoaded extends EpisodeState {
  final Episode episode;

  const EpisodeSingleLoaded(this.episode);

  @override
  List<Object?> get props => [episode];
}

class EpisodeError extends EpisodeState {
  final String message;

  const EpisodeError(this.message);

  @override
  List<Object?> get props => [message];
}
