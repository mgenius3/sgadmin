class User {
  String username;
  String name;
  String email;
  String id;
  String naira_Wallet_Balance;
  String? date_created;

  User(
      {required this.username,
      required this.email,
      required this.name,
      required this.naira_Wallet_Balance,
      required this.id,
      this.date_created});
}
