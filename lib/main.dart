import 'package:finai_frontend/app/presentation/pages/splash/splash_screen_page.dart';
import 'package:finai_frontend/core/constants/app_strings.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:finai_frontend/app/presentation/cubit/auth/auth_cubit.dart';
import 'package:finai_frontend/app/domain/use_cases/auth/login.dart';
// TODO: Implement these Cubits when available
// import 'package:finai_frontend/app/presentation/cubit/account/account_cubit.dart';
// import 'package:finai_frontend/app/presentation/cubit/category/category_cubit.dart';
import 'package:finai_frontend/app/presentation/cubit/transaction/transaction_cubit.dart';
import 'package:finai_frontend/app/presentation/cubit/permission/permission_cubit.dart';
import 'package:finai_frontend/core/navigation/navigation_service.dart';
import 'package:finai_frontend/core/themes/app_themes.dart';
import 'package:finai_frontend/core/services/injection.dart';
import 'package:finai_frontend/core/config/app_config.dart';

void main() {
  // Initialize the environment before setting up dependencies
  AppConfig.setEnvironment(AppEnvironment.development);
  configureDependencies();
  runApp(const MainApp());
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider<AuthCubit>(
          create: (context) => AuthCubit(getIt<Login>()),
        ),
        BlocProvider<PermissionCubit>(
          create: (context) => PermissionCubit(),
        ),
        // TODO: Add these Cubits when implemented
        // BlocProvider<AccountCubit>(
        //   create: (context) => AccountCubit(),
        // ),
        // BlocProvider<CategoryCubit>(
        //   create: (context) => CategoryCubit(),
        // ),
        BlocProvider<TransactionCubit>(
          create: (context) => TransactionCubit(),
        ),
      ],
      child: MaterialApp(
        title: AppStrings.appName,
        theme: AppThemes.lightTheme,
        darkTheme: AppThemes.darkTheme,
        themeMode: ThemeMode.system,
        debugShowCheckedModeBanner: false,
        navigatorKey: NavigationService.navigatorKey,
        home: const SplashScreenPage(),
      ),
    );
  }
}
