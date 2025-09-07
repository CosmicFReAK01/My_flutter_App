enum UserType { customer, consumer }

class Profile {
  final String userId;
  final String name;
  final String email;
  final String? phone;
  final String? profileImageUrl;
  final UserType userType;
  final String? businessName; // For consumers
  final String? businessDescription; // For consumers
  final List<String>? serviceCategories; // For consumers

  Profile({
    required this.userId,
    required this.name,
    required this.email,
    required this.userType,
    this.phone,
    this.profileImageUrl,
    this.businessName,
    this.businessDescription,
    this.serviceCategories,
  });
}
