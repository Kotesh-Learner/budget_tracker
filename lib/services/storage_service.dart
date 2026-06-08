import 'package:hive_flutter/hive_flutter.dart';

class StorageService {
  static const String transactionBox = "transactions";
  static const String categoryBox = "categories";
  static const budgetBox = "budgets";

  static Future<void> init() async {
    await Hive.initFlutter();

    await Hive.openBox(transactionBox);
    await Hive.openBox(categoryBox);
    await Hive.openBox(budgetBox);
    await seedDefaultCategories();
  }

  static Future<void> seedDefaultCategories() async {
    final box = Hive.box(categoryBox);

    if (box.isEmpty) {
      box.add("Food");
      box.add("Fuel");
      box.add("Shopping");
      box.add("Rent");
      box.add("Gym");
      box.add("Salary");
    }
  }

  static Box getTransactionBox() {
    return Hive.box(transactionBox);
  }

  static Box getCategoryBox() {
    return Hive.box(categoryBox);
  }

  static Box getBudgetBox() {
    return Hive.box(budgetBox);
  }
}