import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:podcast/bloc/auth/auth_bloc.dart';
import 'package:podcast/bloc/auth/auth_state.dart';
import 'package:podcast/services/favorite_service.dart';
import 'package:podcast/services/api_service.dart';

/// A reusable favorite button widget that handles adding/removing favorites
///
/// Usage:
/// ```dart
/// FavoriteButton(
///   episodeUuid: 'episode-uuid-here',
///   size: 24,
/// )
/// ```
class FavoriteButton extends StatefulWidget {
  final String episodeUuid;
  final double size;
  final Color? activeColor;
  final Color? inactiveColor;
  final VoidCallback? onFavoriteChanged;

  const FavoriteButton({
    super.key,
    required this.episodeUuid,
    this.size = 24,
    this.activeColor,
    this.inactiveColor,
    this.onFavoriteChanged,
  });

  @override
  State<FavoriteButton> createState() => _FavoriteButtonState();
}

class _FavoriteButtonState extends State<FavoriteButton> {
  late FavoriteService _favoriteService;
  bool _isFavorited = false;
  bool _isLoading = true;
  bool _isProcessing = false;
  String? _favoriteUuid;
  String? _userLogin;

  @override
  void initState() {
    super.initState();
    _favoriteService = FavoriteService(ApiService());
    _initializeFavorite();
  }

  Future<void> _initializeFavorite() async {
    // Get user from AuthBloc
    final authState = context.read<AuthBloc>().state;
    if (authState is AuthAuthenticated && authState.user != null) {
      _userLogin = authState.user!.login;
      await _checkIfFavorited();
    } else {
      setState(() {
        _isLoading = false;
      });
    }
  }

  Future<void> _checkIfFavorited() async {
    if (_userLogin == null) return;

    setState(() {
      _isLoading = true;
    });

    try {
      final isFavorited = await _favoriteService.isFavorited(
        userLogin: _userLogin!,
        episodeUuid: widget.episodeUuid,
      );

      if (isFavorited) {
        final favoriteUuid = await _favoriteService.getFavoriteUuid(
          userLogin: _userLogin!,
          episodeUuid: widget.episodeUuid,
        );
        setState(() {
          _isFavorited = true;
          _favoriteUuid = favoriteUuid;
          _isLoading = false;
        });
      } else {
        setState(() {
          _isFavorited = false;
          _favoriteUuid = null;
          _isLoading = false;
        });
      }
    } catch (e) {
      setState(() {
        _isLoading = false;
      });
    }
  }

  Future<void> _toggleFavorite() async {
    if (_userLogin == null || _isProcessing) return;

    setState(() {
      _isProcessing = true;
    });

    try {
      if (_isFavorited && _favoriteUuid != null) {
        // Remove from favorites
        final result = await _favoriteService.deleteFavorite(_favoriteUuid!);

        if (result['success'] == true) {
          setState(() {
            _isFavorited = false;
            _favoriteUuid = null;
            _isProcessing = false;
          });

          if (mounted) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text('Retiré des favoris'),
                backgroundColor: Colors.grey[700],
                duration: Duration(seconds: 1),
              ),
            );
          }

          widget.onFavoriteChanged?.call();
        } else {
          setState(() {
            _isProcessing = false;
          });

          if (mounted) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(result['message'] ?? 'Erreur'),
                backgroundColor: Colors.red,
              ),
            );
          }
        }
      } else {
        // Add to favorites
        final result = await _favoriteService.createFavorite(
          userLogin: _userLogin!,
          episodeUuid: widget.episodeUuid,
        );

        if (result['success'] == true) {
          final favorite = result['favorite'];
          setState(() {
            _isFavorited = true;
            _favoriteUuid = favorite?.uuid;
            _isProcessing = false;
          });

          if (mounted) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text('Ajouté aux favoris'),
                backgroundColor: Colors.green,
                duration: Duration(seconds: 1),
              ),
            );
          }

          widget.onFavoriteChanged?.call();
        } else {
          setState(() {
            _isProcessing = false;
          });

          if (mounted) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(result['message'] ?? 'Erreur'),
                backgroundColor: Colors.red,
              ),
            );
          }
        }
      }
    } catch (e) {
      setState(() {
        _isProcessing = false;
      });

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Erreur: ${e.toString()}'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return SizedBox(
        width: widget.size,
        height: widget.size,
        child: CircularProgressIndicator(
          strokeWidth: 2,
          valueColor: AlwaysStoppedAnimation<Color>(
            widget.inactiveColor ?? Colors.grey,
          ),
        ),
      );
    }

    return GestureDetector(
      onTap: _isProcessing ? null : _toggleFavorite,
      child: AnimatedContainer(
        duration: Duration(milliseconds: 200),
        width: widget.size,
        height: widget.size,
        child: _isProcessing
            ? SizedBox(
                width: widget.size * 0.7,
                height: widget.size * 0.7,
                child: CircularProgressIndicator(
                  strokeWidth: 2,
                  valueColor: AlwaysStoppedAnimation<Color>(
                    widget.activeColor ?? Colors.red,
                  ),
                ),
              )
            : Icon(
                _isFavorited ? Icons.favorite : Icons.favorite_border,
                color: _isFavorited
                    ? (widget.activeColor ?? Colors.red)
                    : (widget.inactiveColor ?? Colors.grey),
                size: widget.size,
              ),
      ),
    );
  }
}
