import 'dart:io';
import 'dart:ui';

import 'package:desktop_window/desktop_window.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';
import 'package:google_fonts/google_fonts.dart';

import 'bloc/auth/auth_bloc.dart';
import 'bloc/navigation/navigation_bloc.dart';
import 'bloc/post/post_bloc.dart';
import 'bloc/topic/topic_bloc.dart';
import 'constants/theme/app_theme.dart';
import 'data/injector.dart';
import 'data/repositories/auth_repository.dart';
import 'data/repositories/post_repository.dart';
import 'data/repositories/topic_repository.dart';
import 'screens/root_screen.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  if (!kIsWeb && Platform.isWindows) {
    await DesktopWindow.setMinWindowSize(const Size(400, 600));
  }

  await Injector.setupInjector();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(create: (context) => NavigationBloc()),
        BlocProvider(create: (context) => AuthBloc(GetIt.instance.get<AuthRepository>())),
        BlocProvider(create: (context) => TopicBloc(GetIt.instance.get<TopicRepository>())),
        BlocProvider(create: (context) => PostBloc(GetIt.instance.get<PostRepository>())),
      ],
      child: MaterialApp(
        scrollBehavior: const MaterialScrollBehavior().copyWith(
          dragDevices: {
            PointerDeviceKind.mouse,
            PointerDeviceKind.touch,
            PointerDeviceKind.stylus,
            PointerDeviceKind.trackpad,
          },
        ),
        debugShowCheckedModeBanner: false,
        theme: AppTheme.appTheme.copyWith(
          textTheme: GoogleFonts.interTextTheme(
            Theme.of(context).textTheme,
          ),
        ),
        home: const RootScreen(),
      ),
    );
  }
}
