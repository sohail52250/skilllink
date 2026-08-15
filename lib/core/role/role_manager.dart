class RoleManager {
  static String role = "worker"; // default

  static void setRole(String newRole) {
    role = newRole;
  }

  static String getRole() {
    return role;
  }
}