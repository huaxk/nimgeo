import unittest, endians

import geometry

suite "common tests":
  test "Endianness and WkbByteOrder comparison operation":
    check littleEndian == wkbNDR
    check bigEndian == wkbXDR
