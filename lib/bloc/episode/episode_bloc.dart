import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:podcast/bloc/episode/episode_event.dart';
import 'package:podcast/bloc/episode/episode_state.dart';
import 'package:podcast/repositories/episode_repository.dart';

class EpisodeBloc extends Bloc<EpisodeEvent, EpisodeState> {
  final EpisodeRepository _episodeRepository;

  EpisodeBloc(this._episodeRepository) : super(EpisodeInitial()) {
    on<EpisodeLoadByPodcastRequested>(_onEpisodeLoadByPodcastRequested);
    on<EpisodeLoadByIdRequested>(_onEpisodeLoadByIdRequested);
  }

  Future<void> _onEpisodeLoadByPodcastRequested(
    EpisodeLoadByPodcastRequested event,
    Emitter<EpisodeState> emit,
  ) async {
    emit(EpisodeLoading());
    try {
      final episodes = await _episodeRepository.getAllEpisodesByPodcast(event.podcastUuid);
      emit(EpisodeLoaded(episodes));
    } catch (e) {
      emit(EpisodeError(e.toString()));
    }
  }

  Future<void> _onEpisodeLoadByIdRequested(
    EpisodeLoadByIdRequested event,
    Emitter<EpisodeState> emit,
  ) async {
    emit(EpisodeLoading());
    try {
      final episode = await _episodeRepository.getEpisodeById(event.episodeUuid);
      emit(EpisodeSingleLoaded(episode));
    } catch (e) {
      emit(EpisodeError(e.toString()));
    }
  }
}
