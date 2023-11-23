import 'package:flutter/material.dart';
import 'package:simple_currency_format/simple_currency_format.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  List<Map<String, dynamic>> compras = [];
  var total = 0.0;
  TextEditingController descricaoProduto = TextEditingController();
  TextEditingController valorUnitario = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        actions: [
          IconButton(
            onPressed: () {
              adicionarPedidoLista();
              atualizarLista();
            },
            icon: const Icon(Icons.shopping_cart),
          )
        ],
        title: const Text("Quando Custa"),
      ),
      body: SingleChildScrollView(
        reverse: false,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20.0),
              child: SizedBox(
                height: 100,
                child: Column(
                  children: [
                    TextField(
                      autofocus: false,
                      controller: descricaoProduto,
                      decoration: const InputDecoration(
                          border: InputBorder.none,
                          icon: Icon(Icons.pending_actions),
                          hintText: 'Informe o produto'),
                    ),
                    TextField(
                      keyboardType: const TextInputType.numberWithOptions(
                          signed: false, decimal: true),
                      controller: valorUnitario,
                      autofocus: false,
                      onSubmitted: (value) {
                        adicionarPedidoLista();
                      },
                      decoration: const InputDecoration(
                          border: InputBorder.none,
                          icon: Icon(Icons.monetization_on_outlined),
                          hintText: 'Informe o valor'),
                    ),
                  ],
                ),
              ),
            ),
            SizedBox(
              height: MediaQuery.of(context).size.height / 1.5,
              child: ListView.builder(
                itemCount: compras.length,
                itemBuilder: (c, i) {
                  return Dismissible(
                    key: Key("${compras[i]["descricao"]}"),
                    onDismissed: (direction) {
                      setState(() {
                        compras.removeAt(i);
                        atualizarLista();
                      });
                      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                          showCloseIcon: true,
                          backgroundColor: Colors.red,
                          content:
                              Text("${compras[i]["descricao"]} foi removido")));
                    },
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 20.0, vertical: 10),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              SizedBox(
                                height: 50,
                                width: MediaQuery.of(context).size.width / 2.3,
                                child: Text(
                                  "${compras[i]["descricao"]}",
                                  style: const TextStyle(
                                    fontSize: 20,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                              SizedBox(
                                height: 50,
                                width: MediaQuery.of(context).size.width / 2.3,
                                child: Text(
                                  "${currencyFormat(compras[i]["valor"], symbol: "R\$")}",
                                  style: const TextStyle(
                                    fontSize: 15,
                                    fontWeight: FontWeight.w400,
                                  ),
                                ),
                              ),
                            ],
                          ),
                          Column(
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: [
                              SizedBox(
                                height: 50,
                                width: MediaQuery.of(context).size.width / 2.3,
                                child: Row(
                                  children: [
                                    TextButton(
                                      onPressed: compras[i]["quantidade"] == 1
                                          ? null
                                          : () => setState(() {
                                                total = 0;
                                                compras[i]["quantidade"]--;
                                                atualizarLista();
                                              }),
                                      child: const Text("-"),
                                    ),
                                    Text("  ${compras[i]["quantidade"]}"),
                                    TextButton(
                                      onPressed: () => setState(() {
                                        total = 0;
                                        compras[i]["quantidade"]++;
                                        for (var element in compras) {
                                          total = total +
                                              (element["valor"] *
                                                  element["quantidade"]);
                                        }
                                      }),
                                      child: const Text("+"),
                                    ),
                                  ],
                                ),
                              ),
                              SizedBox(
                                height: 50,
                                child: Text(
                                  textAlign: TextAlign.end,
                                  "${currencyFormat(compras[i]["quantidade"] * compras[i]["valor"], symbol: "R\$")}",
                                  style: const TextStyle(
                                    fontSize: 15,
                                    fontWeight: FontWeight.w900,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),
            widgetTotal(),
          ],
        ),
      ),
    );
  }

  Padding widgetTotal() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20.0),
      child: Text(
        "${currencyFormat(total, symbol: "R\$")}",
        style: const TextStyle(
          fontSize: 40,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }

  void adicionarPedidoLista() {
    var descrcaoInofrmado = descricaoProduto.text;
    double valorInformado =
        double.parse(valorUnitario.text.replaceAll(',', '.'));

    atualizarLista();

    setState(() {
      compras.add(
        {
          "descricao": descrcaoInofrmado,
          "quantidade": 1,
          "valor": valorInformado
        },
      );
    });
    descricaoProduto.clear();
    valorUnitario.clear();
  }

  void atualizarLista() {
    if (compras.isEmpty) {
      total = 0.00;
    } else {
      for (var element in compras) {
        total = total + (element["valor"] * element["quantidade"]);
      }
    }
  }
}
