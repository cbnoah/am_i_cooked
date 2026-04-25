import 'dart:typed_data';

class PictureModel {
  int? id;
  Uint8List? imgBlob;
  String? altText;
  String? uploadedAt;

  PictureModel({this.id, this.imgBlob, this.altText, this.uploadedAt});

  PictureModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    imgBlob = json['img_blob'];
    altText = json['alt_text'];
    uploadedAt = json['uploaded_at'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['img_blob'] = imgBlob;
    data['alt_text'] = altText;
    data['uploaded_at'] = uploadedAt;
    return data;
  }
}
