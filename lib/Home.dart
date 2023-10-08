import 'package:flutter/material.dart';

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
            onPressed: () => AddLista(),
            icon: const Icon(Icons.shopping_cart),
          )
        ],
        title: const Text("Quando Custa"),
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20.0),
            child: SizedBox(
              height: 100,
              child: Column(
                children: [
                  TextField(
                    autofocus: true,
                    controller: descricaoProduto,
                    decoration: const InputDecoration(
                        border: InputBorder.none,
                        icon: Icon(Icons.pending_actions),
                        hintText: 'Informe o produto'),
                  ),
                  TextField(
                    controller: valorUnitario,
                    autofocus: true,
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
            height: MediaQuery.of(context).size.width / 0.7,
            child: ListView.builder(
              itemCount: compras.length,
              itemBuilder: (c, i) {
                return Padding(
                  padding: const EdgeInsets.symmetric(
                      horizontal: 20.0, vertical: 10),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Container(
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
                          Container(
                            height: 50,
                            width: MediaQuery.of(context).size.width / 2.3,
                            child: Text(
                              "R\$${compras[i]["valor"]}",
                              style: const TextStyle(
                                fontSize: 15,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ],
                      ),
                      Column(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          Container(
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
                                            for (var element in compras) {
                                              total = total +
                                                  (element["valor"] *
                                                      element["quantidade"]);
                                            }
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
                              "R\$ ${compras[i]["quantidade"] * compras[i]["valor"]}",
                              style: const TextStyle(
                                fontSize: 15,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                );
              },
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20.0),
            child: Text(
              "R\$ $total",
              style: const TextStyle(
                fontSize: 40,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ],
      ),
    );
  }

  void AddLista() {
    var descrcaoInofrmado = descricaoProduto.text;
    double valorInformado = double.parse(valorUnitario.text);

    for (var element in compras) {
      total = total + (element["valor"] * element["quantidade"]);
    }

    setState(() {
      compras.add(
        {
          "descricao": "$descrcaoInofrmado",
          "quantidade": 1,
          "valor": valorInformado
        },
      );
    });
    descricaoProduto.clear();
    valorUnitario.clear();
  }
}
