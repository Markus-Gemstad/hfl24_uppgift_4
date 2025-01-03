import 'dart:io';

void clearScreen() {
  print(Process.runSync("clear", [], runInShell: true).stdout);
}

String readValidInputString(
    String label, bool Function(String?) valueValidator) {
  stdout.write(label);
  String? value = stdin.readLineSync();
  bool isValid = valueValidator(value);

  while (!isValid) {
    stdout.write('Värdet du anget är felaktigt! Försök igen:');
    value = stdin.readLineSync();
    isValid = valueValidator(value);
  }
  return value!;
}

int readValidInputInt(String label, bool Function(String?) valueValidator) {
  stdout.write(label);
  String? value = stdin.readLineSync();
  bool isValid = valueValidator(value);

  while (!isValid) {
    stdout.write('Värdet du anget är felaktigt! Försök igen:');
    value = stdin.readLineSync();
    isValid = valueValidator(value);
  }
  return int.parse(value!);
}
