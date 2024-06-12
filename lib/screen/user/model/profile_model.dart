class ProfileModel
{
  String?name,email,about,number,uid;

  ProfileModel({this.name, this.email, this.about, this.number,this.uid});

  factory ProfileModel.mapToModel(Map m1,String uid)
  {
    return ProfileModel(about:m1['about'] ,number:m1['number'] ,email:m1['email'] ,name:m1['name'] ,uid:uid );
  }
}