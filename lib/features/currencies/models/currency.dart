
class Currency {
  final String label;
  final String name;
  final String symbol;

  const Currency({required this.label, required this.name, required this.symbol});


  @override
  String toString() {
    return "Currency(label: $label, name: $name, symbol: $symbol)";
  }
}
