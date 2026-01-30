import 'package:flutter/material.dart';

class SearchPage extends StatefulWidget {
  const SearchPage({super.key});

  @override
  State<SearchPage> createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  String? selectedRegime;
  String? selectedAllergene;

  final List<String> regimes = [
    'Végétarien',
    'Vegan',
    'Sans gluten',
    'Keto',
    'Halal',
  ];

  final List<String> allergenes = [
    'Lactose',
    'Arachide',
    'Oeuf',
    'Fruits à coque',
    'Soja',
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF3F1FA),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            children: [
              // Barre de recherche (déjà faite)
              Row(
                children: [
                  Material(
                    color: const Color(0xFFEADEFF),
                    shape: const CircleBorder(),
                    child: InkWell(
                      onTap: () => Navigator.maybePop(context),
                      child: const SizedBox(
                        width: 44,
                        height: 44,
                        child: Icon(Icons.arrow_back),
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Container(
                      height: 44,
                      padding: const EdgeInsets.symmetric(horizontal: 12),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(24),
                      ),
                      child: const TextField(
                        decoration: InputDecoration(
                          hintText: 'Rechercher...',
                          border: InputBorder.none,
                        ),
                      ),
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 16),


        Row(
          children: [
            Expanded(
              child: DropdownMenu<String>(
                hintText: 'Régime',
                width: double.infinity,
                inputDecorationTheme: InputDecorationTheme(
                  filled: true,
                  fillColor: const Color(0xFFEADEFF),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(20),
                    borderSide: BorderSide.none,
                  ),
                ),
                textStyle: const TextStyle(
                  color: const Color(0xFF6750A4),
                  fontWeight: FontWeight.w600,
                ),
                trailingIcon: const Icon(
                  Icons.keyboard_arrow_down,
                  color: const Color(0xFF6750A4),
                ),
                dropdownMenuEntries: regimes
                    .map((r) => DropdownMenuEntry(value: r, label: r))
                    .toList(),
                onSelected: (value) {
                  setState(() => selectedRegime = value);
                },
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: DropdownMenu<String>(
                hintText: 'Allergène',
                width: double.infinity,
                inputDecorationTheme: InputDecorationTheme(
                  filled: true,
                  fillColor: const Color(0xFFEADEFF),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(20),
                    borderSide: BorderSide.none,
                  ),
                ),
                textStyle: const TextStyle(
                  color: Color(0xFF6750A4),
                  fontWeight: FontWeight.w600,
                ),
                trailingIcon: const Icon(
                  Icons.keyboard_arrow_down,
                  color: Color(0xFF6750A4),
                ),
                dropdownMenuEntries: allergenes
                    .map((a) => DropdownMenuEntry(value: a, label: a))
                    .toList(),
                onSelected: (value) {
                  setState(() => selectedAllergene = value);
                },
              ),
            ),
          ],
        ),

            ],
          ),
        ),
      ),
    );
  }
}

