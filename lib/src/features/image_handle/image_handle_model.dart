class ImageModel {
  final String? id;
  final String? path;
  final String? filename;
  final bool? isActive;

  ImageModel({
    this.id,
    this.path,
    this.filename,
    this.isActive,
  });

  factory ImageModel.fromJson(Map<String, dynamic> json) {
    return ImageModel(
      id: json['id']?.toString() ?? json['_id']?.toString(),
      path: json['path']?.toString(),
      filename: json['filename']?.toString(),
      isActive: json['is_active'] as bool?,
    );
  }
}