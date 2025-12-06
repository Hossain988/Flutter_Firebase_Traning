// TODO: Students will uncomment this when they add Firebase
// import 'package:cloud_firestore/cloud_firestore.dart';

/// User model representing a user in Firestore
/// 
/// Students will learn:
/// - User data modeling
/// - Storing additional user information
/// - User profile management
class UserModel {
  final String uid;
  final String email;
  final String displayName;
  
  // Additional user information (stored in users collection)
  final String firstName;
  final String lastName;
  final String phoneNumber;
  final String? bio;
  final String? address;
  final DateTime createdAt;
  final DateTime? lastLoginAt;

  UserModel({
    required this.uid,
    required this.email,
    required this.displayName,
    required this.firstName,
    required this.lastName,
    required this.phoneNumber,
    this.bio,
    this.address,
    required this.createdAt,
    this.lastLoginAt,
  });

  /// Convert UserModel to Firestore Map
  /// 
  /// Converts UserModel to Map for Firestore storage
  /// Handles DateTime to Timestamp conversion and optional fields
  Map<String, dynamic> toMap() {
    // TODO: Uncomment the import at the top of the file when adding Firebase
    // Then replace the ISO string conversions below with Timestamp conversions
    
    return {
      'uid': uid,
      'email': email,
      'displayName': displayName,
      'firstName': firstName,
      'lastName': lastName,
      'phoneNumber': phoneNumber,
      'bio': bio,
      'address': address,
      // Convert DateTime to Timestamp for Firestore
      // TODO: When Firebase is added, uncomment these lines and remove the ISO string versions:
      // 'createdAt': Timestamp.fromDate(createdAt),
      // 'lastLoginAt': lastLoginAt != null ? Timestamp.fromDate(lastLoginAt!) : null,
      'createdAt': createdAt.toIso8601String(), // TODO: Replace with Timestamp when Firebase is added
      'lastLoginAt': lastLoginAt?.toIso8601String(), // TODO: Replace with Timestamp when Firebase is added
    };
  }

  /// Create UserModel from Firestore DocumentSnapshot
  /// 
  /// Parses Map from Firestore to UserModel object
  /// Handles Timestamp to DateTime conversion and optional fields
  factory UserModel.fromMap(Map<String, dynamic> map) {
    // TODO: Uncomment the import at the top of the file when adding Firebase
    
    // Helper function to convert Timestamp or ISO string to DateTime
    DateTime parseDateTime(dynamic value) {
      if (value == null) {
        throw ArgumentError('DateTime value cannot be null');
      }
      
      // TODO: When Firebase is added, handle Timestamp objects:
      // if (value is Timestamp) {
      //   return value.toDate();
      // }
      
      // Handle ISO string format (temporary until Firebase is added)
      if (value is String) {
        return DateTime.parse(value);
      }
      
      // Fallback for other formats
      return value as DateTime;
    }
    
    // Helper function to parse optional DateTime
    DateTime? parseOptionalDateTime(dynamic value) {
      if (value == null) return null;
      
      // TODO: When Firebase is added, handle Timestamp objects:
      // if (value is Timestamp) {
      //   return value.toDate();
      // }
      
      // Handle ISO string format (temporary until Firebase is added)
      if (value is String) {
        return DateTime.parse(value);
      }
      
      return value as DateTime?;
    }
    
    return UserModel(
      uid: map['uid'] as String,
      email: map['email'] as String,
      displayName: map['displayName'] as String,
      firstName: map['firstName'] as String,
      lastName: map['lastName'] as String,
      phoneNumber: map['phoneNumber'] as String,
      bio: map['bio'] as String?,
      address: map['address'] as String?,
      createdAt: parseDateTime(map['createdAt']),
      lastLoginAt: parseOptionalDateTime(map['lastLoginAt']),
    );
  }

  /// Create a copy of UserModel with updated fields
  UserModel copyWith({
    String? uid,
    String? email,
    String? displayName,
    String? firstName,
    String? lastName,
    String? phoneNumber,
    String? bio,
    String? address,
    DateTime? createdAt,
    DateTime? lastLoginAt,
  }) {
    return UserModel(
      uid: uid ?? this.uid,
      email: email ?? this.email,
      displayName: displayName ?? this.displayName,
      firstName: firstName ?? this.firstName,
      lastName: lastName ?? this.lastName,
      phoneNumber: phoneNumber ?? this.phoneNumber,
      bio: bio ?? this.bio,
      address: address ?? this.address,
      createdAt: createdAt ?? this.createdAt,
      lastLoginAt: lastLoginAt ?? this.lastLoginAt,
    );
  }

  /// Get full name
  String get fullName => '$firstName $lastName';
}

