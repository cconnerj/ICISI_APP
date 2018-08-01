import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';
import 'dart:io';

import 'package:ICISI/ui/description_page.dart';
import 'package:ICISI/theme.dart' as Theme;

class ControlsPage extends StatefulWidget {
  int id;
  ControlsPage({this.id});

  @override
  _ControlsPageState createState() => _ControlsPageState();
}

class _ControlsPageState extends State<ControlsPage> {
  bool loading;
  List<Map> controlHeadings;

  final int id;
  _ControlsPageState({this.id});

  @override
  void initState() {
    super.initState();
    loading = true;
    getControlData();
  }

  Future getControlData() async {
    Directory documentsDirectory = await getApplicationDocumentsDirectory();
    String path = join(documentsDirectory.path, "asset_prototype_sqlite.db");
    ByteData data =
    await rootBundle.load(join("assets", "prototype_sqlite.db"));
    List<int> bytes =
    data.buffer.asUint8List(data.offsetInBytes, data.lengthInBytes);
    await new File(path).writeAsBytes(bytes);
    Database db = await openDatabase(path);
    final _controlsList = await db
        .rawQuery('SELECT * FROM controls WHERE version_id = ${widget.id} ORDER by index_id');
    print(_controlsList);
    await db.close();

    setState(() {
      loading = false;
      controlHeadings = _controlsList;
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
                  itemCount: controlHeadings.length,
                  itemBuilder: (BuildContext context, int index) {
                    return new Opacity(
                      opacity: 0.9,
                      child: new Card(
                        color: Theme.CompanyColors.coolGrey,
                        elevation: 2.0,
                        child: new ListTile(
                            leading: new Text(
                              "${controlHeadings[index]['id']}",
                              style: new TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            title: new Text(
                              "${controlHeadings[index]['title']}",
                              style: new TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                                fontSize: 15.0,
                              ),
                            ),
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => DescriptionPage(
                                      id: controlHeadings[index]['id']),
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