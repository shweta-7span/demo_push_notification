// handles data payload from fcm
class PushData {
  PushData({
    this.dataTitle,
    this.dataBody,
    this.dataRedirect,
  });

  String? dataTitle;
  String? dataBody;
  String? dataRedirect;

  PushData.fromJson(Map<String, dynamic> data) {
    dataTitle = data['title'];
    dataBody = data['body'];
    dataRedirect = data['redirect'];
  }
}
