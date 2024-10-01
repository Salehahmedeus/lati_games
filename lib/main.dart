import 'package:flutter/material.dart';
import 'package:gameslati/providers/darkmode_provider.dart';
import 'package:gameslati/providers/games_provider.dart';
import 'package:gameslati/screens/home_screen.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context)
   {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider<GamesProvider>(
          create: (context) => GamesProvider()..fetchgames("all"),
        ),
        ChangeNotifierProvider<DarkmodeProvider>(
          create: (context) => DarkmodeProvider()..getMode(),
        )
      ],
      child: Consumer<GamesProvider>(builder: (context, gameConsumer, _) {
        return Consumer<DarkmodeProvider>(
            builder: (context, darkModeConsumer, _) {
          return MaterialApp(
            title: 'Flutter Demo',
            theme: ThemeData(
              dividerTheme: DividerThemeData(
                color:
                    darkModeConsumer.isDark ? Colors.white24 : Colors.black26,
              ),
              appBarTheme: AppBarTheme(
                  centerTitle: true, backgroundColor: darkModeConsumer.isDark ? Colors.black : Colors.white),
              
              scaffoldBackgroundColor:
                  darkModeConsumer.isDark ? Colors.black : Colors.white,
              textTheme: GoogleFonts.cairoTextTheme(),
              colorScheme: ColorScheme.fromSeed(seedColor: Colors.blue),
              useMaterial3: false,
            ),
            home: const HomeScreen(),
          );
        });
      }),
    );
  }
}
