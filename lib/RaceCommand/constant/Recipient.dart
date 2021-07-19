class Recipient {
  static final int Agent = 0x01;
  static final int Partner = (0x01 << 1);
  static final int Twin = (Agent | Partner);
  static final int SP = (0x01 << 7);
  static final int DontCare = 0xFF;
}
