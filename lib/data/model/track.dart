import 'package:music_media/core/constants/const_madia.dart';

class Track {
  final int id;
  final String name;
  final String artist;
  String imageUrl;
  final String savedNetworkUrl;
  final String savedNetworkImage;
  String linkUrl;
  bool isDownloaded;

  Track({
    required this.id,
    required this.name,
    required this.artist,
    required this.imageUrl,
    required this.savedNetworkUrl,
    required this.savedNetworkImage,
    required this.linkUrl,
    this.isDownloaded = false,
  });

  factory Track.fromJson(Map<String, dynamic> json, List? image) {
    final md5 = json['md5_image'];
    String? image;
    if (md5 != null && md5 is String) {
      image =
          "https://e-cdns-images.dzcdn.net/images/cover/$md5/500x500-000000-80-0-0.jpg";
    }
    final url = (json['preview'] == null || json['preview'] == '')
        ? ConstMedia.audioDefault
        : json['preview'];
    return Track(
      id: json['id'],
      name: json['title'] ?? '',
      artist: json['artist']['name'] ?? '',
      imageUrl: image ?? ConstMedia.imageDefault,
      savedNetworkUrl: url,
      savedNetworkImage: image ?? ConstMedia.imageDefault,
      linkUrl: url,
    );
  }
}
