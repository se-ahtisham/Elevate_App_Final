import 'package:elevate_app/Pages/Splash_Screens/mainSplash.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // For env file
  await dotenv.load(fileName: ".env");

  SystemChrome.setSystemUIOverlayStyle(
    const SystemUiOverlayStyle(
      statusBarColor: Colors.transparent,
      statusBarIconBrightness: Brightness.light,
      statusBarBrightness: Brightness.dark,
    ),
  );

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    /*final job = Job(
      id: "0",
      title: "Flutter Developer",
      company: "Google",
      location: "Remote - Pakistan",
      description: "Build high-quality Flutter apps with clean architecture.",
      salary: "150k - 250k PKR",
      jobType: "Full Time",
      platform: "LinkedIn",
      isRemote: true,
      applyUrl: "https://careers.google.com",
    );
*/
    return MaterialApp(debugShowCheckedModeBanner: false, home: SplashScreen());
  }
}
