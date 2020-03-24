class MyPatterns {
  //  => email pattern
  static String _emailPattern =
      r"^^[a-zA-Z0-9.!#$%&*+\/=?^_`{|}~-]+@[a-zA-Z0-9](?:[a-zA-Z0-9-]{0,61}[a-zA-Z0-9])?(?:\.[a-zA-Z0-9](?:[a-zA-Z0-9-]{0,61}[a-zA-Z0-9])?)*$";
  static RegExp _emailRegularExpression = RegExp(_emailPattern);

  // => Egyptian Mobile Number Pattern
  static String _phonePattern = r'^(01)[0-9]{8}';
  static RegExp _phoneRegularExpression = RegExp(_phonePattern);

  // => Egyptian National ID
  static String _egyptionIdPatern =
      r'(2|3)[0-9][1-9][0-1][1-9][0-3][1-9](01|02|03|04|11|12|13|14|15|16|17|18|19|21|22|23|24|25|26|27|28|29|31|32|33|34|35|88)\d\d\d\d\d';
  static RegExp _egyptionIdRegularExpression = RegExp(_egyptionIdPatern);

  static bool checkEmailPattern(userInput) {
    return _emailRegularExpression.hasMatch(userInput);
  }

  static bool checkPhonePattern(userInput) {
    return _phoneRegularExpression.hasMatch(userInput);
  }

  static bool checkEgyptionIdPattern(userInput) {
    return _egyptionIdRegularExpression.hasMatch(userInput);
  }
}