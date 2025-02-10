import 'package:flutter/material.dart';
import 'package:rrr/plateau/widgets/plateau_body.dart';
import 'package:rrr/widgets/rrr_app_bar.dart';

import '../widgets/rrr_bottom.dart';

class ScreenPlateau extends StatefulWidget {
  const ScreenPlateau({super.key});

  @override
  State<ScreenPlateau> createState() => _ScreenPlateauState();
}

class _ScreenPlateauState extends State<ScreenPlateau> {
  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      appBar: RrrAppBar(titre: "RvsR:R"),
      body: PlateauBody(),
      bottomSheet: RrrBottom(),
    );
  }
}
