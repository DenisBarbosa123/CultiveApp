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
  static String requestUpdatePassword() => "https://cultiveapp.herokuapp.com/api/usuario/autorizaUpdateSenha";

  //Publication

  static String getPublicationsByParameters(
          {String tipo, String limit, String offset}) =>
      "https://cultiveapp.herokuapp.com/api/publicacao?tipo=$tipo&limit=$limit&offset=$offset";
  static String createPublication(int userId) =>
      "https://cultiveapp.herokuapp.com/api/usuario/${userId.toString()}/publicacao";
  static String editPublication(int postId) =>
      "https://cultiveapp.herokuapp.com/api/publicacao/${postId.toString()}";
  static String deletePublication(int postId) =>
      "https://cultiveapp.herokuapp.com/api/publicacao/${postId.toString()}";

  //Comments
  static String createComment(int userId, int postId) =>
      "https://cultiveapp.herokuapp.com/api/usuario/${userId.toString()}/publicacao/${postId.toString()}/comentario";
  static String editComment(int userId, int postId, int commentId) =>
      "https://cultiveapp.herokuapp.com/api/usuario/${userId.toString()}/publicacao/${postId.toString()}/comentario/${commentId.toString()}";
  static String deleteComment(int userId, int postId, int commentId) =>
      "https://cultiveapp.herokuapp.com/api/usuario/${userId.toString()}/publicacao/${postId.toString()}/comentario/${commentId.toString()}";

  //Get all Products
  static String getAllProducts() => "https://cultiveapp.herokuapp.com/api/produtos";

  //Events

  static String getAllEvents() => "https://cultiveapp.herokuapp.com/api/eventos";
  static String createEvent(String userId) => "https://cultiveapp.herokuapp.com/api/usuario/$userId/evento";
  static String deleteEvent(String eventId) => "https://cultiveapp.herokuapp.com/api/evento/$eventId";

}
