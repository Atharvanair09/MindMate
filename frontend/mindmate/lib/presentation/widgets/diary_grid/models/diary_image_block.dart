import 'package:uuid/uuid.dart';

class DiaryImageBlock {
  final String id;
  String imagePath;
  int x;
  int y;
  int width;
  int height;

  DiaryImageBlock({
    String? id,
    required this.imagePath,
    required this.x,
    required this.y,
    required this.width,
    required this.height,
  }) : id = id ?? const Uuid().v4();

  DiaryImageBlock copyWith({
    String? imagePath,
    int? x,
    int? y,
    int? width,
    int? height,
  }) {
    return DiaryImageBlock(
      id: id,
      imagePath: imagePath ?? this.imagePath,
      x: x ?? this.x,
      y: y ?? this.y,
      width: width ?? this.width,
      height: height ?? this.height,
    );
  }
}
