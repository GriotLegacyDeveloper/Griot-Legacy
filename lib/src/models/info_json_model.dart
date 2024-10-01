class InfoJsonModel {
  int id;
  //String profileImage;
  String fileName;

  InfoJsonModel({this.id,this.fileName,});

  InfoJsonModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    // profileImage = json['profileImage']!=null && json['profileImage']!="" ? "${GlobalConstants.imageLink}profile-pic/${json['profileImage']}" : "";
    fileName = json['fileName'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = id;
    //data['profileImage'] = this.profileImage;
    data['fileName'] = fileName;
    return data;
  }

}