class MateriModel {
  int? id;
  String title;
  String content;
  String imageUrl;
  String videoUrl;
  String subTitle;
  String createdBy;

  MateriModel({
    this.id,
    required this.title,
    required this.content,
    required this.imageUrl,
    required this.videoUrl,
    required this.subTitle,
    required this.createdBy,
  });

  factory MateriModel.fromMap(Map<String, dynamic> map) {
    return MateriModel(
      id: (map['id'] as num?)?.toInt(),
      title: map['title'] as String,
      content: map['content'] as String,
      imageUrl: map['image_url'] as String,
      videoUrl: map['video_url'] as String,
      subTitle: map['subtitle'] as String,
      createdBy: map['created_by'] ?? '',
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'title': title,
      'content': content,
      'image_url': imageUrl,
      'video_url': videoUrl,
      'subtitle': subTitle,
      'created_by': createdBy,
    };
  }

  Map<String, dynamic> toInsertMap() {
    return {
      'title': title,
      'content': content,
      'image_url': imageUrl,
      'video_url': videoUrl,
      'subtitle': subTitle,
      'created_by': createdBy,
    };
  }
}
