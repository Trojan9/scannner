
import 'dart:io';
import 'package:path/path.dart';
import 'package:flutter/material.dart';
import 'dart:async';

import 'package:flutter/services.dart';
import 'package:flutter_cache_manager/flutter_cache_manager.dart';
import 'package:image/image.dart' as mage;
import 'package:opencv/opencv.dart' as cv2;
import 'package:opencv/core/core.dart';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:scanner/cvs.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'OpenCv',
      theme: ThemeData(
        // This is the theme of your application.
        //
        // Try running your application with "flutter run". You'll see the
        // application has a blue toolbar. Then, without quitting the app, try
        // changing the primarySwatch below to Colors.green and then invoke
        // "hot reload" (press "r" in the console where you ran "flutter run",
        // or simply save your changes to "hot reload" in a Flutter IDE).
        // Notice that the counter didn't reset back to zero; the application
        // is not restarted.
        primarySwatch: Colors.blue,
        // This makes the visual density adapt to the platform that you run
        // the app on. For desktop platforms, the controls will be smaller and
        // closer together (more dense) than on mobile platforms.
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);

  // This widget is the home page of your application. It is stateful, meaning
  // that it has a State object (defined below) that contains fields that affect
  // how it looks.

  // This class is the configuration for the state. It holds the values (in this
  // case the title) provided by the parent (in this case the App widget) and
  // used by the build method of the State. Fields in a Widget subclass are
  // always marked "final".

  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  String _platformVersion = 'Unknown';
  Image image,imagenew;
  var img;
  Future scan()async{
    //Image image;
    bool preloaded = false;
    bool loaded = false;
    String url ="https://www.addictionary.org/g/009-incredible-professional-resume-template-download-high-resolution-868_868.jpg";
     File file = await DefaultCacheManager().getSingleFile(url);
    // setState(() {
    //   image = Image.file(file);
    //   preloaded = true;
    // });
     //print(await file.readAsBytes());
dynamic res=await cv2.ImgProc.resize(await file.readAsBytes(),[1300,800], 0, 0, cv2.ImgProc.interArea);

    var documentDirectory = await getApplicationDocumentsDirectory();

    File file1 = new File(
        join(documentDirectory.path, 'imagetest.png')
    );
   // File file1;
    await file1.writeAsBytesSync(res);




//blur image
 dynamic res1=await cv2.ImgProc.gaussianBlur(await file1.readAsBytes(), [5,5], 0);
    File file2 = new File(
        join(documentDirectory.path, 'imagetest.png')
    );
    // File file1;
    await file2.writeAsBytesSync(res1);
    //find canny edges
    dynamic res2=await cv2.ImgProc.canny(await file2.readAsBytes(),30,50);
    File file3 = new File(
        join(documentDirectory.path, 'edges.png')
    );
    await file3.writeAsBytesSync(res2);
    dynamic res4 = await cv2.ImgProc.copyMakeBorder(
        await file3.readAsBytes(), 20, 20, 20, 20, Core.borderConstant);
    File file4 = new File(
        join(documentDirectory.path, 'edges.png')
    );
    await file4.writeAsBytesSync(res4);
    setState(() {
      image=Image.file(file4);
    });
    //dynamic res3=await cv2.ImgProc.contoursMatchI3.;
 //print("done");
  return image;


  }

  Future<void> initPlatformState() async {
    String platformVersion;
    // Platform messages may fail, so we use a try/catch PlatformException.
    try {
      platformVersion = await cv2.OpenCV.platformVersion;
    } on PlatformException {
      platformVersion = 'Failed to get platform version.';
    }

    // If the widget was removed from the tree while the asynchronous platform
    // message was in flight, we want to discard the reply rather than calling
    // setState to update our non-existent appearance.
    if (!mounted) return;

    setState(() {
      _platformVersion = platformVersion;
    });

  }

@override
  void didChangeDependencies() async {
    // TODO: implement didChangeDependencies
    await scan();
    super.didChangeDependencies();
  }
  @override
  Widget build(BuildContext context) {

    return Scaffold(
      appBar: AppBar(
        // Here we take the value from the MyHomePage object that was created by
        // the App.build method, and use it to set our appbar title.
        title: Text(widget.title),
      ),
      body: Center(
        child: Container(
          width: MediaQuery.of(context).size.width,
          height: MediaQuery.of(context).size.height,
          child: image!=null?image:CircularProgressIndicator(),
        ),

      ),
      // This trailing comma makes auto-formatting nicer for build methods.
    );
  }
}
