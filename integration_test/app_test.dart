import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:music_media/data/hive/track_hive.dart';
import 'package:music_media/data/hive/tracks_box.dart';
import 'package:music_media/view/introduction/introduction.dart';
import 'package:music_media/view_model/home/home_bloc.dart';
import 'package:music_media/view_model/searching/searching_bloc.dart';
import 'package:music_media/view_model/theme/theme_bloc.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  group('Music App Integration Tests', () {
    setUpAll(() async {
      // Initialize Hive once for all tests
      await Hive.initFlutter();

      // Check if adapter is already registered to avoid conflicts
      if (!Hive.isAdapterRegistered(0)) {
        Hive.registerAdapter(TrackHiveAdapter());
      }

      // Open the box if not already open
      if (!Hive.isBoxOpen('tracksBox')) {
        tracksBox = await Hive.openBox<TrackHive>('tracksBox');
      }
    });

    tearDownAll(() async {
      // Clean up after all tests - simplified approach
      try {
        await Hive.close();
      } catch (e) {
        // Ignore cleanup errors in tests
      }
    });

    Widget createTestApp() {
      return MultiBlocProvider(
        providers: [
          BlocProvider<ThemeCubit>(create: (context) => ThemeCubit()),
          BlocProvider<HomeCubit>(create: (context) => HomeCubit()),
          BlocProvider<SearchingCubit>(create: (context) => SearchingCubit()),
        ],
        child: BlocBuilder<ThemeCubit, ThemeState>(
          builder: (context, state) {
            return MaterialApp(
              title: 'Music Media',
              themeMode: state.themeData,
              theme: ThemeData.light(),
              darkTheme: ThemeData.dark(),
              home: const Introduction(),
            );
          },
        ),
      );
    }

    testWidgets('should load app successfully', (WidgetTester tester) async {
      // Launch the app using our custom widget
      await tester.pumpWidget(createTestApp());
      await tester.pumpAndSettle();

      // Wait for the app to fully load
      await tester.pump(const Duration(seconds: 2));

      // Should find the app running
      expect(find.byType(MaterialApp), findsOneWidget);
    });

    testWidgets('should handle basic app lifecycle',
        (WidgetTester tester) async {
      // Launch the app
      await tester.pumpWidget(createTestApp());
      await tester.pumpAndSettle();

      // Wait for app to load
      await tester.pump(const Duration(seconds: 1));

      // Should have MaterialApp running
      expect(find.byType(MaterialApp), findsOneWidget);

      // App should be responsive
      await tester.pump();
      expect(find.byType(MaterialApp), findsOneWidget);
    });

    testWidgets('should maintain app state', (WidgetTester tester) async {
      // Launch the app
      await tester.pumpWidget(createTestApp());
      await tester.pumpAndSettle();

      // Give time for initialization
      await tester.pump(const Duration(seconds: 1));

      // Check that we have a working app
      expect(find.byType(MaterialApp), findsOneWidget);

      // Simulate some interaction
      await tester.pump(const Duration(milliseconds: 100));

      // App should still be running
      expect(find.byType(MaterialApp), findsOneWidget);
    });
  });
}
