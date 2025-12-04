import 'package:flutter/material.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  final List<Map<String, dynamic>> items = [
    {"name": "Bouquet Mawar", "price": 50000},
    {"name": "Bouquet Lily", "price": 60000},
    {"name": "Bouquet Tulip", "price": 75000},
    {"name": "Bouquet Sunflower", "price": 55000},
    {"name": "Bouquet Daisy", "price": 45000},
  ];

  final Set<Map<String, dynamic>> cart = {};

  void toggleItem(Map<String, dynamic> item) {
    setState(() {
      if (cart.contains(item)) {
        cart.remove(item);
      } else {
        cart.add(item);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      routes: {
        '/': (context) => CatalogPage(
              items: items,
              cart: cart,
              onItemTap: toggleItem,
            ),
        '/bayar': (context) => BayarPage(cart: cart.toList()),
      },
    );
  }
}

class CatalogPage extends StatelessWidget {
  final List<Map<String, dynamic>> items;
  final Set<Map<String, dynamic>> cart;
  final Function(Map<String, dynamic>) onItemTap;

  CatalogPage({
    required this.items,
    required this.cart,
    required this.onItemTap,
  });

  int _totalHarga() {
    int total = 0;
    for (var item in cart) {
      total += item["price"] as int;
    }
    return total;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(70),
        child: Container(
          decoration: BoxDecoration(
            color: Color(0xFFE573B8),
            borderRadius: BorderRadius.vertical(bottom: Radius.circular(25)),
          ),
          padding: EdgeInsets.only(top: 15),
          child: AppBar(
            elevation: 0,
            backgroundColor: Colors.transparent,
            title: Row(
              children: [
                Icon(Icons.local_florist, color: Colors.white, size: 26),
                SizedBox(width: 10),
                Text(
                  "Katalog Bouquet Pilihan",
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 20,
                  ),
                ),
              ],
            ),
            actions: [
              Padding(
                padding: EdgeInsets.only(right: 18),
                child: Row(
                  children: [
                    IconButton(
                      icon: Icon(Icons.shopping_cart,
                          size: 28, color: Colors.white),
                      onPressed: () => Navigator.pushNamed(context, '/bayar'),
                    ),
                    Container(
                      width: 28,
                      height: 28,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        shape: BoxShape.circle,
                        border:
                            Border.all(color: Colors.pinkAccent, width: 2),
                      ),
                      alignment: Alignment.center,
                      child: Text(
                        "${cart.length}",
                        style: TextStyle(
                          color: Colors.pinkAccent,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ],
                ),
              )
            ],
          ),
        ),
      ),

      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
              padding: EdgeInsets.all(10),
              itemCount: items.length,
              itemBuilder: (context, index) {
                final item = items[index];
                final isSelected = cart.contains(item);

                return Container(
                  margin: EdgeInsets.only(bottom: 10),
                  child: Card(
                    elevation: isSelected ? 3 : 1,
                    color: isSelected ? Colors.pink.shade50 : Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Padding(
                      padding: EdgeInsets.all(14),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                item["name"],
                                style: TextStyle(
                                  fontSize: 17,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                              SizedBox(height: 4),
                              Text(
                                "Rp ${item["price"]}",
                                style: TextStyle(
                                  fontSize: 15,
                                  color: Colors.grey[700],
                                ),
                              ),
                            ],
                          ),

                          ElevatedButton(
                            onPressed: () => onItemTap(item),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: isSelected
                                  ? Colors.green
                                  : Colors.pinkAccent,
                              padding: EdgeInsets.symmetric(
                                  horizontal: 20, vertical: 10),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10),
                              ),
                            ),
                            child: Text(
                              isSelected ? "✓ Dipilih" : "Tambah",
                              style: TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                );
              },
            ),
          ),

          Container(
            padding: EdgeInsets.all(18),
            decoration: BoxDecoration(
              color: Colors.grey[200],
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "Total Item: ${cart.length}",
                      style: TextStyle(fontSize: 18),
                    ),
                    SizedBox(height: 8),
                    Text(
                      "Total Harga: Rp ${_totalHarga()}",
                      style: TextStyle(
                          fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                  ],
                ),

                ElevatedButton(
                  onPressed: cart.isEmpty
                      ? null
                      : () => Navigator.pushNamed(context, '/bayar'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor:
                        cart.isEmpty ? Colors.grey : Colors.pinkAccent,
                    padding: EdgeInsets.symmetric(
                        horizontal: 26, vertical: 12),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  child: Text(
                    "Bayar",
                    style: TextStyle(
                        color: Colors.white, fontWeight: FontWeight.bold),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}


class BayarPage extends StatelessWidget {
  final List<Map<String, dynamic>> cart;

  BayarPage({required this.cart});

  int _totalBayar() {
    int total = 0;
    for (var item in cart) {
      total += item["price"] as int;
    }
    return total;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color(0xFFE573B8),
        title: Text(
          "Pembayaran",
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
      ),

      body: Padding(
        padding: EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "Item yang dibeli:",
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 10),

            ...cart.map((e) => Container(
                  margin: EdgeInsets.only(bottom: 10),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(e["name"], style: TextStyle(fontSize: 16)),
                      Text(
                        "Rp ${e["price"]}",
                        style: TextStyle(
                            fontSize: 16, fontWeight: FontWeight.w600),
                      ),
                    ],
                  ),
                )),

            Spacer(),

            Text(
              "Total Pembayaran: Rp ${_totalBayar()}",
              style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
            ),

            SizedBox(height: 18),

            Center(
              child: ElevatedButton(
                onPressed: () {},
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.pinkAccent,
                  padding:
                      EdgeInsets.symmetric(horizontal: 28, vertical: 14),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30),
                  ),
                ),
                child: Text(
                  "Konfirmasi Pembayaran",
                  style: TextStyle(
                      fontSize: 18,
                      color: Colors.white,
                      fontWeight: FontWeight.bold),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
