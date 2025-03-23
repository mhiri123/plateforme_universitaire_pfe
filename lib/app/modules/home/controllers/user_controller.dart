class UserController {
  String? _role = 'Étudiant';

  String? getUserRole() {
    return _role;
  }

  void setUserRole(String role) {
    _role = role;
  }
}
