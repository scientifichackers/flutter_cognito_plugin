final otpRegex = RegExp(
  r"(Your One Time Password \(OTP\) is )([0-9]+)(\. DO NOT SHARE THIS WITH ANYBODY\.)",
);

main() {
  final match = otpRegex.firstMatch(
    "Your One Time Password (OTP) is 484669. DO NOT SHARE THIS WITH ANYBODY.",
  );
  if (match == null) return;
  print(int.parse(match.group(2)));
}
