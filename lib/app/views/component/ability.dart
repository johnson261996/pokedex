import 'package:flutter/material.dart';

class AbilityWidget extends StatelessWidget {

  final Map ability;

  const AbilityWidget({super.key, required this.ability});

  @override
  Widget build(BuildContext context) {

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),

      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [

          /// TYPE + NAME
          Container(
            padding: const EdgeInsets.symmetric(
                horizontal: 6, vertical: 2),
          
            decoration: BoxDecoration(
              color: Colors.orange.shade200,
              borderRadius: BorderRadius.circular(6),
            ),
          
            child: Text(
              ability["type"] ?? "",
              style: const TextStyle(
                fontSize: 11,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          
          const SizedBox(height: 6),
          
          Text(
            ability["name"] ?? "",
            style: const TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 16,
            ),
          ),

          /// EFFECT
          if (ability["effect"] != null)
            Padding(
              padding: const EdgeInsets.only(top: 4),
              child: Text(
                ability["effect"],
                style: const TextStyle(
                  fontSize: 13,
                  color: Colors.black87,
                ),
              ),
            ),
        ],
      ),
    );
  }
}