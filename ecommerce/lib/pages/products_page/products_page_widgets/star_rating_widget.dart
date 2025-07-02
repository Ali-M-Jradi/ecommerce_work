import 'package:flutter/material.dart';

class StarRatingWidget extends StatelessWidget {
  final double currentRating;
  final Function(double) onRatingChanged;

  const StarRatingWidget({
    super.key,
    required this.currentRating,
    required this.onRatingChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: List.generate(5, (index) {
        return GestureDetector(
          onTap: () {
            // Determine if user tapped left or right side of star
            // For simplicity, we'll cycle through: 0 -> 0.5 -> 1.0 -> 1.5 -> 2.0, etc.
            double newRating = index + 1.0;
            if (currentRating == newRating) {
              // If full star is already selected, set to half star
              newRating = index + 0.5;
            } else if (currentRating == index + 0.5) {
              // If half star is selected, set to 0 (deselect)
              newRating = index.toDouble();
            }
            onRatingChanged(newRating);
          },
          child: Container(
            padding: EdgeInsets.symmetric(horizontal: 2),
            child: Icon(
              _getStarIcon(currentRating, index + 1),
              size: 32,
              color: currentRating > index ? Colors.orange : Colors.grey.shade400,
            ),
          ),
        );
      }),
    );
  }

  // Helper method to determine star icon based on rating
  IconData _getStarIcon(double rating, int starPosition) {
    if (rating >= starPosition) {
      return Icons.star; // Full star
    } else if (rating >= starPosition - 0.5) {
      return Icons.star_half; // Half star
    } else {
      return Icons.star_border; // Empty star
    }
  }
}
