import 'package:flutter/material.dart';
import 'package:rrr/home/widgets/home_body.dart';
import 'package:rrr/widgets/rrr_bottom.dart';

import '../widgets/rrr_app_bar.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      appBar: RrrAppBar(titre: "Royauté vs Réligion: Révolution",),
      body: HomeBody(),
      bottomSheet: RrrBottom(),
    );
  }
}
