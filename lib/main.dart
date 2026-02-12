import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:perfect_super_admin/config/routes/app_routes.dart';
import 'package:perfect_super_admin/core/services/file_service.dart';
import 'package:perfect_super_admin/core/services/permission_service.dart';
import 'package:perfect_super_admin/core/theme/text_theme.dart';
import 'package:perfect_super_admin/features/activity/data/repositories/activity_repository_impl.dart';
import 'package:perfect_super_admin/features/activity/data/repositories/media_repository_imp.dart';
import 'package:perfect_super_admin/features/activity/domain/repositories/activity_repository.dart';
import 'package:perfect_super_admin/features/activity/domain/repositories/media_repository.dart';
import 'package:perfect_super_admin/features/activity/domain/usecases/create_daily_insight.dart';
import 'package:perfect_super_admin/features/activity/domain/usecases/create_quiz.dart';
import 'package:perfect_super_admin/features/activity/domain/usecases/delete_media.dart';
import 'package:perfect_super_admin/features/activity/presentation/blocs/acitivity/activity_bloc.dart';
import 'package:perfect_super_admin/features/auth/data/repositories/auth_repository.dart';
import 'package:perfect_super_admin/features/auth/presentation/bloc/bloc/auth_bloc.dart';
import 'package:perfect_super_admin/features/communication/data/repositories/call_repository.dart';
import 'package:perfect_super_admin/features/communication/presentation/blocs/call_listener/call_listener_event.dart';
import 'package:perfect_super_admin/features/communication/presentation/blocs/chat_bloc/chat_bloc.dart';
import 'package:perfect_super_admin/features/communication/presentation/blocs/chat_message_bloc/chat_message_bloc.dart';
import 'package:perfect_super_admin/features/communication/presentation/blocs/search_cubit/search_cubit.dart';
import 'package:perfect_super_admin/features/communication/presentation/factories/call_action_bloc_factory.dart';
import 'package:perfect_super_admin/features/communication/presentation/factories/call_listener_bloc_factory.dart';
import 'package:perfect_super_admin/features/dashboard/data/repositories/revenue_repository.dart';
import 'package:perfect_super_admin/features/dashboard/domain/usecases/export_revenue_usecase.dart';
import 'package:perfect_super_admin/features/dashboard/presentation/blocs/revenue%20cubit/revenue_cubit.dart';
import 'package:perfect_super_admin/features/dashboard/presentation/blocs/revenue_export/revenueexport_cubit.dart';
import 'package:perfect_super_admin/features/manage/data/repositories/admin_user_repo_impl.dart';
import 'package:perfect_super_admin/features/manage/data/services/firebase_course_service.dart';
import 'package:perfect_super_admin/features/manage/data/services/media/cloudinary_service.dart';
import 'package:perfect_super_admin/features/manage/domain/repositories/admin_user_repository.dart';
import 'package:perfect_super_admin/features/manage/presentation/blocs/admin_user/admin_user_bloc.dart';
import 'package:perfect_super_admin/features/manage/presentation/blocs/bloc/course_bloc.dart';
import 'package:perfect_super_admin/features/manage/presentation/cubits/course_cubit.dart';
import 'package:perfect_super_admin/features/manage/presentation/cubits/course_thumbnail_cubit.dart';
import 'package:perfect_super_admin/features/manage/presentation/cubits/course_video_cubit.dart';
import 'package:perfect_super_admin/features/manage/presentation/cubits/cubit/course_selection_state_cubit.dart';
import 'package:perfect_super_admin/modules/bottom_bar/cubit/bottom_bar_cubit.dart';
import 'package:perfect_super_admin/firebase_options.dart';
import 'package:zego_uikit/zego_uikit.dart';
import 'core/services/notification_service.dart';
import 'features/activity/domain/usecases/delete_daily_insight.dart';
import 'features/activity/domain/usecases/update_daily_insight.dart';
import 'features/activity/domain/usecases/upload_media.dart';
import 'features/activity/presentation/blocs/media/media_bloc.dart';

final FlutterLocalNotificationsPlugin notifications =
    FlutterLocalNotificationsPlugin();

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  final notificationService = NotificationService(notifications);

  await notificationService.init();

  ZegoUIKit().setAdvanceConfigs({'enable_log': 'false'});

  runApp(
    MyApp(),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return MultiRepositoryProvider(
      providers: [
        RepositoryProvider<AdminUserRepository>(
            create: (context) =>
                AdminUserRepositoryImpl(FirebaseFirestore.instance)),
        RepositoryProvider<MediaRepository>(
            create: (context) => MediaRepositoryImpl(CloudinaryService())),
        RepositoryProvider<ActivityRepository>(
            create: (context) =>
                ActivityRepositoryImpl(FirebaseFirestore.instance)),
        RepositoryProvider<CallRepository>(
            create: (context) => CallRepository()),
        RepositoryProvider<AuthRepository>(
            create: (context) => AuthRepository()),
        RepositoryProvider<RevenueRepository>(
            create: (context) => RevenueRepository()),
        BlocProvider(
          create: (_) => CourseBloc(
            cloudinaryService: CloudinaryService(),
            firebaseService: FirebaseCourseService(),
          ),
        ),
        BlocProvider(create: (context) => CourseSelectionCubit()),
        BlocProvider(create: (_) => CourseThumbnailCubit()),
        BlocProvider(
          create: (_) => CourseVideosCubit(),
        ),
        BlocProvider(create: (context) => SearchCubit()),
        BlocProvider(
            create: (context) => ChatBloc()
              ..add(LoadTrainersEvent())
              ..add(LoadUsersEvent())),
        BlocProvider(create: (context) => ChatMessageBloc()),
      ],
      child: MultiBlocProvider(
        providers: [
          BlocProvider(
              create: (context) => RevenueExportCubit(
                  exportUsecase: ExportRevenueUsecase(),
                  fileService: FileService(),
                  notificationService: NotificationService(notifications),
                  permissionService: PermissionService())),
          BlocProvider(
              create: (context) => AdminUserBloc(
                  RepositoryProvider.of<AdminUserRepository>(context))),
          BlocProvider(
              create: (context) => CourseCubit(FirebaseFirestore.instance)),
          BlocProvider(
            create: (context) => MediaBloc(
                deleteMedia: DeleteMedia(
                    RepositoryProvider.of<MediaRepository>(context)),
                uploadMedia: UploadMedia(CloudinaryService())),
          ),
          BlocProvider(create: (context) => CallActionBlocFactory.create()),
          BlocProvider(
              create: (context) =>
                  CallListenerBlocFactory.create()..add(StartCallListening())),
          BlocProvider(
            create: (context) => BottomNavCubit(),
          ),
          BlocProvider(
            create: (context) => AuthBloc(
                authRepository: RepositoryProvider.of<AuthRepository>(context))
              ..add(CheckLoginStatusEvent()),
          ),
          BlocProvider<ActivityBloc>(
              create: (context) => ActivityBloc(
                  createDailyInsight: CreateDailyInsight(
                      RepositoryProvider.of<ActivityRepository>(context)),
                  updateDailyInsight: UpdateDailyInsight(
                      RepositoryProvider.of<ActivityRepository>(context)),
                  deleteDailyInsight: DeleteDailyInsight(
                      RepositoryProvider.of<ActivityRepository>(context)),
                  createQuiz: CreateQuiz(
                      RepositoryProvider.of<ActivityRepository>(context)))),
          BlocProvider(
              create: (context) => RevenueCubit(
                  RepositoryProvider.of<RevenueRepository>(context)))
        ],
        child: SafeArea(
          child: MaterialApp(
            debugShowCheckedModeBanner: false,
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
