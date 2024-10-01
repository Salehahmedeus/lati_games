import 'package:flutter/material.dart';
import 'package:gameslati/models/detailed_game_model.dart';

class MinimumSystemRequirmentsCard extends StatelessWidget {
  const MinimumSystemRequirmentsCard(
      {super.key, required this.minimumSystemRequirmentsModel});

  final MinimumSystemRequirements minimumSystemRequirmentsModel;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          "minimum System Requirments",
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 24),
        ),
        const SizedBox(
          height: 16,
        ),
        Text(
          "OS:${minimumSystemRequirmentsModel.os}",
          style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 14),
        ),
        Text(
          "MEMORY:${minimumSystemRequirmentsModel.memory}",
          style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 14),
        ),
        Text(
          "PROCESSOR:${minimumSystemRequirmentsModel.processor}",
          style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 14),
        ),
        Text(
          "GRAPHICS:${minimumSystemRequirmentsModel.graphics}",
          style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 14),
        ),
        Text(
          "STORGE:${minimumSystemRequirmentsModel.storage}",
          style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 14),
        ),
      ],
    );
  }
}
