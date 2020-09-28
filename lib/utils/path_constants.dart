class PathConstants {
  //User

  static String createUserUrl() =>
      "https://cultiveapp.herokuapp.com/api/usuario";
  static String userLoginUrl() =>
      "https://cultiveapp.herokuapp.com/api/usuario/login";
  static String resetUserPasswordUrl() =>
      "https://cultiveapp.herokuapp.com/api/usuario/resetSenha";
  static String getUserById(String id) =>
      "https://cultiveapp.herokuapp.com/api/usuario/$id";
  static String editUserById(String id) =>
      "https://cultiveapp.herokuapp.com/api/usuario/$id";
  static String deleteUserById(String id) =>
      "https://cultiveapp.herokuapp.com/api/usuario/$id";

  //Publication

  static String getPublicationsByParameters(
          {String tipo, String limit, String offset}) =>
      "https://cultiveapp.herokuapp.com/api/publicacao?tipo=$tipo&limit=$limit&offset=$offset";
  static String createPublication(int userId) =>
      "https://cultiveapp.herokuapp.com/api/usuario/${userId.toString()}/publicacao";
}
