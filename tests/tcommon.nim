import unittest, endians

import nimwkb

suite "common tests":
  test "Endianness and WkbByteOrder comparison operation":
    check littleEndian == wkbNDR
    check bigEndian == wkbXDR

  test "toByte: convert uint32 to byte":
    let x = 4326'u32
    check x.toByte(wkbNDR) == [0xE6'u8, 0x10, 0x00, 0x00]
    check x.toByte(wkbXDR) == [0x00'u8, 0x00, 0x10, 0xE6]

  test "toByte: convert float64 to byte":
    let x = 1.0'f64
    check x.toByte(wkbNDR) == [0x00'u8, 0x00, 0x00, 0x00,
                                  0x00, 0x00, 0xF0, 0x3F]
    check x.toByte(wkbXDR) == [0x3F'u8, 0xF0, 0x00, 0x00,
                                  0x00, 0x00, 0x00, 0x00]

  test "bytehex: convert byte to hex":
    let b = 0xE6.byte
    check bytehex(b) == "E6"

  test "toHex: convert seq[byte] to hex":
    let x = @[1'u8,
              1, 0, 0, 0,
              0, 0, 0, 0, 0, 0, 240, 63,
              0, 0, 0, 0, 0, 0, 0, 64]
    const s = "01"&
              "01000000"&
              "000000000000F03F"&
              "0000000000000040"
    check x.toHex == s
