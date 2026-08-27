import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_gauges/gauges.dart';

/// Jauge circulaire animée représentant la progression du chargement
/// (0.0 à 1.0). Le remplissage s'anime automatiquement à chaque changement
/// de valeur grâce à `RangePointer(animationDuration: ...)`.
class ProgressGauge extends StatelessWidget {
  final double progress;

  const ProgressGauge({super.key, required this.progress});

  @override
  Widget build(BuildContext context) {
    final percent = (progress * 100).clamp(0, 100);
    final color = Theme.of(context).colorScheme.primary;

    return SizedBox(
      width: 220,
      height: 220,
      child: SfRadialGauge(
        axes: [
          RadialAxis(
            minimum: 0,
            maximum: 100,
            startAngle: 270,
            endAngle: 270,
            showLabels: false,
            showTicks: false,
            axisLineStyle: AxisLineStyle(
              thickness: 0.14,
              thicknessUnit: GaugeSizeUnit.factor,
              color: color.withOpacity(0.12),
            ),
            pointers: [
              RangePointer(
                value: percent.toDouble(),
                width: 0.14,
                sizeUnit: GaugeSizeUnit.factor,
                color: color,
                cornerStyle: CornerStyle.bothCurve,
                enableAnimation: true,
                animationDuration: 600,
                animationType: AnimationType.easeOutBack,
              ),
            ],
            annotations: [
              GaugeAnnotation(
                positionFactor: 0,
                widget: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      '${percent.toInt()}%',
                      style: const TextStyle(fontSize: 34, fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      'chargé',
                      style: TextStyle(fontSize: 13, color: Colors.grey.shade500),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
