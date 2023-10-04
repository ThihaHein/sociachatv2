import 'dart:io';

import 'package:camera/camera.dart';
import 'package:file_picker/file_picker.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:sociachatv2/Functions/cameraFunction.dart';
import 'package:sociachatv2/designs/customDesigns/customNavigationBar.dart';
import 'package:sociachatv2/models/posts/postConfig.dart';

import '../../designs/resources/style.dart';
class PostUpload extends StatefulWidget {

  @override
  State<PostUpload> createState() => _PostUploadState();
}

class _PostUploadState extends State<PostUpload>with SingleTickerProviderStateMixin  {
  User? user = FirebaseAuth.instance.currentUser;
  bool isStory = false;
  bool isPost = true;
  bool isExpanded = false;
  List<String> _imagePath = [];
  List<XFile> selectedImages = [];
  TextEditingController descriptionController = TextEditingController();
 String videoPath = '';
   late CameraController _controller;
  late List<CameraDescription> _cameras;
  XFile? photo;

  late AnimationController _animationController;
  Future<String?> getUserImage()async{
    String? userImage = user!.photoURL;
    return userImage;
  }
void animateButton() {
    setState(() {
      isExpanded = !isExpanded;
    });
}

  Future<void> pickImages() async {
    List<XFile>? pickedImages = await ImagePicker().pickMultiImage();

    if (pickedImages != null) {
      setState(() {
        selectedImages.addAll(pickedImages);
      });
    }
  }


@override
void initState() {
    // TODO: implement initState
  initializeCamera();
  _animationController = AnimationController(
    vsync: this,
    duration: Duration(milliseconds: 500),
  );
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final double targetAspectRatio = _controller.value.aspectRatio;
    final double screenHeight = MediaQuery.of(context).size.height;
    final double cameraHeight = screenHeight;
    final double cameraWidth = cameraHeight * targetAspectRatio;

    return SafeArea(
        child: Scaffold(
          backgroundColor: kBgColor,
          body: Column(
            children: [
              Padding(
                padding: const EdgeInsets.only(left: 20.0,top: 20,right: 20),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text('Discard', style: kNanumGothicBold.copyWith(color: kBlue, fontSize: 14),),
                    Text('Create'.toUpperCase(), style: kNanumGothicBold.copyWith(color: kWhite, fontSize: 14),),
                    SizedBox(
                      width: 70,
                      height: 24,
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(backgroundColor: kPink, shape: const StadiumBorder(),),
                        onPressed: () async{
                          showDialog(
                            context: context,
                            barrierDismissible: false,
                            builder: (BuildContext context) {
                              return  Center(
                                child: Container(
                                  padding: EdgeInsets.all(20),
                                  decoration: BoxDecoration(
                                    color: kDarkGrey.withOpacity(0.5),
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.center,
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      CircularProgressIndicator(color: kLightGrey,backgroundColor: kGrey,),
                                      SizedBox(height: 20),
                                      Text('Uploading...',style: kNanumGothicSemiBold.copyWith(color: kWhite),),
                                    ],
                                  ),
                                ),
                              );
                            },
                          );
                          await PostConfig().uploadPost(descriptionController.text,selectedImages, videoPath);
                          Navigator.push(context, (MaterialPageRoute(builder: (context)=>CustomNavigationBar())));
                        },
                        child: Text('Publish',style: kNanumGothicBold.copyWith(fontSize: 11),),
                      ),
                    ),
                  ],
                ),
              ),
              if(isPost)
              Expanded(
                child: SingleChildScrollView(
                  physics: BouncingScrollPhysics(),
                  child: Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(20),
                    child: Column(
                      children: [
                        const SizedBox(height: 40,),
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                          CircleAvatar(foregroundImage: NetworkImage(user!.photoURL??''),),
                          const SizedBox(width: 20,),
                          Expanded(
                            child: SizedBox(
                              width: 240,
                              height:100,
                              child: TextFormField(
                                controller: descriptionController,
                                   style: TextStyle(color: kWhite),
                                  cursorColor: kGrey,
                                  keyboardType:  TextInputType.multiline,
                                  maxLines: null,
                                  expands: true,
                                  scrollPhysics: BouncingScrollPhysics(),
                                  decoration: const InputDecoration(

                                    hintText: 'What\'s on your mind?',
                                    hintStyle: TextStyle(color: kDarkGrey, fontSize: 16),
                                    focusColor: Colors.transparent,
                                    border: InputBorder.none,
                                  ),
                                ),
                            ),
                          )
                          ],
                        ),
                        const SizedBox(height: 10,),
                        if(selectedImages.isNotEmpty)
                          Padding(
                            padding: const EdgeInsets.only(bottom: 10.0),
                            child: Stack(
                              children:[ SizedBox(
                                width: 300,
                                height: 300,
                                child: ClipRRect(
                                  borderRadius: BorderRadius.circular(20),
                                  child: GridView.builder(
                                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                                      crossAxisCount: 3,
                                      mainAxisSpacing: 4,
                                      crossAxisSpacing: 4,
                                    ),
                                    itemCount: selectedImages.length>9 ? 9:  selectedImages.length,
                                    shrinkWrap: true,
                                    physics: NeverScrollableScrollPhysics(),
                                    itemBuilder: (context, index) {
                                      return Stack(
                                        children:[ SizedBox(
                                          width:100,
                                          child:GestureDetector(
                                            onTap: () {
                                              showDialog(
                                                context: context,
                                                builder: (BuildContext context) {
                                                  return AlertDialog(
                                                    backgroundColor: Colors.transparent,
                                                    content: Container(
                                                      width: MediaQuery.of(context).size.width,
                                                      height: MediaQuery.of(context).size.height * 0.6,
                                                      child: Hero(
                                                        tag: 'image_$index',
                                                        child: Image.file(
                                                          File(selectedImages[index].path),
                                                          fit: BoxFit.contain,
                                                        ),
                                                      ),
                                                    ),
                                                  );
                                                },
                                              );
                                            },
                                            child: Hero(
                                              tag: 'image_$index', // Use the same tag as in the dialog
                                              child: Image.file(
                                                File(selectedImages[index].path),
                                                fit: BoxFit.cover,
                                              ),
                                            ),
                                          ),

                                        ),
                                          Positioned(
                                            top: 5,
                                            right: 5,
                                            child: GestureDetector(
                                              onTap: (){
                                                setState(() {
                                                  selectedImages.removeAt(index);
                                                });
                                              },
                                              child: Icon( Icons.remove_circle_outline,color: kBlack,size: 20,),
                                            ),
                                          ),
                                        ]
                                      );
                                    },
                                  ),
                                ),
                              ),
                ]
                            ),
                          ),
                        Row(
                          children: [
                            Align(
                              alignment: Alignment.centerLeft,
                              child: GestureDetector(
                                onTap: animateButton,
                                child: Container(
                                  width: 30,
                                  height: 30,
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(20),
                                    border: Border.all(color: kDarkGrey,width: 0.4)
                                  ),
                                  child:  Icon( isExpanded ? Icons.close: Icons.add, color: kGrey,size: 20,),
                                ),
                              ),
                            ),
                            if(isExpanded)
                              SlideTransition(
                                  position: Tween<Offset>(
                                    begin:const Offset(0.2,0),
                                    end:Offset.zero
                                  ).animate(
                                      CurvedAnimation(
                                      parent: _animationController,
                                          curve: isExpanded ? Curves.bounceOut: Curves.bounceIn)),
                                child: Container(
                                  width: 150,
                                  padding: EdgeInsets.only(left: 12,right: 12,top: 5,bottom: 5),
                                  decoration: BoxDecoration(
                                    color: kDarkerGrey,
                                   borderRadius: BorderRadius.circular(20)
                                  ),
                                  child:  Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    children: [
                                        GestureDetector(
                                          onTap: pickImages,
                                            child: Icon(Icons.image_outlined, color: kWhite,)),
                                        Icon(Icons.gif_box_outlined, color: kWhite,),
                                        Icon(Icons.camera_alt_outlined, color: kWhite,),
                                        Icon(Icons.link, color: kWhite,),
                                    ],
                                  ),
                                ),
                              )
                          ],
                        ),
                        const SizedBox(height: 20,),
                      ],
                    ),
                  ),
                ),
              ),
              if(isStory)
              Padding(
                padding: const EdgeInsets.only(top: 20.0),
                child: Stack(
                    children:[
                      photo!= null? Image.file(File(photo!.path)):AspectRatio(
                        aspectRatio: 1/1.32,
                        child: CameraPreview(_controller),
                      ),
                  Positioned.fill(
                    bottom: 10,
                    child: Align(
                      alignment: Alignment.bottomCenter,
                      child: SizedBox(
                        width: 50,
                        height: 50,
                        child: GestureDetector(
                          onTap: takePicture,
                          child: Container(
                            decoration: BoxDecoration(
                              color: kDarkGrey,
                              borderRadius: BorderRadius.circular(30)
                            ),
                            child: Center(child: Icon(Icons.camera_rounded, color: kWhite,size: 42,)),
                          ),
                        )
                      ),
                    ),
                  )]),
              ),
              Spacer(),
              Padding(
                padding: const EdgeInsets.only(bottom: 10.0),
                child: Container(
                    padding: const EdgeInsets.all(5),
                    width: 170,
                    height: 35,
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(20),
                        border: Border.all(color: kDarkGrey,width: 0.4)
                    ),
                    child:  Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        ElevatedButton(
                          onPressed: (){
                            setState(() {
                              isPost = true;
                              isStory = false;
                            });
                          },
                          style: ElevatedButton.styleFrom(backgroundColor: isPost?kPink:Colors.transparent,elevation: 0.0,shape: const StadiumBorder()),
                          child: Text('POST',style: kNanumGothicBold.copyWith(color: kWhite),),),
                        ElevatedButton(
                            onPressed: (){
                              setState(() {
                                isPost = false;
                                isStory = true;
                              });
                            },
                            style: ElevatedButton.styleFrom(backgroundColor: isStory?kPink:Colors.transparent,elevation: 0.0,shape: const StadiumBorder()),
                            child: Text('STORY',style: kNanumGothicBold.copyWith(color: kWhite),)),
                      ],
                    )
                ),
              ),
            ],
          ),
        ));
  }
  Future<void> initializeCamera() async {
    List<CameraDescription> cameras = await availableCameras();
    CameraDescription selectedCamera = cameras[0];

    int sensorOrientation = await getCameraSensorOrientation(selectedCamera);

    _controller = CameraController(
      selectedCamera,
      ResolutionPreset.ultraHigh,
      enableAudio: false,
      imageFormatGroup: ImageFormatGroup.yuv420,
    );

    _controller.initialize().then((_) {
      if (!mounted) {
        return;
      }
      setState(() {});
    });
  }

  Future<int> getCameraSensorOrientation(CameraDescription camera) async {
    return 0;
  }
  Future<void> takePicture() async {
    try {
      if (_controller != null && _controller!.value.isInitialized) {
        final XFile takenPhoto = await _controller!.takePicture();
        setState(() {
          photo = takenPhoto;
        });
      }
    } catch (e) {
    print("Error capturing photo: $e");
    }
  }
  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }
}
