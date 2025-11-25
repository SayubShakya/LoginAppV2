class ImageModel {
  final String id;
  final String path;
  final String filename;
  final bool isActive;

  ImageModel({
    required this.id,
    required this.path,
    required this.filename,
    required this.isActive,
  });

  factory ImageModel.fromJson(Map<String, dynamic> json) {
    return ImageModel(
      id: json['_id'],
      path: json['path'],
      filename: json['filename'],
      isActive: json['is_active'],
    );
  }
}
