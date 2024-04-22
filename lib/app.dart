import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';

import 'core/providers/locale_type_controller.dart';
import 'core/providers/theme_mode_controller.dart';
import 'core/res/colors.dart';
import 'core/res/text_styles.dart';
import 'core/router/router.dart';

class App extends ConsumerWidget {
  const App({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    const primaryColor = Colors.blueAccent;

    /// Light theme
    final lightTheme = ThemeData(
      primaryColor: primaryColor,
      scaffoldBackgroundColor: ColorNames.lightGrey1,
      drawerTheme: const DrawerThemeData(
        backgroundColor: ColorNames.lightGrey1,
      ),
      appBarTheme: const AppBarTheme(
        backgroundColor: Colors.white,
      ),
      colorScheme: ColorScheme.fromSeed(
        primary: primaryColor,
        seedColor: primaryColor,
        surfaceTint: Colors.transparent,
      ),
      dialogTheme: DialogTheme(
        titleTextStyle: context.largeStyle,
      ),
      useMaterial3: true,
    );

    /// Dark theme
    final darkTheme = ThemeData(
      primaryColor: primaryColor,
      colorScheme: const ColorScheme.dark(
        primary: primaryColor,
        surfaceTint: Colors.transparent,
      ),
      dividerTheme: DividerThemeData(
        color: Colors.grey[700],
      ),
      dialogTheme: DialogTheme(
        titleTextStyle: context.largeStyle.copyWith(color: Colors.white),
      ),
      useMaterial3: true,
    );

    final locale = ref.watch(localeTypeControllerProvider)?.toLocale;
    final themeMode = ref.watch(themeModeControllerProvider);

    return MaterialApp.router(
      title: 'Flutter Chat GPT',
      localizationsDelegates: AppLocalizations.localizationsDelegates,
      supportedLocales: AppLocalizations.supportedLocales,
      debugShowCheckedModeBanner: false,
      locale: locale,
      theme: lightTheme.copyWith(
        textTheme: GoogleFonts.interTextTheme(lightTheme.textTheme),
      ),
      darkTheme: darkTheme.copyWith(
        textTheme: GoogleFonts.interTextTheme(darkTheme.textTheme),
      ),
      themeMode: themeMode,
      routerConfig: router,
    );
  }
}
