class WorkerModel {
  final String id;
  final String name;
  final String trade;
  final String city;
  final double rating;
  final int reviewsCount;
  final bool isAvailable;

  WorkerModel({
    required this.id,
    required this.name,
    required this.trade,
    required this.city,
    required this.rating,
    required this.reviewsCount,
    required this.isAvailable,
  });

  factory WorkerModel.fromMap(Map<String, dynamic> map, String id) {
    return WorkerModel(
      id: id,
      name: map['name'] ?? '',
      trade: map['trade'] ?? '',
      city: map['city'] ?? '',
      rating: (map['rating'] ?? 0).toDouble(),
      reviewsCount: map['reviewsCount'] ?? 0,
      isAvailable: map['isAvailable'] ?? true,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'trade': trade,
      'city': city,
      'rating': rating,
      'reviewsCount': reviewsCount,
      'isAvailable': isAvailable,
    };
  }

  WorkerModel copyWith({
    String? id,
    String? name,
    String? trade,
    String? city,
    double? rating,
    int? reviewsCount,
    bool? isAvailable,
  }) {
    return WorkerModel(
      id: id ?? this.id,
      name: name ?? this.name,
      trade: trade ?? this.trade,
      city: city ?? this.city,
      rating: rating ?? this.rating,
      reviewsCount: reviewsCount ?? this.reviewsCount,
      isAvailable: isAvailable ?? this.isAvailable,
    );
  }
}