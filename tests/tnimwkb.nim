import unittest, logging

import nimwkb

# addHandler(newConsoleLogger(levelThreshold = lvlDebug))

const srid = 4326'u32

#  Point
let ptCoord = Coord(x: 1.0, y: 2.0)
let pt = Point(coord: ptCoord)
let spt = Point(srid: srid, coord: ptCoord)
let ptGeometry = Geometry(kind: wkbPoint, pt: pt)
let sptGeometry = Geometry(kind: wkbPoint, pt: spt)
const wkbnpt = "01"&# little endian
               "01000000"&
               "000000000000F03F"&
               "0000000000000040" 
const wkbnspt = "01"&# little endian
                "01000020"&
                "E6100000"&# with srid = 4326
                "000000000000F03F"&
                "0000000000000040"
const wkbxpt = "00"&# big endian
               "00000001"&
               "3FF0000000000000"&
               "4000000000000000"
const wkbxspt = "00"&# big endian
                "20000001"&
                "000010E6"&# with srid = 4326
                "3FF0000000000000"&
                "4000000000000000"

suite "parse Point wkb hex string":
  test "little endian wkb":
    check parseWkb(wkbnpt) == ptGeometry

  test "little endian wkb with srid":
    check parseWkb(wkbnspt) == sptGeometry
  
  test "big endian wkb":
    check parseWkb(wkbxpt) == ptGeometry

  test "big endian wkb with srid":
    check parseWkb(wkbxspt) == sptGeometry

#  LineString     
let ls = @[Coord(x: 1.0, y: 1.0), Coord(x: 2.0, y: 2.0)]
const wkbnls = "01"&
               "02000000"&
               "02000000"&
               "000000000000F03F"&
               "000000000000F03F"&
               "0000000000000040"&
               "0000000000000040"               
const wkbnsls = "01"&
                "02000020"&
                "E6100000"&# with srid = 4326
                "02000000"&# number of points
                "000000000000F03F"&
                "000000000000F03F"&
                "0000000000000040"&
                "0000000000000040"
const wkbxls = "00"&
               "00000002"&
               "00000002"&
               "3FF0000000000000"&
               "3FF0000000000000"&
               "4000000000000000"&
               "4000000000000000"

const wkbxsls = "00"&
                "20000002"&
                "000010E6"&# with srid = 4326
                "00000002"&
                "3FF0000000000000"&
                "3FF0000000000000"&
                "4000000000000000"&
                "4000000000000000"

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

#  Polygon      
let pg = @[
           @[Coord(x: 1.0, y: 1.0), Coord(x: 2.0, y: 2.0), Coord(x: 3.0, y: 3.0), Coord(x: 1.0, y: 1.0)],
           @[Coord(x:4.0, y: 4.0), Coord(x: 5.0, y: 5.0), Coord(x: 6.0, y: 6.0), Coord(x: 4.0, y: 4.0)]
          ]    
const wkbnpg = "01"&
               "03000000"&
               "02000000"&# number of rings
               "04000000"&# number of points
               "000000000000F03F"&
               "000000000000F03F"&
               "0000000000000040"&
               "0000000000000040"&
               "0000000000000840"&
               "0000000000000840"&
               "000000000000F03F"&
               "000000000000F03F"&
               "04000000"&# number of points
               "0000000000001040"&
               "0000000000001040"&
               "0000000000001440"&
               "0000000000001440"&
               "0000000000001840"&
               "0000000000001840"&
               "0000000000001040"&
               "0000000000001040"           

const wkbnspg = "01"&
                "03000020"&
                "E6100000"&# with srid = 4326
                "02000000"&# number of rings
                "04000000"&# number of points
                "000000000000F03F"&
                "000000000000F03F"&
                "0000000000000040"&
                "0000000000000040"&
                "0000000000000840"&
                "0000000000000840"&
                "000000000000F03F"&
                "000000000000F03F"&
                "04000000"&# number of points
                "0000000000001040"&
                "0000000000001040"&
                "0000000000001440"&
                "0000000000001440"&
                "0000000000001840"&
                "0000000000001840"&
                "0000000000001040"&
                "0000000000001040"           
const wkbxpg = "00"&
               "00000003"&
               "00000002"&# number of rings
               "00000004"&# number of points
               "3FF0000000000000"&
               "3FF0000000000000"&
               "4000000000000000"&
               "4000000000000000"&
               "4008000000000000"&
               "4008000000000000"&
               "3FF0000000000000"&
               "3FF0000000000000"&
               "00000004"&# number of points
               "4010000000000000"&
               "4010000000000000"&
               "4014000000000000"&
               "4014000000000000"&
               "4018000000000000"&
               "4018000000000000"&
               "4010000000000000"&
               "4010000000000000" 
const wkbxspg = "00"&
                "20000003"&
                "000010E6"&# with srid = 4326
                "00000002"&# number of rings
                "00000004"&# number of points
                "3FF0000000000000"&
                "3FF0000000000000"&
                "4000000000000000"&
                "4000000000000000"&
                "4008000000000000"&
                "4008000000000000"&
                "3FF0000000000000"&
                "3FF0000000000000"&
                "00000004"&# number of points
                "4010000000000000"&
                "4010000000000000"&
                "4014000000000000"&
                "4014000000000000"&
                "4018000000000000"&
                "4018000000000000"&
                "4010000000000000"&
                "4010000000000000" 


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

#  MultiPoint
let mpt = @[Point(coord: Coord(x: 1.0, y: 1.0)), 
            Point(coord: Coord(x: 2.0, y: 2.0))]
const wkbnmpt = "01"&
                "04000000"&
                "02000000"&# number of point
                "01"&
                "01000000"&
                "000000000000F03F"&
                "000000000000F03F"&
                "01"&
                "01000000"&
                "0000000000000040"&
                "0000000000000040"

const wkbnsmpt = "01"&
                 "04000020"&
                 "E6100000"&#  srid = 4326
                 "02000000"&# number of point
                 "01"&
                 "01000000"&
                 "000000000000F03F"&
                 "000000000000F03F"&
                 "01"&
                 "01000000"&
                 "0000000000000040"&
                 "0000000000000040"

const wkbxmpt = "00"&
                "00000004"&
                "00000002"&# number of point
                "00"&
                "00000001"&
                "3FF0000000000000"&
                "3FF0000000000000"&
                "00"&
                "00000001"&
                "4000000000000000"&
                "4000000000000000"                

const wkbxsmpt = "00"&
                 "20000004"&
                 "000010E6"&#  srid = 4326
                 "00000002"&# number of point
                 "00"&
                 "00000001"&
                 "3FF0000000000000"&
                 "3FF0000000000000"&
                 "00"&
                 "00000001"&
                 "4000000000000000"&
                 "4000000000000000" 

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

let mls = @[
            LineString(coords: @[Coord(x: 1.0, y: 1.0), Coord(x: 2.0, y: 2.0)]),
            LineString(coords: @[Coord(x: 3.0, y: 3.0), Coord(x: 4.0, y: 4.0)])
          ]
const wkbnmls = "01"&
                "05000000"&
                "02000000"&# number of LineString
                "01"&
                "02000000"&
                "02000000"&
                "000000000000F03F"&
                "000000000000F03F"&
                "0000000000000040"&
                "0000000000000040"&
                "01"&
                "02000000"&
                "02000000"&
                "0000000000000840"&
                "0000000000000840"&
                "0000000000001040"&
                "0000000000001040"
const wkbnsmls = "01"&
                 "05000020"&
                 "E6100000"&#  srid = 4326
                 "02000000"&# number of LineString
                 "01"&
                 "02000000"&
                 "02000000"&
                 "000000000000F03F"&
                 "000000000000F03F"&
                 "0000000000000040"&
                 "0000000000000040"&
                 "01"&
                 "02000000"&
                 "02000000"&
                 "0000000000000840"&
                 "0000000000000840"&
                 "0000000000001040"&
                 "0000000000001040"
const wkbxmls = "00"&
                "00000005"&
                "00000002"&# number of LineString
                "00"&
                "00000002"&
                "00000002"&
                "3FF0000000000000"&
                "3FF0000000000000"&
                "4000000000000000"&
                "4000000000000000"&
                "00"&
                "00000002"&
                "00000002"&
                "4008000000000000"&
                "4008000000000000"&
                "4010000000000000"&
                "4010000000000000"
const wkbxsmls = "00"&
                 "20000005"&
                 "000010E6"&#  srid = 4326
                 "00000002"&# number of LineString
                 "00"&
                 "00000002"&
                 "00000002"&
                 "3FF0000000000000"&
                 "3FF0000000000000"&
                 "4000000000000000"&
                 "4000000000000000"&
                 "00"&
                 "00000002"&
                 "00000002"&
                 "4008000000000000"&
                 "4008000000000000"&
                 "4010000000000000"&
                 "4010000000000000"


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

let mpg = @[
            Polygon(rings: @[
              @[Coord(x: 1.0, y: 1.0), Coord(x: 2.0, y: 2.0),
                Coord(x: 3.0, y: 3.0), Coord(x: 1.0, y: 1.0)]
            ]),
            Polygon(rings: @[
              @[Coord(x: 3.0, y: 3.0), Coord(x: 4.0, y: 4.0),
                Coord(x: 5.0, y: 5.0), Coord(x: 3.0, y: 3.0)],
              @[Coord(x: 6.0, y: 6.0), Coord(x: 7.0, y: 7.0),
                Coord(x: 8.0, y: 8.0), Coord(x: 6.0, y: 6.0)]
            ])
          ]
const wkbnmpg = "01"&
                "06000000"&
                "02000000"&# number of Ploygon
                "01"&
                "03000000"&# Ploygon
                "01000000"&# number of rings
                "04000000"&# number of points
                "000000000000F03F"&
                "000000000000F03F"&
                "0000000000000040"&
                "0000000000000040"&
                "0000000000000840"&
                "0000000000000840"&
                "000000000000F03F"&
                "000000000000F03F"&
                "01"&
                "03000000"&# Ploygon
                "02000000"&# number of rings
                "04000000"&# number of points
                "0000000000000840"&
                "0000000000000840"&
                "0000000000001040"&
                "0000000000001040"&
                "0000000000001440"&
                "0000000000001440"&
                "0000000000000840"&
                "0000000000000840"&
                "04000000"&# number of points
                "0000000000001840"&
                "0000000000001840"&
                "0000000000001C40"&
                "0000000000001C40"&
                "0000000000002040"&
                "0000000000002040"&
                "0000000000001840"&
                "0000000000001840"
const wkbnsmpg =  "01"&
                  "06000020"&
                  "E6100000"&#  srid = 4326
                  "02000000"&# number of Ploygon
                  "01"&
                  "03000000"&# Ploygon
                  "01000000"&# number of rings
                  "04000000"&# number of points
                  "000000000000F03F"&
                  "000000000000F03F"&
                  "0000000000000040"&
                  "0000000000000040"&
                  "0000000000000840"&
                  "0000000000000840"&
                  "000000000000F03F"&
                  "000000000000F03F"&
                  "01"&
                  "03000000"&# Ploygon
                  "02000000"&# number of rings
                  "04000000"&# number of points
                  "0000000000000840"&
                  "0000000000000840"&
                  "0000000000001040"&
                  "0000000000001040"&
                  "0000000000001440"&
                  "0000000000001440"&
                  "0000000000000840"&
                  "0000000000000840"&
                  "04000000"&# number of points
                  "0000000000001840"&
                  "0000000000001840"&
                  "0000000000001C40"&
                  "0000000000001C40"&
                  "0000000000002040"&
                  "0000000000002040"&
                  "0000000000001840"&
                  "0000000000001840"
const wkbxmpg = "00"&
                "00000006"&
                "00000002"&# number of Ploygon
                "00"&
                "00000003"&# Ploygon
                "00000001"&# number of rings
                "00000004"&# number of points
                "3FF0000000000000"&
                "3FF0000000000000"&
                "4000000000000000"&
                "4000000000000000"&
                "4008000000000000"&
                "4008000000000000"&
                "3FF0000000000000"&
                "3FF0000000000000"&
                "00"&
                "00000003"&# Ploygon
                "00000002"&# number of rings
                "00000004"&# number of points
                "4008000000000000"&
                "4008000000000000"&
                "4010000000000000"&
                "4010000000000000"&
                "4014000000000000"&
                "4014000000000000"&
                "4008000000000000"&
                "4008000000000000"&
                "00000004"&# number of points
                "4018000000000000"&
                "4018000000000000"&
                "401C000000000000"&
                "401C000000000000"&
                "4020000000000000"&
                "4020000000000000"&
                "4018000000000000"&
                "4018000000000000"
const wkbxsmpg =  "00"&
                  "20000006"&
                  "000010E6"&#  srid = 4326
                  "00000002"&# number of Ploygon
                  "00"&
                  "00000003"&# Ploygon
                  "00000001"&# number of rings
                  "00000004"&# number of points
                  "3FF0000000000000"&
                  "3FF0000000000000"&
                  "4000000000000000"&
                  "4000000000000000"&
                  "4008000000000000"&
                  "4008000000000000"&
                  "3FF0000000000000"&
                  "3FF0000000000000"&
                  "00"&
                  "00000003"&# Ploygon
                  "00000002"&# number of rings
                  "00000004"&# number of points
                  "4008000000000000"&
                  "4008000000000000"&
                  "4010000000000000"&
                  "4010000000000000"&
                  "4014000000000000"&
                  "4014000000000000"&
                  "4008000000000000"&
                  "4008000000000000"&
                  "00000004"&# number of points
                  "4018000000000000"&
                  "4018000000000000"&
                  "401C000000000000"&
                  "401C000000000000"&
                  "4020000000000000"&
                  "4020000000000000"&
                  "4018000000000000"&
                  "4018000000000000"

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

let gc = @[Geometry(kind: wkbPoint, pt: Point(coord: Coord(x: 1.0, y: 1.0))),
           Geometry(kind: wkbLineString,
                    ls: LineString(coords: @[Coord(x: 1.0, y: 1.0),
                                             Coord(x: 2.0, y: 2.0)
                                            ]))
          ]
const wkbgc = "01"&
              "07000000"&#  GeometryCollection
              "02000000"&#  number of geometry
              "01"&
              "01000000"&#  Point
              "000000000000F03F"&
              "000000000000F03F"&
              "01"&
              "02000000"&# LineString
              "02000000"&
              "000000000000F03F"&
              "000000000000F03F"&
              "0000000000000040"&
              "0000000000000040"

suite "parse GeometryCollection wkb hex string":
  test "wkb with one Point and two LineString":
    check parseWkb(wkbgc) == Geometry(kind: wkbGeometryCollection, gc: gc)


suite "convert Geometry Point to wkb":
  test "Point to wkb bytes":
    check writeWkb(ptGeometry, wkbNDR) == wkbnpt
