import 'package:flutter/material.dart';
import 'controles/controle_planeta.dart';
import 'telas/tela_planeta.dart';
import 'modelos/planeta.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Planetas',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: const Color.fromARGB(255, 248, 112, 173)),
        useMaterial3: true,
      ),
      home: const MyHomePage(title: 'App - Planetas'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key, required this.title}) : super(key: key);

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  final ControlePlaneta _controlePlaneta = ControlePlaneta();
  List<Planeta> _planetas = [];

  @override
  void initState() {
    super.initState();
    lerPlanetas();
  }

  Future<void> lerPlanetas() async {
    final resultado = await _controlePlaneta.lerPlanetas();
    setState(() {
      _planetas = resultado;
    });
  }

  void incluirPlaneta(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => TelaPlaneta(
        isIncluir: true,
        planeta: Planeta.vazio(),
        onFinalizado: () {
        lerPlanetas();
      })),
    );
  }

  void _alterarPlaneta(BuildContext context, Planeta planeta) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => TelaPlaneta(
        isIncluir: false,
        planeta: planeta,
        onFinalizado: () {
        lerPlanetas();
      })),
    );
  }

  Future<void> excluirPlaneta(int id) async {
    await _controlePlaneta.excluirPlaneta(id);
    lerPlanetas();
  }

  void alterarPlaneta(Planeta planeta) {
    _alterarPlaneta(context, planeta);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text(widget.title),
      ),
      body: ListView.builder(
        itemCount: _planetas.length,
        itemBuilder: (context, index) {
          final planeta = _planetas[index];
          return ListTile(
            title: Text(planeta.nome),
            subtitle: Text(planeta.apelido ?? ''),
            trailing: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                IconButton(
                  icon: const Icon(Icons.edit),
                  onPressed: () => alterarPlaneta(planeta),
                ),
                IconButton(
                  icon: const Icon(Icons.delete),
                  onPressed: () async {
                    if (planeta.id != null) {
                      await excluirPlaneta(planeta.id!);
                    }
                  },
                ),
              ],
            ),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => incluirPlaneta(context),
        tooltip: 'Adicionar',
        child: const Icon(Icons.add),
      ),
    );
  }
}
