import 'estadia_strategy.dart';

class EstadiaStandard implements EstadiaStrategy {
  const EstadiaStandard();

  @override
  double calcular(int noites) {
    if (noites < 0) {
      throw ArgumentError('A quantidade de noites não pode ser negativa.');
    }

    return noites * 200.0;
  }
}

class EstadiaLuxo implements EstadiaStrategy {
  const EstadiaLuxo();

  @override
  double calcular(int noites) {
    if (noites < 0) {
      throw ArgumentError('A quantidade de noites não pode ser negativa.');
    }

    final subtotal = noites * 350.0;

    if (noites >= 5) {
      return subtotal * 0.9;
    }

    return subtotal;
  }
}

class EstadiaSuitePremium implements EstadiaStrategy {
  const EstadiaSuitePremium();

  @override
  double calcular(int noites) {
    if (noites < 0) {
      throw ArgumentError('A quantidade de noites não pode ser negativa.');
    }

    if (noites == 0) {
      return 0.0;
    }

    return noites * 500.0 + 100.0;
  }
}

