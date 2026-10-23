import 'package:cp3_aluguel_veiculos/aluguel/aluguel_strategy.dart';
import 'package:cp3_aluguel_veiculos/aluguel/calculadora_aluguel.dart';
import 'package:cp3_aluguel_veiculos/aluguel/estrategias_aluguel.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('AluguelEconomico', () {
    const estrategia = AluguelEconomico();

    test('retorna zero para zero diárias', () {
      // ACT
      final resultado = estrategia.calcular(0);

      // ASSERT
      expect(resultado, closeTo(0.0, 0.01));
    });

    test('calcula uma diária', () {
      final resultado = estrategia.calcular(1);
      expect(resultado, closeTo(100.0, 0.01));
    });

    test('calcula duas diárias', () {
      final resultado = estrategia.calcular(2);
      expect(resultado, closeTo(200.0, 0.01));
    });

    test('calcula sete diárias', () {
      final resultado = estrategia.calcular(7);
      expect(resultado, closeTo(700.0, 0.01));
    });

    test('lança exceção para diárias negativas', () {
      expect(() => estrategia.calcular(-1), throwsArgumentError);
    });
  });

  group('AluguelExecutivo', () {
    const estrategia = AluguelExecutivo();

    test('retorna zero para zero diárias', () {
      final resultado = estrategia.calcular(0);
      expect(resultado, closeTo(0.0, 0.01));
    });

    test('calcula uma diária sem desconto', () {
      final resultado = estrategia.calcular(1);
      expect(resultado, closeTo(180.0, 0.01));
    });

    test('calcula seis diárias sem desconto', () {
      final resultado = estrategia.calcular(6);
      expect(resultado, closeTo(1080.0, 0.01));
    });

    test('aplica desconto a partir de sete diárias', () {
      final resultado = estrategia.calcular(7);
      expect(resultado, closeTo(1134.0, 0.01));
    });

    test('aplica desconto em dez diárias', () {
      final resultado = estrategia.calcular(10);
      expect(resultado, closeTo(1620.0, 0.01));
    });

    test('lança exceção para diárias negativas', () {
      expect(() => estrategia.calcular(-2), throwsArgumentError);
    });
  });

  group('AluguelSUV', () {
    const estrategia = AluguelSUV();

    test('retorna zero e não cobra taxa para zero diárias', () {
      final resultado = estrategia.calcular(0);
      expect(resultado, closeTo(0.0, 0.01));
    });

    test('calcula uma diária com taxa de preparação', () {
      final resultado = estrategia.calcular(1);
      expect(resultado, closeTo(330.0, 0.01));
    });

    test('cobra a taxa de preparação uma vez em duas diárias', () {
      final resultado = estrategia.calcular(2);
      expect(resultado, closeTo(580.0, 0.01));
    });

    test('cobra a taxa de preparação uma vez em sete diárias', () {
      final resultado = estrategia.calcular(7);
      expect(resultado, closeTo(1830.0, 0.01));
    });

    test('lança exceção para diárias negativas', () {
      expect(() => estrategia.calcular(-3), throwsArgumentError);
    });
  });

  group('CalculadoraAluguel', () {
    test('delega o cálculo para a estratégia econômica', () {
      const calculadora = CalculadoraAluguel(AluguelEconomico());
      expect(calculadora.calcular(4), closeTo(400.0, 0.01));
    });

    test('delega o cálculo para a estratégia executiva', () {
      const calculadora = CalculadoraAluguel(AluguelExecutivo());
      expect(calculadora.calcular(7), closeTo(1134.0, 0.01));
    });

    test('delega o cálculo para a estratégia SUV', () {
      const calculadora = CalculadoraAluguel(AluguelSUV());
      expect(calculadora.calcular(5), closeTo(1330.0, 0.01));
    });

    test('mantém o retorno zero ao delegar para a estratégia escolhida', () {
      const AluguelStrategy estrategia = AluguelSUV();
      const calculadora = CalculadoraAluguel(estrategia);
      expect(calculadora.calcular(0), closeTo(0.0, 0.01));
    });
  });
}
