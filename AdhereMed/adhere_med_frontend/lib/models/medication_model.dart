class Medication {
  final int id;
  final String? name;
  final String? genericName;
  final String? brandName;
  final String description;
  final String dosageForm;
  final String strength;
  final String routeOfAdministration;
  final String sideEffects;
  final String interactions;
  final String contraindications;
  final String? manufacturer; // Could be null
  final String approvalDate;
  final String expiryDate;
  final bool requiresPrescription;
  final int stockQuantity;
  final String price;
  final String createdAt;
  final String updatedAt;

  Medication({
    required this.id,
    this.name,
    this.genericName,
    this.brandName,
    required this.description,
    required this.dosageForm,
    required this.strength,
    required this.routeOfAdministration,
    required this.sideEffects,
    required this.interactions,
    required this.contraindications,
    this.manufacturer,
    required this.approvalDate,
    required this.expiryDate,
    required this.requiresPrescription,
    required this.stockQuantity,
    required this.price,
    required this.createdAt,
    required this.updatedAt,
  });

  // Factory method to create Medication object from JSON
  factory Medication.fromJson(Map<String, dynamic> json) {
    return Medication(
      id: json['id'],
      name: json['name'] ?? 'Empty',
      genericName: json['generic_name'] ?? 'Empty',
      brandName: json['brand_name'] ?? 'Empty',
      description: json['description'],
      dosageForm: json['dosage_form'],
      strength: json['strength'],
      routeOfAdministration: json['route_of_administration'],
      sideEffects: json['side_effects'],
      interactions: json['interactions'],
      contraindications: json['contraindications'],
      manufacturer: json['manufacturer'],
      approvalDate: json['approval_date'],
      expiryDate: json['expiry_date'],
      requiresPrescription: json['requires_prescription'],
      stockQuantity: json['stock_quantity'],
      price: json['price'],
      createdAt: json['created_at'],
      updatedAt: json['updated_at'],
    );
  }

  // Convert Medication object to JSON
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'generic_name': genericName,
      'brand_name': brandName,
      'description': description,
      'dosage_form': dosageForm,
      'strength': strength,
      'route_of_administration': routeOfAdministration,
      'side_effects': sideEffects,
      'interactions': interactions,
      'contraindications': contraindications,
      'manufacturer': manufacturer,
      'approval_date': approvalDate,
      'expiry_date': expiryDate,
      'requires_prescription': requiresPrescription,
      'stock_quantity': stockQuantity,
      'price': price,
      'created_at': createdAt,
      'updated_at': updatedAt,
    };
  }
}
