import 'package:flutter/material.dart';

class SPFRecommendationTable extends StatelessWidget {
  const SPFRecommendationTable({super.key});

  @override
  Widget build(BuildContext context) {
    final rows = [
      ["UVI Range", "Skin Type I–III", "Skin Type IV–VI"],
      ["0–2", "SPF 15", "Optional / SPF 15"],
      ["3–5", "SPF 30", "SPF 15–30"],
      ["6–7", "SPF 50", "SPF 30–50"],
      ["8–10", "SPF 50+", "SPF 50"],
      ["11+", "SPF 50+ + Protective wear", "SPF 50+"],
    ];

    return Table(
      border: TableBorder.all(color: Colors.orange.shade200, width: 1),
      defaultVerticalAlignment: TableCellVerticalAlignment.middle,
      children: List.generate(rows.length, (index) {
        final isHeader = index == 0;
        final backgroundColor = index.isEven
            ? Colors.orange.shade50
            : Colors.yellow.shade50;

        return TableRow(
          decoration: BoxDecoration(
            color: backgroundColor,
          ),
          children: rows[index].map((cell) {
            return Padding(
              padding: const EdgeInsets.all(12),
              child: Text(
                cell,
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontWeight: isHeader ? FontWeight.bold : FontWeight.normal,
                  color: isHeader ? Colors.deepOrange : Colors.black87,
                ),
              ),
            );
          }).toList(),
        );
      }),
    );
  }
}