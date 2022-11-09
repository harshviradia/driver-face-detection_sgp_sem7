import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';
import 'dart:ui';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';

class UploadImageScreen extends StatefulWidget {
  const UploadImageScreen({Key? key}) : super(key: key);

  @override
  _UploadImageScreenState createState() => _UploadImageScreenState();
}

class _UploadImageScreenState extends State<UploadImageScreen> {

  final TextEditingController _controller_err = TextEditingController();
  final TextEditingController _controller_msg = TextEditingController();

  File? image ;
  var bytes;
  // late final pick_image ;
  final _picker = ImagePicker();
  bool showSpinner = false ;

  Future getImage()async{
    final pickedFile = await _picker.pickImage(source: ImageSource.gallery , imageQuality: 80);
    // pick_image=pickedFile;
    if(pickedFile!= null ){
      image = File(pickedFile.path);
      bytes = await File('image').readAsBytes();
      setState(() {

      });
    }else {
      print('no image selected');
    }
  }

  Future<void> uploadImage ()async{

    setState(() {
      showSpinner = true ;
    });
    var stream  = new http.ByteStream(image!.openRead());
    stream.cast();

    var length = await image!.length();

    // var uri = Uri.parse('https://583st1inq4.execute-api.us-east-1.amazonaws.com/ms/datas3');
    // var uri = Uri.parse('https://583st1inq4.execute-api.us-east-1.amazonaws.com/newTest/test-api');


    // PUT - Image to S3 Bucket
    String bucketname='reciver-bkt';
    String uploadIMGname='Upload1.jpg';
    String StageURL='https://rzdgmqv4f2.execute-api.us-east-1.amazonaws.com/v1/';

    var uri = Uri.parse(StageURL+bucketname+'/'+uploadIMGname);
    final http.Response response = await http.put(uri,
        headers: {'testsource':'testtoken','Content-Type': 'image/jpg','Accept': 'image/jpg'},body: image!.readAsBytesSync());

    var headers = {
      'testsource': 'testtoken',
      'Content-Type': 'image/jpg'
    };






    // final http.Response response = await http.put(
    //   uri,
    //   headers: {
    //     'Content-Type': 'image/jpg',
    //   },
    //   body: bytes
    //   // json.encode(<String,String>{"hello":"bye"})
    // );

    // var request = new http.MultipartRequest('POST', uri);
    // request.fields['title'] = "dummyImage";
    // request.headers['Authorization'] = "Datas3";
    // request.headers['content-type'] = "image/jpg";
    // request.headers['accept'] = "image/jpg";
    //
    // // request.headers['Connection'] = "keep-alive";
    //
    // var multiport = new http.MultipartFile(
    //     'image.jpg',
    //     stream,
    //     length);
    //
    // request.files.add(multiport);
    //
    // var response = await request.send() ;
    _controller_err.text="CODE: "+response.statusCode.toString();
    _controller_msg.text="MSG: "+response.reasonPhrase.toString();
    print(response.statusCode.toString() );
    print(response.reasonPhrase.toString() );


    if(response.statusCode == 200){
      setState(() {
        showSpinner = false ;
      });
      print(response.reasonPhrase.toString() );
      print('image uploaded');


    }else {
      print(response.reasonPhrase.toString() );
      print('failed');
      setState(() {
        showSpinner = false ;
      });

    }

  }

  @override
  Widget build(BuildContext context) {
    return ModalProgressHUD(
      inAsyncCall: showSpinner,
      child: Scaffold(
        appBar: AppBar(
          title: Text('Upload Image'),
        ),
        body: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            GestureDetector(
              onTap: (){
                getImage();
              },
              child: Container(
                child: image == null ? Center(child: Text('Pick Image'),)
              :
              Container(
                child: Center(
                  child:
                  Stack(
                    alignment: Alignment.center,
                    children: [
                      Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10),
                          color: Colors.greenAccent,
                          border: Border(
                            left: BorderSide(
                              color: Colors.green,
                              width: 3,
                            ),
                          ),
                        ),
                        height: 210,
                        width: 210,
                      ),
                      Image.file(
                        File(image!.path).absolute,
                        height: 200,
                        width: 200,
                        fit: BoxFit.cover,
                      ),
                    ],
                  )
                ),
              ),
              ),
            ),
            SizedBox(height: 50,),
            FlatButton(
              color: Colors.green,
              padding: const EdgeInsets.symmetric(vertical: 15,horizontal: 65),
              splashColor: Colors.redAccent,
              onPressed: () {
                uploadImage();
              },
              child: const Text(
                ' Upload',

                style: TextStyle(

                  color: Colors.white,
                  fontSize: 20
                ),
              ),
            ),
            SizedBox(height: 50,),
            TextField( controller: _controller_err,readOnly: true,textAlign: TextAlign.center,),
            SizedBox(height: 30,),
            TextField( controller: _controller_msg,readOnly: true,textAlign: TextAlign.center,),





          ],
        ),
      ),
    );
  }

  // Future _uploadImage(BuildContext context, int index, String type) async {
  //   try {
  //     var pickedImages=[],uploadedImages=[];
  //     var pickedFile;
  //     if (type == "gallery") {
  //       pickedFile = await _picker.pickImage(source: ImageSource.gallery);
  //     } else if (type == "camera") {
  //       pickedFile = await _picker.pickImage(source: ImageSource.camera);
  //     } else {
  //       print("option_type: $type");
  //       return;
  //     }
  //
  //     if (pickedFile == null) {
  //       return null;
  //     }
  //     var path=pickedFile.path;
  //     print("pickedFile: ${pickedFile.path}");
  //     var imageExt = path.extension(pickedFile.path);
  //     print("imageExt: $imageExt");
  //
  //     if (imageExt != '.jpg' && imageExt != '.jpeg' && imageExt != '.png') {
  //       return null;
  //     }
  //
  //     List<int> imageBytes = await pickedFile.readAsBytes();
  //     print("Bytes Image :::: $imageBytes");
  //     final Int8List int8array = Int8List.fromList(imageBytes);
  //     print("BLOB FILE ::::::: $int8array");
  //
  //     setState(() {
  //       pickedImages.add(pickedFile.path);
  //     });
  //
  //     String now = DateTime.now().toString().replaceAll(' ', '_');
  //     // String subName = "user_image_$now";
  //     String subName = "user_image_$now$imageExt";
  //
  //     uploadedImages.add(subName);
  //
  //     // String customPath = "${appDocDirectory.path}/Pictures/$subName$imageExt";
  //     // print("File path: $customPath");
  //     //
  //     // File tmpFile = File(pickedFile.path);
  //     // tmpFile = await tmpFile.copy(customPath);
  //
  //     /// Upload image to AWS
  //     store.dispatch(insAction.sendImageUrl(int8array, subName));
  //     // if(index>=0) {
  //     //   incidentImages[index] = path.basename(tmpFile.path);
  //     // }else {
  //     //   incidentImages.add(path.basename(tmpFile.path));
  //     // }
  //
  //   }catch(e) {
  //     print("Execption :: ${e.toString()}");
  //   }
  // }
  //
  // ThunkAction<AppState> sendImageUrl(Int8List uploadFileName, String imageName) {
  //   return (Store<AppState> store) async {
  //     print("UploadFileNAme: $uploadFileName \n uuid: $imageName");
  //     var getAwsUrl = await get(
  //       Uri.parse(
  //           'https://customer-dev.omnidya.com/api/s3/getUrlForS3FileUpload?objectKey=$imageName'),
  //       headers: <String, String>{
  //         'Content-Type': 'application/json',
  //       },
  //     );
  //     print('AWS Presigned URL Status Code : ' + getAwsUrl.statusCode.toString());
  //     print('AWS Presigned URL for PUT : ' + getAwsUrl.body.toString());
  //
  //     String loginToken = getAwsUrl.body;
  //     var imageUrl = loginToken.substring(1, loginToken.length - 1);
  //     var uri = Uri.parse(imageUrl);
  //     print("Final URL ::::::: $uri");
  //
  //     if (getAwsUrl.statusCode == 200) {
  //       var uploadImage = await put(uri,
  //           headers: <String, String>{
  //             'Content-Type': 'image/jpeg',
  //           },
  //           body: uploadFileName);
  //       print('AWS Upload Image Status Code : ' +
  //           uploadImage.statusCode.toString());
  //       print('AWS Upload Image Body : ' + uploadImage.body.toString());
  //     }
  //   };
  // }
}
