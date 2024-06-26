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
  TextEditingController _controllerTarefa = TextEditingController();

  Future<File> _getArquivo() async {
    final diretorio = await getApplicationCacheDirectory();
    return File("${diretorio.path}/tarefa.json");
  }

  _salvarTarefa() {
    Map<String, dynamic> tarefa = Map();
    tarefa["titulo"] = _controllerTarefa.text;
    tarefa["realizada"] = false;
    setState(() {
      _lista.add(tarefa);
    });

    _salvarArquivo();
    _controllerTarefa.text = "";
  }

  _salvarArquivo() async {
    var arquivo = await _getArquivo();

    String dados = json.encode(_lista);
    arquivo.writeAsString(dados);
  }

  _lerArquivo() async {
    try {
      final arquivo = await _getArquivo();
      return arquivo.readAsString();
    } catch (e) {
      return null;
    }
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _lerArquivo().then((dados) {
      setState(() {
        _lista = json.decode(dados);
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Lista de Tarefas"),
        backgroundColor: Colors.deepPurpleAccent,
      ),
      body: Expanded(
          child: Container(
        padding: EdgeInsets.only(bottom: 80),
        child: ListView.builder(
            itemCount: _lista.length,
            itemBuilder: (context, index) {
              return Dismissible(
                  onDismissed: (direction) {
                    setState(() {
                      _lista.removeAt(index);
                    });
                    _salvarArquivo();
                  },
                  direction: DismissDirection.endToStart,
                  background: Container(
                    color: Colors.red,
                    padding: EdgeInsets.all(16),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        Icon(
                          Icons.delete,
                          color: Colors.white,
                        )
                      ],
                    ),
                  ),
                  key: Key(index.toString()),
                  child: CheckboxListTile(
                      title: Text(_lista[index]["titulo"]),
                      value: _lista[index]["realizada"],
                      onChanged: (val) {
                        setState(() {
                          _lista[index]["realizada"] = val;
                        });
                        _salvarArquivo();
                      }));
              // return ListTile(title: Text(_lista[index]["titulo"]));
            }),
      )),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          showDialog(
              context: context,
              builder: (context) {
                return AlertDialog(
                  title: Text("Digite uma tarefa"),
                  content: TextField(
                    controller: _controllerTarefa,
                    decoration: InputDecoration(labelText: "Digite sua tarefa"),
                    onChanged: (text) {},
                  ),
                  actions: [
                    ElevatedButton(
                        onPressed: () => Navigator.pop(context),
                        child: Text("Cancelar")),
                    ElevatedButton(
                        onPressed: () {
                          _salvarTarefa();
                          Navigator.pop(context);
                        },
                        child: Text("Salvar"))
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
