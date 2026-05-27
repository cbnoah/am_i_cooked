import 'dart:typed_data';
import 'dart:convert';

class PictureModel {
  int? id;
  Uint8List? imgBlob;
  String? altText;
  String? uploadedAt;
  int? width;
  int? height;

  PictureModel({this.id, this.imgBlob, this.altText, this.uploadedAt, this.width, this.height});

  PictureModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    final imgBlobData = json['img_blob'];
    if (imgBlobData is String) {
      imgBlob = base64Decode(imgBlobData);
    } else if (imgBlobData is Map && imgBlobData['type'] == 'Buffer') {
      imgBlob = Uint8List.fromList(List<int>.from(imgBlobData['data']));
    } else if (imgBlobData is List) {
      imgBlob = Uint8List.fromList(List<int>.from(imgBlobData));
    } else {
      imgBlob = null;
    }
    altText = json['alt_text'];
    uploadedAt = json['uploaded_at'];
    width = json['width'];
    height = json['height'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    if (imgBlob != null) {
      data['img_blob'] = base64Encode(imgBlob!);
    }
    data['alt_text'] = altText;
    data['uploaded_at'] = uploadedAt;
    data['width'] = width;
    data['height'] = height;
    return data;
  }
}
