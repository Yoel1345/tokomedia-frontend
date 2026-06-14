class Product {
  final String id;
  final String userIdentifier;
  final String name;
  final double price;
  final double? originalPrice;
  final int? discountPercent;
  final double rating;
  final String soldCount;
  final String location;
  final String? storeName;
  final bool isMall;
  final bool isBisaCOD;
  final String? bonusText;
  final String? bonusTextWeb;
  final bool isGratisOngkir;
  final bool isPinkPrice;
  final bool isLokal;
  final String imagePath;

  const Product({
    required this.id,
    this.userIdentifier = '',
    required this.name,
    required this.price,
    this.originalPrice,
    this.discountPercent,
    required this.rating,
    required this.soldCount,
    this.location = '',
    this.storeName,
    this.isMall = false,
    this.isBisaCOD = false,
    this.bonusText,
    this.bonusTextWeb,
    this.isGratisOngkir = false,
    this.isPinkPrice = false,
    this.isLokal = false,
    required this.imagePath,
  });

  factory Product.fromJson(Map<String, dynamic> json) {
    final price = double.tryParse(json['price']?.toString() ?? '0') ?? 0;
    final originalPrice = json['original_price'] != null
        ? double.tryParse(json['original_price'].toString())
        : null;
    final discountPercent = json['discount_percent'] != null
        ? int.tryParse(json['discount_percent'].toString())
        : null;
    final rating = double.tryParse(json['rating']?.toString() ?? '0') ?? 0;
    final imagePath = json['image_path'] as String? ?? '';
    return Product(
      id: json['id'].toString(),
      userIdentifier: json['user_identifier'] as String? ?? '',
      name: json['name'] as String? ?? '',
      price: price,
      originalPrice: originalPrice,
      discountPercent: discountPercent,
      rating: rating,
      soldCount: json['sold_count']?.toString() ?? '0',
      location: json['location'] as String? ?? '',
      storeName: json['store_name'] as String?,
      isMall: json['is_mall'] == '1' || json['is_mall'] == 1 || json['is_mall'] == true,
      isBisaCOD: json['is_bisa_cod'] == '1' || json['is_bisa_cod'] == 1 || json['is_bisa_cod'] == true,
      bonusText: json['bonus_text'] as String?,
      bonusTextWeb: json['bonus_text_web'] as String?,
      isGratisOngkir: json['is_gratis_ongkir'] == '1' || json['is_gratis_ongkir'] == 1 || json['is_gratis_ongkir'] == true,
      isPinkPrice: json['is_pink_price'] == '1' || json['is_pink_price'] == 1 || json['is_pink_price'] == true,
      isLokal: json['is_lokal'] == '1' || json['is_lokal'] == 1 || json['is_lokal'] == true,
      imagePath: imagePath,
    );
  }

  Map<String, dynamic> toJson() => {
    'name': name,
    'price': price,
    'original_price': originalPrice,
    'discount_percent': discountPercent,
    'rating': rating,
    'sold_count': soldCount,
    'location': location,
    'store_name': storeName,
    'is_mall': isMall ? '1' : '0',
    'is_bisa_cod': isBisaCOD ? '1' : '0',
    'bonus_text': bonusText,
    'bonus_text_web': bonusTextWeb,
    'is_gratis_ongkir': isGratisOngkir ? '1' : '0',
    'is_pink_price': isPinkPrice ? '1' : '0',
    'is_lokal': isLokal ? '1' : '0',
    'image_path': imagePath,
  };
}
