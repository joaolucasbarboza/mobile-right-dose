class Routes {
  static const apiUrl = "http://192.168.1.243:8080";
  static const authLogin = "$apiUrl/auth/login";
  static const authRegister = "$apiUrl/auth/register";

  static const getMedicine = "$apiUrl/medicine";

  static const getPrescription = "$apiUrl/prescriptions";
  static const getPrescriptionById = "$apiUrl/prescriptions/{id}";
  static const addPrescription = "$apiUrl/prescriptions";

  static const fcmTokenUrl = "$apiUrl/user/update-token";
}