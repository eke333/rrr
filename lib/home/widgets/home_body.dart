import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:rrr/constants/rrr_colors.dart';
import 'package:rrr/plateau/screen_plateau.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../widgets/rrr_action_button.dart';

class HomeBody extends StatefulWidget {
  const HomeBody({super.key});

  @override
  State<HomeBody> createState() => _HomeBodyState();
}

class _HomeBodyState extends State<HomeBody> {
  final List<Map<String, String>> carouselItems = [
    {
      'image': 'assets/images/royaute.png',
      'text': 'ROYAUTE',
    },
    {
      'image': 'assets/images/vs2.jpg',
      'text': 'vs',
    },
    {
      'image': 'assets/images/religion.jpg',
      'text': 'RELIGION',
    },
    {
      'image': 'assets/images/deux_points.jpg',
      'text': ':',
    },
    {
      'image': 'assets/images/revolution.jpg',
      'text': 'REVOLUTION',
    },
  ];

  bool _isRulesVisible = false;

  // Fonction pour ouvrir l'URL
  void _launchURL() async {
    const url = 'https://www.igiari.com/RRR_regles.pdf';
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw 'Could not launch $url';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: GestureDetector(
        onTap: () {
          if (_isRulesVisible) {
            setState(() {
              _isRulesVisible = false;
            });
          }
        },
        child: Center(
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: <Widget>[
                const SizedBox(height: 50),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Image.asset(
                      "assets/logos/jeu-de-plateau.png",
                      height: 70,
                    ),
                    const SizedBox(width: 15),
                    Text(
                      "RvsR:R",
                      style: TextStyle(
                        fontSize: 45,
                        fontWeight: FontWeight.bold,
                        color: RrrColors.rrr_home_icon,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 40),
                CarouselSlider(
                  options: CarouselOptions(
                    height: 400,
                    autoPlay: true,
                    autoPlayInterval: const Duration(seconds: 3),
                    enlargeCenterPage: true,
                    viewportFraction: 0.8,
                  ),
                  items: carouselItems.map((item) {
                    return Builder(
                      builder: (BuildContext context) {
                        return Column(
                          children: [
                            Image.asset(
                              item['image']!,
                              height: 230,
                              width: 250,
                            ),
                            const SizedBox(height: 10),
                            Text(
                              item['text']!,
                              style: const TextStyle(
                                fontSize: 28,
                                fontWeight: FontWeight.bold,
                                fontFamily: 'Roboto',
                              ),
                              textAlign: TextAlign.center,
                            ),
                          ],
                        );
                      },
                    );
                  }).toList(),
                ),
                //const SizedBox(height: 10),
                RrrActionButton(
                    buttonTitle: "Jouer",
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => const ScreenPlateau()),
                      );
                    }),
                const SizedBox(height: 20),
                GestureDetector(
                  onTap: () {
                    setState(() {
                      _isRulesVisible = !_isRulesVisible;
                    });
                  },
                  child: AnimatedContainer(
                    duration: const Duration(milliseconds: 300),
                    width: double.infinity,
                    height: _isRulesVisible ? 150 : 50,
                    alignment: Alignment.center,
                    decoration: BoxDecoration(
                      color: Colors.grey[200],
                      borderRadius: BorderRadius.circular(10),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black26,
                          blurRadius: 4,
                          offset: Offset(0, 2),
                        ),
                      ],
                    ),
                    child: _isRulesVisible
                        ? Padding(
                      padding: const EdgeInsets.all(10.0),
                      child: Text.rich(
                        TextSpan(
                          text: 'La partie débute avec la tuile neutre ',
                          style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold, fontSize: 18),
                          children: <TextSpan>[
                            TextSpan(
                              text: "Citoyen",
                              style: TextStyle(color: RrrColors.rrr_home_icon, fontWeight: FontWeight.bold, fontSize: 18,),
                            ),
                            TextSpan(
                              text: "\n\nVeuillez cliquer sur le lien ci dessous pour découvrir toutes les règles du règle.\n",
                              style: TextStyle(fontWeight: FontWeight.normal, fontSize: 16),
                            ),
                            TextSpan(
                              text: 'cliquez ici',
                              style: TextStyle(color: RrrColors.rrr_home_icon, decoration: TextDecoration.underline, fontWeight: FontWeight.bold), // Style du lien
                              recognizer: TapGestureRecognizer()..onTap = _launchURL, // Action lors du tap
                            ),
                          ],
                        ),
                        textAlign: TextAlign.center,
                      ),
                    )
                        : const Text(
                      "Voir les règles du jeu",
                      style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
