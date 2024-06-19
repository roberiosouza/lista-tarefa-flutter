import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';
import 'dart:io';
import 'dart:convert';
import 'dart:async';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  List _lista = [];

  _salvarArquivo() async {
    final diretorio = await getApplicationCacheDirectory();
    var arquivo = File("${diretorio.path}/tarefas.json");

    Map<String, dynamic> tarefa = Map();
    tarefa["titulo"] = "Ir ao mercado";
    tarefa["realizada"] = false;
    _lista.add(tarefa);

    String dados = json.encode(_lista);
    arquivo.writeAsString(dados);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Lista de Tarefas"),
        backgroundColor: Colors.deepPurpleAccent,
      ),
      body: Expanded(
        child: ListView.builder(
            itemCount: _lista.length,
            itemBuilder: (context, index) {
              return ListTile(title: Text(_lista[index]));
            }),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          showDialog(
              context: context,
              builder: (context) {
                return AlertDialog(
                  title: Text("Digite uma tarefa"),
                  content: TextField(
                    decoration: InputDecoration(labelText: "Digite sua tarefa"),
                    onChanged: (text) {},
                  ),
                  actions: [
                    ElevatedButton(
                        onPressed: () => Navigator.pop(context),
                        child: Text("Cancelar")),
                    ElevatedButton(onPressed: () {}, child: Text("Salvar"))
                  ],
                );
              });
        },
        child: Icon(
          Icons.add,
          color: Colors.white,
        ),
        backgroundColor: Colors.deepPurpleAccent,
      ),
    );
  }
}
