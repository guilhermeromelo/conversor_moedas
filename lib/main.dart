import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:async';
import 'dart:convert';

const request = "https://api.hgbrasil.com/finance?key=9dceb422";

Future<Map> getData() async {
  http.Response response = await http.get(request);
  return json.decode(response.body);
}

void main() async {
  runApp(MaterialApp(
    home: Home(),
    theme: ThemeData(
        hintColor: Colors.amber,
        primaryColor: Colors.white,
        inputDecorationTheme: InputDecorationTheme(
          enabledBorder:
              OutlineInputBorder(borderSide: BorderSide(color: Colors.white)),
          focusedBorder:
              OutlineInputBorder(borderSide: BorderSide(color: Colors.amber)),
          hintStyle: TextStyle(color: Colors.amber),
        )),
  ));
}

class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

final realController = TextEditingController();
final dolarController = TextEditingController();
final euroController = TextEditingController();

double dolar;
double euro;

void clearAll(){
  realController.text ="";
  dolarController.text ="";
  euroController.text ="";
}

void _realChanged(String text) {
  if(text.isEmpty){
    clearAll();
    return;
  }else {
    double real1 = double.parse(text);
    dolarController.text = (real1 / dolar).toStringAsFixed(2);
    euroController.text = (real1 / euro).toStringAsFixed(2);
  }
}
void _dolarChanged(String text) {
  if(text.isEmpty){
    clearAll();
    return;
  }else {
    double dolar1 = double.parse(text);
    realController.text = (dolar1 * dolar).toStringAsFixed(2);
    euroController.text = ((dolar1 * dolar) / euro).toStringAsFixed(2);
  }
}
void _euroChanged(String text) {
  if(text.isEmpty){
    clearAll();
    return;
  }else {
    double euro1 = double.parse(text);
    realController.text = (euro1 * euro).toStringAsFixed(2);
    dolarController.text = ((euro1 * euro) / dolar).toStringAsFixed(2);
  }
}

class _HomeState extends State<Home> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black12,
      appBar: AppBar(
        title: Text("\$ Conversor de Moedas \$"),
        backgroundColor: Colors.amber,
        centerTitle: true,
      ),
      body: FutureBuilder<Map>(
        future: getData(),
        // ignore: missing_return
        builder: (context, snapshot) {
          switch (snapshot.connectionState) {
            case ConnectionState.none:
            case ConnectionState.waiting:
              return Center(
                child: Text(
                  "Carregando Informações...",
                  style: TextStyle(color: Colors.amber, fontSize: 25.0),
                  textAlign: TextAlign.center,
                ),
              );
            default:
              if (snapshot.hasError) {
                return Center(
                  child: Text(
                    "Erro ao Carregar Dados :(",
                    style: TextStyle(color: Colors.amber, fontSize: 25.0),
                    textAlign: TextAlign.center,
                  ),
                );
              } else {
                dolar = snapshot.data["results"]["currencies"]["USD"]["buy"];
                euro = snapshot.data["results"]["currencies"]["EUR"]["buy"];
                return tela();
              }
          }
        },
      ),
    );
  }
}

Widget buildTextField(
    String label, String prefix, TextEditingController controller, Function function) {
  return TextField(
    controller: controller,
    decoration: InputDecoration(
        labelText: label,
        labelStyle: TextStyle(color: Colors.amber),
        border: OutlineInputBorder(),
        prefixText: prefix),
    style: TextStyle(color: Colors.amber, fontSize: 25),
    onChanged: function,
    keyboardType: TextInputType.number,
  );
}

Widget tela(){
  return SingleChildScrollView(
    padding: EdgeInsets.all(10.0),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: <Widget>[
        Icon(Icons.monetization_on,
            size: 150, color: Colors.amber),
        buildTextField("Reais", "R\$ ", realController, _realChanged),
        Divider(),
        buildTextField("Dolares", "US\$ ", dolarController, _dolarChanged),
        Divider(),
        buildTextField("Euros", "\€ ", euroController, _euroChanged),

      ],
    ),
  );
}
