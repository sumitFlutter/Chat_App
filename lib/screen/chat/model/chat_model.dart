class ChatModel{
  String?msg,time,date,uid,id;

  ChatModel({ this.msg, this.time, this.date,this.uid,this.id});
  factory ChatModel.mapToModel(Map m1, String id)
  {
    return ChatModel(time:m1['time'] ,msg: m1['msg'] ,date:m1['date'],uid:m1['uid'] ,id:m1['id']);
  }
}