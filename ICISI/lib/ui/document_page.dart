import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';
import 'dart:io';

import 'package:ICISI/ui/version_page.dart';
import 'package:ICISI/theme.dart' as Theme;

class DocumentPage extends StatefulWidget {
  int id;
  DocumentPage({this.id});
  @override
  _DocumentPageState createState() => _DocumentPageState();
}

class _DocumentPageState extends State<DocumentPage> {
  bool loading;
  List<Map> standardNames;

  final int id;
  _DocumentPageState({this.id});

  void initState() {
    super.initState();
    loading = true;
    getStandardsData();
  }

  Future getStandardsData() async {
    Directory documentsDirectory = await getApplicationDocumentsDirectory();
    String path = join(documentsDirectory.path, "asset_prototype_sqlite.db");
    ByteData data =
    await rootBundle.load(join("assets", "prototype_sqlite.db"));
    List<int> bytes =
    data.buffer.asUint8List(data.offsetInBytes, data.lengthInBytes);
    await new File(path).writeAsBytes(bytes);
    Database db = await openDatabase(path);
    final _standardsList = await db
        .rawQuery('SELECT * FROM documents WHERE sector_id = ${widget.id}');
    print(_standardsList);
    await db.close();

    setState(() {
      loading = false;
      standardNames = _standardsList;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: BackButton(
            color: Theme.CompanyColors.iBlue
        ),
        backgroundColor: Colors.white,
        title: Image.asset(
          'images/logoGrey.png',
          fit: BoxFit.fill,
        ),
        centerTitle: true,
      ),
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
                  itemCount: standardNames.length,
                  itemBuilder: (BuildContext context, int index) {
                    return new Opacity(
                      opacity: 0.9,
                      child: new Card(
                        color: Theme.CompanyColors.coolGrey,
                        elevation: 2.0,
                        child: new ListTile(
                          // leading: ,
                            title: new Text(
                              "${standardNames[index]['title']}",
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
                                  builder: (context) => VersionPage(
                                      id: standardNames[index]['id']),
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