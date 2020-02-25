class APIPath {
  static String user(String uid) => 'users/$uid';
  static String pet(String mifaId, String petId) => 'mifa/$mifaId/pets/$petId';
  static String pets(String mifaId) => 'mifa/$mifaId/pets';

  static String meal(String mifaId, String mealId) =>
      'mifa/$mifaId/meals/$mealId';
  static String meals(String mifaId) => 'mifa/$mifaId/meals';
}
