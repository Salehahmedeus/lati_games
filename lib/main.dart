import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:gameslati/firebase_options.dart';
import 'package:gameslati/providers/darkmode_provider.dart';
import 'package:gameslati/providers/games_provider.dart';
import 'package:gameslati/screens/home_screen.dart';
import 'package:gameslati/screens/login_screen.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
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
              drawerTheme: DrawerThemeData(
                backgroundColor:
                    darkModeConsumer.isDark ? Colors.black : Colors.white,
              ),
              appBarTheme: AppBarTheme(
                  centerTitle: true,
                  backgroundColor:
                      darkModeConsumer.isDark ? Colors.black : Colors.white),
              scaffoldBackgroundColor:
                  darkModeConsumer.isDark ? Colors.black : Colors.white,
              textTheme: GoogleFonts.robotoTextTheme(),
              colorScheme: ColorScheme.fromSeed(seedColor: Colors.blue),
              useMaterial3: true,
            ),
            home: const HomeScreen(),
          );
        });
      }),
    );
  }
}

class ScreenRouter extends StatefulWidget {
  const ScreenRouter({super.key});
  @override
  State<ScreenRouter> createState() => _ScreenRouterState();
}

class _ScreenRouterState extends State<ScreenRouter> {
  FirebaseAuth firebaseAuth = FirebaseAuth.instance;

  // @override
  // Widget build(BuildContext context) {
  //   if (kDebugMode) {
  //     print("AS${firebaseAuth.currentUser!.email}");
  //   }
  //   return firebaseAuth.currentUser != null
  //       ? const HomeScreen()
  //       : const LoginScreen();
  // }

  @override
  Widget build(BuildContext context) {
    final FirebaseAuth firebaseAuth = FirebaseAuth.instance;

    return StreamBuilder<User?>(
      stream: firebaseAuth.authStateChanges(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(
              child: CircularProgressIndicator()); // Loading indicator
        }
        if (snapshot.hasData) {
          return const HomeScreen();
        } else {
          return const LoginScreen();
        }
      },
    );
  }
}
