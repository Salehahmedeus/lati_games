import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:gameslati/models/detailed_game_model.dart';
import 'package:gameslati/models/game_model.dart';
import 'package:gameslati/services/api.dart';

class GamesProvider with ChangeNotifier {
  bool isLoding = false;

  GameDetailsModel? detailedGameModel;

  List<GameModel> games = [];
  Api api = Api();
  fetchgames(String platfrom) async {
    isLoding = true;
    notifyListeners();
    //didnt understandet it
    games.clear();
    final response = await api
        .get("https://www.freetogame.com/api/games?platform=$platfrom");

    if (kDebugMode) {
      print("STATUS CODE : ${response.statusCode}");
      print("BODY : ${response.body}");
    }

    if (response.statusCode == 200) {
      var decodedData = json.decode(response.body);
      games =
          List<GameModel>.from(decodedData.map((e) => GameModel.fromJson(e)))
              .toList();

      isLoding = false;
      notifyListeners();
    }
  }
  //----------------------------------------Detailed game----------------------------------------\\
  fetchGameById(String id) async {
    isLoding = true;

    // games.clear();

    final response =
        await api.get("https://www.freetogame.com/api/game?id=$id");

    

    if (response.statusCode == 200) {
      var decodedData = json.decode(response.body);

      if (kDebugMode) {
        print("DECODED DATA :  ${jsonDecode(response.body)}");
      }
      detailedGameModel = GameDetailsModel.fromJson(decodedData);
      getgamecatagoury(detailedGameModel!.genre);

      isLoding = false;
      notifyListeners();
    }
  }
  //----------------------------------------Similar game----------------------------------------\\

  List<GameModel> simlargames = [];
  getgamecatagoury(String category) async {
    isLoding = true;
    notifyListeners();

    //didnt understandet it
    simlargames.clear();
    final response = await api.get(
        "https://www.freetogame.com/api/games?platform=$category");

    if (response.statusCode == 200) {
      var decodedData = json.decode(response.body);
      simlargames =
          List<GameModel>.from(decodedData.map((e) => GameModel.fromJson(e)))
              .toList();

      isLoding = false;
      notifyListeners();
    }
  }
}
