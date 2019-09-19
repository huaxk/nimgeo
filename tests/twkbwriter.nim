import unittest
import geometry, wkbwriter

include common

suite "utility procedure":
  test "toByte: convert uint32 to byte":
    const x = 4326'u32
    const nuint32 = [0xE6'u8, 0x10, 0x00, 0x00]
    const xuint32 = [0x00'u8, 0x00, 0x10, 0xE6]
    check x.toByte(wkbNDR) == nuint32
    check x.toByte(wkbXDR) == xuint32

  test "toByte: convert float64 to byte":
    const x = 1.0'f64
    const nfloat64 = [0x00'u8, 0x00, 0x00, 0x00, 0x00, 0x00, 0xF0, 0x3F]
    const xfloat64 = [0x3F'u8, 0xF0, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00]
    check x.toByte(wkbNDR) == nfloat64
    check x.toByte(wkbXDR) == xfloat64

  test "toByte: convert Coord to byte":
    let coord = Coord(x: 1.0, y: 2.0)
    const ncoord = [0x00'u8, 0x00, 0x00, 0x00, 0x00, 0x00, 0xF0, 0x3F,
                       0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x40]
    const xcoord = [0x3F'u8, 0xF0, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00,
                       0x40, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00]
    check coord.toByte(wkbNDR) == ncoord
    check coord.toByte(wkbXDR) == xcoord

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


suite "Geometry to wkb hex using WkbWriter":
  test "convert Geometry Point to wkb":
    check ptGeometry.toWkb(wkbNDR) == wkbnpt
    check ptGeometry.toWkb(wkbXDR) == wkbxpt
    check sptGeometry.toWkb(wkbNDR) == wkbnspt
    check sptGeometry.toWkb(wkbXDR) == wkbxspt

  test "convert Geometry LineString to wkb":
    check lsGeometry.toWkb(wkbNDR) == wkbnls
    check lsGeometry.toWkb(wkbXDR) == wkbxls
    check slsGeometry.toWkb(wkbNDR) == wkbnsls
    check slsGeometry.toWkb(wkbXDR) == wkbxsls

  test "convert Geometry Polygon to wkb":
    check pgGeometry.toWkb(wkbNDR) == wkbnpg
    check pgGeometry.toWkb(wkbXDR) == wkbxpg
    check spgGeometry.toWkb(wkbNDR) == wkbnspg
    check spgGeometry.toWkb(wkbXDR) == wkbxspg

  test "convert Geometry MultiPoint to wkb":
    check mptGeometry.toWkb(wkbNDR) == wkbnmpt
    check mptGeometry.toWkb(wkbXDR) == wkbxmpt
    check smptGeometry.toWkb(wkbNDR) == wkbnsmpt
    check smptGeometry.toWkb(wkbXDR) == wkbxsmpt

  test "convert Geometry MultiLineString to wkb":
    check mlsGeometry.toWkb(wkbNDR) == wkbnmls
    check mlsGeometry.toWkb(wkbXDR) == wkbxmls
    check smlsGeometry.toWkb(wkbNDR) == wkbnsmls
    check smlsGeometry.toWkb(wkbXDR) == wkbxsmls
  
  test "convert Geometry MultiPolygon to wkb":
    check mpgGeometry.toWkb(wkbNDR) == wkbnmpg
    check mpgGeometry.toWkb(wkbXDR) == wkbxmpg
    check smpgGeometry.toWkb(wkbNDR) == wkbnsmpg
    check smpgGeometry.toWkb(wkbXDR) == wkbxsmpg