import 'package:flutter/material.dart';
import 'package:nota_1000/presentation/views/quiz/quiz_page.dart';
import 'package:nota_1000/presentation/widgets/custom_appbar.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  List<String> question = [
    "Ingles",
    "Espanhol",
    "Portugues",
    "Artes",
    "Educacao Fisica",
    "Historia",
    "Geografia",
    "Filosofia",
    "Sociologia",
    "Matematica",
    "Fisica",
    "Quimica",
    "Biologia",
    "Todas"
  ];
final Map<String, int> _perguntasPorMateria = {};

  int get _totalPerguntas {
    int total = 0;
    _perguntasPorMateria.forEach((key, value) {
      if (key != "Todas") {
        total += value;
      }
    });
    return total;
  }

  // Função acionada ao clicar em qualquer botão de matéria
  void _onMateriaTap(String materia) {
    if (materia == "Todas") {
      // Acrescenta +1 a todas as matérias (exceto 'Todas')
      setState(() {
        for (var item in question) {
          if (item != "Todas") {
            _perguntasPorMateria[item] = (_perguntasPorMateria[item] ?? 0) + 1;
          }
        }
      });
    } else {
      // Para as outras matérias, abre o diálogo de digitação
      _abrirDialogoQuantidade(materia);
    }
  }

  // Diálogo para digitar a quantidade individual
  void _abrirDialogoQuantidade(String materia) {
    final TextEditingController controller = TextEditingController(
      text: (_perguntasPorMateria[materia] ?? '').toString(),
    );

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('Quantidade para $materia'),
          content: TextField(
            controller: controller,
            keyboardType: TextInputType.number,
            autofocus: true,
            decoration: const InputDecoration(
              labelText: 'Número de perguntas',
              border: OutlineInputBorder(),
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Cancelar'),
            ),
            ElevatedButton(
              onPressed: () {
                int? qtd = int.tryParse(controller.text);
                if (qtd != null && qtd > 0) {
                  setState(() {
                    _perguntasPorMateria[materia] = qtd;
                  });
                } else {
                  setState(() {
                    _perguntasPorMateria.remove(materia);
                  });
                }
                Navigator.pop(context);
              },
              child: const Text('Confirmar'),
            ),
          ],
        );
      },
    );
  }
  void _iniciarSimulado() {
  if (_totalPerguntas == 0) {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Selecione ao menos uma matéria e quantidade!'),
      ),
    );
    return;
  }

  // Navega para a rota '/quiz' passando o mapa de configurações como argumento
  Navigator.pushNamed(
    context,
    '/quiz',
    arguments: _perguntasPorMateria,
  );
}
  

  @override
  Widget build(BuildContext context) {
    final primaryColor = Theme.of(context).primaryColor;

    return Scaffold(
      appBar: CustomAppBar(
        title: 'Nota 1000',
        showBackButton: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            // Barra superior exibindo o total acumulado
            Container(
              width: double.infinity,
              padding: const EdgeInsets.symmetric(vertical: 12),
              decoration: BoxDecoration(
                color: Colors.grey[300],
                borderRadius: BorderRadius.circular(8),
              ),
              child: Center(
                child: Text(
                  'Numero de perguntas totais ($_totalPerguntas)',
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                    color: Colors.black87,
                  ),
                ),
              ),
            ),
            const SizedBox(height: 16),

            // Grid com as matérias
            Expanded(
              child: GridView.builder(
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  crossAxisSpacing: 12,
                  mainAxisSpacing: 12,
                  childAspectRatio: 2.5,
                ),
                itemCount: question.length,
                itemBuilder: (context, index) {
                  String materia = question[index];
                  bool isTodas = materia == "Todas";
                  int qtdSelected = _perguntasPorMateria[materia] ?? 0;
                  bool isSelected = qtdSelected > 0;

                  return ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: isTodas
                          ? Colors.orangeAccent
                          : (isSelected ? primaryColor : Colors.grey[300]),
                      foregroundColor: (isSelected || isTodas) ? Colors.white : Colors.black87,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                    onPressed: () => _onMateriaTap(materia),
                    child: Text(
                      isTodas
                          ? 'Todas (+1)'
                          : (isSelected ? '$materia\n($qtdSelected)' : materia),
                      textAlign: TextAlign.center,
                      style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w600),
                    ),
                  );
                },
              ),
            ),
            const SizedBox(height: 16),

            // Botão Começar
            SizedBox(
              width: double.infinity,
              height: 50,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Theme.of(context).colorScheme.primary, // Sincronizado com a cor padrão/tema
                  foregroundColor: Theme.of(context).colorScheme.onPrimary, // Cor do texto adequada ao fundo
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                onPressed: _iniciarSimulado,
                child: const Text(
                  'Começar',
                  style: TextStyle(fontSize: 18, color: Colors.white),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}