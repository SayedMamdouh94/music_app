import 'package:flutter_test/flutter_test.dart';
import 'package:music_media/data/service/service.dart';

void main() {
  group('Service Tests', () {
    late Service service;

    setUp(() {
      service = Service();
    });

    test('should create service instance', () {
      expect(service, isNotNull);
      expect(service, isA<Service>());
    });

    test('should have correct base URL', () {
      final baseUrl = service.baseUrl;
      expect(baseUrl, equals('https://api.deezer.com'));
    });

    test('should clear cache without errors', () {
      expect(() => Service.clearCache(), returnsNormally);
    });

    test('should dispose HTTP client without errors', () {
      expect(() => Service.dispose(), returnsNormally);
    });

    test('should throw exception for invalid track type', () {
      expect(
        () => service.getTracks(123, type: 'invalid_type'),
        throwsException,
      );
    });

    test('should handle service instance creation multiple times', () {
      final service1 = Service();
      final service2 = Service();

      expect(service1, isNotNull);
      expect(service2, isNotNull);
      expect(service1.baseUrl, equals(service2.baseUrl));
    });

    test('should have consistent baseUrl across instances', () {
      final service1 = Service();
      final service2 = Service();

      expect(service1.baseUrl, equals('https://api.deezer.com'));
      expect(service2.baseUrl, equals('https://api.deezer.com'));
      expect(service1.baseUrl, equals(service2.baseUrl));
    });

    test('should handle cache operations without errors', () {
      // Test cache clearing multiple times
      expect(() => Service.clearCache(), returnsNormally);
      expect(() => Service.clearCache(), returnsNormally);
    });

    test('should handle dispose operations without errors', () {
      // Test dispose operations
      expect(() => Service.dispose(), returnsNormally);
    });
  });
}
