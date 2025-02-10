import 'package:flutter/material.dart';
import 'package:rrr/constants/rrr_colors.dart';

class RrrBottom extends StatelessWidget {
  const RrrBottom({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      height: 15,
      decoration: BoxDecoration(
        color: RrrColors.rrr_home_icon,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(30),
          topRight: Radius.circular(30),
        ),
      ),
    );
  }
}
