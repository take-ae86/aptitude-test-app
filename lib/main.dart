import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'screens/home_screen.dart';
import 'screens/placeholder_screen.dart';
import 'screens/kraepelin_exam_page.dart';
import 'screens/cab_gab/cab_gab_selection_screen.dart';

void main() {
  runApp(const AptitudeApp());
}

class AptitudeApp extends StatelessWidget {
  const AptitudeApp({super.key});

  @override
  Widget build(BuildContext context) {
    // 基本のテキストテーマ (Update Trigger 2)
    final baseTextTheme = const TextTheme(
      bodyMedium: TextStyle(fontSize: 16, fontWeight: FontWeight.w500, color: Color(0xFF333333)),
      bodyLarge: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Color(0xFF333333)),
      titleLarge: TextStyle(fontSize: 22, fontWeight: FontWeight.w900, color: Color(0xFF333333)),
      titleMedium: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Color(0xFF333333)),
      labelLarge: TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
    );

    return MaterialApp(
      title: '適性検査対策アプリ',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        useMaterial3: true,
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color(0xFF42A5F5),
          primary: const Color(0xFF42A5F5),
          surface: const Color(0xFFF5F9FF),
        ),
        // Noto Sans JP を適用して中華フォント問題を解決
        textTheme: GoogleFonts.notoSansJpTextTheme(baseTextTheme),
        scaffoldBackgroundColor: const Color(0xFFF5F9FF),
        appBarTheme: AppBarTheme(
          backgroundColor: const Color(0xFF42A5F5),
          foregroundColor: Colors.white,
          centerTitle: true,
          elevation: 0,
          titleTextStyle: GoogleFonts.notoSansJp(fontSize: 20, fontWeight: FontWeight.bold),
        ),
        cardTheme: CardThemeData(
          elevation: 2,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          margin: EdgeInsets.zero,
        ),
      ),
      home: const HomeScreen(),
    );
  }
}
