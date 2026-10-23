import 'aluguel_strategy.dart';

class CalculadoraAluguel {
  final AluguelStrategy estrategia;

  const CalculadoraAluguel(this.estrategia);

  double calcular(int diarias) {
    return estrategia.calcular(diarias);
  }
}
