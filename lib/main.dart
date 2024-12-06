import 'package:country_display_application/Controllers/github_controller.dart';
import 'package:country_display_application/Screens/SplashScreen/splash_screen.dart';
import 'package:flexify/flexify.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

List<String> starredList = [];
void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  SharedPreferences prefs = await SharedPreferences.getInstance();
  starredList = prefs.getStringList('starred_list') ?? [];

  runApp(
    const MyApp(),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.sizeOf(context);
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (context) => GitHubController(),
        ),
      ],
      child: ScreenUtilInit(
        minTextAdapt: true,
        designSize: Size(
          size.width,
          size.height,
        ),
        builder: (context, _) {
          return Flexify(
            designWidth: size.width,
            designHeight: size.height,
            app: const MaterialApp(
              debugShowCheckedModeBanner: false,
              home: SplashScreen(),
            ),
          );
        },
      ),
    );
  }
}
