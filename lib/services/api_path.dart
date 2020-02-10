class APIPath {
  static String pet(String uid, String petId) => 'users/$uid/pets/$petId';
  static String pets(String uid) => 'users/$uid/pets';

  static String meal(String uid, String mealId) => 'users/$uid/meals/$mealId';
  static String meals(String uid) => 'users/$uid/meals';
}
