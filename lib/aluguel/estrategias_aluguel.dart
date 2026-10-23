import 'aluguel_strategy.dart';

class AluguelEconomico implements AluguelStrategy {
  const AluguelEconomico();

  @override
  double calcular(int diarias) {
    if (diarias < 0) {
      throw ArgumentError('A quantidade de diárias não pode ser negativa.');
    }

    return diarias * 100.0;
  }
}

class AluguelExecutivo implements AluguelStrategy {
  const AluguelExecutivo();

  @override
  double calcular(int diarias) {
    if (diarias < 0) {
      throw ArgumentError('A quantidade de diárias não pode ser negativa.');
    }

    final subtotal = diarias * 180.0;

    if (diarias >= 7) {
      return subtotal * 0.9;
    }

    return subtotal;
  }
}

class AluguelSUV implements AluguelStrategy {
  const AluguelSUV();

  @override
  double calcular(int diarias) {
    if (diarias < 0) {
      throw ArgumentError('A quantidade de diárias não pode ser negativa.');
    }

    if (diarias == 0) {
      return 0.0;
    }

    return diarias * 250.0 + 80.0;
  }
}
