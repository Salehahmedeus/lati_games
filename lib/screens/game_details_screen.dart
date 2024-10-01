
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:fullscreen_image_viewer/fullscreen_image_viewer.dart';
import 'package:gameslati/helpers/consts.dart';
import 'package:gameslati/helpers/functions_helper.dart';
import 'package:gameslati/providers/games_provider.dart';
import 'package:gameslati/widgets/cards/game_card.dart';
import 'package:gameslati/widgets/cards/minimum_system_req.dart';
import 'package:provider/provider.dart';

class GameDetailesScreen extends StatefulWidget {
  const GameDetailesScreen({super.key, required this.gameID});
  final String gameID;

  @override
  State<GameDetailesScreen> createState() => _GameDetailesScreenState();
}

class _GameDetailesScreenState extends State<GameDetailesScreen> {
  @override
  void initState() {
    Provider.of<GamesProvider>(context, listen: false)
        .fetchGameById(widget.gameID);
    super.initState();
  }

  bool isShowMore = false;

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Consumer<GamesProvider>(builder: (context, gameCounsumer, _) {
      return Scaffold(
        appBar: AppBar(
          centerTitle: true,
          title: Text(
            gameCounsumer.detailedGameModel == null
                ? "loading...."
                : gameCounsumer.detailedGameModel!.title,
            style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
          ),
        ),
        body: Center(
          child: gameCounsumer.isLoding &&
                  gameCounsumer.detailedGameModel == null
              ? const CircularProgressIndicator()
              : SingleChildScrollView(
                  child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Stack(
                          children: [
                            ClipRRect(
                              borderRadius: BorderRadius.circular(16),
                              child: Image.network(
                                  width: size.width,
                                  gameCounsumer.detailedGameModel!.thumbnail,
                                  fit: BoxFit.cover),
                            ),
                            Positioned(
                                top: 16,
                                right: 16,
                                child: Row(
                                  children: [
                                    if (gameCounsumer
                                        .detailedGameModel!.platform
                                        .toUpperCase()
                                        .contains("Windows".toUpperCase()))
                                      const Icon(
                                        FontAwesomeIcons.computer,
                                        color: Colors.white,
                                        size: 32,
                                      ),
                                    const SizedBox(
                                      width: 16,
                                    ),
                                    if (gameCounsumer
                                        .detailedGameModel!.platform
                                        .toUpperCase()
                                        .contains("web".toUpperCase()))
                                      const Icon(
                                        FontAwesomeIcons.globe,
                                        color: Colors.white,
                                        size: 32,
                                      )
                                  ],
                                ))
                          ],
                        ),
                        const SizedBox(
                          height: 8,
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(vertical: 8),
                          child: Text(
                            gameCounsumer.detailedGameModel!.title,
                            style: const TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(vertical: 8),
                          child: Row(
                            children: [
                              ElevatedButton(
                                  onPressed: () {
                                    launchExtUrl(gameCounsumer
                                        .detailedGameModel!.gameUrl);
                                  },
                                  child: const Text(
                                    "play Now",
                                    style: TextStyle(
                                        color: Colors.black,
                                        fontSize: 18,
                                        fontWeight: FontWeight.bold),
                                  ))
                            ],
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(vertical: 8),
                          child: Text(
                            gameCounsumer.detailedGameModel!.shortDescription,
                            style: const TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.normal,
                            ),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(vertical: 8),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                gameCounsumer.detailedGameModel!.description,
                                style: const TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                ),
                                maxLines: isShowMore ? 50 : 3,
                              ),
                              GestureDetector(
                                onTap: () {
                                  setState(() {
                                    isShowMore = !isShowMore;
                                  });
                                },
                                child: Text(
                                  isShowMore ? "show less..." : "show more...",
                                  style: TextStyle(
                                    fontSize: 16,
                                    color: blueColor,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              )
                            ],
                          ),
                        ),
                        GridView.builder(
                          physics: const NeverScrollableScrollPhysics(),
                          shrinkWrap: true,
                          itemCount: gameCounsumer
                              .detailedGameModel!.screenshots.length,
                          gridDelegate:
                              const SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: 2,
                            mainAxisSpacing: 8,
                            crossAxisSpacing: 8,
                          ),
                          itemBuilder: (context, index) {
                            return ClipRRect(
                              borderRadius: BorderRadius.circular(8),
                              child: GestureDetector(
                                onTap: () {
                                  FullscreenImageViewer.open(
                                      context: context,
                                      child: Hero(
                                          tag: "hero",
                                          child: Image.network(
                                            gameCounsumer.detailedGameModel!
                                                .screenshots[index].image,
                                            loadingBuilder: (context, child,
                                                loadingProgress) {
                                              return loadingProgress == null
                                                  ? child
                                                  : const Center(
                                                      child:
                                                          CircularProgressIndicator(),
                                                    );
                                            },
                                          )));
                                },
                                child: Hero(
                                  tag: "Hero",
                                  child: Image.network(
                                      fit: BoxFit.cover,
                                      gameCounsumer.detailedGameModel!
                                          .screenshots[index].image),
                                ),
                              ),
                            );
                          },
                        ),
                        const SizedBox(
                          height: 16,
                        ),
                        if (gameCounsumer
                                .detailedGameModel!.minimumSystemRequirements !=
                            null)
                          MinimumSystemRequirmentsCard(
                              minimumSystemRequirmentsModel: gameCounsumer
                                  .detailedGameModel!
                                  .minimumSystemRequirements!),
                        const SizedBox(
                          height: 16,
                        ),
                        const Text(
                          "Similar game",
                          style: TextStyle(
                              fontWeight: FontWeight.bold, fontSize: 24),
                        ),
                        const SizedBox(
                          height: 16,
                        ),
                        SizedBox(
                            height: size.height * 0.33,
                            child: ListView.builder(
                              shrinkWrap: true,
                              physics: const AlwaysScrollableScrollPhysics(),
                              scrollDirection: Axis.horizontal,
                              itemCount: gameCounsumer.simlargames.length,
                              itemBuilder: (context, index) => SizedBox(
                                  height: 150,
                                  width: size.width * 0.5,
                                  child: Padding(
                                    padding: const EdgeInsets.only(right: 16),
                                    child: GameCard(
                                      gameModel: gameCounsumer.simlargames[index],
                                      onCardTap: (gameModel) {
                                        print(gameCounsumer.simlargames[index]);
                                      },
                                    ),
                                  )),
                            )),
                        const SizedBox(
                          height: 16,
                        )
                      ]),
                )),
        ),
      );
    });
  }
}























// class GameDetailsScreen extends StatefulWidget {
//   final String gameID;

//   const GameDetailsScreen({super.key, required this.gameID});

//   @override
//   _GameDetailsScreenState createState() => _GameDetailsScreenState();
// }

// class _GameDetailsScreenState extends State<GameDetailsScreen> {
//   GameDetailsModel? gameDetailsModel;

//   @override
//   void initState() {
//     super.initState();
//     _fetchGameDetails();
//   }

//   Future<void> _fetchGameDetails() async {
//     final response = await http.get(
//         Uri.parse('https://www.freetogame.com/api/game?id=${widget.gameID}'));
//     final game_DetailsModel =
//         GameDetailsModel.fromJson(jsonDecode(response.body));
//     setState(() {
//       gameDetailsModel = game_DetailsModel;
//     });
//   }

//   @override
//   Widget build(BuildContext context) {
//     if (gameDetailsModel == null) {
//       return const Center(
//         child: CircularProgressIndicator(),
//       );
//     }
//     return Scaffold(
//       appBar: AppBar(
//         title: Text(gameDetailsModel!.title),
//       ),
//       body: SingleChildScrollView(
//         child: Padding(
//           padding: const EdgeInsets.all(16.0),
//           child: Column(
//             children: [
//               GameTitleAndThumbnail(
//                 title: gameDetailsModel!.title,
//                 thumbnail: gameDetailsModel!.thumbnail,
//               ),
//               const SizedBox(height: 16),
//               GameStatusAndDescription(
//                 status: gameDetailsModel!.status,
//                 shortDescription: gameDetailsModel!.shortDescription,
//               ),
//               const SizedBox(height: 16),
//               ScreenshotsWidget(
//                 screenshots: gameDetailsModel!.screenshots,
//               ),
//               const SizedBox(height: 16),
//               GameDetails(
//                 description: gameDetailsModel!.description,
//                 gameUrl: gameDetailsModel!.gameUrl,
//                 genre: gameDetailsModel!.genre,
//                 platform: gameDetailsModel!.platform,
//                 publisher: gameDetailsModel!.publisher,
//                 developer: gameDetailsModel!.developer,
//                 releaseDate: gameDetailsModel!.releaseDate,
//               ),
//               const SizedBox(height: 16),
//               gameDetailsModel!.platform != "Browser"
//                   ? MinimumSystemRequirementsWidget(
//                       minimumSystemRequirements:
//                           gameDetailsModel?.minimumSystemRequirements,
//                       gameDetails: gameDetailsModel!,
//                     )
//                   : const SizedBox(height: 16),
//             ],
//           ),
//         ),
//       ),
//     );
//   }
// }

// class GameTitleAndThumbnail extends StatelessWidget {
//   final String title;
//   final String thumbnail;

//   const GameTitleAndThumbnail(
//       {super.key, required this.title, required this.thumbnail});

//   @override
//   Widget build(BuildContext context) {
//     return Column(
//       children: [
//         Image.network(thumbnail, scale: 1.1),
//         const SizedBox(width: 16),
//         Text(
//             textAlign: TextAlign.center,
//             title,
//             style: const TextStyle(
//               fontSize: 24,
//               fontWeight: FontWeight.bold,
//             )),
//       ],
//     );
//   }
// }

// class GameStatusAndDescription extends StatelessWidget {
//   final String status;
//   final String shortDescription;

//   const GameStatusAndDescription(
//       {super.key, required this.status, required this.shortDescription});

//   @override
//   Widget build(BuildContext context) {
//     return Column(
//       children: [
//         Text(status, style: const TextStyle(fontSize: 18)),
//         const SizedBox(height: 8),
//         Text(shortDescription, style: const TextStyle(fontSize: 16)),
//       ],
//     );
//   }
// }

// class GameDetails extends StatelessWidget {
//   final String description;
//   final String gameUrl;
//   final String genre;
//   final String platform;
//   final String publisher;
//   final String developer;
//   final DateTime releaseDate;

//   const GameDetails({
//     super.key,
//     required this.description,
//     required this.gameUrl,
//     required this.genre,
//     required this.platform,
//     required this.publisher,
//     required this.developer,
//     required this.releaseDate,
//   });

//   @override
//   Widget build(BuildContext context) {
//     return Column(
//       children: [
//         Text(description, style: const TextStyle(fontSize: 16)),
//         const SizedBox(height: 8),
//         Text('Game URL: $gameUrl', style: const TextStyle(fontSize: 16)),
//         const SizedBox(height: 8),
//         Text('Genre: $genre',
//             style: const TextStyle(
//               fontSize: 16,
//             )),
//         const SizedBox(height: 8),
//         Text('Platform: $platform', style: const TextStyle(fontSize: 16)),
//         const SizedBox(height: 8),
//         Text('Publisher: $publisher', style: const TextStyle(fontSize: 16)),
//         const SizedBox(height: 8),
//         Text('Developer: $developer', style: const TextStyle(fontSize: 16)),
//         const SizedBox(height: 8),
//         Text(
//             'Release Date: ${releaseDate.year}-${releaseDate.month}-${releaseDate.day}',
//             style: const TextStyle(fontSize: 16)),
//       ],
//     );
//   }
// }

// class MinimumSystemRequirementsWidget extends StatelessWidget {
//   final MinimumSystemRequirements? minimumSystemRequirements;
//   final GameDetailsModel gameDetails;

//   const MinimumSystemRequirementsWidget(
//       {super.key, this.minimumSystemRequirements, required this.gameDetails});

//   @override
//   Widget build(BuildContext context) {
//     return gameDetails.platform == "Browser"
//         ? const Text("No system requirements available for browser games.")
//         : gameDetails.minimumSystemRequirements == null
//             ? const Text("")
//             : Column(
//                 children: [
//                   const Text('Minimum System Requirements:',
//                       style: TextStyle(fontSize: 18)),
//                   const SizedBox(height: 8),
//                   Text('OS: ${minimumSystemRequirements?.os}',
//                       style: const TextStyle(fontSize: 16)),
//                   const SizedBox(height: 8),
//                   Text('Processor: ${minimumSystemRequirements?.processor}',
//                       style: const TextStyle(fontSize: 16)),
//                   const SizedBox(height: 8),
//                   Text('Memory: ${minimumSystemRequirements?.memory}',
//                       style: const TextStyle(fontSize: 16)),
//                   const SizedBox(height: 8),
//                   Text('Graphics: ${minimumSystemRequirements?.graphics}',
//                       style: const TextStyle(fontSize: 16)),
//                   const SizedBox(height: 8),
//                   Text('Storage: ${minimumSystemRequirements?.storage}',
//                       style: const TextStyle(fontSize: 16)),
//                 ],
//               );
//   }
// }

// class ScreenshotsWidget extends StatelessWidget {
//   final List<Screenshot> screenshots;

//   const ScreenshotsWidget({super.key, required this.screenshots});

//   @override
//   Widget build(BuildContext context) {
//     return SingleChildScrollView(
//       scrollDirection: Axis.horizontal,
//       child: SizedBox(
//         height: 200,
//         child: Row(
//           children: [
//             ...screenshots.map((screenshot) => Padding(
//                   padding: const EdgeInsets.all(8.0),
//                   child: Image.network(screenshot.image),
//                 )),
//           ],
//         ),
//       ),
//     );
//   }
// }

// class SameGenreWidget extends StatelessWidget {
//   const SameGenreWidget({super.key});

//   @override
//   Widget build(BuildContext context) {
//     return Container();
//   }
// }
