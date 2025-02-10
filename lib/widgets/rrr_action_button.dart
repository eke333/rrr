import 'package:flutter/material.dart';
import 'package:rrr/constants/rrr_colors.dart';

class RrrActionButton extends StatelessWidget {
  final String buttonTitle;
  final VoidCallback onPressed;
  const RrrActionButton(
      {super.key, required this.buttonTitle, required this.onPressed});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      height: 56,
      child: ElevatedButton(
        onPressed: onPressed,
        style: ElevatedButton.styleFrom(
            backgroundColor: RrrColors.rrr_home_icon,
            foregroundColor: Colors.white,
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8)
            )
        ),
        child: Text(
          buttonTitle,
          style: const TextStyle(
              fontSize: 20
          ),
        ),
      ),
    );
  }
}
