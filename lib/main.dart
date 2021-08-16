import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:html/parser.dart';
import 'package:http/http.dart' as http;
import 'package:web_scraper_demo/data_model.dart';

import 'callback_price_model.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: MyHomePage(title: 'Flutter Web Scraper Demo'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key? key, required this.title}) : super(key: key);

  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  List<String> titleList = [];

  List<String> imgList = [];

  List<String> totalPriceList = [];

  List<DataModel> productList = [];

  @override
  void initState() {
    super.initState();
    // getUrlData();
    queryProductDetail();
  }

  getUrlData() async {
    // var url =
    //     "https://goalnepal.com/tournament/55";
    // var url = "https://list.jd.com/list.html?cat=670,671,672";
    var url = _textEditingController.text;

    if (url.isEmpty) return;

    final response = await http.get(Uri.parse(url));

    final body = response.body;

    final html = parse(body);

    // final imgList = html.querySelector('.page-title')!.text;

    // print(imgList);

    final imageList = html.querySelectorAll('.p-img');
    final priceList = html.querySelectorAll('.p-price');
    final nameList = html.querySelectorAll('.p-name');

    for (var item in nameList) {
      print("商品名称：" + item.querySelector('a')!.querySelector('em')!.text);

      titleList.add(item.querySelector('a')!.querySelector('em')!.text);
    }

    for (var item in priceList) {
      print('商品价格：${item.text.trim()}');
      totalPriceList.add(item.text.trim());
    }

    for (var item in imageList) {
      var title = item.querySelector('a')!.attributes['title'];
      print(title);
      var imgUrl = item
          .querySelector('a')!
          .querySelector('img')!
          .attributes['data-lazy-img'];
      print(imgUrl);

      imgList.add('https:$imgUrl');
    }

    final newList = imgList
        .asMap()
        .map(
          (key, value) => MapEntry(
            key,
            DataModel(
                name: titleList[key], image: value, price: totalPriceList[key]),
          ),
        )
        .values
        .toList();

    print(newList);
    productList.addAll(newList);
    setState(() {});
  }

  queryProductDetail() async {
    var url = 'https://item.jd.com/100009077475.html';

    final skuId = url.split('/')[3].split('.')[0];

    print(url.split('/')[3].split('.')[0]);

    if (url.isEmpty) return;

    final response = await http.get(Uri.parse(url));

    final body = response.body;

    final html = parse(body);

    final result = html.querySelector('.p-price');

    final skuList = result!
        .querySelector('.price')!
        .attributes['class']!
        .split(' ')[1]
        .split('-');
    print(skuList);
    print('${skuList[0]}_${skuList[2]}');

    // final res = await http.get(Uri.parse(
    //     'https://p.3.cn/prices/mgets?skuIds=${skuList[0]}_${skuList[2]}'));

    final res = await http
        .get(Uri.parse('https://p.3.cn/prices/mgets?skuIds=J_$skuId'));

    print(res.body.runtimeType);

    print(CallbackPriceModel.fromJson(json.decode(res.body)[0]).p);
  }

  void _incrementCounter() {
    getUrlData();
  }

  TextEditingController _textEditingController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
        actions: [
          IconButton(
              onPressed: () {
                setState(() {
                  titleList.clear();
                  totalPriceList.clear();
                  totalPriceList.clear();
                  productList.clear();
                });
              },
              icon: Icon(Icons.delete_forever))
        ],
      ),
      body: Column(
        children: [
          Container(
            padding: EdgeInsets.all(10),
            child: TextFormField(
              controller: _textEditingController,
              decoration: InputDecoration(hintText: '请输入网址。。。'),
            ),
          ),
          productList.isNotEmpty
              ? Expanded(
                  child: ListView.builder(
                    itemCount: productList.length,
                    itemBuilder: (_, index) => Container(
                      padding: EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        border: Border(
                          bottom: BorderSide(
                            width: 1,
                            color: Color(0XFFEEEEEE),
                          ),
                        ),
                      ),
                      height: 120,
                      child: Row(
                        children: [
                          Container(
                              decoration: BoxDecoration(
                                border: Border.all(
                                  width: 1,
                                  color: Color(0XFFEEEEEE),
                                ),
                              ),
                              child: Image.network(productList[index].image!)),
                          SizedBox(
                            width: 10,
                          ),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  '${productList[index].price!}',
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 20,
                                    color: Colors.red,
                                  ),
                                ),
                                SizedBox(
                                  height: 10,
                                ),
                                Text(
                                  '${productList[index].name!}',
                                  overflow: TextOverflow.ellipsis,
                                  maxLines: 2,
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                )
              : SizedBox.shrink()
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _incrementCounter,
        tooltip: 'Increment',
        child: Icon(Icons.play_arrow),
      ),
    );
  }
}
