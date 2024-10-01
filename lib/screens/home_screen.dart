
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:gameslati/helpers/consts.dart';
import 'package:gameslati/providers/darkmode_provider.dart';
import 'package:gameslati/providers/games_provider.dart';
import 'package:gameslati/widgets/cards/game_card.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:shimmer/shimmer.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int nowIndex = 0;
  bool isLoding = false;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<GamesProvider>(builder: (context, gamesConsumer, child) {
      return Consumer<DarkmodeProvider>(
          builder: (context, darkModeConsumer, _) {
        return Scaffold(
          appBar: AppBar(
            title: const Text("GAMER"),
            actions: [
              Row(
                children: [
                  Text(darkModeConsumer.isDark ? "white mode" : "dark mode"),
                  Switch(
                      value: darkModeConsumer.isDark,
                      onChanged: (value) {
                        setState(() {
                          Provider.of<DarkmodeProvider>(context, listen: false)
                              .switchmode();
                          value = !value;
                        });
                      })
                ],
              )
            ],
          ),
          body: Center(
              child: GridView.builder(
                  itemCount: isLoding ? 6 : gamesConsumer.games.length,
                  padding: const EdgeInsets.all(16),
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                      mainAxisSpacing: 16,
                      crossAxisSpacing: 16,
                      childAspectRatio: 0.7,
                      crossAxisCount: 2),
                  itemBuilder: (context, index) {
                    return AnimatedSwitcher(
                        duration: const Duration(milliseconds: 300),
                        child: isLoding
                            //didnt understand the ClipRRect
                            ? ClipRRect(
                                borderRadius: BorderRadius.circular(16),
                                child: Shimmer.fromColors(
                                  baseColor: Colors.black12,
                                  highlightColor: Colors.white38,
                                  child: Container(
                                    color: Colors.white,
                                    height: double.infinity,
                                    width: double.infinity,
                                  ),
                                ),
                              )
                            : GameCard(
                                gameModel: gamesConsumer.games[index],
                                onCardTap: (gameModel) {
                                  print(gamesConsumer.games[index].id);
                                },
                              ));
                  })),
          bottomNavigationBar: BottomNavigationBar(
            backgroundColor:
                darkModeConsumer.isDark ? Colors.black : Colors.white,
            selectedItemColor: darkModeConsumer.isDark
                ? const Color.fromARGB(255, 255, 133, 133)
                : redColor,
            selectedLabelStyle: GoogleFonts.roboto(fontWeight: FontWeight.bold),
            unselectedLabelStyle:
                GoogleFonts.roboto(fontWeight: FontWeight.normal, fontSize: 12),
            onTap: (currentIndex) {
              setState(() {
                nowIndex = currentIndex;
              });

              Provider.of<GamesProvider>(context, listen: false)
                  .fetchgames(currentIndex == 0
                      ? "all"
                      : currentIndex == 1
                          ? "pc"
                          : "browser");
            },
            currentIndex: nowIndex,
            items: [
              BottomNavigationBarItem(
                label: "All",
                icon: Icon(
                  FontAwesomeIcons.gamepad,
                  color: darkModeConsumer.isDark ? redColor : Colors.black,
                ),
              ),
              BottomNavigationBarItem(
                  label: "PC",
                  icon: Icon(
                    FontAwesomeIcons.computer,
                    color: darkModeConsumer.isDark ? redColor : Colors.black,
                  )),
              BottomNavigationBarItem(
                  label: "WEB",
                  icon: Icon(
                    FontAwesomeIcons.globe,
                    color: darkModeConsumer.isDark ? redColor : Colors.black,
                  )),
            ],
          ),
        );
      });
    });
  }
}
