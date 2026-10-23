import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'estadia/calculadora_estadia.dart';
import 'estadia/estadia_strategy.dart';
import 'estadia/estrategias_estadia.dart';

void main() {
  runApp(const EstadiaApp());
}

class EstadiaApp extends StatelessWidget {
  const EstadiaApp({super.key});

  @override
  Widget build(BuildContext context) {
    const verde = Color(0xFF234D3A);
    const terracota = Color(0xFFC87952);

    return MaterialApp(
      title: 'Simulador de Estadia',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: verde),
        scaffoldBackgroundColor: const Color(0xFFF6F1E8),
        useMaterial3: true,
        inputDecorationTheme: const InputDecorationTheme(
          filled: true,
          fillColor: Color(0xFFFBF9F5),
        ),
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            backgroundColor: terracota,
            foregroundColor: Colors.white,
          ),
        ),
      ),
      home: const TelaEstadia(),
    );
  }
}

class TelaEstadia extends StatefulWidget {
  const TelaEstadia({super.key});

  @override
  State<TelaEstadia> createState() => _TelaEstadiaState();
}

class _TelaEstadiaState extends State<TelaEstadia> {
  final TextEditingController _noitesController = TextEditingController();
  EstadiaStrategy _estrategiaSelecionada = const EstadiaStandard();
  double? _valorTotal;
  String? _mensagemErro;

  void _calcularEstadia() {
    final noites = int.tryParse(_noitesController.text);

    if (noites == null) {
      setState(() {
        _valorTotal = null;
        _mensagemErro = 'Informe a quantidade de noites.';
      });
      return;
    }

    try {
      final calculadora = CalculadoraEstadia(_estrategiaSelecionada);
      final valor = calculadora.calcular(noites);

      setState(() {
        _valorTotal = valor;
        _mensagemErro = null;
      });
    } on ArgumentError {
      setState(() {
        _valorTotal = null;
        _mensagemErro = 'A quantidade de noites deve ser zero ou maior.';
      });
    }
  }

  @override
  void dispose() {
    _noitesController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    const verde = Color(0xFF234D3A);
    const terracota = Color(0xFFC87952);

    return Scaffold(
      body: SafeArea(
        child: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 540),
            child: ListView(
              padding: const EdgeInsets.all(24),
              children: [
                const SizedBox(height: 8),
                Container(
                  padding: const EdgeInsets.all(24),
                  decoration: BoxDecoration(
                    color: verde,
                    borderRadius: BorderRadius.circular(18),
                  ),
                  child: const Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Icon(Icons.hotel_class_outlined, color: Colors.white),
                          SizedBox(width: 8),
                          Text(
                            'CASA AURORA',
                            style: TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                              letterSpacing: 1.2,
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: 22),
                      Text(
                        'Simulador de estadia',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 28,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                      SizedBox(height: 6),
                      Text(
                        'Escolha o quarto e informe quantas noites '
                        'pretende ficar.',
                        style: TextStyle(color: Colors.white70, height: 1.4),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 24),
                const Text(
                  'Detalhes da reserva',
                  style: TextStyle(
                    color: verde,
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 10),
                Card(
                  color: Colors.white,
                  elevation: 0,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                    side: const BorderSide(color: Color(0xFFE5DDD1)),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(18),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        DropdownButtonFormField<EstadiaStrategy>(
                          value: _estrategiaSelecionada,
                          decoration: const InputDecoration(
                            labelText: 'Categoria do quarto',
                            border: OutlineInputBorder(),
                          ),
                          items: const [
                            DropdownMenuItem(
                              value: EstadiaStandard(),
                              child: Text('Standard'),
                            ),
                            DropdownMenuItem(
                              value: EstadiaLuxo(),
                              child: Text('Luxo'),
                            ),
                            DropdownMenuItem(
                              value: EstadiaSuitePremium(),
                              child: Text('Suíte Premium'),
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
                        const SizedBox(height: 14),
                        TextField(
                          controller: _noitesController,
                          keyboardType: TextInputType.number,
                          inputFormatters: [
                            FilteringTextInputFormatter.digitsOnly,
                          ],
                          decoration: const InputDecoration(
                            labelText: 'Quantidade de noites',
                            border: OutlineInputBorder(),
                          ),
                          onSubmitted: (_) => _calcularEstadia(),
                        ),
                        const SizedBox(height: 18),
                        SizedBox(
                          height: 50,
                          child: ElevatedButton.icon(
                            onPressed: _calcularEstadia,
                            icon: const Icon(Icons.king_bed_outlined),
                            label: const Text('Calcular estadia'),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                if (_mensagemErro != null) ...[
                  const SizedBox(height: 14),
                  Text(
                    _mensagemErro!,
                    style: const TextStyle(color: Colors.red),
                  ),
                ],
                if (_valorTotal != null) ...[
                  const SizedBox(height: 16),
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 18,
                      vertical: 16,
                    ),
                    decoration: BoxDecoration(
                      color: const Color(0xFFF0DDCE),
                      borderRadius: BorderRadius.circular(14),
                      border: Border.all(color: const Color(0xFFE0C0A9)),
                    ),
                    child: Row(
                      children: [
                        const Icon(Icons.receipt_long_outlined, color: verde),
                        const SizedBox(width: 12),
                        const Expanded(
                          child: Text(
                            'Total da reserva',
                            style: TextStyle(
                              color: verde,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                        Text(
                          formatarReais(_valorTotal!),
                          style: const TextStyle(
                            color: verde,
                            fontSize: 20,
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
