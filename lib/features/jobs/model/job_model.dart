class JobModel {
  final String id;
  final String title;
  final String description;
  final String city;
  final int budget;
  final String createdBy;
  final String status;
  final DateTime? createdAt;

  JobModel({
    required this.id,
    required this.title,
    required this.description,
    required this.city,
    required this.budget,
    required this.createdBy,
    required this.status,
    this.createdAt,
  });

  factory JobModel.fromMap(Map<String, dynamic> map, String id) {
    return JobModel(
      id: id,
      title: map['title'] ?? '',
      description: map['description'] ?? '',
      city: map['city'] ?? '',
      budget: (map['budget'] ?? 0) is int
          ? map['budget']
          : int.tryParse(map['budget'].toString()) ?? 0,
      createdBy: map['createdBy'] ?? '',
      status: map['status'] ?? 'open',
      createdAt: map['createdAt'] != null
          ? DateTime.tryParse(map['createdAt'].toString())
          : null,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'title': title,
      'description': description,
      'city': city,
      'budget': budget,
      'createdBy': createdBy,
      'status': status,
      'createdAt': createdAt?.toIso8601String(),
    };
  }

  JobModel copyWith({
    String? id,
    String? title,
    String? description,
    String? city,
    int? budget,
    String? createdBy,
    String? status,
    DateTime? createdAt,
  }) {
    return JobModel(
      id: id ?? this.id,
      title: title ?? this.title,
      description: description ?? this.description,
      city: city ?? this.city,
      budget: budget ?? this.budget,
      createdBy: createdBy ?? this.createdBy,
      status: status ?? this.status,
      createdAt: createdAt ?? this.createdAt,
    );
  }
}