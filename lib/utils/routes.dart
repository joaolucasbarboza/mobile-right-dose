class Routes {
  static const apiUrl = "http://192.168.0.15:8080";
  static const authLogin = "$apiUrl/auth/login";
  static const authRegister = "$apiUrl/auth/register";

  static const getMedicine = "$apiUrl/medicine";

  static const getPrescription = "$apiUrl/prescriptions";
  static const getPrescriptionById = "$apiUrl/prescriptions/{id}";
  static const addPrescription = "$apiUrl/prescriptions";

  static const getAllUpcomingNotifications = "$apiUrl/prescriptions-notifications/upcoming-notifications";

  static const updatePrescriptionStatus = "$apiUrl/prescriptions-notifications/update-status";

  static const generateRecommendation = "$apiUrl/generate-ai";

  static const fcmTokenUrl = "$apiUrl/user/update-token";
}