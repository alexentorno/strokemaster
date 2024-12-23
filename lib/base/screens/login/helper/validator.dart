class Validator {

  static String? validateName(String? value) {
    if (value == null || value.isEmpty) {
      return 'Name is required';
    }
    if (value.length < 2) {
      return 'Name must be at least 2 characters';
    }
    if (!RegExp(r'^[a-zA-Z\s]+$').hasMatch(value)) {
      return 'Name must contain only letters and spaces';
    }
    return null;
  }

  static String? validateEmail(String? value) {
    if (value == null || value.isEmpty) {
      return "Email is required.";
    }
    // Regular expression for email validation
    final emailRegExp = RegExp(r"^[^\s@]+@[^\s@]+\.[^\s@]+$");

    if (!emailRegExp.hasMatch(value)) {
      return "Please enter a valid email address.";
    }

    return null;
  }

  static String? validatePassword(String? value) {
    if (value == null || value.isEmpty) {
      return "Password is required.";
    }

    final passwordRegExp = RegExp(r"^[A-Z][a-zA-Z0-9]");
    final containsNumber = RegExp(r'[0-9]');

    if (!passwordRegExp.hasMatch(value)) {
      return "Password must start with a capital letter.";
    } else if (value.length < 8){
      return "Password must be at least 8 characters long.";
    } else if (!containsNumber.hasMatch(value)) {
      return "Password must contain numbers.";
    }
    return null;
  }
}
