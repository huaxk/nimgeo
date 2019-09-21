import unittest, endians

import nimgeo/geometry

const
  x = 1.0
  y = 2.0

suite "base test":
  test "Endianness and WkbByteOrder comparison operation":
    check littleEndian == wkbNDR
    check bigEndian == wkbXDR

  test "create Coord":
    var cd = newCoord(x, y)
    check cd.x == x
    check cd.y == y


let
  coords = @[newCoord(1.0, 1.0), newCoord(2.0, 2.0)]
  rings = @[
    @[newCoord(1.0, 1.0), newCoord(2.0, 2.0), newCoord(3.0, 3.0), newCoord(1.0, 1.0)],
    @[newCoord(4.0, 4.0), newCoord(5.0, 5.0), newCoord(6.0, 6.0), newCoord(4.0, 4.0)]
  ]
  points = @[newPoint(1.0, 1.0), newPoint(2.0, 2.0)]
  linestrings = @[
    newLineString(@[newCoord(1.0, 1.0), newCoord(2.0, 2.0)]),
    newLineString(@[newCoord(3.0, 3.0), newCoord(4.0, 4.0)])
  ]
  polygons = @[
    newPolygon(@[
      @[newCoord(1.0, 1.0), newCoord(2.0, 2.0), newCoord(3.0, 3.0), newCoord(1.0, 1.0)]
    ]),
    newPolygon(@[
      @[newCoord(4.0, 4.0), newCoord(5.0, 5.0), newCoord(6.0, 6.0), newCoord(4.0, 4.0)]
    ])
  ]
  gc = @[
    Geometry(kind: wkbPoint, pt: newPoint(x, y)),
    Geometry(kind: wkbLineString, ls: newLineString(coords)),
    Geometry(kind: wkbPolygon, pg: newPolygon(rings)),
    Geometry(kind: wkbMultiPoint, mpt: newMultiPoint(points)),
    Geometry(kind: wkbMultiLineString, mls: newMultiLineString(linestrings)),
    Geometry(kind: wkbMultiPolygon, mpg: newMultiPolygon(polygons))
  ]

suite "create geometry":
  test "create Point":
    var pt = newPoint(x, y)
    check pt.coord == newCoord(x, y)
    check pt.srid == 0

  test "create LineString":
    var ls = newLineString(coords)
    check ls.coords == coords
    check ls.srid == 0

  test "create Polygon":
    var pg = newPolygon(rings)
    check pg.rings == rings
    check pg.srid == 0
  
  test "create MultiPoint":
    var mpt = newMultiPoint(points)
    check mpt.points == points
    check mpt.srid == 0
  
  test "create MultiLineString":
    var mls = newMultiLineString(linestrings)
    check mls.linestrings == linestrings
    check mls.srid == 0

  test "create MultiPolygon":
    var mpg = newMultiPolygon(polygons)
    check mpg.polygons == polygons
    check mpg.srid == 0

  test "create GeometryCollection AssertionError":
    var gcGeometry = Geometry(kind: wkbGeometryCollection, gc: gc)
    expect(AssertionError):
      discard gcGeometry.srid
      gcGeometry.srid = 4326

  test "set Geometry's srid":
    for geo in gc:
      check geo.srid == 0
      geo.srid = 4326
      check geo.srid == 4326
