import 'package:flutter/material.dart';
import 'package:ICISI/ui/sector_page.dart';
import 'package:ICISI/theme.dart' as Theme;

class Home extends StatelessWidget {


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(

        backgroundColor: Colors.white,
        title: Image.asset(
          'images/logoGrey.png',
          fit: BoxFit.fill,
        ),
        centerTitle: true,
      ),
      body: new SectorPage(),
    );
  }
}
