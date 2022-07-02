// To parse this JSON data, do
//
//     final recruiterProfileModel = recruiterProfileModelFromJson(jsonString);

import 'dart:convert';

RecruiterProfileModel recruiterProfileModelFromJson(String str) => RecruiterProfileModel.fromJson(json.decode(str));

String recruiterProfileModelToJson(RecruiterProfileModel data) => json.encode(data.toJson());

class RecruiterProfileModel {
  RecruiterProfileModel({
    this.success,
    this.message,
    this.data,
  });

  bool success;
  String message;
  Data data;

  factory RecruiterProfileModel.fromJson(Map<String, dynamic> json) => RecruiterProfileModel(
    success: json["success"],
    message: json["message"],
    data: Data.fromJson(json["data"]),
  );

  Map<String, dynamic> toJson() => {
    "success": success,
    "message": message,
    "data": data.toJson(),
  };
}

class Data {
  Data({
    this.id,
    this.firstName,
    this.lastName,
    this.email,
    this.phone,
    this.gender,
    this.image,
    this.dob,
    this.role,
    this.membershipId,
    this.emailVerifiedAt,
    this.verified,
    this.isPhoneVerified,
    this.typeOfDisability,
    this.profession,
    this.organizationId,
    this.otp,
    this.otpExpireAt,
    this.status,
    this.isReferral,
    this.membershipExpireAt,
    this.membershipAutoRenewal,
    this.stripeCustomerId,
    this.isComplete,
    this.isVolunteerProfileComplete,
    this.isRecruiterProfileComplete,
    this.termsAndConditions,
    this.state,
    this.city,
    this.zipCode,
    this.serviceState,
    this.serviceCity,
    this.serviceZipCode,
    this.deletedAt,
    this.createdAt,
    this.updatedAt,
  });

  int id;
  String firstName;
  String lastName;
  String email;
  String phone;
  String gender;
  String image;
  dynamic dob;
  String role;
  int membershipId;
  DateTime emailVerifiedAt;
  int verified;
  int isPhoneVerified;
  dynamic typeOfDisability;
  dynamic profession;
  dynamic organizationId;
  dynamic otp;
  dynamic otpExpireAt;
  String status;
  dynamic isReferral;
  dynamic membershipExpireAt;
  int membershipAutoRenewal;
  dynamic stripeCustomerId;
  int isComplete;
  int isVolunteerProfileComplete;
  int isRecruiterProfileComplete;
  bool termsAndConditions;
  String state;
  String city;
  String zipCode;
  dynamic serviceState;
  dynamic serviceCity;
  dynamic serviceZipCode;
  dynamic deletedAt;
  DateTime createdAt;
  DateTime updatedAt;

  factory Data.fromJson(Map<String, dynamic> json) => Data(
    id: json["id"],
    firstName: json["first_name"],
    lastName: json["last_name"],
    email: json["email"],
    phone: json["phone"],
    gender: json["gender"],
    image: json["image"],
    dob: json["dob"],
    role: json["role"],
    membershipId: json["membership_id"],
    emailVerifiedAt: DateTime.parse(json["email_verified_at"]),
    verified: json["verified"],
    isPhoneVerified: json["is_phone_verified"],
    typeOfDisability: json["type_of_disability"],
    profession: json["profession"],
    organizationId: json["organization_id"],
    otp: json["otp"],
    otpExpireAt: json["otp_expire_at"],
    status: json["status"],
    isReferral: json["is_referral"],
    membershipExpireAt: json["membership_expire_at"],
    membershipAutoRenewal: json["membership_auto_renewal"],
    stripeCustomerId: json["stripe_customer_id"],
    isComplete: json["is_complete"],
    isVolunteerProfileComplete: json["is_volunteer_profile_complete"],
    isRecruiterProfileComplete: json["is_recruiter_profile_complete"],
    termsAndConditions: json["terms_and_conditions"],
    state: json["state"],
    city: json["city"],
    zipCode: json["zip_code"],
    serviceState: json["service_state"],
    serviceCity: json["service_city"],
    serviceZipCode: json["service_zip_code"],
    deletedAt: json["deleted_at"],
    createdAt: DateTime.parse(json["created_at"]),
    updatedAt: DateTime.parse(json["updated_at"]),
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "first_name": firstName,
    "last_name": lastName,
    "email": email,
    "phone": phone,
    "gender": gender,
    "image": image,
    "dob": dob,
    "role": role,
    "membership_id": membershipId,
    "email_verified_at": emailVerifiedAt.toIso8601String(),
    "verified": verified,
    "is_phone_verified": isPhoneVerified,
    "type_of_disability": typeOfDisability,
    "profession": profession,
    "organization_id": organizationId,
    "otp": otp,
    "otp_expire_at": otpExpireAt,
    "status": status,
    "is_referral": isReferral,
    "membership_expire_at": membershipExpireAt,
    "membership_auto_renewal": membershipAutoRenewal,
    "stripe_customer_id": stripeCustomerId,
    "is_complete": isComplete,
    "is_volunteer_profile_complete": isVolunteerProfileComplete,
    "is_recruiter_profile_complete": isRecruiterProfileComplete,
    "terms_and_conditions": termsAndConditions,
    "state": state,
    "city": city,
    "zip_code": zipCode,
    "service_state": serviceState,
    "service_city": serviceCity,
    "service_zip_code": serviceZipCode,
    "deleted_at": deletedAt,
    "created_at": createdAt.toIso8601String(),
    "updated_at": updatedAt.toIso8601String(),
  };
}
