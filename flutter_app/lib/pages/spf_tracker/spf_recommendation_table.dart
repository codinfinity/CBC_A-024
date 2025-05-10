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
      border: TableBorder.all(),
      children: rows.map((row) {
        return TableRow(children: row.map((cell) {
          return Padding(padding: const EdgeInsets.all(8), child: Text(cell));
        }).toList());
      }).toList(),
    );
  }
}
