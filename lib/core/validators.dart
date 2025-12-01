class Validators {
  static String? email(String? value) {
    if (value == null || value.isEmpty) {
      return 'Email не може бути порожнім';
    }
    if (!value.contains('@') || !value.contains('.')) {
      return 'Введіть коректний email';
    }
    return null; // null означає, що валідація пройшла успішно
  }

  static String? password(String? value) {
    if (value == null || value.isEmpty) {
      return 'Пароль не може бути порожнім';
    }
    if (value.length < 6) {
      return 'Пароль має бути не менше 6 символів';
    }
    return null;
  }
  
  static String? username(String? value) {
    if (value == null || value.isEmpty) {
      return 'Ім\'я не може бути порожнім';
    }
    // Регулярний вираз, що забороняє цифри
    if (RegExp(r'[0-9]').hasMatch(value)) {
       return 'Ім\'я не повинно містити цифр';
    }
    return null;
  }
}
