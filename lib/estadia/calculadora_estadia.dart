import 'estadia_strategy.dart';

class CalculadoraEstadia {
  final EstadiaStrategy estrategia;

  const CalculadoraEstadia(this.estrategia);

  double calcular(int noites) {
    return estrategia.calcular(noites);
  }
}

