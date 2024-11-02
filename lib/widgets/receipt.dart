import 'package:food_reserve/models/food_model.dart';
import 'package:pdf/widgets.dart' as pw;

receipt(List<Food> reservedDishes) {
  double totall = 0;
  for (var i = 0; i < reservedDishes.length; i++) {
    totall += reservedDishes[i].cost;
  }
  return pw.Center(
    child: pw.Padding(
      padding: const pw.EdgeInsets.all(5),
      child: pw.Column(
        crossAxisAlignment: pw.CrossAxisAlignment.center,
        children: [
          for (var i = 0; i < reservedDishes.length; i++)
            pw.Row(
              mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
              children: [
                pw.Text(
                  reservedDishes[i].title,
                  style: pw.TextStyle(
                    fontSize: 20,
                    fontWeight: pw.FontWeight.bold,
                  ),
                ),
                pw.Text(
                  '\$ ${reservedDishes[i].cost.toString()}',
                  style: pw.TextStyle(
                    fontSize: 20,
                    fontWeight: pw.FontWeight.bold,
                  ),
                ),
              ],
            ),
          pw.SizedBox(height: 10),
          pw.Center(
            child: pw.Text(
              'Totall:    \$ ${totall.toString()}',
              style: pw.TextStyle(
                fontSize: 20,
                fontWeight: pw.FontWeight.bold,
              ),
            ),
          ),
        ],
      ),
    ),
  );
}
