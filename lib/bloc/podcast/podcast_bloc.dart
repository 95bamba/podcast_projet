import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:podcast/bloc/podcast/podcast_event.dart';
import 'package:podcast/bloc/podcast/podcast_state.dart';
import 'package:podcast/repositories/podcast_repository.dart';

class PodcastBloc extends Bloc<PodcastEvent, PodcastState> {
  final PodcastRepository _podcastRepository;

  PodcastBloc(this._podcastRepository) : super(PodcastInitial()) {
    on<PodcastLoadAllRequested>(_onPodcastLoadAllRequested);
    on<PodcastLoadByCategoryRequested>(_onPodcastLoadByCategoryRequested);
    on<PodcastCreateRequested>(_onPodcastCreateRequested);
    on<PodcastUpdateRequested>(_onPodcastUpdateRequested);
    on<PodcastDeleteRequested>(_onPodcastDeleteRequested);
  }

  Future<void> _onPodcastLoadAllRequested(
    PodcastLoadAllRequested event,
    Emitter<PodcastState> emit,
  ) async {
    emit(PodcastLoading());
    try {
      final podcasts = await _podcastRepository.getAllPodcasts();
      emit(PodcastLoaded(podcasts));
    } catch (e) {
      emit(PodcastError(e.toString()));
    }
  }

  Future<void> _onPodcastLoadByCategoryRequested(
    PodcastLoadByCategoryRequested event,
    Emitter<PodcastState> emit,
  ) async {
    emit(PodcastLoading());
    try {
      final podcasts = await _podcastRepository.getPodcastsByCategory(event.categoryUuid);
      emit(PodcastLoaded(podcasts));
    } catch (e) {
      emit(PodcastError(e.toString()));
    }
  }

  Future<void> _onPodcastCreateRequested(
    PodcastCreateRequested event,
    Emitter<PodcastState> emit,
  ) async {
    emit(PodcastLoading());
    try {
      await _podcastRepository.createPodcast(
        libelle: event.libelle,
        description: event.description,
        categoryUuid: event.categoryUuid,
        image: event.image,
      );
      emit(const PodcastOperationSuccess('Podcast created successfully'));
      // Reload podcasts
      add(PodcastLoadAllRequested());
    } catch (e) {
      emit(PodcastError(e.toString()));
    }
  }

  Future<void> _onPodcastUpdateRequested(
    PodcastUpdateRequested event,
    Emitter<PodcastState> emit,
  ) async {
    emit(PodcastLoading());
    try {
      await _podcastRepository.updatePodcast(
        uuid: event.uuid,
        libelle: event.libelle,
        description: event.description,
        categoryUuid: event.categoryUuid,
        image: event.image,
      );
      emit(const PodcastOperationSuccess('Podcast updated successfully'));
      // Reload podcasts
      add(PodcastLoadAllRequested());
    } catch (e) {
      emit(PodcastError(e.toString()));
    }
  }

  Future<void> _onPodcastDeleteRequested(
    PodcastDeleteRequested event,
    Emitter<PodcastState> emit,
  ) async {
    emit(PodcastLoading());
    try {
      await _podcastRepository.deletePodcast(event.uuid);
      emit(const PodcastOperationSuccess('Podcast deleted successfully'));
      // Reload podcasts
      add(PodcastLoadAllRequested());
    } catch (e) {
      emit(PodcastError(e.toString()));
    }
  }
}
