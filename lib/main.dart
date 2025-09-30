import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:perfect_super_admin/config/routes/app_routes.dart';
import 'package:perfect_super_admin/core/theme/text_theme.dart';
import 'package:perfect_super_admin/features/auth/data/repositories/auth_repository.dart';
import 'package:perfect_super_admin/features/auth/presentation/bloc/bloc/auth_bloc.dart';
import 'package:perfect_super_admin/features/chat/presentation/blocs/bloc/chat_bloc.dart';
import 'package:perfect_super_admin/features/chat/presentation/blocs/chat_message_bloc/chat_message_bloc.dart';
import 'package:perfect_super_admin/features/manage/data/services/firebase_course_service.dart';
import 'package:perfect_super_admin/features/manage/data/services/media/cloudinary_service.dart';
import 'package:perfect_super_admin/features/manage/presentation/blocs/bloc/course_bloc.dart';
import 'package:perfect_super_admin/features/manage/presentation/cubits/course_thumbnail_cubit.dart';
import 'package:perfect_super_admin/features/manage/presentation/cubits/course_video_cubit.dart';
import 'package:perfect_super_admin/features/manage/presentation/cubits/cubit/course_selection_state_cubit.dart';
import 'package:perfect_super_admin/modules/bottom_bar/cubit/bottom_bar_cubit.dart';
import 'package:perfect_super_admin/firebase_options.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(
    MyApp(),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiRepositoryProvider(
      providers: [
        RepositoryProvider<AuthRepository>(
            create: (context) => AuthRepository()),
        BlocProvider(
          create: (_) => CourseBloc(
            cloudinaryService: CloudinaryService(),
            firebaseService: FirebaseCourseService(),
          ),
        ),
        BlocProvider(create: (context)=> CourseSelectionCubit()),
        BlocProvider(create: (_) => CourseThumbnailCubit()),
        BlocProvider(
          create: (_) => CourseVideosCubit(),
        ),
        BlocProvider(create: (context)=>ChatBloc()..add(LoadTrainersEvent())..add(LoadUsersEvent())),
        BlocProvider(create: (context)=>ChatMessageBloc())
      ],
      child: MultiBlocProvider(
        providers: [
          BlocProvider(
            create: (context) => BottomNavCubit(),
          ),
          BlocProvider(
            create: (context) => AuthBloc(
                authRepository: RepositoryProvider.of<AuthRepository>(context))
              ..add(CheckLoginStatusEvent()),
          ),
        ],
        child: SafeArea(
          child: MaterialApp(
            debugShowCheckedModeBanner: false,
            title: 'Flutter Demo',
            theme: ThemeData(
              colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
              textTheme: TextTheme(
                  headlineLarge: AppTextStyles.heading as TextStyle?,
                  titleMedium: AppTextStyles.subtitle as TextStyle?),
              useMaterial3: true,
            ),
            initialRoute: '/',
            onGenerateRoute: AppRoutess.onGenerateRoute,
          ),
        ),
      ),
    );
  }
}
