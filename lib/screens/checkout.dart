import 'package:flutter/material.dart';
import 'package:food_reserve/models/food_model.dart';
import 'package:food_reserve/widgets/receipt.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:printing/printing.dart';

class CheckoutScreen extends StatelessWidget {
  const CheckoutScreen({super.key, required this.reservedDishes});
  final List<Food> reservedDishes;
  void printReceipt() async {
    final doc = pw.Document();

    doc.addPage(pw.Page(
        pageFormat: PdfPageFormat.a4,
        build: (pw.Context context) {
          return pw.Center(child: receipt(reservedDishes));
        }));
    await Printing.layoutPdf(
        onLayout: (PdfPageFormat format) async => doc.save());
  }

  @override
  Widget build(BuildContext context) {
    double totall = 0;
    for (var i = 0; i < reservedDishes.length; i++) {
      totall += reservedDishes[i].cost;
    }
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.primary,
        title: Text(
          'Checkout!',
          style: TextStyle(
            color: Theme.of(context).colorScheme.onPrimary,
          ),
        ),
      ),
      body: Center(
        child: SingleChildScrollView(
          child: Column(
            children: [
              for (var i = 0; i < reservedDishes.length; i++)
                ListTile(
                  leading: Text(reservedDishes[i].title),
                  trailing: Text('\$ ${reservedDishes[i].cost.toString()}'),
                ),
              Center(
                child: Text('totall: ${totall.toString()}'),
              ),
              const SizedBox(height: 50,),
              ElevatedButton.icon(
                onPressed: printReceipt,
                icon: const Icon(Icons.print),
                label: const Text('Print or Save receipt'),
              )
            ],
          ),
        ),
      ),
    );
  }
}
