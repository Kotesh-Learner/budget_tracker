import 'package:flutter/material.dart';

import '../services/storage_service.dart';

class AddBudgetScreen extends StatefulWidget {
  const AddBudgetScreen({super.key});

  @override
  State<AddBudgetScreen> createState() =>
      _AddBudgetScreenState();
}

class _AddBudgetScreenState
    extends State<AddBudgetScreen> {

  String selectedCategory = "Food";

  final budgetController =
      TextEditingController();

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

  void saveBudget() {

    if (budgetController.text.isEmpty) {
      return;
    }

    final box =
        StorageService.getBudgetBox();

    box.put(
      selectedCategory,
      double.parse(
        budgetController.text,
      ),
    );

    Navigator.pop(context, true);
  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      appBar: AppBar(
        title: const Text("Set Budget"),
      ),
      body: Padding(
        padding:
            const EdgeInsets.all(16),
        child: Column(
          children: [

            DropdownButtonFormField(
              value: selectedCategory,
              items: categories
                  .map(
                    (e) =>
                        DropdownMenuItem(
                      value: e,
                      child: Text(
                        e.toString(),
                      ),
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

            const SizedBox(height: 20),

            TextField(
              controller:
                  budgetController,
              keyboardType:
                  TextInputType.number,
              decoration:
                  const InputDecoration(
                labelText:
                    "Monthly Budget",
                border:
                    OutlineInputBorder(),
              ),
            ),

            const SizedBox(height: 20),

            ElevatedButton(
              onPressed: saveBudget,
              child:
                  const Text("Save"),
            ),
          ],
        ),
      ),
    );
  }
}