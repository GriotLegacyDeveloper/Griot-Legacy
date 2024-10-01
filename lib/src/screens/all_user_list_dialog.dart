import 'package:flutter/material.dart';
import 'package:griot_legacy_social_media_app/size_config.dart';
import 'package:multi_select_item/multi_select_item.dart';

import '../controllers/post_controller.dart';
import '../models/alluserlistmodel.dart';
import '../models/selction_model.dart';

class AllUserListTribeDiloag extends StatefulWidget {
  final AllUserListTribeDiloagInterface mListenr;
  final AllUserListModel allUserData;
  final  List<SelectionModel> selctionList;

  const AllUserListTribeDiloag({Key key, this.mListenr, this.allUserData, this.selctionList,}) : super(key: key);

  @override
  _AllUserListTribeDiloagState createState() => _AllUserListTribeDiloagState();
}

class _AllUserListTribeDiloagState extends State<AllUserListTribeDiloag> {


  List selectedTribeName = [];
  List selectedTribeID = [];
  List items = [];
  //List itemsLocal = [];
  MultiSelectController multiSelectcontroller =  MultiSelectController();
  List multiSelectList = [];
  int indexLocal;
  PostController controller;

   List<SelectionModel> _selectedList =  <SelectionModel>[];


  bool loaderStatus = true;
  bool didGetResponse = false;
  //AllUserListModel allUserData;


  getAllUser() async {
 setState(() {
   for (var index = 0;
   index < widget.allUserData.responseData.data.length;
   index++) {
     multiSelectList.add({
       "images": widget.allUserData.responseData.data[index].profileImage,
       "desc": widget.allUserData.responseData.data[index].fullName
     });
   }
   multiSelectcontroller.disableEditingWhenNoneSelected = true;
   multiSelectcontroller.set(multiSelectList.length);
   _selectedList.addAll( widget.selctionList);
 });
   /* final state =
        context.findAncestorStateOfType<GetBuilderState<PostController>>() ??
            GetBuilderState<PostController>();
    controller = PostController(context, state);
    final prefs = await controller.sharedPrefs;
    final obj = {
      "userId": prefs.getString("spUserID"),
      "loginId": prefs.getString("spLoginID"),
      "appType": prefs.getString("spAppType"),
    };
    print(obj);
    controller.waitUntilGetAllUserList(obj).then((value) {
      setState(() {
        loaderStatus = true;
        allUserData = controller.allUserModelData;
        didGetResponse = true;
        for (var index = 0;
        index < allUserData.responseData.data.length;
        index++) {
          multiSelectList.add({
            "images": allUserData.responseData.data[index].profileImage,
            "desc": allUserData.responseData.data[index].fullName
          });
        }
        multiSelectcontroller.disableEditingWhenNoneSelected = true;
        multiSelectcontroller.set(multiSelectList.length);
      });
    });*/
  }

  void add() {
    multiSelectList.add({"images": multiSelectList.length});
    multiSelectList.add({"desc": multiSelectList.length});

    setState(() {
      multiSelectcontroller.set(multiSelectList.length);
    });
  }

  void delete() {
    var list = multiSelectcontroller.selectedIndexes;
    list.sort((b, a) => a.compareTo(b));
    list.forEach((element) {
      multiSelectList.removeAt(element);
    });

    setState(() {
      multiSelectcontroller.set(multiSelectList.length);
    });
  }

  void selectAll() {
    setState(() {
      multiSelectcontroller.toggleAll();
    });
  }



  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getAllUser();
   /* print("widget.allUserData.responseData.data.length  ${widget.allUserData.responseData.data.length}");*/
  }

  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);
    return  Scaffold(

      backgroundColor: Colors.transparent,
      body: Padding(
        padding:  EdgeInsets.only(left: SizeConfig.screenWidth*.1,
            right: SizeConfig.screenWidth*.1,top: SizeConfig.screenHeight*.03,
            bottom: SizeConfig.screenHeight*.03),
        child: Container(
              height: SizeConfig.screenHeight, // Change as per your requirement
              width: SizeConfig.screenWidth, // Change as per your requirement
          color: Colors.white,
               child:Column(
                 mainAxisSize: MainAxisSize.max,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                   Padding(
                     padding:  EdgeInsets.only(top: SizeConfig.screenHeight*.02),
                     child: Row(
                       mainAxisAlignment: MainAxisAlignment.center,
                       children: [
                         Text(
                          'Tribe User List',style: TextStyle(color: Colors.black,
                             fontWeight: FontWeight.w500,fontSize: SizeConfig.safeBlockHorizontal*5.0),),
                       ],
                     ),
                   ),

                  Expanded(

                    child: Padding(
                      padding:  EdgeInsets.only(top: SizeConfig.screenHeight*.01),
                      child: Container(
                        color: Colors.white,
                        margin: const EdgeInsets.only(left: 4, right: 4),
                        padding: const EdgeInsets.only(bottom: 16),
                        height: SizeConfig.screenHeight - 240,

                        //(allUserData.responseData.data.length * 60).toDouble()
                        //padding: EdgeInsets.all(12),
                        child: ListView.builder(
                          // shrinkWrap: true,
                          itemCount: widget.allUserData.responseData.data.length,
                          itemBuilder: (BuildContext context, int index) {
                            //print("isSelecte.... ${widget.allUserData.responseData.data[index].isSelected}");

                            return Padding(
                              padding:  EdgeInsets.only(top: 5),
                              child: Container(
                                color:  widget.allUserData
                                    .responseData.data[index].isSelected
                                //multiSelectcontroller.isSelected(index)
                                    ? Colors.grey.shade200
                                    : Colors.white,
                                height: 55,
                                child: GestureDetector(
                                  onTap: () {
                 /*                   print("isSelecte "
                                        "${widget.allUserData.responseData.data[index].isSelected}");*/
                                  /*  if(mounted) {
                                      setState(() {
                                        indexLocal=index;
                                        if (selectedTribeID.contains(widget.allUserData
                                            .responseData.data[index].userId)) {
                                          if(widget.allUserData.responseData.data[index].isSelected){
                                            print("iffffff");
                                            selectedTribeName.remove(widget.allUserData
                                                .responseData.data[index].fullName);
                                            items.remove(widget.allUserData
                                                .responseData.data[index].fullName);
                                            if(mounted) {
                                              setState(() {
                                                widget.allUserData.responseData.data[index].isSelected=false;
                                              });
                                            }
                                            selectedTribeID.remove(widget.allUserData
                                                .responseData.data[index].userId);

                                            print("itemsLocaliffff ${selectedTribeID.length}");


                                          }


                                        }
                                        else {
                                          print("elsssss");
                                          //multiSelectcontroller.isSelected(index);
                                          if(!widget.allUserData.responseData.data[index].isSelected){

                                            selectedTribeName.add(widget.allUserData
                                                .responseData.data[index].fullName);
                                            items.add(widget.allUserData
                                                .responseData.data[index].fullName);
                                            if(mounted) {
                                              setState(() {
                                                widget.allUserData.responseData.data[index].isSelected=true;
                                              });
                                            }

                                            selectedTribeID.add(widget.allUserData
                                                .responseData.data[index].userId);

                                            print("itemsLocalelsss ${selectedTribeID.length}");

                                          }

                                        }
                                        multiSelectcontroller.toggle(index);
                                      });
                                    }*/
                                    setState(() {
                                      indexLocal=index;
                                    });

                                    if(!widget.allUserData
                                        .responseData.data[index].isSelected) {
                                      _selectedList.add( SelectionModel(
                                          widget.allUserData
                                              .responseData.data[index].userId, widget.allUserData
                                          .responseData.data[index].fullName));
                                      if (mounted) {
                                        setState(() {
                                          widget.allUserData
                                              .responseData.data[index].isSelected = true;
                                        });
                                      }

                                    //  print("iffflooop    ${_selectedList}");




                                    }else {
                                    /*  if (mounted) {
                                        setState(() {
                                          widget.allUserData
                                              .responseData.data[index].isSelected = false;
                                        });
                                      }
                                      for (int i = 0; i < _selectedList.length;i++) {
                                        if (mounted) {
                                          setState(() {
                                            _selectedList.removeAt(i);
                                          });
                                        }
                                      }*/
                                      if(widget.allUserData.responseData.data.elementAt(index).isSelected){
                                        if (mounted) {
                                          setState(() {
                                            widget.allUserData
                                                .responseData.data[index]
                                                .isSelected = false;

                                          });
                                        }
                                      }
                                      for(int j = 0; j < _selectedList.length;j++) {
                                      if(_selectedList.elementAt(j).id==
                                          widget.allUserData.responseData.data.elementAt(index).userId){
                                        setState(() {
                                          _selectedList.removeAt(j);

                                        });
                                      }

                                      }






                                   /*   for (int i = 0; i < _selectedList.length;i++) {
                                        if (mounted) {
                                          setState(() {
                                            _selectedList.removeAt(index);
                                          });
                                        }
                                      }*/







                                    }



                                  },
                                  child: Row(
                                    children: [
                                      Stack(
                                        children: [
                                          Container(

                                            decoration: const BoxDecoration(
                                              //color: Colors.blue,
                                                shape: BoxShape.circle,
                                                image: DecorationImage(image: AssetImage('assets/images/dummy.jpeg'))
                                            ),
                                            height: SizeConfig.screenHeight * .07,
                                            width: SizeConfig.screenHeight * .07,
                                          ),
                                          Container(

                                            decoration:  BoxDecoration(
                                              //color: Colors.blue,
                                              shape: BoxShape.circle,
                                              image:  widget.allUserData.responseData
                                                  .data[index].profileImage!=null ?
                                              DecorationImage(image:  NetworkImage(widget.allUserData
                                                  .responseData.userImageUrl +
                                                  widget.allUserData.responseData
                                                      .data[index].profileImage),
                                                  fit: BoxFit.fitWidth
                                              ):DecorationImage(image: AssetImage("assets/images/dummy.jpeg")),

                                            ),
                                            height: SizeConfig.screenHeight * .07,
                                            width: SizeConfig.screenHeight * .07,
                                          ),
                                        ],
                                      ),

                                      const SizedBox(
                                        width: 12,
                                      ),
                                      Expanded(
                                          child: Text(widget.allUserData
                                              .responseData.data[index].fullName)),
                                    ],
                                  ),
                                ),
                              ),
                            );
                          },

                        ),
                      ),
                    ),
                  ),
                  Container(
                    margin: EdgeInsets.all(4),
                    child: MaterialButton(
                      color: Colors.black,
                      onPressed: () {
                        Navigator.of(context).pop();
                        widget.mListenr.addFunction(items,selectedTribeName,widget.allUserData,
                            _selectedList);
                      },
                      child: Text("Done",style: TextStyle(color: Colors.white),),
                    ),
                  )
                ],
              ),),
      ),
    );
  }
}
abstract class AllUserListTribeDiloagInterface{
  addFunction(list,selctTribName,AllUserListModel model, List<SelectionModel> multiSelect);
}
