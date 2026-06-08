import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';

import '../services/storage_service.dart';

class AnalyticsScreen extends StatefulWidget {
  const AnalyticsScreen({super.key});

  @override
  State<AnalyticsScreen> createState() =>
      _AnalyticsScreenState();
}

class _AnalyticsScreenState
    extends State<AnalyticsScreen> {

  List transactions = [];

  @override
  void initState() {
    super.initState();

    final box =
        StorageService.getTransactionBox();

    transactions = box.values.toList();
  }

  Map<String, double> getCategoryTotals() {

    Map<String, double> data = {};

    for (var tx in transactions) {

      if (tx["type"] != "expense") continue;

      String category =
          tx["category"] ?? "Other";

      double amount =
          (tx["amount"] ?? 0).toDouble();

      data[category] =
          (data[category] ?? 0) + amount;
    }

    return data;
  }

  double getIncome() {

    double total = 0;

    for (var tx in transactions) {

      if (tx["type"] == "income") {
        total += tx["amount"];
      }
    }

    return total;
  }

  double getExpense() {

    double total = 0;

    for (var tx in transactions) {

      if (tx["type"] == "expense") {
        total += tx["amount"];
      }
    }

    return total;
  }

  @override
  Widget build(BuildContext context) {

    final categoryData =
        getCategoryTotals();

    final entries =
        categoryData.entries.toList();

    return Scaffold(
      appBar: AppBar(
        title:
            const Text("Analytics"),
      ),
      body: SingleChildScrollView(
        padding:
            const EdgeInsets.all(16),
        child: Column(
          children: [

            const Text(
              "Expense Distribution",
              style: TextStyle(
                fontSize: 20,
                fontWeight:
                    FontWeight.bold,
              ),
            ),

            const SizedBox(height: 20),

            SizedBox(
              height: 250,
              child: PieChart(
                PieChartData(
                  sections:
                      entries.map((e) {

                    return PieChartSectionData(
                      value: e.value,
                      title: e.key,
                      radius: 80,
                    );
                  }).toList(),
                ),
              ),
            ),

            const SizedBox(height: 30),

            Card(
              child: Padding(
                padding:
                    const EdgeInsets.all(
                        16),
                child: Column(
                  children: [

                    ListTile(
                      title:
                          const Text(
                        "Income",
                      ),
                      trailing:
                          Text(
                        "₹${getIncome().toStringAsFixed(0)}",
                      ),
                    ),

                    ListTile(
                      title:
                          const Text(
                        "Expense",
                      ),
                      trailing:
                          Text(
                        "₹${getExpense().toStringAsFixed(0)}",
                      ),
                    ),

                    ListTile(
                      title:
                          const Text(
                        "Savings",
                      ),
                      trailing:
                          Text(
                        "₹${(getIncome() - getExpense()).toStringAsFixed(0)}",
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}