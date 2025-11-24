class PropertyTypeModel {
  final String id;
  final String name;
  final bool isActive;
  final String createdDate;
  final String updatedDate;

  PropertyTypeModel({
    required this.id,
    required this.name,
    required this.isActive,
    required this.createdDate,
    required this.updatedDate,
  });

  factory PropertyTypeModel.fromJson(Map<String, dynamic> json) {
    return PropertyTypeModel(
      id: json['id'],
      name: json['name'],
      isActive: json['is_active'],
      createdDate: json['created_date'],
      updatedDate: json['updated_date'],
    );
  }
}
