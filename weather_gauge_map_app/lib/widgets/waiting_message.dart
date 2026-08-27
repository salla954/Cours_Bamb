import 'package:flutter/material.dart';

/// Affiche un message qui change en boucle (ex : "Nous téléchargeons les
/// données…") avec une transition en fondu enchaîné pour un rendu soigné.
class WaitingMessage extends StatelessWidget {
  final String message;

  const WaitingMessage({super.key, required this.message});

  @override
  Widget build(BuildContext context) {
    return AnimatedSwitcher(
      duration: const Duration(milliseconds: 400),
      transitionBuilder: (child, animation) => FadeTransition(
        opacity: animation,
        child: SlideTransition(
          position: Tween<Offset>(begin: const Offset(0, 0.2), end: Offset.zero)
              .animate(animation),
          child: child,
        ),
      ),
      child: Text(
        message,
        key: ValueKey(message),
        textAlign: TextAlign.center,
        style: TextStyle(fontSize: 15, color: Theme.of(context).colorScheme.onSurfaceVariant),
      ),
    );
  }
}
