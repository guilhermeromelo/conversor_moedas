import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:async';
import 'dart:convert';

const request = "https://api.hgbrasil.com/finance?key=9dceb422";

Future<Map> getData() async{
  http.Response response = await http.get(request);
  return json.decode(response.body);
}

void main() async{

  runApp(MaterialApp(
    home: Home(),
  ));
}

class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

  double dolar;
  double euro;


class _HomeState extends State<Home> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(backgroundColor: Colors.black12, appBar: AppBar(
      title: Text("\$ Conversor de Moedas \$"), backgroundColor: Colors.amber, centerTitle: true,),
      body: FutureBuilder<Map>(
        future:getData(),
        // ignore: missing_return
        builder: (context, snapshot){
          switch(snapshot.connectionState){
            case ConnectionState.none:
            case ConnectionState.waiting:
              return Center(
                child: Text(
                  "Carregando Informações...", style: TextStyle(color: Colors.amber, fontSize: 25.0), textAlign: TextAlign.center,
                ),
              );
            default: if(snapshot.hasError){
              return Center(
                child: Text(
                  "Erro ao Carregar Dados :(", style: TextStyle(color: Colors.amber, fontSize: 25.0), textAlign: TextAlign.center,
                ),
              );
            } else{
              dolar = snapshot.data["results"]["currencies"]["USD"]["buy"];
              euro = snapshot.data["results"]["currencies"]["EUR"]["buy"];
              return Container(color: Colors.green,);
            }
          }
        },
      ),
    );
  }
}
