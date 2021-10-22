class UserClient{
  String userID;
  String username;
  String email;
  String password;


 String get getUserID => this.userID;

 set setUserID(String userID) => this.userID = userID;

  get getUsername => this.username;

 set setUsername( username) => this.username = username;

  get getEmail => this.email;

 set setEmail( email) => this.email = email;

  get getPassword => this.password;

 set setPassword( password) => this.password = password;

 UserClient({
   this.userID,
   this.username,
   this.email,
   this.password,
 });
}