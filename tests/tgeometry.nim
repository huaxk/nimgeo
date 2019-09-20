import unittest, endians

import wkb/geometry

suite "common tests":
  test "Endianness and WkbByteOrder comparison operation":
    check littleEndian == wkbNDR
    check bigEndian == wkbXDR
