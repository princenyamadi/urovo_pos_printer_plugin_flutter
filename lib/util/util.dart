import 'package:flutter/services.dart';
import 'package:image/image.dart' as img;

class Utility {
  static String getDateTime() {
    DateTime now = DateTime.now();
    return now.toString();
  }

  // static Future<int?> getBitmap(ByteData imageBytes) async {
  //   List<int> values = imageBytes.buffer.asUint8List();
  //   img.Image? photo;
  //   photo = img.decodeImage(values);
  //   int pixel = photo!.getPixel(5, 0);
  //   return pixel;
  // }
}
