import 'package:flutter/material.dart';
import 'add_budget_screen.dart';
import '../services/storage_service.dart';
import 'add_transaction_screen.dart';

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({super.key});

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  List transactions = [];
  List budgets = [];

  @override
  void initState() {
    super.initState();
    loadTransactions();
  }

  void loadTransactions() {
    final transactionBox = StorageService.getTransactionBox();

    final budgetBox = StorageService.getBudgetBox();

    setState(() {
      transactions = transactionBox.values.toList();

      budgets = budgetBox.keys.toList();
    });
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

  double getSavings() {
    return getIncome() - getExpense();
  }

  double getCategoryExpense(String category) {
    double total = 0;

    for (var tx in transactions) {
      if (tx["category"] == category && tx["type"] == "expense") {
        total += tx["amount"];
      }
    }

    return total;
  }

  Widget buildSummaryCard(String title, String value, IconData icon) {
    return Expanded(
      child: Card(
        elevation: 4,
        child: Padding(
          padding: const EdgeInsets.all(12),
          child: Column(
            children: [
              Icon(icon),

              const SizedBox(height: 8),

              Text(title, style: const TextStyle(fontWeight: FontWeight.bold)),

              const SizedBox(height: 5),

              Text(value, style: const TextStyle(fontSize: 16)),
            ],
          ),
        ),
      ),
    );
  }

  Widget buildBudgetCard({
    required String category,
    required double spent,
    required double budget,
  }) {
    double progress = budget == 0 ? 0 : spent / budget;

    if (progress > 1) {
      progress = 1;
    }

    return Card(
      elevation: 3,
      margin: const EdgeInsets.only(bottom: 10),
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              category,
              style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
            ),

            const SizedBox(height: 10),

            LinearProgressIndicator(value: progress),

            const SizedBox(height: 10),

            Text(
              "₹${spent.toStringAsFixed(0)} / ₹${budget.toStringAsFixed(0)}",
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Budget Tracker")),

      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            Row(
              children: [
                buildSummaryCard(
                  "Income",
                  "₹${getIncome().toStringAsFixed(0)}",
                  Icons.trending_up,
                ),

                buildSummaryCard(
                  "Expense",
                  "₹${getExpense().toStringAsFixed(0)}",
                  Icons.trending_down,
                ),

                buildSummaryCard(
                  "Savings",
                  "₹${getSavings().toStringAsFixed(0)}",
                  Icons.savings,
                ),
              ],
            ),

            const SizedBox(height: 20),

            Expanded(
              child: ListView(
                children: [
                  const Text(
                    "Budget Progress",
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),

                  const SizedBox(height: 10),

                  // Sample Budget Cards
                  ...budgets.map((category) {
                    final budget = StorageService.getBudgetBox().get(category);

                    final spent = getCategoryExpense(category);

                    return buildBudgetCard(
                      category: category,
                      spent: spent,
                      budget: budget,
                    );
                  }),

                  const SizedBox(height: 20),

                  const Text(
                    "Transactions",
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),

                  const SizedBox(height: 10),

                  if (transactions.isEmpty)
                    const Center(
                      child: Padding(
                        padding: EdgeInsets.all(20),
                        child: Text("No Transactions Yet"),
                      ),
                    ),

                  ...transactions.map((tx) {
                    return Card(
                      child: ListTile(
                        leading: Icon(
                          tx["type"] == "income"
                              ? Icons.arrow_downward
                              : Icons.arrow_upward,
                        ),
                        title: Text(tx["title"]),
                        subtitle: Text(tx["category"]),
                        trailing: Text(
                          "₹${tx["amount"]}",
                          style: const TextStyle(fontWeight: FontWeight.bold),
                        ),
                      ),
                    );
                  }),
                ],
              ),
            ),
          ],
        ),
      ),

      floatingActionButton: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          FloatingActionButton(
            heroTag: "budget",
            child: const Icon(Icons.account_balance),
            onPressed: () async {
              final result = await Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => const AddBudgetScreen()),
              );

              if (result == true) {
                loadTransactions();
              }
            },
          ),

          const SizedBox(height: 10),

          FloatingActionButton(
            heroTag: "transaction",
            child: const Icon(Icons.add),
            onPressed: () async {
              final result = await Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => const AddTransactionScreen()),
              );
              if (result == true) {
                loadTransactions();
              }
            },
          ),
        ],
      ),
    );
  }
}
