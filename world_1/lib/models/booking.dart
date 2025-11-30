import 'service.dart';
import 'user.dart';
import 'staff.dart';

class Booking {
  final String id;
  final String userId;
  final String serviceId;
  final DateTime bookingDate;
  final String status;
  final double totalAmount;
  final String paymentStatus;
  final String notes;
  final Service? service;
  final User? user;
  final Map<String, dynamic>? customLocation;
  final String deceasedName;
  final String relationship;
  final Staff? assignedStaff;

  Booking({
    required this.id,
    required this.userId,
    required this.serviceId,
    required this.bookingDate,
    required this.status,
    required this.totalAmount,
    required this.paymentStatus,
    required this.notes,
    this.service,
    this.user,
    this.customLocation,
    this.deceasedName = '',
    this.relationship = '',
    this.assignedStaff,
  });

  factory Booking.fromJson(Map<String, dynamic> json) {
    return Booking(
      id: json['_id'] ?? json['id'] ?? '',
      userId: json['user'] is String
          ? json['user']
          : (json['user']?['_id'] ?? json['user']?['id'] ?? ''),
      serviceId: json['service'] is String
          ? json['service']
          : (json['service']?['_id'] ?? json['service']?['id'] ?? ''),
      bookingDate: json['bookingDate'] != null
          ? DateTime.parse(json['bookingDate'])
          : DateTime.now(),
      status: json['status'] ?? 'pending',
      totalAmount: (json['totalAmount'] ?? 0).toDouble(),
      paymentStatus: json['paymentStatus'] ?? 'pending',
      notes: json['notes'] ?? '',
      service: json['service'] is Map
          ? Service.fromJson(json['service'])
          : null,
      user: json['user'] is Map ? User.fromJson(json['user']) : null,
      customLocation: json['customLocation'] != null
          ? Map<String, dynamic>.from(json['customLocation'])
          : null,
      deceasedName: json['deceasedName'] ?? '',
      relationship: json['relationship'] ?? '',
      assignedStaff: json['assignedStaff'] != null && json['assignedStaff'] is Map
          ? Staff.fromJson(json['assignedStaff'])
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'user': userId,
      'service': serviceId,
      'bookingDate': bookingDate.toIso8601String(),
      'status': status,
      'totalAmount': totalAmount,
      'paymentStatus': paymentStatus,
      'notes': notes,
    };
  }
}

