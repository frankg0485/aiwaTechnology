import 'dart:core';
import 'dart:typed_data';

class Converter {
  static final String mChars = "0123456789ABCDEF";

  static int bytesToInt(int High, int Low) {
    int high = (High & 0xFF) << 8;
    int low = (Low & 0xFF);
    return (high + low);
  }

  static String byte2HexStrReverse(Int8List b) {
    StringBuffer sb = new StringBuffer();
    for (int n = b.length - 1; n >= 0; n--) {
      sb.write(mChars[(b[n] & 0xFF) >> 4]);
      sb.write(mChars[b[n] & 0x0F]);
      sb.write(' ');
    }

    return sb.toString().trim().toUpperCase();
  }
}
