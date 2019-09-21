import unittest
import nimgeo/[geometry, wkbwriter]

include common

suite "utility procedure for writing to wkb ":
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

suite "Geometry to wkb hex":
  test "write Point to wkb":
    check pt.toWkb(wkbNDR) == wkbnpt
    check pt.toWkb(wkbXDR) == wkbxpt
    check spt.toWkb(wkbNDR) == wkbnspt
    check spt.toWkb(wkbXDR) == wkbxspt

  test "write Geometry Point to wkb":
    check ptGeometry.toWkb(wkbNDR) == wkbnpt
    check ptGeometry.toWkb(wkbXDR) == wkbxpt
    check sptGeometry.toWkb(wkbNDR) == wkbnspt
    check sptGeometry.toWkb(wkbXDR) == wkbxspt

  test "write LineString to wkb":
    check ls.toWkb(wkbNDR) == wkbnls
    check ls.toWkb(wkbXDR) == wkbxls
    check sls.toWkb(wkbNDR) == wkbnsls
    check sls.toWkb(wkbXDR) == wkbxsls

  test "write Geometry LineString to wkb":
    check lsGeometry.toWkb(wkbNDR) == wkbnls
    check lsGeometry.toWkb(wkbXDR) == wkbxls
    check slsGeometry.toWkb(wkbNDR) == wkbnsls
    check slsGeometry.toWkb(wkbXDR) == wkbxsls

  test "write LineString to wkb":
    check pg.toWkb(wkbNDR) == wkbnpg
    check pg.toWkb(wkbXDR) == wkbxpg
    check spg.toWkb(wkbNDR) == wkbnspg
    check spg.toWkb(wkbXDR) == wkbxspg

  test "write Geometry Polygon to wkb":
    check pgGeometry.toWkb(wkbNDR) == wkbnpg
    check pgGeometry.toWkb(wkbXDR) == wkbxpg
    check spgGeometry.toWkb(wkbNDR) == wkbnspg
    check spgGeometry.toWkb(wkbXDR) == wkbxspg

  test "write MultiPoint to wkb":
    check mpt.toWkb(wkbNDR) == wkbnmpt
    check mpt.toWkb(wkbXDR) == wkbxmpt
    check smpt.toWkb(wkbNDR) == wkbnsmpt
    check smpt.toWkb(wkbXDR) == wkbxsmpt

  test "write Geometry MultiPoint to wkb":
    check mptGeometry.toWkb(wkbNDR) == wkbnmpt
    check mptGeometry.toWkb(wkbXDR) == wkbxmpt
    check smptGeometry.toWkb(wkbNDR) == wkbnsmpt
    check smptGeometry.toWkb(wkbXDR) == wkbxsmpt

  test "write MultiLineString to wkb":
    check mls.toWkb(wkbNDR) == wkbnmls
    check mls.toWkb(wkbXDR) == wkbxmls
    check smls.toWkb(wkbNDR) == wkbnsmls
    check smls.toWkb(wkbXDR) == wkbxsmls

  test "write Geometry MultiLineString to wkb":
    check mlsGeometry.toWkb(wkbNDR) == wkbnmls
    check mlsGeometry.toWkb(wkbXDR) == wkbxmls
    check smlsGeometry.toWkb(wkbNDR) == wkbnsmls
    check smlsGeometry.toWkb(wkbXDR) == wkbxsmls
  
  test "write MultiPolygon to wkb":
    check mpg.toWkb(wkbNDR) == wkbnmpg
    check mpg.toWkb(wkbXDR) == wkbxmpg
    check smpg.toWkb(wkbNDR) == wkbnsmpg
    check smpg.toWkb(wkbXDR) == wkbxsmpg
  
  test "write Geometry MultiPolygon to wkb":
    check mpgGeometry.toWkb(wkbNDR) == wkbnmpg
    check mpgGeometry.toWkb(wkbXDR) == wkbxmpg
    check smpgGeometry.toWkb(wkbNDR) == wkbnsmpg
    check smpgGeometry.toWkb(wkbXDR) == wkbxsmpg

  test "write GeometryCollection to wkb":
    check gc.toWkb(wkbNDR) == wkbngc
    check gc.toWkb(wkbXDR) == wkbxgc

  test "write GeometryCollection to wkb":
    check gcGeometry.toWkb(wkbNDR) == wkbngc
    check gcGeometry.toWkb(wkbXDR) == wkbxgc