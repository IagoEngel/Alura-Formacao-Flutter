import 'package:bytebank/screens/dashboard/saldo.dart';
import 'package:bytebank/screens/deposito/formulario.dart';
import 'package:bytebank/screens/transferencia/formulario.dart';
import 'package:bytebank/screens/transferencia/lista.dart';
import 'package:bytebank/screens/transferencia/ultimas.dart';
import 'package:flutter/material.dart';

class Dashboard extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Bytebank'),
      ),
      body: ListView(
        children: [
          Align(
            alignment: Alignment.topCenter,
            child: SaldoCard(),
          ),
          ButtonBar(
            alignment: MainAxisAlignment.center,
            children: [
              ElevatedButton(
                child: Text('Receber depósito'),
                style: ElevatedButton.styleFrom(primary: Colors.green),
                onPressed: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => FormularioDeposito()));
                },
              ),
              ElevatedButton(
                style: ElevatedButton.styleFrom(primary: Colors.green),
                child: Text('Nova transferência'),
                onPressed: () {
                  Navigator.push(context, MaterialPageRoute(builder: (context) {
                    return FormularioTransferencia();
                  }));
                },
              ),
            ],
          ),
          UltimasTransferencias(),
        ],
      ),
    );
  }
}
