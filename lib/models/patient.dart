//Represents a patient record from the database
class Patient {
  final String id;
  final String userId;
  final String name;
  final String? email;
  final String? phone;
  final DateTime? birthDate;
  final String? notes;
  final DateTime createdAt;

  Patient({
    required this.id,
    required this.userId,
    required this.name,
    this.email,
    this.phone,
    this.birthDate,
    this.notes,
    required this.createdAt,
});

  ///Creates a Patient from a Supabase row (JSON map)
  factory Patient.fromJson(Map<String, dynamic> json){
    return Patient(
      id: json['id'],
      userId: json['user_id'],
      name: json['name'],
      email: json['email'],
      phone: json['phone'],
      birthDate: json['birth_date'] != null ? DateTime.parse(json['birth_date']) : null,
      notes: json['notes'],
      createdAt: DateTime.parse(json['created_at']),
    );
  }

  ///Convert to a JSON map for Supabase insert/update
  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'email': email,
      'phone': phone,
      'birth_date': birthDate?.toIso8601String(),
      'notes': notes,
    };
  }


}