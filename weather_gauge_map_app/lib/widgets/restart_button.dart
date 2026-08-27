import 'package:flutter/material.dart';

/// Bouton circulaire affiché à la place de la jauge une fois le chargement
/// terminé (même encombrement que [ProgressGauge] pour une transition fluide).
class RestartButton extends StatelessWidget {
  final VoidCallback onPressed;

  const RestartButton({super.key, required this.onPressed});

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    return SizedBox(
      width: 220,
      height: 220,
      child: Material(
        color: colorScheme.primary,
        shape: const CircleBorder(),
        elevation: 3,
        child: InkWell(
          customBorder: const CircleBorder(),
          onTap: onPressed,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.refresh_rounded, size: 48, color: colorScheme.onPrimary),
              const SizedBox(height: 8),
              Text(
                'Recommencer',
                style: TextStyle(
                  color: colorScheme.onPrimary,
                  fontWeight: FontWeight.w600,
                  fontSize: 16,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
