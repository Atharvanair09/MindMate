import 'diary_image_block.dart';

class DiaryPageData {
  String text;
  List<DiaryImageBlock> images;

  DiaryPageData({
    this.text = '',
    List<DiaryImageBlock>? images,
  }) : images = images ?? [];
}
