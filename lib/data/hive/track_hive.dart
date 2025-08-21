import 'package:hive/hive.dart';

part 'track_hive.g.dart';

@HiveType(typeId: 0)
class TrackHive extends HiveObject {
  TrackHive({
    required this.name,
    required this.artist,
    required this.imageUrl,
    required this.linkUrl,
  });

  @HiveField(0)
  String name;

  @HiveField(1)
  String artist;

  @HiveField(2)
  String imageUrl;

  @HiveField(3)
  String linkUrl;
}
