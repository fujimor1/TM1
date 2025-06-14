class UserModel {
  int? id;
  String? username;
  String? correo;
  String? password;
  String? passwordConfirm;
  String? firstName;
  String? lastName;
  String? dni;
  String? telefono;
  String? tipo;

  UserModel(
      {this.id,
      this.username,
      this.correo,
      this.password,
      this.passwordConfirm,
      this.firstName,
      this.lastName,
      this.dni,
      this.telefono,
      this.tipo});

  UserModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    username = json['username'];
    correo = json['correo'];
    password = json['password'];
    passwordConfirm = json['password_confirm'];
    firstName = json['first_name'];
    lastName = json['last_name'];
    dni = json['dni'];
    telefono = json['telefono'];
    tipo = json['tipo'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = this.id;
    data['username'] = this.username;
    data['correo'] = this.correo;
    data['password'] = this.password;
    data['password_confirm'] = this.passwordConfirm;
    data['first_name'] = this.firstName;
    data['last_name'] = this.lastName;
    data['dni'] = this.dni;
    data['telefono'] = this.telefono;
    data['tipo'] = this.tipo;
    return data;
  }
}
  