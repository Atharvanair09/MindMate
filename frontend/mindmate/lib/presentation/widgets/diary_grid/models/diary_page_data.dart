import 'diary_image_block.dart';

class DiaryPageData {
  String text;
  List<DiaryImageBlock> images;
  String fontFamily;
  double fontSize;

  DiaryPageData({
    this.text = '',
    List<DiaryImageBlock>? images,
    this.fontFamily = 'Poppins',
    this.fontSize = 16.0,
  }) : images = images ?? [];

  Map<String, dynamic> toJson() {
    return {
      'text': text,
      'images': images.map((i) => i.toJson()).toList(),
      'fontFamily': fontFamily,
      'fontSize': fontSize,
    };
  }

  factory DiaryPageData.fromJson(Map<String, dynamic> json) {
    return DiaryPageData(
      text: json['text'] ?? '',
      images: (json['images'] as List?)
          ?.map((i) => DiaryImageBlock.fromJson(i))
          .toList(),
      fontFamily: json['fontFamily'] ?? 'Poppins',
      fontSize: (json['fontSize'] ?? 16.0).toDouble(),
    );
  }
}
