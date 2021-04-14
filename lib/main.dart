import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_amplify_demo/routes/routes_generator.dart';
import 'package:flutter_amplify_demo/routes/routes_path.dart';
import 'package:flutter_amplify_demo/services/amplify_services.dart';

import 'package:flutter_amplify_demo/services/get_it_service.dart';
import 'package:flutter_amplify_demo/services/navigation_service.dart';
import 'package:flutter_amplify_demo/stores/auth.dart';
import 'package:flutter_amplify_demo/stores/chat.dart';
import 'package:flutter_amplify_demo/stores/user.dart';
import 'package:flutter_amplify_demo/wrapper.dart';
import 'package:provider/provider.dart';

void main() {
  GetItService.setupLocator();

  SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
    systemNavigationBarColor: Colors.black,
    statusBarColor: Colors.black,
  ));

  WidgetsFlutterBinding.ensureInitialized();
  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  MyApp({Key key}) : super(key: key);

  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  void initState() {
    super.initState();
    AmplifyService.configureAmplify();
  }

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider<ChatStore>(
          create: (_) => ChatStore(),
          lazy: false,
        ),
        ChangeNotifierProvider<UserStore>(
          create: (_) => UserStore(),
          lazy: false,
        ),
        ChangeNotifierProvider<AuthStore>(
          create: (_) => AuthStore(),
          lazy: false,
        )
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        home: Wrapper(),
        theme: ThemeData(
          fontFamily: 'Poppins',
          textButtonTheme: TextButtonThemeData(
            style: TextButton.styleFrom(
              primary: Colors.black,
              backgroundColor: Colors.white,
            ),
          ),
        ),
        navigatorKey: get_it_instance_const<NavigationService>().navigatorKey,
        onGenerateRoute: generateRoute,
        initialRoute: RoutePath.Wrapper,
      ),
    );
  }
}
