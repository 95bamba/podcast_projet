import 'dart:io';
import 'package:equatable/equatable.dart';

abstract class PodcastEvent extends Equatable {
  const PodcastEvent();

  @override
  List<Object?> get props => [];
}

class PodcastLoadAllRequested extends PodcastEvent {}

class PodcastLoadByCategoryRequested extends PodcastEvent {
  final String categoryUuid;

  const PodcastLoadByCategoryRequested(this.categoryUuid);

  @override
  List<Object?> get props => [categoryUuid];
}

class PodcastCreateRequested extends PodcastEvent {
  final String libelle;
  final String description;
  final String categoryUuid;
  final File? image;

  const PodcastCreateRequested({
    required this.libelle,
    required this.description,
    required this.categoryUuid,
    this.image,
  });

  @override
  List<Object?> get props => [libelle, description, categoryUuid, image];
}

class PodcastUpdateRequested extends PodcastEvent {
  final String uuid;
  final String libelle;
  final String description;
  final String categoryUuid;
  final File? image;

  const PodcastUpdateRequested({
    required this.uuid,
    required this.libelle,
    required this.description,
    required this.categoryUuid,
    this.image,
  });

  @override
  List<Object?> get props => [uuid, libelle, description, categoryUuid, image];
}

class PodcastDeleteRequested extends PodcastEvent {
  final String uuid;

  const PodcastDeleteRequested(this.uuid);

  @override
  List<Object?> get props => [uuid];
}
