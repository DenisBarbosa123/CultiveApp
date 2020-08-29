class PathConstants {
  static String createUserUrl() =>
      "https://cultiveapp.herokuapp.com/api/usuario";
  static String userLoginUrl() =>
      "https://cultiveapp.herokuapp.com/api/usuario/login";
  static String resetUserPasswordUrl() =>
      "https://cultiveapp.herokuapp.com/api/usuario/resetSenha";
  static String getUserById(String id) =>
      "https://cultiveapp.herokuapp.com//api/usuario/$id";
}
