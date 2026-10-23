import 'package:cp3_estadia_hotel/estadia/calculadora_estadia.dart';
import 'package:cp3_estadia_hotel/estadia/estadia_strategy.dart';
import 'package:cp3_estadia_hotel/estadia/estrategias_estadia.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('EstadiaStandard', () {
    const estrategia = EstadiaStandard();

    test('retorna zero para zero noites', () {
      final resultado = estrategia.calcular(0);
      expect(resultado, closeTo(0.0, 0.01));
    });

    test('calcula uma noite', () {
      final resultado = estrategia.calcular(1);
      expect(resultado, closeTo(200.0, 0.01));
    });

    test('calcula duas noites', () {
      final resultado = estrategia.calcular(2);
      expect(resultado, closeTo(400.0, 0.01));
    });

    test('calcula cinco noites', () {
      final resultado = estrategia.calcular(5);
      expect(resultado, closeTo(1000.0, 0.01));
    });

    test('lança exceção para noites negativas', () {
      expect(() => estrategia.calcular(-1), throwsArgumentError);
    });
  });

  group('EstadiaLuxo', () {
    const estrategia = EstadiaLuxo();

    test('retorna zero para zero noites', () {
      final resultado = estrategia.calcular(0);
      expect(resultado, closeTo(0.0, 0.01));
    });

    test('calcula uma noite sem desconto', () {
      final resultado = estrategia.calcular(1);
      expect(resultado, closeTo(350.0, 0.01));
    });

    test('calcula quatro noites sem desconto', () {
      final resultado = estrategia.calcular(4);
      expect(resultado, closeTo(1400.0, 0.01));
    });

    test('aplica desconto a partir de cinco noites', () {
      final resultado = estrategia.calcular(5);
      expect(resultado, closeTo(1575.0, 0.01));
    });

    test('aplica desconto em sete noites', () {
      final resultado = estrategia.calcular(7);
      expect(resultado, closeTo(2205.0, 0.01));
    });

    test('lança exceção para noites negativas', () {
      expect(() => estrategia.calcular(-2), throwsArgumentError);
    });
  });

  group('EstadiaSuitePremium', () {
    const estrategia = EstadiaSuitePremium();

    test('retorna zero sem cobrar a taxa para zero noites', () {
      final resultado = estrategia.calcular(0);
      expect(resultado, closeTo(0.0, 0.01));
    });

    test('calcula uma noite com taxa de limpeza', () {
      final resultado = estrategia.calcular(1);
      expect(resultado, closeTo(600.0, 0.01));
    });

    test('cobra a taxa de limpeza uma vez em duas noites', () {
      final resultado = estrategia.calcular(2);
      expect(resultado, closeTo(1100.0, 0.01));
    });

    test('cobra a taxa de limpeza uma vez em seis noites', () {
      final resultado = estrategia.calcular(6);
      expect(resultado, closeTo(3100.0, 0.01));
    });

    test('lança exceção para noites negativas', () {
      expect(() => estrategia.calcular(-3), throwsArgumentError);
    });
  });

  group('CalculadoraEstadia', () {
    test('delega o cálculo para a estratégia standard', () {
      const calculadora = CalculadoraEstadia(EstadiaStandard());
      expect(calculadora.calcular(2), closeTo(400.0, 0.01));
    });

    test('delega o cálculo para a estratégia luxo', () {
      const calculadora = CalculadoraEstadia(EstadiaLuxo());
      expect(calculadora.calcular(5), closeTo(1575.0, 0.01));
    });

    test('delega o cálculo para a suíte premium', () {
      const calculadora = CalculadoraEstadia(EstadiaSuitePremium());
      expect(calculadora.calcular(3), closeTo(1600.0, 0.01));
    });

    test('mantém o retorno zero ao delegar para a estratégia escolhida', () {
      const EstadiaStrategy estrategia = EstadiaLuxo();
      const calculadora = CalculadoraEstadia(estrategia);
      expect(calculadora.calcular(0), closeTo(0.0, 0.01));
    });
  });
}
