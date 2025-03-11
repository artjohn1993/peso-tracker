import 'package:intl/intl.dart';
class MoneyUtil {
  MoneyUtil._();

  static String format(double money) {
    final formatter = NumberFormat("#,##0.00", "en_US");

    return formatter.format(money);
  }

  static String formatTotal(double balance) {
    return balance < 0
        ? "-₱${MoneyUtil.format(balance * (-1))}"
        : "₱${MoneyUtil.format(balance)}";
  }
}