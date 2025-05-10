import 'package:flutter/material.dart';

class SPFSelectorWidget extends StatefulWidget {
  const SPFSelectorWidget({super.key});

  @override
  State<SPFSelectorWidget> createState() => _SPFSelectorWidgetState();
}

class _SPFSelectorWidgetState extends State<SPFSelectorWidget> {
  int? selectedSPF;

  @override
  Widget build(BuildContext context) {
    final List<int> spfOptions = [15, 30, 50, 70, 100];

    return Column(
      children: [
        const Text("Select SPF Level:"),
        Wrap(
          spacing: 10,
          children: spfOptions.map((spf) {
            return ChoiceChip(
              label: Text("SPF $spf"),
              selected: selectedSPF == spf,
              onSelected: (bool selected) {
                setState(() {
                  selectedSPF = selected ? spf : null;
                });
                if (selected) {
                  // TODO: Save to Firestore with timestamp
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('SPF $spf applied!')),
                  );
                }
              },
            );
          }).toList(),
        ),
      ],
    );
  }
}
