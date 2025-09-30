import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:perfect_super_admin/features/auth/presentation/pages/login_page.dart';
import 'package:perfect_super_admin/features/auth/presentation/pages/splash_page.dart';
import 'package:perfect_super_admin/features/chat/presentation/pages/chat_page.dart';
import 'package:perfect_super_admin/features/manage/presentation/pages/add_course_page.dart';
import 'package:perfect_super_admin/features/manage/presentation/pages/all_courses_pages.dart';
import 'package:perfect_super_admin/features/manage/presentation/pages/manage_tutor_page.dart';
import 'package:perfect_super_admin/features/manage/presentation/pages/trainers_requests_pages.dart';
import 'package:perfect_super_admin/modules/bottom_bar/widget/bottom_bar.dart';

class AppRoutess {
  static Route onGenerateRoute(RouteSettings settings) {
    switch (settings.name) {
      case '/':
        return _buildRoute(SplashScreen(), settings);
      case '/login':
        return _buildRoute(LogInPage(), settings);
      case '/mainpage':
        return _buildRoute(BottomBar(), settings);
      case '/trainersrequests':
        return _buildRoute(TutorRequestsPage(), settings);
      case '/addcoursePage':
        return _buildRoute(AddCoursePage(), settings);
      case '/tutorall':
        return _buildRoute(TutorsGridView(), settings);
      case '/allcourses':
        return _buildRoute(AllCoursesPages(), settings);
      case '/chatpage':
        final args = settings.arguments as Map<String, dynamic>? ?? {};
        final name = args['name'] as String?;
        final receiverId = args['receiverId'] as String?;
        return _buildRoute(
            ChatPage(name: name ?? '', receiverId: receiverId ?? ''), settings);
      default:
        return _buildRoute(
            Scaffold(
              body: Center(
                child: Text("Page not found"),
              ),
            ),
            settings);
    }
  }

  static PageRouteBuilder _buildRoute(
    Widget page,
    RouteSettings settings,
  ) {
    return PageRouteBuilder(
      settings: settings,
      pageBuilder: (_, __, ___) => page,
      transitionsBuilder: (_, animation, secondaryAnimation, child) {
        const begin = Offset(1.0, 0.0); // Right to Left
        const end = Offset.zero;
        const reverseBegin = Offset(-1.0, 0.0); // Left to Right on Pop
        const curve = Curves.ease;

        final tween =
            Tween(begin: begin, end: end).chain(CurveTween(curve: curve));
        final reverseTween = Tween(begin: end, end: reverseBegin)
            .chain(CurveTween(curve: curve));

        final offsetAnimation = animation.drive(tween);
        final reverseOffsetAnimation = secondaryAnimation.drive(reverseTween);

        return SlideTransition(
          position: offsetAnimation,
          child: SlideTransition(
            position: reverseOffsetAnimation,
            child: child,
          ),
        );
      },
    );
  }
}
