import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'aluguel/aluguel_strategy.dart';
import 'aluguel/calculadora_aluguel.dart';
import 'aluguel/estrategias_aluguel.dart';

void main() {
  runApp(const AluguelApp());
}

class AluguelApp extends StatelessWidget {
  const AluguelApp({super.key});

  @override
  Widget build(BuildContext context) {
    const azul = Color(0xFF142A3A);
    const amarelo = Color(0xFFF2A900);

    return MaterialApp(
      title: 'Aluguel de Veículos',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: amarelo),
        scaffoldBackgroundColor: const Color(0xFFF1F4F7),
        appBarTheme: const AppBarTheme(
          backgroundColor: azul,
          foregroundColor: Colors.white,
        ),
        useMaterial3: true,
      ),
      home: const TelaAluguel(),
    );
  }
}

class TelaAluguel extends StatefulWidget {
  const TelaAluguel({super.key});

  @override
  State<TelaAluguel> createState() => _TelaAluguelState();
}

class _TelaAluguelState extends State<TelaAluguel> {
  final TextEditingController _diariasController = TextEditingController();
  AluguelStrategy _estrategiaSelecionada = const AluguelEconomico();
  double? _valorTotal;
  String? _mensagemErro;

  void _calcularAluguel() {
    final diarias = int.tryParse(_diariasController.text);

    if (diarias == null) {
      setState(() {
        _valorTotal = null;
        _mensagemErro = 'Informe a quantidade de diárias.';
      });
      return;
    }

    try {
      final calculadora = CalculadoraAluguel(_estrategiaSelecionada);
      final valor = calculadora.calcular(diarias);

      setState(() {
        _valorTotal = valor;
        _mensagemErro = null;
      });
    } on ArgumentError {
      setState(() {
        _valorTotal = null;
        _mensagemErro = 'A quantidade de diárias deve ser zero ou maior.';
      });
    }
  }

  @override
  void dispose() {
    _diariasController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    const azul = Color(0xFF142A3A);
    const amarelo = Color(0xFFF2A900);

    return Scaffold(
      appBar: AppBar(
        title: const Row(
          children: [
            Icon(Icons.directions_car_filled_rounded),
            SizedBox(width: 10),
            Text('ROTA • LOCAÇÃO'),
          ],
        ),
      ),
      body: SafeArea(
        child: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 540),
            child: ListView(
              padding: const EdgeInsets.all(24),
              children: [
                const SizedBox(height: 8),
                const Text(
                  'SIMULE SUA RESERVA',
                  style: TextStyle(
                    color: Color(0xFF60717E),
                    fontSize: 12,
                    fontWeight: FontWeight.bold,
                    letterSpacing: 1.4,
                  ),
                ),
                const SizedBox(height: 8),
                const Text(
                  'Aluguel de veículos',
                  style: TextStyle(
                    color: azul,
                    fontSize: 30,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                const SizedBox(height: 20),
                Card(
                  color: Colors.white,
                  elevation: 1,
                  child: Padding(
                    padding: const EdgeInsets.all(20),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        DropdownButtonFormField<AluguelStrategy>(
                          value: _estrategiaSelecionada,
                          decoration: const InputDecoration(
                            labelText: 'Categoria do veículo',
                            border: OutlineInputBorder(),
                          ),
                          items: const [
                            DropdownMenuItem(
                              value: AluguelEconomico(),
                              child: Text('Econômico'),
                            ),
                            DropdownMenuItem(
                              value: AluguelExecutivo(),
                              child: Text('Executivo'),
                            ),
                            DropdownMenuItem(
                              value: AluguelSUV(),
                              child: Text('SUV'),
                            ),
                          ],
                          onChanged: (estrategia) {
                            if (estrategia == null) return;
                            setState(() {
                              _estrategiaSelecionada = estrategia;
                              _valorTotal = null;
                              _mensagemErro = null;
                            });
                          },
                        ),
                        const SizedBox(height: 16),
                        TextField(
                          controller: _diariasController,
                          keyboardType: TextInputType.number,
                          inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                          decoration: const InputDecoration(
                            labelText: 'Quantidade de diárias',
                            border: OutlineInputBorder(),
                          ),
                          onSubmitted: (_) => _calcularAluguel(),
                        ),
                        const SizedBox(height: 20),
                        FilledButton.icon(
                          style: FilledButton.styleFrom(
                            backgroundColor: amarelo,
                            foregroundColor: azul,
                            padding: const EdgeInsets.symmetric(vertical: 15),
                          ),
                          onPressed: _calcularAluguel,
                          icon: const Icon(Icons.calculate_outlined),
                          label: const Text('Calcular aluguel'),
                        ),
                      ],
                    ),
                  ),
                ),
                if (_mensagemErro != null) ...[
                  const SizedBox(height: 16),
                  Text(
                    _mensagemErro!,
                    style: const TextStyle(color: Colors.red),
                  ),
                ],
                if (_valorTotal != null) ...[
                  const SizedBox(height: 16),
                  Container(
                    padding: const EdgeInsets.all(20),
                    decoration: BoxDecoration(
                      color: azul,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'VALOR TOTAL DA RESERVA',
                          style: TextStyle(
                            color: Colors.white70,
                            fontSize: 12,
                            letterSpacing: 1,
                          ),
                        ),
                        const SizedBox(height: 6),
                        Text(
                          formatarReais(_valorTotal!),
                          style: const TextStyle(
                            color: amarelo,
                            fontSize: 30,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ],
            ),
          ),
        ),
      ),
    );
  }
}

String formatarReais(double valor) {
  final partes = valor.toStringAsFixed(2).split('.');
  final inteiro = partes[0];
  final resultado = StringBuffer();

  for (var i = 0; i < inteiro.length; i++) {
    resultado.write(inteiro[i]);
    final digitosRestantes = inteiro.length - i - 1;
    if (digitosRestantes > 0 && digitosRestantes % 3 == 0) {
      resultado.write('.');
    }
  }

  return 'R\$ ${resultado.toString()},${partes[1]}';
}
