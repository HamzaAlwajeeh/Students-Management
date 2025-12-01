/// نموذج بيانات الدفع - متوافق مع API
class Payment {
  final int id;
  final int studentId;
  final int foodPayment;
  final int housingPayment;
  final int totalPayment;
  final String paymentMonth;
  final String? studentName;
  final DateTime? createdAt;
  final DateTime? updatedAt;

  const Payment({
    required this.id,
    required this.studentId,
    required this.foodPayment,
    required this.housingPayment,
    required this.totalPayment,
    required this.paymentMonth,
    this.studentName,
    this.createdAt,
    this.updatedAt,
  });

  factory Payment.fromJson(Map<String, dynamic> json) => Payment(
    id: json['id'] as int,
    studentId: json['student_id'] is int 
        ? json['student_id'] as int 
        : int.tryParse(json['student_id'].toString()) ?? 0,
    foodPayment: json['food_payment'] is int 
        ? json['food_payment'] as int 
        : int.tryParse(json['food_payment'].toString()) ?? 0,
    housingPayment: json['housing_payment'] is int 
        ? json['housing_payment'] as int 
        : int.tryParse(json['housing_payment'].toString()) ?? 0,
    // API uses 'totle_payment' (typo) - handle both
    totalPayment: json['totle_payment'] is int 
        ? json['totle_payment'] as int 
        : json['total_payment'] is int 
            ? json['total_payment'] as int
            : int.tryParse((json['totle_payment'] ?? json['total_payment'] ?? '0').toString()) ?? 0,
    paymentMonth: json['payment_month'] as String? ?? '',
    studentName: json['student'] != null 
        ? json['student']['student_name'] as String? 
        : null,
    createdAt: json['created_at'] != null 
        ? DateTime.tryParse(json['created_at'].toString()) : null,
    updatedAt: json['updated_at'] != null 
        ? DateTime.tryParse(json['updated_at'].toString()) : null,
  );

  Map<String, dynamic> toJson() => {
    'student_id': studentId,
    'food_payment': foodPayment,
    'housing_payment': housingPayment,
    'payment_month': paymentMonth,
  };

  Payment copyWith({
    int? id,
    int? studentId,
    int? foodPayment,
    int? housingPayment,
    int? totalPayment,
    String? paymentMonth,
    String? studentName,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return Payment(
      id: id ?? this.id,
      studentId: studentId ?? this.studentId,
      foodPayment: foodPayment ?? this.foodPayment,
      housingPayment: housingPayment ?? this.housingPayment,
      totalPayment: totalPayment ?? this.totalPayment,
      paymentMonth: paymentMonth ?? this.paymentMonth,
      studentName: studentName ?? this.studentName,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }
}
