class Helper {
  static int bytesToInt(int High, int Low) {
    int high = (High&0xFF) << 8;
    int low = (Low&0xFF);
    return (high + low);
  }
}