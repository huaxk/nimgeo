import unittest, logging

import geometry, nimwkb

include common

# addHandler(newConsoleLogger(levelThreshold = lvlDebug))

suite "parse Point wkb hex string":
  test "little endian wkb":
    check parseWkb(wkbnpt) == ptGeometry

  test "little endian wkb with srid":
    check parseWkb(wkbnspt) == sptGeometry
  
  test "big endian wkb":
    check parseWkb(wkbxpt) == ptGeometry

  test "big endian wkb with srid":
    check parseWkb(wkbxspt) == sptGeometry

suite "parse LineString wkb hex string":
  test "little endian wkb":
    check parseWkb(wkbnls) == Geometry(kind: wkbLineString,
                                        ls: LineString(coords: ls))

  test "little endian wkb with srid":
    check parseWkb(wkbnsls) == Geometry(kind: wkbLineString,
                                        ls: LineString(srid: srid, coords: ls))

  test "big endian wkb":
    check parseWkb(wkbxls) == Geometry(kind: wkbLineString,
                                        ls: LineString(coords:ls))

  test "big endian wkb with srid":
    check parseWkb(wkbxsls) == Geometry(kind: wkbLineString,
                                        ls: LineString(srid: srid, coords: ls))


suite "parse Polygon wkb hex string":
  test "little endian wkb":
    check parseWkb(wkbnpg) == Geometry(kind: wkbPolygon,
                                       pg: Polygon(rings: pg))

  test "little endian wkb with srid":
    check parseWkb(wkbnspg) == Geometry(kind: wkbPolygon,
                                       pg: Polygon(srid: srid, rings: pg))

  test "big endian wkb":
    check parseWkb(wkbxpg) == Geometry(kind: wkbPolygon,
                                       pg: Polygon(rings:pg))

  test "big endian wkb with srid":
    check parseWkb(wkbxspg) == Geometry(kind: wkbPolygon,
                                       pg: Polygon(srid: srid, rings:pg))


suite "parse MultiPoint wkb hex string":
  test "little endian wkb":
    check parseWkb(wkbnmpt) == Geometry(kind: wkbMultiPoint,
                                        mpt: MultiPoint(points: mpt))

  test "little endian wkb with srid":
    check parseWkb(wkbnsmpt) == Geometry(kind: wkbMultiPoint,
                                         mpt: MultiPoint(srid: srid, points: mpt))

  test "big endian wkb":
    check parseWkb(wkbxmpt) == Geometry(kind: wkbMultiPoint,
                                        mpt: MultiPoint(points: mpt))

  test "big endian wkb with srid":
    check parseWkb(wkbxsmpt) == Geometry(kind: wkbMultiPoint,
                                         mpt: MultiPoint(srid: srid,
                                           points: mpt))


suite "parse MultiLineString wkb hex string":
  test "little endian wkb":
    check parseWkb(wkbnmls) == Geometry(kind: wkbMultiLineString,
                                       mls: MultiLineString(linestrings: mls))

  test "little endian wkb with srid":
    check parseWkb(wkbnsmls) == Geometry(kind: wkbMultiLineString,
                                        mls: MultiLineString(srid: srid,
                                          linestrings: mls))

  test "big endian wkb":
    check parseWkb(wkbxmls) == Geometry(kind: wkbMultiLineString,
                                        mls: MultiLineString(linestrings: mls))

  test "big endian wkb with srid":
    check parseWkb(wkbxsmls) == Geometry(kind: wkbMultiLineString,
                                          mls: MultiLineString(srid: srid,
                                            linestrings: mls))


suite "parse MultiPolygon wkb hex string":
  test "little endian wkb":
    check parseWkb(wkbnmpg) == Geometry(kind: wkbMultiPolygon,
                                        mpg: MultiPolygon(polygons: mpg))
  test "little endian wkb with srid":
    check parseWkb(wkbnsmpg) == Geometry(kind: wkbMultiPolygon,
                                         mpg: MultiPolygon(srid: srid, 
                                           polygons: mpg))
  test "big endian wkb":
    check parseWkb(wkbxmpg) == Geometry(kind: wkbMultiPolygon,
                                        mpg: MultiPolygon(polygons: mpg))

  test "big endian wkb with srid":
    check parseWkb(wkbxsmpg) == Geometry(kind: wkbMultiPolygon,
                                         mpg: MultiPolygon(srid: srid,
                                           polygons: mpg))


suite "parse GeometryCollection wkb hex string":
  test "wkb with one Point and two LineString":
    check parseWkb(wkbgc) == Geometry(kind: wkbGeometryCollection, gc: gc)
