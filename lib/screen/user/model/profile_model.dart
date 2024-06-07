class ProfileModel
{
  String?name,email,profile,number,uid;

  ProfileModel({this.name, this.email, this.profile, this.number,this.uid});

  factory ProfileModel.mapToModel(Map m1,String uid)
  {
    return ProfileModel(profile:m1['profile'] ,number:m1['number'] ,email:m1['email'] ,name:m1['name'] ,uid:uid );
  }
}