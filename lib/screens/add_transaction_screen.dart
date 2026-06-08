import 'package:flutter/material.dart';

import '../services/storage_service.dart';

class AddTransactionScreen extends StatefulWidget {
  const AddTransactionScreen({super.key});

  @override
  State<AddTransactionScreen> createState() =>
      _AddTransactionScreenState();
}

class _AddTransactionScreenState
    extends State<AddTransactionScreen> {

  final titleController = TextEditingController();
  final amountController = TextEditingController();

  String selectedType = "expense";

  String selectedCategory = "Food";

  List categories = [];

  @override
  void initState() {
    super.initState();

    categories = StorageService
        .getCategoryBox()
        .values
        .toList();

    if (categories.isNotEmpty) {
      selectedCategory = categories.first;
    }
  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      appBar: AppBar(
        title: const Text("Add Transaction"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: SingleChildScrollView(
          child: Column(
            children: [

              TextField(
                controller: titleController,
                decoration: const InputDecoration(
                  labelText: "Title",
                  border: OutlineInputBorder(),
                ),
              ),

              const SizedBox(height: 15),

              TextField(
                controller: amountController,
                keyboardType:
                    const TextInputType.numberWithOptions(
                  decimal: true,
                ),
                decoration: const InputDecoration(
                  labelText: "Amount",
                  border: OutlineInputBorder(),
                ),
              ),

              const SizedBox(height: 15),

              DropdownButtonFormField(
                value: selectedType,
                decoration: const InputDecoration(
                  border: OutlineInputBorder(),
                  labelText: "Transaction Type",
                ),
                items: const [

                  DropdownMenuItem(
                    value: "income",
                    child: Text("Income"),
                  ),

                  DropdownMenuItem(
                    value: "expense",
                    child: Text("Expense"),
                  ),
                ],
                onChanged: (value) {
                  setState(() {
                    selectedType = value!;
                  });
                },
              ),

              const SizedBox(height: 15),

              DropdownButtonFormField(
                value: selectedCategory,
                decoration: const InputDecoration(
                  border: OutlineInputBorder(),
                  labelText: "Category",
                ),
                items: categories
                    .map(
                      (e) => DropdownMenuItem(
                        value: e,
                        child: Text(e.toString()),
                      ),
                    )
                    .toList(),
                onChanged: (value) {
                  setState(() {
                    selectedCategory =
                        value.toString();
                  });
                },
              ),

              const SizedBox(height: 25),

              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () {

                    if (titleController.text.isEmpty ||
                        amountController.text.isEmpty) {
                      return;
                    }

                    final box =
                        StorageService.getTransactionBox();

                    box.add({
                      "title": titleController.text,
                      "amount": double.parse(
                        amountController.text,
                      ),
                      "type": selectedType,
                      "category": selectedCategory,
                      "date": DateTime.now()
                          .toIso8601String(),
                    });

                    Navigator.pop(context, true);
                  },
                  child:
                      const Text("Save Transaction"),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}