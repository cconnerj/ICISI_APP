import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';
import 'dart:io';

import 'package:ICISI/theme.dart' as Theme;

class DescriptionPage extends StatefulWidget {
  String id;
  DescriptionPage({this.id});

  @override
  _DescriptionPageState createState() => _DescriptionPageState();
}

class _DescriptionPageState extends State<DescriptionPage> {
  bool initialized;
  bool loading;
  List<Map> controlDescription;

  final String id;
  _DescriptionPageState({this.id});

  @override
  void initState() {
    super.initState();
    initialized = false;
    loading = true;
    getDescriptionData();
  }

  Future getDescriptionData() async {
    Directory documentsDirectory = await getApplicationDocumentsDirectory();
    String path = join(documentsDirectory.path, "asset_prototype_sqlite.db");
    ByteData data =
    await rootBundle.load(join("assets", "prototype_sqlite.db"));
    List<int> bytes =
    data.buffer.asUint8List(data.offsetInBytes, data.lengthInBytes);
    await new File(path).writeAsBytes(bytes);
    Database db = await openDatabase(path);
    await db
        .rawQuery('SELECT * FROM controls WHERE id = "${widget.id}"')
        .then((results) {
      setState(() {
        loading = false;
        initialized = true;
        controlDescription = results;
      });
    }).catchError((e) {});
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
                  itemCount: controlDescription.length,
                  itemBuilder: (BuildContext context, int index) {
                    return new Opacity(
                      opacity: 0.92,
                      child: new Card(
                        color: Theme.CompanyColors.coolGrey,
                        elevation: 2.0,
                        child: new ListTile(
                          title: new Text(
                            "${controlDescription[index]['id']} ${controlDescription[index]['title']}",
                            style: new TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                              fontSize: 20.0,
                            ),
                            textAlign: TextAlign.center,
                          ),
                          subtitle: new Text(
                            "${controlDescription[index]['body']}",
                            style: new TextStyle(
                              color: Colors.white,
                              fontSize: 16.0,
                            ),
                          ),
                        ),
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