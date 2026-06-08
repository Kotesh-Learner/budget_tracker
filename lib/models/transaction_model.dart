class TransactionModel {
  final String title;
  final double amount;
  final String category;
  final DateTime date;
  final bool isIncome;

  TransactionModel({
    required this.title,
    required this.amount,
    required this.category,
    required this.isIncome,
    required this.date,
  });

  Map<String, dynamic> toMap() {
    return {
      'title': title,
      'amount': amount,
      'category': category,
      'date': date.toIso8601String(),
    };
  }

  factory TransactionModel.fromMap(
      Map<dynamic, dynamic> map) {
    return TransactionModel(
      title: map['title'],
      amount: map['amount'],
      isIncome: map['isIncome'],
      category: map['category'],
      date: DateTime.parse(map['date']),
    );
  }
}