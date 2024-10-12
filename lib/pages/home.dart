import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_firebase_giuaki/pages/product.dart';
import 'package:flutter_firebase_giuaki/service/database.dart';
import 'package:fluttertoast/fluttertoast.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  TextEditingController tencontroller = TextEditingController();
  TextEditingController loaicontroller = TextEditingController();
  TextEditingController giacontroller = TextEditingController();
  TextEditingController imagecontroller = TextEditingController();
  Stream? ProductStream;

  getontheload() async {
    ProductStream = await DatabaseMethods().getProductDetails();
    setState(() {});
  }

  @override
  void initState() {
    getontheload();
    super.initState();
  }

  Widget allProductDetails() {
    return StreamBuilder(
        stream: ProductStream,
        builder: (context, AsyncSnapshot snapshot) {
          return snapshot.hasData
              ? ListView.builder(
                  itemCount: snapshot.data.docs.length,
                  itemBuilder: (context, index) {
                    DocumentSnapshot ds = snapshot.data.docs[index];
                    return Container(
                      margin: const EdgeInsets.only(bottom: 20.0),
                      child: Material(
                        elevation: 5.0,
                        borderRadius: BorderRadius.circular(10),
                        child: Container(
                          padding: const EdgeInsets.all(20),
                          width: MediaQuery.of(context).size.width,
                          decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(10)),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              ds["imageUrl"] != null &&
                                      ds["imageUrl"].isNotEmpty
                                  ? Image.network(
                                      ds["imageUrl"],
                                      width: double.infinity,
                                      height: 200,
                                      fit: BoxFit.cover,
                                    )
                                  : const SizedBox(
                                      height: 200,
                                      child: Center(
                                        child: Text(
                                          "No Image Available",
                                          style: TextStyle(
                                              color: Colors.grey, fontSize: 16),
                                        ),
                                      ),
                                    ),
                              const SizedBox(height: 10),
                              Row(
                                children: [
                                  Text("Tên sp: " + ds["Ten"],
                                      style: const TextStyle(
                                          color: Colors.blue,
                                          fontSize: 20.0,
                                          fontWeight: FontWeight.bold)),
                                  const Spacer(),
                                  GestureDetector(
                                      onTap: () {
                                        tencontroller.text = ds["Ten"];
                                        loaicontroller.text = ds["Loai"];
                                        giacontroller.text = ds["Gia"];
                                        imagecontroller.text = ds["imageUrl"];
                                        EditProductDetail(ds["Id"]);
                                      },
                                      child: const Icon(
                                        Icons.edit,
                                        color: Colors.orange,
                                      )),
                                  const SizedBox(
                                    width: 5.0,
                                  ),
                                  GestureDetector(
                                      onTap: () async {
                                        await DatabaseMethods()
                                            .deleteProductDetail(ds["Id"])
                                            .then((value) {
                                          Fluttertoast.showToast(
                                              msg:
                                                  "Product information has been deleted successfully",
                                              toastLength: Toast.LENGTH_SHORT,
                                              gravity: ToastGravity.CENTER,
                                              timeInSecForIosWeb: 1,
                                              backgroundColor: Colors.red,
                                              textColor: Colors.white,
                                              fontSize: 16.0);
                                        });
                                      },
                                      child: const Icon(
                                        Icons.delete,
                                        color: Colors.orange,
                                      ))
                                ],
                              ),
                              Text("Loại sp: " + ds["Loai"],
                                  style: const TextStyle(
                                      color: Colors.orange,
                                      fontSize: 20.0,
                                      fontWeight: FontWeight.bold)),
                              Text("Giá sp: " + ds["Gia"],
                                  style: const TextStyle(
                                      color: Colors.blue,
                                      fontSize: 20.0,
                                      fontWeight: FontWeight.bold)),
                            ],
                          ),
                        ),
                      ),
                    );
                  })
              : Container();
        });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(context,
              MaterialPageRoute(builder: (context) => const Product()));
        },
        child: const Icon(Icons.add),
      ),
      appBar: AppBar(
        title: const Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              "Flutter",
              style: TextStyle(
                  color: Colors.blue,
                  fontSize: 20.0,
                  fontWeight: FontWeight.bold),
            ),
            Text(
              "Firebase",
              style: TextStyle(
                  color: Colors.orange,
                  fontSize: 20.0,
                  fontWeight: FontWeight.bold),
            )
          ],
        ),
      ),
      body: Container(
        margin: const EdgeInsets.only(left: 20.0, right: 20.0, top: 30.0),
        child: Column(
          children: [
            Expanded(child: allProductDetails()),
          ],
        ),
      ),
    );
  }

  Future EditProductDetail(String id) => showDialog(
      context: context,
      builder: (context) => AlertDialog(
            content: Container(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      GestureDetector(
                          onTap: () {
                            Navigator.pop(context);
                          },
                          child: const Icon(Icons.cancel)),
                      const SizedBox(
                        width: 60.0,
                      ),
                      const Text(
                        "Edit",
                        style: TextStyle(
                            color: Colors.blue,
                            fontSize: 20.0,
                            fontWeight: FontWeight.bold),
                      ),
                      const Text(
                        "Details",
                        style: TextStyle(
                            color: Colors.orange,
                            fontSize: 20.0,
                            fontWeight: FontWeight.bold),
                      )
                    ],
                  ),
                  const SizedBox(
                    height: 20.0,
                  ),
                  const Text("Tên sp",
                      style: TextStyle(
                          color: Colors.black,
                          fontSize: 20.0,
                          fontWeight: FontWeight.bold)),
                  const SizedBox(
                    height: 10.0,
                  ),
                  Container(
                    padding: const EdgeInsets.only(left: 10.0),
                    decoration: BoxDecoration(
                        border: Border.all(),
                        borderRadius: BorderRadius.circular(10.0)),
                    child: TextField(
                      controller: tencontroller,
                      decoration:
                          const InputDecoration(border: InputBorder.none),
                    ),
                  ),
                  const SizedBox(
                    height: 20.0,
                  ),
                  const Text("Loại sp",
                      style: TextStyle(
                          color: Colors.black,
                          fontSize: 20.0,
                          fontWeight: FontWeight.bold)),
                  const SizedBox(
                    height: 10.0,
                  ),
                  Container(
                    padding: const EdgeInsets.only(left: 10.0),
                    decoration: BoxDecoration(
                        border: Border.all(),
                        borderRadius: BorderRadius.circular(10.0)),
                    child: TextField(
                      controller: loaicontroller,
                      decoration:
                          const InputDecoration(border: InputBorder.none),
                    ),
                  ),
                  const SizedBox(
                    height: 20.0,
                  ),
                  const Text("Giá sp",
                      style: TextStyle(
                          color: Colors.black,
                          fontSize: 20.0,
                          fontWeight: FontWeight.bold)),
                  const SizedBox(
                    height: 10.0,
                  ),
                  Container(
                    padding: const EdgeInsets.only(left: 10.0),
                    decoration: BoxDecoration(
                        border: Border.all(),
                        borderRadius: BorderRadius.circular(10.0)),
                    child: TextField(
                      controller: giacontroller,
                      decoration:
                          const InputDecoration(border: InputBorder.none),
                    ),
                  ),
                  const SizedBox(
                    height: 30.0,
                  ),
                  const Text("Hình ảnh",
                      style: TextStyle(
                          color: Colors.black,
                          fontSize: 20.0,
                          fontWeight: FontWeight.bold)),
                  const SizedBox(
                    height: 10.0,
                  ),
                  Container(
                    padding: const EdgeInsets.only(left: 10.0),
                    decoration: BoxDecoration(
                        border: Border.all(),
                        borderRadius: BorderRadius.circular(10.0)),
                    child: TextField(
                      controller: imagecontroller,
                      decoration:
                          const InputDecoration(border: InputBorder.none),
                    ),
                  ),
                  const SizedBox(
                    height: 30.0,
                  ),
                  ElevatedButton(
                      onPressed: () async {
                        Map<String, dynamic> updateInfo = {
                          "Ten": tencontroller.text,
                          "Loai": loaicontroller.text,
                          "Id": id,
                          "Gia": giacontroller.text,
                          "imageUrl": imagecontroller.text,
                        };
                        await DatabaseMethods()
                            .updateProductDetail(id, updateInfo)
                            .then((value) {
                          Navigator.pop(context);
                        });
                      },
                      child: const Text("Update"))
                ],
              ),
            ),
          ));
}
