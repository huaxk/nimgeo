import unittest

import nimwkb

suite "common tests":
  # test "bytehex":
  #   let b = 0xE6.byte
  #   check bytehex(b) == "E6"

  test "toHex":
    let i = 4326
    check i.toHex(8, wkbNDR) == "E6100000"

  # test "toHex(f: float64, len: Positive): string":
  #   let f = 1.0'f64
  #   check f.toHex(16) == "000000000000F03F"