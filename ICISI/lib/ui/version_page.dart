import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';
import 'dart:io';

import 'package:ICISI/ui/control_page.dart';
import 'package:ICISI/theme.dart' as Theme;

class VersionPage extends StatefulWidget {
  int id;
  VersionPage({this.id});

  @override
  _VersionPageState createState() => _VersionPageState();
}

class _VersionPageState extends State<VersionPage> {
  bool loading;
  List<Map> versionNames;
  final int id;
  _VersionPageState({this.id});

  void initState() {
    super.initState();
    loading = true;
    getVersionData();
  }

  Future getVersionData() async {
    Directory documentsDirectory = await getApplicationDocumentsDirectory();
    String path = join(documentsDirectory.path, "asset_prototype_sqlite.db");
    ByteData data =
    await rootBundle.load(join("assets", "prototype_sqlite.db"));
    List<int> bytes =
    data.buffer.asUint8List(data.offsetInBytes, data.lengthInBytes);
    await new File(path).writeAsBytes(bytes);
    Database db = await openDatabase(path);
    final _versionList = await db
        .rawQuery('SELECT * FROM versions WHERE document_id = ${widget.id}');
    print(_versionList);
    await db.close();

    setState(() {
      loading = false;
      versionNames = _versionList;
    });
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: BackButton(
          color: Theme.CompanyColors.iBlue
        ),
        automaticallyImplyLeading: true,
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
                  itemCount: versionNames.length,
                  itemBuilder: (BuildContext context, int index) {
                    return new Opacity(
                      opacity: 0.9,
                      child: new Card(
                        color: Theme.CompanyColors.coolGrey,
                        elevation: 2.0,
                        child: new ListTile(
                          // leading: ,
                            title: new Text(
                              "${versionNames[index]['title']}",
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
                                  builder: (context) => ControlsPage(
                                      id: versionNames[index]['id']),
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