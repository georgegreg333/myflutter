int factorial(int n) {
  if (n<0) throw ArgumentError('Negative numbers not allowed!');
  int res = 1;
  for (int i=2; i<=n; i++)
  {
    res = res * i;
  }
  return res;
}

String calcFactorialfromInput(String input) {
  if (input.isEmpty) {
    return 'Please enter a number!';
  }

  final number = int.tryParse(input);
  if (number == null) {
    return 'Invalid number';
  }

  try {
    final value = factorial(number);
    return 'Factorial value of $number is $value';
  } catch (e) {
    return 'Error $e';
  }
}