import unittest, endians

import nimwkb

suite "common tests":
  test "Endianness and WkbByteOrder":
    check littleEndian == wkbNDR
    check bigEndian == wkbXDR

  test "convert uint32 to Byte":
    let x = 4326'u32
    check x.toByte(wkbNDR) == [0xE6'u8, 0x10'u8, 0x00'u8, 0x00'u8]
    check x.toByte(wkbXDR) == [0x00'u8, 0x00'u8, 0x10'u8, 0xE6'u8]

  test "bytehex":
    let b = 0xE6.byte
    check bytehex(b) == "E6"

  # test "toHex":
  #   let i = 4326
  #   check i.toHex(8, wkbNDR) == "E6100000"

  # test "toHex(f: float64, len: Positive): string":
  #   let f = 1.0'f64
  #   check f.toHex(16) == "000000000000F03F"
