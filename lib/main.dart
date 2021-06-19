import 'dart:io';
import 'dart:io' as io;
import 'dart:typed_data';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:file_picker/file_picker.dart';
import 'package:nearby_connections/nearby_connections.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:aes_crypt/aes_crypt.dart';
import 'package:flutter_swiper/flutter_swiper.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:image_picker/image_picker.dart';


void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Login(),
      theme: ThemeData.dark(),
      debugShowCheckedModeBanner: false,
    );
  }
}

class Login extends StatelessWidget {
  final nameController = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Container(
          height: MediaQuery.of(context).size.height,
          decoration: BoxDecoration(
              gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: <Color>[Color(0xFF667eea), Color(0xFF764ba2)]
              )
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(30,80,0,120),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('File',
                        style: TextStyle(fontWeight: FontWeight.bold, fontSize: 50, color: Colors.white,fontFamily: 'Comfortaa'),
                      ),
                      SizedBox(height: 10),
                      Text('Transfer',
                        style: TextStyle(fontWeight: FontWeight.bold, fontSize: 50, color: Colors.white,fontFamily: 'Comfortaa'),
                      ),
                    ],
                  ),
                ),
              ),
              Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Form(
                    key: _formKey,
                    child: Column(
                      children: [
                        Padding(
                          padding: const EdgeInsets.fromLTRB(40,30,40,30),
                          child: TextFormField(
                            controller: nameController,
                            decoration: InputDecoration(
                                border: OutlineInputBorder(borderSide: BorderSide()),
                                prefixIcon: Icon(Icons.person,color: Colors.white,size: 30),
                                labelText: 'Username',
                                labelStyle: TextStyle(color: Colors.white, fontSize: 20, fontFamily: 'Comfortaa'),
                                hintText: 'e.g. Viraj',
                                hintStyle: TextStyle(color: Colors.white,fontFamily: 'Comfortaa')
                            ),
                            validator: (text) {
                              if (text.isEmpty)
                                return 'Username can\'t be empty.';
                              else if(text.length < 3)
                                return 'Username must be at least 3 characters.';
                              else if(text.length > 10)
                                return 'Username must be less than 10 characters.';
                              else
                                return null;
                            },
                          ),
                        ),
                      ],
                    ),
                  ),
                  Container(
                    height: 50,
                    width: 180,
                    child: ElevatedButton(
                      child: Text('Continue',
                          style: TextStyle(fontSize: 20,fontFamily: 'Comfortaa',fontWeight: FontWeight.bold,color: Color(0xFF667eea))
                      ),
                      onPressed: (){
                        if(_formKey.currentState.validate()){
                          var nameEntered = nameController.text;
                          Navigator.of(context).push(
                            MaterialPageRoute(
                                builder: (context) => Send(userName1: nameEntered)
                            ),
                          );
                        }
                      },
                      style: ElevatedButton.styleFrom(
                        primary: Colors.white,
                        elevation: 20,
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(50)
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class Send extends StatefulWidget {
  final String userName1;
  Send({@required this.userName1});
  @override
  _SendState createState() => _SendState(
      userName2:userName1
  );
}

class _SendState extends State<Send> {
  final String userName2;
  String get avtChar => userName2[0].toUpperCase();
  _SendState({@required this.userName2});

  permissions() async {
    Map<Permission, PermissionStatus> statuses = await [
      Permission.storage,
      Permission.location,
    ].request();
    await Nearby().enableLocationServices();
    print(statuses);
  }

  @override
  void initState() {
    permissions();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        appBar: AppBar(
          flexibleSpace: Container(
            decoration: BoxDecoration(
                borderRadius: BorderRadius.vertical(bottom: Radius.circular(25)),
                gradient: LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: <Color>[Color(0xFF667eea), Color(0xFF764ba2)]
                )
            ),
          ),
          title: Text('File Transfer',
            style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 23, fontFamily: 'Comfortaa'),
          ),
          elevation: 0,
          backgroundColor: Colors.white,
          centerTitle: true,
        ),
        drawer: Drawer(
          child: Container(
            color: Colors.white,
            child: ListView(
              children: [
                DrawerHeader(
                  decoration: BoxDecoration(
                      gradient: LinearGradient(
                          begin: Alignment.centerLeft,
                          end: Alignment.centerRight,
                          colors: <Color>[Color(0xFF667eea), Color(0xFF764ba2)]
                      )
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      CircleAvatar(
                        backgroundColor: Colors.white,
                        radius: 45,
                        child: Text('$avtChar',
                          style: TextStyle(color: Color(0xFF667eea), fontSize: 45, fontFamily: 'Comfortaa', fontWeight: FontWeight.bold),
                        ),
                      ),
                      SizedBox(height: 10),
                      Text('$userName2',
                        style: TextStyle(color: Colors.white, fontSize: 30, fontFamily: 'Comfortaa', fontWeight: FontWeight.bold),
                      )
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.fromLTRB(8,0,8,0),
                  child: Container(
                    decoration: BoxDecoration(
                        border: Border(bottom: BorderSide(color: Colors.grey))
                    ),
                    child: InkWell(
                      onTap: (){},
                      child: Container(
                        height: 45,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Row(
                              children: [
                                Icon(Icons.person,color: Colors.black),
                                Padding(
                                  padding: const EdgeInsets.all(8),
                                  child: Text('Profile',
                                    style: TextStyle(fontSize: 19, fontFamily: 'Comfortaa', color: Colors.black, fontWeight: FontWeight.bold),
                                  ),
                                )
                              ],
                            ),
                            Icon(Icons.arrow_forward_ios,color: Colors.black)
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.fromLTRB(8,0,8,0),
                  child: Container(
                    decoration: BoxDecoration(
                        border: Border(bottom: BorderSide(color: Colors.grey))
                    ),
                    child: InkWell(
                      onTap: (){},
                      child: Container(
                        height: 45,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Row(
                              children: [
                                Icon(Icons.settings,color: Colors.black),
                                Padding(
                                  padding: const EdgeInsets.all(8),
                                  child: Text('Settings',
                                    style: TextStyle(fontSize: 19, fontFamily: 'Comfortaa', fontWeight: FontWeight.bold, color: Colors.black),
                                  ),
                                )
                              ],
                            ),
                            Icon(Icons.arrow_forward_ios,color: Colors.black)
                          ],
                        ),
                      ),
                    ),
                  ),
                )
              ],
            ),
          ),
        ),
        body: Body(userName3:userName2),
      ),
    );
  }
}

class Body extends StatefulWidget {
  final String userName3;
  Body({@required this.userName3});
  @override
  _BodyState createState() => _BodyState(
      userName:userName3
  );
}

class _BodyState extends State<Body> {
  final String userName;
  _BodyState({@required this.userName});
  final Strategy strategy = Strategy.P2P_STAR;
  String cId = "0";
  File tempFile;
  Map<int, String> map = Map();
  bool pressed = false, pressedRec = false;
  int index;
  String encFilepath,aesFilepath,directory,decFilepath;
  var crypt = AesCrypt('my cool password');
  // ignore: deprecated_member_use
  List file = new List();

  List data;

  @override
  void initState() {
    super.initState();
    fetch_data_from_api();
  }

  Future<String> fetch_data_from_api() async {
    var jsondata = await http.get(Uri.parse("http://newsapi.org/v2/everything?q=tech&apiKey=0b0b712f35b54dae9b147f3105cf60cc"));
    var fetchdata = jsonDecode(jsondata.body);
    setState(() {
      data = fetchdata["articles"];
    });
    return "Success";
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            SizedBox(height: 50),
            Text('Share everything',
                style: TextStyle(fontSize: 30.0, fontFamily: 'Comfortaa', fontWeight: FontWeight.bold, color: Colors.black)
            ),
            SizedBox(height: 10),
            Text('For everyone',
                style: TextStyle(fontSize: 28, fontFamily: 'Comfortaa', color: Colors.black)
            ),
            SizedBox(height: 50),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                    primary: Color(0xFF667eea),
                    elevation: 2,
                  ),
                  child: Container(
                    height: MediaQuery.of(context).size.height * 0.17,
                    width: MediaQuery.of(context).size.width * 0.35,
                    child: Stack(
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(top: 30.0,left: 15.0),
                          child: Container(
                            height: 40.0,
                            width: 40.0,
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(20.0),
                                color: Colors.white,
                                image: DecorationImage(image: AssetImage('assets/sendArrow.jpeg')),
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.black,
                                    blurRadius: 18.0, // soften the shadow
                                    spreadRadius: 1.0, //extend the shadow
                                    offset: Offset(6,7),
                                  )
                                ]
                            ),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(left: 15.0,top: 80.0),
                          child: Text('Send',
                              style: TextStyle(fontSize: 20.0, fontFamily: 'Comfortaa', color: Colors.black)
                          ),
                        )
                      ],
                    ),
                  ),
                  onPressed: () async {
                    if (await Permission.location.isGranted && await Nearby().enableLocationServices() && await Permission.storage.isGranted) {
                      setState(() {
                        pressed = true;
                        pressedRec = false;
                      });
                      try {
                        await Nearby().startDiscovery(
                          userName,
                          strategy,
                          onEndpointFound: (id, name, serviceId) {
                            showModalBottomSheet(
                              context: context,
                              builder: (builder) {
                                return Center(
                                  child: Column(
                                    children: <Widget>[
                                      SizedBox(height: 20),
                                      Text("Username: " + name,
                                        style: TextStyle(fontFamily: 'Comfortaa',fontSize: 15.0),
                                      ),
                                      SizedBox(height: 40),
                                      ElevatedButton(
                                        style: ElevatedButton.styleFrom(
                                          primary: Color(0xFF764ba2),
                                        ),
                                        child: Text("Request Connection",
                                          style: TextStyle(fontFamily: 'Comfortaa',fontSize: 15.0,color: Colors.white),
                                        ),
                                        onPressed: () {
                                          Navigator.pop(context);
                                          Nearby().requestConnection(
                                            userName,
                                            id,
                                            onConnectionInitiated: (id, info) {
                                              onConnectionInit(id, info);
                                            },
                                            onConnectionResult: (id, status) {
                                              showSnackbar(status);
                                            },
                                            onDisconnected: (id) {
                                              showSnackbar(id);
                                            },
                                          );
                                        },
                                      ),
                                    ],
                                  ),
                                );
                              },
                            );
                          },
                          onEndpointLost: (id) {
                            showSnackbar("Lost Endpoint:" + id);
                          },
                        );
                        showSnackbar("Searching for user..." );
                      } catch (e) {
                        showSnackbar(e);
                      }
                    }
                    else if(await Permission.location.isDenied || await Permission.storage.isDenied){
                      Map<Permission, PermissionStatus> statuses = await [
                        Permission.storage,
                        Permission.location
                      ].request();
                      await Nearby().enableLocationServices();
                      print(statuses);
                    }
                    else if (await Permission.location.isPermanentlyDenied || await Permission.storage.isPermanentlyDenied){
                      showDialog(context: context,
                          builder: (BuildContext context){
                            return Theme(
                                data: ThemeData(dialogBackgroundColor: Colors.white),
                                child: CupertinoAlertDialog(
                                  title: Text('Permissions Required'),
                                  content: Text('This app needs permission. You can grant them in app settings.'),
                                  actions: [
                                    CupertinoDialogAction(
                                      child: Text('Settings'),
                                      onPressed: (){
                                        openAppSettings();
                                        Navigator.of(context).pop();
                                      },
                                    ),
                                    CupertinoDialogAction(
                                      child: Text('Cancel'),
                                      onPressed: () => Navigator.of(context).pop(),
                                    ),
                                  ],
                                )
                            );
                          }
                      );
                    }
                  },
                ),
                SizedBox(width: 10),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                    primary: Color(0xFF764ba2),
                    elevation: 2,
                  ),
                  child: Container(
                    height: MediaQuery.of(context).size.height * 0.17,
                    width: MediaQuery.of(context).size.width * 0.35,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(20.0),
                    ),
                    child: Stack(
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(top: 30.0,left: 15.0),
                          child: Container(
                            height: 40.0,
                            width: 40.0,
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(20.0),
                                color: Colors.white,
                                image: DecorationImage(
                                  image: AssetImage('assets/receiveArrow.jpeg'),
                                ),
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.black,
                                    blurRadius: 18.0, // soften the shadow
                                    spreadRadius: 1.0, //extend the shadow
                                    offset: Offset(6.0,7.0),
                                  )
                                ]
                            ),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(left: 15.0,top: 80.0),
                          child: Text('Receive',
                              style: TextStyle(fontSize: 20.0, fontFamily: 'Comfortaa', color: Colors.black)
                          ),
                        )
                      ],
                    ),
                  ),
                  onPressed: () async {
                    if (await Permission.location.isGranted && await Nearby().enableLocationServices() && await Permission.storage.isGranted) {
                      setState(() {
                        pressed = false;
                        pressedRec = true;
                      });
                      try {
                        await Nearby().startAdvertising(
                          userName,
                          strategy,
                          onConnectionInitiated: onConnectionInit,
                          onConnectionResult: (id, status) {
                            showSnackbar(status);
                          },
                          onDisconnected: (id) {
                            showSnackbar("Disconnected: " + id);
                          },
                        );
                        showSnackbar("Hosting connection...");
                      } catch (exception) {
                        showSnackbar(exception);
                      }
                    }
                    else if(await Permission.location.isDenied || await Permission.storage.isDenied){
                      Map<Permission, PermissionStatus> statuses = await [
                        Permission.storage,
                        Permission.location
                      ].request();
                      await Nearby().enableLocationServices();
                      print(statuses);
                    }
                    else if (await Permission.location.isPermanentlyDenied || await Permission.storage.isPermanentlyDenied){
                      showDialog(context: context,
                          builder: (BuildContext context){
                            return Theme(
                                data: ThemeData(dialogBackgroundColor: Colors.white),
                                child: CupertinoAlertDialog(
                                  title: Text('Permissions Required'),
                                  content: Text('This app needs permission. You can grant them in app settings.'),
                                  actions: [
                                    CupertinoDialogAction(
                                      child: Text('Settings'),
                                      onPressed: (){
                                        openAppSettings();
                                        Navigator.of(context).pop();
                                      },
                                    ),
                                    CupertinoDialogAction(
                                      child: Text('Cancel'),
                                      onPressed: () => Navigator.of(context).pop(),
                                    ),
                                  ],
                                )
                            );
                          }
                      );
                    }
                  },
                ),
              ],
            ),
            SizedBox(height: 30),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                pressed? GestureDetector(
                  onTap: () async {
                    List<File> files = await FilePicker.getMultiFile(type: FileType.any,);
                    for(int i=0;i<files.length;i++) {
                      encFilepath = files[i].path;
                      crypt.setOverwriteMode(AesCryptOwMode.on);
                      try {
                        aesFilepath = await crypt.encryptFile(encFilepath);
                        print('The encryption has been completed successfully.');
                        print('Encrypted file: $aesFilepath');
                      } on AesCryptException catch (e) {
                        if (e.type == AesCryptExceptionType.destFileExists) {
                          print('The encryption has been completed unsuccessfully.');
                          print(e.message);
                        }
                        return;
                      }
                      int payloadId = await Nearby().sendFilePayload(cId, aesFilepath);
                      showSnackbar("Sending file");
                      Nearby().sendBytesPayload(
                          cId,
                          Uint8List.fromList(
                              "$payloadId:${files[i].path
                                  .split('/')
                                  .last}".codeUnits
                          )
                      );
                    }
                  },
                  child: Container(
                    height: 50,
                    width: MediaQuery.of(context).size.width*0.4,
                    alignment: Alignment.center,
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(20.0),
                        gradient: LinearGradient(
                            begin: Alignment.topLeft,
                            end: Alignment.bottomRight,
                            colors: <Color>[Color(0xFF667eea), Color(0xFF764ba2)]
                        )
                    ),
                    child: Text("Send File",
                        style: TextStyle(fontSize: 20.0, fontFamily: 'Comfortaa', color: Colors.white)
                    ),
                  ),
                ) : SizedBox(),
                pressed? GestureDetector(
                  onTap: () async {
                    PickedFile file =  await ImagePicker().getImage(source: ImageSource.camera);
                    encFilepath = file.path;
                    crypt.setOverwriteMode(AesCryptOwMode.on);
                    try {
                      aesFilepath = await crypt.encryptFile(encFilepath);
                      print('The encryption has been completed successfully.');
                      print('Encrypted file: $aesFilepath');
                    } on AesCryptException catch (e) {
                      if (e.type == AesCryptExceptionType.destFileExists) {
                        print('The encryption has been completed unsuccessfully.');
                        print(e.message);
                      }
                      return;
                    }
                    int payloadId = await Nearby().sendFilePayload(cId, aesFilepath);
                    showSnackbar("Sending file");
                    Nearby().sendBytesPayload(
                        cId,
                        Uint8List.fromList(
                            "$payloadId:${file.path
                                .split('/')
                                .last}".codeUnits
                        )
                    );
                  },
                  child: Container(
                    height: 50,
                    width: MediaQuery.of(context).size.width*0.4,
                    alignment: Alignment.center,
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(20.0),
                        gradient: LinearGradient(
                            begin: Alignment.topLeft,
                            end: Alignment.bottomRight,
                            colors: <Color>[Color(0xFF667eea), Color(0xFF764ba2)]
                        )
                    ),
                    child: Text("Send from \n  Camera",
                        style: TextStyle(fontSize: 20.0, fontFamily: 'Comfortaa', color: Colors.white)
                    ),
                  ),
                ) : SizedBox(),
              ],
            ),
            pressedRec? GestureDetector(
              onTap: () async {
                directory = '/storage/emulated/0/Download/Nearby';
                file = io.Directory("$directory").listSync();
                String s;
                String ext;

                for(int i = 0; i < file.length; i++)
                {
                  String newPath = file[i].path + '.aes';
                  print(newPath);
                  file[i]=file[i].renameSync(newPath);
                  s = file[i].path;
                  ext = file[i].path;
                  s = s.substring(s.lastIndexOf("/") + 1,s.indexOf("."));
                  ext = ext.substring(ext.indexOf(".")+1,ext.lastIndexOf("."));
                  crypt.setOverwriteMode(AesCryptOwMode.on);
                  try {
                    decFilepath = directory;
                    decFilepath =  await crypt.decryptFile(file[i].path, '$decFilepath/$s.$ext');
                    file[i].delete();
                  }
                  on AesCryptException catch (e) {
                    if (e.type == AesCryptExceptionType.destFileExists) {
                      print(e.message);
                    }
                  }
                }

              },
              child: Container(
                height: 50,
                alignment: Alignment.center,
                width: 300,
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(20.0),
                    gradient: LinearGradient(
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                        colors: <Color>[Color(0xFF667eea), Color(0xFF764ba2)]
                    )
                ),
                child: Text("Decrypt",
                    style: TextStyle(fontSize: 20.0, fontFamily: 'Comfortaa', color: Colors.white)
                ),
              ),
            ) : SizedBox(),
            SizedBox(height: 30),
            SizedBox(
              height: 600,
              child: Swiper(
                itemBuilder: (BuildContext context, int index) {
                  return InkWell(
                    onTap: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => DetailsPage(
                                author: data[index]["author"],
                                title: data[index]["title"],
                                description: data[index]["description"],
                                urlToImage: data[index]["urlToImage"],
                                publishedAt: data[index]["publishedAt"],
                              )));
                    },
                    child: Stack(
                      children: <Widget>[
                        ClipRRect(
                          borderRadius: BorderRadius.only(
                            topLeft: Radius.circular(35.0),
                            topRight: Radius.circular(35.0),
                          ),
                          child: Image.network(
                            data[index]["urlToImage"],
                            fit: BoxFit.cover,
                            height: 350.0,
                          ),
                        ),
                        Padding(
                          padding: EdgeInsets.fromLTRB(0.0, 300.0, 0.0, 0.0),
                          child: Container(
                            height: 180.0,
                            width: 400.0,
                            child: Material(
                              borderRadius: BorderRadius.circular(35.0),
                              elevation: 10.0,
                              child: Column(
                                children: <Widget>[
                                  Padding(
                                    padding: EdgeInsets.fromLTRB(
                                        20.0, 20.0, 10.0, 10.0),
                                    child: Text(
                                      data[index]["title"],
                                      style: TextStyle(
                                        fontSize: 25.0,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  )
                                ],
                              ),
                            ),
                          ),
                        )
                      ],
                    ),
                  );
                },
                itemCount: data == null ? 0 : data.length,
                viewportFraction: 0.8,
                scale: 0.9,

              ),
            )
          ],
        ),
      ),
    );
  }
  void showSnackbar(dynamic a) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      content: Text(a.toString()),
    ));
  }
  void onConnectionInit(String id, ConnectionInfo info) {
    showModalBottomSheet(
      context: context,
      builder: (builder) {
        return Center(
          child: Column(
            children: <Widget>[
              SizedBox(
                height: 20.0,
              ),
              Text("Token: " + info.authenticationToken,
                  style: TextStyle(fontSize: 20.0, fontFamily: 'Comfortaa', color: Colors.black)
              ),
              Text("Username: " + info.endpointName,
                  style: TextStyle(fontSize: 20.0, fontFamily: 'Comfortaa', color: Colors.black)
              ),
              SizedBox(
                height: 40.0,
              ),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  primary: Color(0xFF764ba2),
                ),
                child: Text("Accept Connection",
                    style: TextStyle(fontSize: 15.0, fontFamily: 'Comfortaa', color: Colors.white)
                ),
                onPressed: () {
                  Navigator.pop(context);
                  cId = id;
                  Nearby().acceptConnection(
                    id,
                    onPayLoadRecieved: (endid, payload) async {
                      if (payload.type == PayloadType.BYTES) {
                        String str = String.fromCharCodes(payload.bytes);
                        showSnackbar(endid + ": " + str);

                        if (str.contains(':')) {
                          int payloadId = int.parse(str.split(':')[0]);
                          String fileName = (str.split(':')[1]);

                          if (map.containsKey(payloadId)) {
                            if (await tempFile.exists()) {
                              tempFile.rename(
                                  tempFile.parent.path + "/" + fileName);
                            } else {
                              showSnackbar("File doesn't exist");
                            }
                          } else {
                            map[payloadId] = fileName;
                          }
                        }
                      }
                      else if (payload.type == PayloadType.FILE) {
                        showSnackbar("File transfer started");
                        tempFile = File(payload.filePath);
                      }
                    },
                    onPayloadTransferUpdate: (endid, payloadTransferUpdate) {
                      if (payloadTransferUpdate.status ==
                          PayloadStatus.IN_PROGRRESS) {
                        print(payloadTransferUpdate.bytesTransferred);
                      } else if (payloadTransferUpdate.status ==
                          PayloadStatus.FAILURE) {
                        showSnackbar("Failed to transfer file");
                      } else if (payloadTransferUpdate.status ==
                          PayloadStatus.SUCCESS) {
                        showSnackbar("Success");
                        if (map.containsKey(payloadTransferUpdate.id)) {
                          String name = map[payloadTransferUpdate.id];
                          tempFile.rename(tempFile.parent.path + "/" + name);
                        } else {
                          map[payloadTransferUpdate.id] = "";
                        }
                      }
                    },
                  );
                },
              ),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  primary: Color(0xFF764ba2),
                ),
                child: Text("Reject Connection",
                    style: TextStyle(fontSize: 15.0, fontFamily: 'Comfortaa', color: Colors.white)
                ),
                onPressed: () async {
                  Navigator.pop(context);
                  try {
                    await Nearby().rejectConnection(id);
                  } catch (e) {
                    showSnackbar(e);
                  }
                },
              ),
            ],
          ),
        );
      },
    );
  }
}

class DetailsPage extends StatefulWidget {
  String title, author, urlToImage, publishedAt, description;

  DetailsPage(
      {this.title,
        this.author,
        this.description,
        this.publishedAt,
        this.urlToImage});

  @override
  _DetailsPageState createState() => _DetailsPageState();
}

class _DetailsPageState extends State<DetailsPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        flexibleSpace: Container(
          decoration: BoxDecoration(
              gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: <Color>[Color(0xFF667eea), Color(0xFF764ba2)]
              )
          ),
        ),
        title: Text('File Transfer',
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 23, fontFamily: 'Comfortaa'),
        ),
        elevation: 0,
        backgroundColor: Colors.white,
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        scrollDirection: Axis.vertical,
        child: Column(
          children: <Widget>[
            Image.network(
              widget.urlToImage,
              fit: BoxFit.cover,
              width: MediaQuery.of(context).size.width,
              height: MediaQuery.of(context).size.height * 0.5,
            ),
            Container(
              height: MediaQuery.of(context).size.height,
              width: MediaQuery.of(context).size.width,
              child: Material(
                borderRadius: BorderRadius.circular(35.0),
                child: Column(
                  children: <Widget>[
                    Padding(
                      padding: EdgeInsets.fromLTRB(20.0, 20.0, 20.0, 20.0),
                      child: Text(
                        widget.title,
                        style: TextStyle(
                          fontSize: 30.0,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    Text(
                      widget.publishedAt.substring(0, 10),
                      style: TextStyle(
                        fontSize: 20.0,
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.all(20.0),
                      child: Text(
                        widget.description,
                        style: TextStyle(
                          fontSize: 25.0,
                        ),
                      ),
                    ),
                    Text(
                      widget.author,
                      style: TextStyle(
                        fontSize: 15.0,
                      ),
                    ),
                  ],
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}