class User {
  final int id;
  final String account;
  final String passowrd;

  User(this.id, this.account, this.passowrd);

  Map<String, dynamic> toMap() {
    return {'id': id, 'account': account, 'passowrd': passowrd};
  }

  @override
  String toString() {
    return 'User{id: $id, account: $account, passowrd: $passowrd}';
  }
}
