import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';
import 'dart:io';

import 'package:ICISI/ui/document_page.dart';
import 'package:ICISI/theme.dart' as Theme;

class SectorPage extends StatefulWidget {
  @override
  _SectorPageState createState() => _SectorPageState();
}

class _SectorPageState extends State<SectorPage> {
  bool loading;
  List<Map<String, dynamic>> sectorList;

  @override
  void initState() {
    super.initState();

    loading = true;
    getSectorData();
  }

  Future getSectorData() async {
    Directory documentsDirectory = await getApplicationDocumentsDirectory();

    String path = join(documentsDirectory.path, "asset_prototype_sqlite.db");

    ByteData data =
    await rootBundle.load(join("assets", "prototype_sqlite.db"));

    List<int> bytes =
    data.buffer.asUint8List(data.offsetInBytes, data.lengthInBytes);

    await new File(path).writeAsBytes(bytes);

    Database db = await openDatabase(path);

    List<Map> _sectorList =
    await db.rawQuery('SELECT * FROM sectors order by id');

    print(_sectorList);

    await db.close();
    setState(() {
      loading = false;
      sectorList = _sectorList;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: new Stack(
        children: <Widget>[
          new Container(
            decoration: new BoxDecoration(
              image: new DecorationImage(
                image: new AssetImage("images/background_pattern.jpg"),
                fit: BoxFit.cover,
                repeat: ImageRepeat.repeat,
              ),
            ),
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: new Center(
                child: !loading
                    ? new ListView.builder(
                  itemCount: sectorList.length,
                  itemBuilder: (BuildContext context, int index) {
                    return new Opacity(
                      opacity: 0.9,
                      child: new Card(
                        color: Theme.CompanyColors.coolGrey,
                        elevation: 2.0,
                        child: new ListTile(
                          // leading: ,
                            title: new Text(
                              "${sectorList[index]['title']}",
                              style: new TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                                fontSize: 20.0,
                              ),
                            ),
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => DocumentPage(
                                      id: sectorList[index]['id']),
                                ),
                              );
                            }),
                      ),
                    );
                  },
                )
                    : CircularProgressIndicator(),
              ),
            ),
          ),
        ],
      ),
    );
  }
}