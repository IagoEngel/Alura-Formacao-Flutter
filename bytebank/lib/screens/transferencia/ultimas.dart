import 'package:bytebank/models/transferencias.dart';
import 'package:bytebank/screens/transferencia/lista.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

const _titulo = 'Últimas transferências';

class UltimasTransferencias extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(_titulo,
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 24)),
        Consumer<Transferencias>(
          builder: (context, transferencias, child) {
            final _ultimaTransferencias =
                transferencias.transferencias.reversed.toList();
            final _quantidade = transferencias.transferencias.length;
            int tamanho = 2;

            if(_quantidade == 0){
              return SemTransferenciaCadastrada();
            }

            if (_quantidade < 2) {
              tamanho = _quantidade;
            }

            return ListView.builder(
              padding: const EdgeInsets.all(8),
              itemCount: tamanho,
              shrinkWrap: true,
              itemBuilder: (context, index) {
                return ItemTransferencia(_ultimaTransferencias[index]);
              },
            );
          },
        ),
        ElevatedButton(
          child: Text('Ver todoas transfereêcias'),
          style: ElevatedButton.styleFrom(primary: Colors.green),
          onPressed: () {
            Navigator.push(context,
                MaterialPageRoute(builder: (context) => ListaTransferencias()));
          },
        ),
      ],
    );
  }
}

class SemTransferenciaCadastrada extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Card(
      margin: EdgeInsets.all(40),
      child: Padding(
        padding: EdgeInsets.all(10),
        child: Text('Você ainda não cadastrou nenhuma transferência',
            textAlign: TextAlign.center),
      ),
    );
  }
}
